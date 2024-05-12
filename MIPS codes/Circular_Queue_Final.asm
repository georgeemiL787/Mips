.data
items:          .space 20             # Allocate space for array items 
capacity:       .word 4               # Store capacity
nItems:         .word 0               # Number of items
         		
queue_msg:      .asciiz "Queue: "     		
size_msg:       .asciiz "Size: "     		
peek_front_msg: .asciiz "peekFront: " 		
peek_rear_msg: .asciiz "peekRear: " 		
queue_full_msg: .asciiz "Queue is full!\n" 	
queue_empty_msg: .asciiz "Queue is empty\n"    			
dequeue_msg: .asciiz "Deleted: "
enqueue_msg: .asciiz "Inserted: "

newline:        .asciiz "\n" 
space:          .asciiz " "     

.text
.globl main

main:
    # Initialize variables
    la $t0, items               # Load base address of items
    lw $t1, capacity            # Load capacity
    lw $t2, nItems              # Load nItems
    li $t3, 1                   # Load constant 1

    # Enqueue elements
    addi $a0, $zero, 1          # Element 1
    jal enqueue
    addi $a0, $zero, 2          # Element 2
    jal enqueue
    addi $a0, $zero, 3          # Element 3
    jal enqueue
    addi $a0, $zero, 4          # Element 4
    jal enqueue
    addi $a0, $zero, 5          # Element 5
    jal enqueue
    addi $a0, $zero, 6          # Element 6
    jal enqueue
    addi $a0, $zero, 7          # Element 7
    jal enqueue

    # Display queue
    jal display
    jal peekFront
    jal peekRear
    jal size

    # Dequeue elements
    jal dequeue
    jal dequeue

    # Display data
    jal display
    jal peekFront
    jal peekRear
    jal size
    
    # Enqueue elements
    addi $a0, $zero, 1          # Element 1
    jal enqueue
    addi $a0, $zero, 2          # Element 2
    jal enqueue
    
    # Display data
    jal display
    jal peekFront
    jal peekRear
    jal size
    
    # Dequeue elements
    jal dequeue
    jal dequeue
    jal dequeue
    jal dequeue
    jal dequeue
    jal dequeue
    jal dequeue
    
    
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
    lw $t6, ($t3)		# Load the element
    addi $t2, $t2, 1            # Increment nItems
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, enqueue_msg         # Load address of enqueue_msg
    syscall
    
    li $v0, 1                   # Load syscall code for print_int                
    move $a0, $t6               # Load element
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load address of newline
    syscall
    
    j enqueue_exit

queue_full:
    li $v0, 4                   # Load syscall code for print_string
    la $a0, queue_full_msg      # Load address of queue_full_message
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
    
    li $v0, 4                  # Load syscall code for print_string
    la $a0, dequeue_msg        # Load syscall code for dequeue_msg
    syscall
    
    li $v0, 1                # Load syscall code for print_int   
    move $a0, $t7            # Move element
    syscall
    
    li $v0, 4                # Load syscall code for print_string  
    la $a0, newline          # Load syscall code for newline
    syscall
    
    j dequeue_exit

queue_empty_dequeue:
    li $v0, 4                   # Load syscall code for print_string
    la $a0, queue_empty_msg     # Load address of queue empty message
    syscall

dequeue_exit:
    jr $ra

queue_empty:
    jr $ra

size:
    li $v0, 4                   # Load syscall code for print_string
    la $a0, size_msg            # Load address of size message
    syscall
    li $v0, 1                   # Load syscall code for print_int
    move $a0, $t2               # Move nItems to print
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load address of newline
    syscall
    
    jr $ra

peekFront:
    # Check if queue is empty
    beqz $t2, queue_empty
    
    li $v0, 4			 # Load syscall code for print_string
    la $a0, peek_front_msg       # Load address of peek_front_msg
    syscall

    # Display the front element
    lw $a0, ($t0)               # Load items
    li $v0, 1                   # Load syscall code for print_int
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load address of newline
    syscall
    jr $ra
    
peekRear:
    # Check if queue is empty
    beqz $t2, queue_empty
    
    li $v0, 4			# Load syscall code for print_string
    la $a0, peek_rear_msg	# Load address of peek_rear_msg
    syscall

    # Calculate the address of the last element
    sll $t3, $t2, 2             # Calculate offset (size of integer)
    sub $t3, $t3, 4             # Adjust offset to point to the last element
    add $t3, $t0, $t3           # Calculate address of the last element

    # Display the last element
    lw $a0, ($t3)               # Load the last element
    li $v0, 1                   # Load syscall code for print_int
    syscall

    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load address of newline
    syscall

    jr $ra

display:
    # Check if queue is empty
    beqz $t2, queue_empty
    # Display the queue
    la $s5, items               # Load base address of items
    
    li $v0, 4			# Load syscall code for print_string
    la $a0, queue_msg		# Load address of queue_msg
    syscall
    
    li $t4, 0                   # Initialize i = 0
    
display_loop:
    bge $t4, $t2, display_exit  # Exit loop if i >= nItems
    lw $t6, ($s5)               # Load items[i]
    li $v0, 1   
    move $a0, $t6              # Load syscall code for print_int
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, space               # Load address of space
    syscall
    
    addi $s5, $s5, 4            # Increment address by 4 (size of integer)
    addi $t4, $t4, 1            # Increment i
    j display_loop
    
display_exit:
    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load address of newline
    syscall
    
    jr $ra
