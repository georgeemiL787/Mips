.data
items:          .space 20             # Allocate space for array items
capacity:       .word 4               # Store capacity
nItems:         .word 0               # Number of items
			 
queue_msg:      .asciiz "Current Queue: \n"  			   
queue_full_msg: .asciiz "Queue is full. Cannot enqueue.\n"	 
queue_empty_msg: .asciiz "Queue is empty\n" 			      
dequeue_msg: .asciiz "Customer served: "
enqueue_msg: .asciiz "Customer added to the queue.\n"
Customer_served_msg: .asciiz "Customer served and removed from the queue.\n"

customer_msg: .asciiz "customer"
d_dote_msg: .asciiz ":"
space:          .asciiz " "  
newline:        .asciiz "\n"        

.text
.globl main

main:
    # Initialize variables
    la $t0, items               # Load base address of items
    lw $t1, capacity            # Load capacity
    lw $t2, nItems              # Load nItems
    li $t3, 1                   # Load constant 1
    
    # Enqueue elements
    addi $a0, $zero, 101          # Element 101
    jal enqueue
    addi $a0, $zero, 102          # Element 102
    jal enqueue
    addi $a0, $zero, 103          # Element 103
    jal enqueue
    
    # Display queue
    jal display
    
    # Dequeue elements
    jal dequeue
    
    # Display queue
    jal display

exit:
    li $v0, 10                  # Exit syscall
    syscall

enqueue:
    # Check if queue is full
    bgt $t2, $t1, queue_full

    # Store element in the next available slot
    sll $t3, $t2, 2             # Calculate offset (size of integer)
    add $t3, $t0, $t3           # Calculate address of next slot
    sw $a0, ($t3)               # Store element
    addi $t2, $t2, 1            # Increment nItems

    li $v0, 4                   # Load syscall code for print_string
    la $a0, enqueue_msg         # Load address of enqueue_msg
    syscall
    
    j enqueue_exit

queue_full:
    li $v0, 4                   # Load syscall code for print_string
    la $a0, queue_full_msg      # Load address of queue_full_msg
    syscall
    
    j enqueue_exit

enqueue_exit:
    jr $ra
dequeue:
    la $s5, items
    lw $t7, ($s5)
    # Check if queue is empty
    beqz $t2, queue_empty_dequeue

    # Shift elements to the left
    li $t3, 1                   # Initialize offset to 1
    move $t4, $t3               # Copy offset to $t4
shift_loop:
    bgt $t3, $t2, shift_exit    # Exit loop if offset >= nItems
    sll $t5, $t3, 2             # Calculate offset (size of integer)
    add $t5, $t0, $t5           # Calculate address of current slot
    lw $t6, ($t5)               # Load next element 
    sw $t6, -4($t5)             # Move next element to previous slot 
    addi $t3, $t3, 1            # Increment offset
    j shift_loop
shift_exit:
    # Decrement nItems
    addi $t2, $t2, -1
    
    li $v0, 4                    # Load syscall code for print_string
    la $a0, Customer_served_msg   # Load syscall code for Customer_served_msg    
    syscall
    
    li $v0, 4                  # Load syscall code for print_string 
    la $a0, dequeue_msg        # Load syscall code for dequeue_msg
    syscall
    
    li $v0, 1                   # Load syscall code for print_int 
    move $a0, $t7               # Move element
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load syscall code for newline
    syscall
    
    j dequeue_exit

queue_empty_dequeue:
    li $v0, 4                   # Load syscall code for print_string
    la $a0, queue_empty_msg     # # Load syscall code for queue_empty_msg
    syscall

dequeue_exit:
    jr $ra 

queue_empty:
    jr $ra

display:
    # Check if queue is empty
    beqz $t2, queue_empty
    # Display the queue
    la $s5, items               # Load base address of items
    
    li $v0, 4			# Load syscall code for print_string
    la $a0, queue_msg           # Load address of queue_msg
    syscall
        
    li $t4, 0                   # Initialize i = 0
    li $t7, 1           	#Initialize counter = 0
    
display_loop:
    bge $t4, $t2, display_exit  # Exit loop if i >= nItems
    lw $t6, ($s5)               # Load items[i]
    
    li $v0, 4   		# Load syscall code for print_string
    la $a0, customer_msg        # Load address of customer_msg      
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, space               # Load address of space
    syscall
    
    li $v0, 1   	       # Load syscall code for print_int
    move $a0, $t7              # Load the counter value into a0
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, d_dote_msg          # Load address of :
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, space               # Load address of space
    syscall
    
    li $v0, 1   		# Load syscall code for print_int
    move $a0, $t6               # Load address of int
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load address of newline
    syscall
    
    addi $s5, $s5, 4            # Increment address by 4 (size of integer)
    addi $t4, $t4, 1            # Increment i
    addi $t7, $t7, 1            #Increment the counter
    j display_loop
    
display_exit:  
    jr $ra