.data
list1: .word 1, 4, 6, 9
list2: .word 0, 2, 3, 7
merged_list: .space 32  # Assuming maximum 8 integers in the merged list

.text
.globl main
main:
    # Load the addresses of the input lists
    la $t0, list1
    la $t1, list2
    # Load the address of the merged list
    la $t2, merged_list
    
    # Initialize indices and counters
    li $t3, 0  # Index for list1
    li $t4, 0  # Index for list2
    li $t5, 0  # Index for merged_list
    
merge_loop:
    # Load integers from list1 and list2
    lw $s0, 0($t0)      # Load integer from list1
    lw $s1, 0($t1)      # Load integer from list2
    
    # Compare the integers
    bge $t4, $t1, copy_remaining_list1
    bge $t3, $t0, copy_remaining_list2
    
    bge $s0, $s1, list2_greater
    
    # Integer from list1 is smaller, store it in merged_list
    sw $s0, 0($t2)      # Store integer in merged_list
    addi $t0, $t0, 4  # Move to the next integer in list1
    j increment_counters

list2_greater:
    # Integer from list2 is smaller or equal, store it in merged_list
    sw $s1, 0($t2)      # Store integer in merged_list
    addi $t1, $t1, 4  # Move to the next integer in list2
    j increment_counters

copy_remaining_list1:
    # Copy the remaining elements from list1 to merged_list
    sw $s0, 0($t2)      # Store integer in merged_list
    addi $t0, $t0, 4  # Move to the next integer in list1
    j increment_counters

copy_remaining_list2:
    # Copy the remaining elements from list2 to merged_list
    sw $s1, 0($t2)      # Store integer in merged_list
    addi $t1, $t1, 4  # Move to the next integer in list2
    
increment_counters:
    addi $t2, $t2, 4  # Move to the next position in merged_list
    addi $t5, $t5, 1  # Increment the merged_list index
    
    # Check if we have reached the end of either list
    bne $t0, $zero, merge_loop
    bne $t1, $zero, merge_loop
    
    # Print the merged list
    la $t2, merged_list
    li $v0, 4         # Print string syscall
    la $a0, merged_list_message
    syscall
    
    # Exit the program
    li $v0, 10        # Exit syscall
    syscall
    
.data
merged_list_message: .asciiz "Merged List: "
