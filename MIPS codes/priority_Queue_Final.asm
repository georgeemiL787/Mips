.data
items:          .space 20             # Allocate space for array items 
capacity:       .word 4               # Store capacity
nItems:         .word 0               # Number of items
         		
queue_msg:      .asciiz "Queue: "     		
size_msg:       .asciiz "Size: "     		
peek_Max_msg: .asciiz "peekMax: " 		
peek_Min_msg: .asciiz "peekMin: " 		
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
    addi $a0, $zero, 5          # Element 5
    jal enqueue
    addi $a0, $zero, 3          # Element 3
    jal enqueue
    addi $a0, $zero, 1          # Element 1
    jal enqueue
    addi $a0, $zero, 4          # Element 4
    jal enqueue
    addi $a0, $zero, 7          # Element 7
    jal enqueue
    addi $a0, $zero, 6          # Element 6
    jal enqueue
    addi $a0, $zero, 8          # Element 8
    jal enqueue

    # Display queue
    jal display
    jal peekMax
    jal peekMin
    jal size

    # Dequeue elements
    jal dequeue
    jal dequeue

    # Display data
    jal display
    jal peekMax
    jal peekMin
    jal size
    
    # Enqueue elements
    addi $a0, $zero, 13          # Element 13
    jal enqueue
    addi $a0, $zero, 1          # Element 1
    jal enqueue
    
    # Display data
    jal display
    jal peekMax
    jal peekMin
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

    # Find the correct position to insert the new element
    la $s5, items               # Load base address of items
    li $t4, 0                   # Initialize index counter

find_position:
    beq $t4, $t2, insert_element   # If we've reached the end of the queue, insert new element
    lw $t6, ($s5)                  # Load current element
    bge $a0, $t6, insert_element   # Compare new element with current element

    addi $s5, $s5, 4            # Move to the next element
    addi $t4, $t4, 1            # Increment index counter
    j find_position

insert_element:
    # Shift elements to the right to make space
    move $t3, $t2               # $t3 will be used as a counter (from end to current position)
    la $s5, items               # Load base address of items

shift_elements:
    beq $t3, $t4, store_element  # Exit loop if we've reached the correct position
    sub $t7, $t3, 1             # Calculate the previous element's index
    sll $t7, $t7, 2             # Multiply the index by 4 to get the byte offset
    add $t7, $s5, $t7           # Calculate the address of the previous element
    lw $t8, ($t7)               # Load the previous element
    sw $t8, 4($t7)              # Move the previous element to the next position
    addi $t3, $t3, -1           # Decrement the counter
    j shift_elements

store_element:
    # Store the new element at the correct position
    sll $t4, $t4, 2             # Multiply the index by 4 to get the byte offset
    add $t4, $s5, $t4           # Calculate the address for the new element
    sw $a0, ($t4)               # Store the new element
    lw $t9, ($t4)
    addi $t2, $t2, 1            # Increment nItems

    # Print enqueue message
    li $v0, 4                   # Load syscall code for print_string
    la $a0, enqueue_msg         # Load address of enqueue_msg
    syscall

    li $v0, 1                   # Load syscall code for print_int                
    move $a0, $t9               # Load element to print
    syscall

    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load address of newline
    syscall

    j enqueue_exit

queue_full:
    li $v0, 4                   # Load syscall code for print_string
    la $a0, queue_full_msg      # Load address of queue_full_message
    syscall
    
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

peekMax:
    # Check if queue is empty
    beqz $t2, queue_empty
    
    li $v0, 4			 # Load syscall code for print_string
    la $a0, peek_Max_msg       # Load address of peek_Max_msg
    syscall

    # Display the front element
    lw $a0, ($t0)               # Load items
    li $v0, 1                   # Load syscall code for print_int
    syscall
    
    li $v0, 4                   # Load syscall code for print_string
    la $a0, newline             # Load address of newline
    syscall
    jr $ra
    
peekMin:
    # Check if queue is empty
    beqz $t2, queue_empty
    
    li $v0, 4			# Load syscall code for print_string
    la $a0, peek_Min_msg	# Load address of peek_Min_msg
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

sort:
	la $s7, items					#load address of numbers into $s7
	li $s0, 0					#initialize counter 1 for loop 1
	li $s6, 9 					#n - 1
	li $s1, 0 					#initialize counter 2 for loop 2
	li $t3, 0					#initialize counter for printing
	li $t4, 10

	syscall
loop:
	sll $t7, $s1, 2					#multiply $s1 by 2 and put it in t7
	add $t7, $s7, $t7 				#add the address of numbers to t7
	lw $t0, 0($t7)  				#load numbers[j]	
	lw $t1, 4($t7) 					#load numbers[j+1]
	slt $t2, $t0, $t1				#if t0 < t1
	bne $t2, $zero, increment
	sw $t1, 0($t7) 					#swap
	sw $t0, 4($t7)

increment:	
	addi $s1, $s1, 1				#increment t1
	sub $s5, $s6, $s0 				#subtract s0 from s6
	bne  $s1, $s5, loop				#if s1 (counter for second loop) does not equal 9, loop
	addi $s0, $s0, 1 				#otherwise add 1 to s0
	li $s1, 0 					#reset s1 to 0
	bne  $s0, $s6, loop				# go back through loop with s1 = s1 + 1
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