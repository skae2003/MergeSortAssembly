	#Samuel Edwards ske210001
	.data
	input_list: .space 128
	sorting_list: .space 128
	subArray1: .space 64
	subArray2: .space 64
	get_size: .asciiz "Choose between 2, 4, 8, 16, and 32 integers to sort: "
	get_int: .asciiz "Please enter an integer: "
	spacing: .asciiz " "
	
	.text
	
	main:
		#gets the total amount of inputs abt to be entered
		li $v0, 4
		la $a0, get_size
		syscall
		#gets actual input and stores it in register $s1
		li $v0, 5
		syscall
		move $s1, $v0
		sll $s1, $s1, 2
		#sets $t1 equal to 0
		li $t1, 0
		
		la $s0, input_list
		
		jal loop_input
		
		#initial size of sub array
		li $s3, 4
		#initial start of sub array
		li $t0, 0

	loop:
	#branch if sub array size is equal or greater than initial array size
		blt $s3, $s1, continue
		j exit
	
	continue:
		
		#get the start of the second sub array
		add $t1, $t0, $s3
		#get the end of the second sub array
		add $t9, $t1, $s3
		bgt $t9, $s1, startFromFirstIncreaseSubArray
		#load address for input list
		la $s0, input_list
		
		jal subArrays
		
		jal merge
		
		j end
		
	startFromFirstIncreaseSubArray:
		li $t9, 0
		sll $s3, $s3, 1
			
	end:
	addi $t0, $t9, 0
	j loop
	
	
	merge:
		la $s0, input_list
		la $s4, subArray1
		la $s5, subArray2
		add $s0, $s0, $t0

		#counters for sub array
		li $t2, 0
		li $t3, 0
		
	mergeSortLoop:
		
		bge $t2, $s3, addSecondRest
		bge $t3, $s3, addFirstRest
		
		lw $t4, ($s4)
		lw $t5, ($s5)
		
		bge $t4, $t5, addSecondToList
		
	
	
	addFirstToList:
	
		sw $t4, ($s0)
		
		addi $s4, $s4, 4
		addi $s0, $s0, 4
		addi $t2, $t2, 4
		
		j mergeSortLoop
	
	addSecondToList:
		
		sw $t5, ($s0)
		
		addi $s5, $s5, 4
		addi $s0, $s0, 4
		addi $t3, $t3, 4
		
		j mergeSortLoop
		
	addFirstRest:
	
		lw $t4, ($s4)
		sw $t4, ($s0)
		
		addi $s4, $s4, 4
		addi $s0, $s0, 4
		addi $t2, $t2, 4
		blt $t2, $s3, addFirstRest
		
		
		jr $ra
	
	addSecondRest:
		lw $t5, ($s5)
		sw $t5, ($s0)
		
		addi $s5, $s5, 4
		addi $s0, $s0, 4
		addi $t3, $t3, 4
		blt $t3, $s3, addSecondRest
		
		
		jr $ra
		
	subArrays:
		la $s0, input_list
		la $s4, subArray1
		la $s5, subArray2
		li $t6, 0
		li $t7, 0
		add $s0, $s0, $t0
		#from input array to sub array
	subArray1Copy:
		lw $t2, ($s0)
		sw $t2, ($s4)
		
		addi $s0, $s0, 4
		addi $s4, $s4, 4
		addi $t6, $t6, 4
		
		blt $t6, $s3, subArray1Copy
		
	subArray2Copy:
		lw $t2, ($s0)
		sw $t2, ($s5)
		
		addi $s0, $s0, 4
		addi $s5, $s5, 4
		addi $t7, $t7, 4
		
		blt $t7, $s3, subArray2Copy
		
		jr $ra	
	
		
	exit:
		la $s0, input_list
		li $t0, 0
	print: 
		li $v0, 1
		lw $a0, 0($s0)
		syscall
		
		li $v0, 4
		la $a0, spacing
		syscall
		
		addi $s0, $s0, 4
		addi $t0, $t0, 4
		
		blt $t0, $s1, print
		
		li $v0, 10
		syscall
		
	loop_input:
		#prompt user for an integer
		li $v0, 4
		la $a0, get_int
		syscall
		#gets the integer value
		li $v0, 5
		syscall
		
		#stores the integer into the array
		sw $v0, 0($s0)
		#increments the counter for the branch and the location for the number to be stored in the array
		addi $t1, $t1, 4
		addi $s0, $s0, 4
		
		blt $t1, $s1, loop_input

		jr $ra