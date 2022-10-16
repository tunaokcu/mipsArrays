#declareArray() asks for size, creates array, returns v0 = address and v1 = size
#initializeArray(addr, size) populates the array according to user input
#swap(addr1, addr2) swaps the value of the elements at addr1 and addr2. Can be used on arrays
#printArr(addr, size) prints array

declareArray:
	# Allocate space for a0
	addi $sp, $sp, -4
	# Preserve a0 first

	sw $a0, 0($sp)
	li $v0, 4 
	la $a0, arraySizePrompt #min text
	syscall	

	#Get array size = n, store it in t1
	li $v0, 5
	syscall
	move $t1, $v0 #$t1 = n
	sll $t2, $t1, 2 # $t2 = 4n

	#print "\n"
	li $v0, 4 
	la $a0, newline
	syscall
	
	#Create array
	li $v0, 9
	move $a0, $t2
	syscall
	
	move $t4, $v0	# t4 = address
	move $v0, $t4 	# v0 = address
	move $v1, $t1	# v1 = size
	lw $a0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
	
initializeArray:
	addi $sp, $sp, -8
	sw $s0, 4($sp)
	sw $s1, 0($sp)
	move $s0, $a0
	move $s1, $a1
	
	addi $t0, $0, 0 # i = 0
	initializeArrayFor:
		beq $t0, $s1, initializeArrayDone # if i == n, done

		sll $t3, $t0, 2 # array offset = t1 = t0 * 2^2 (0 --> 0, 1 --> 4, and so on)
		
		#print "Enter element: "
		li $v0, 4 
		la $a0, arrayElementPrompt
		syscall

		#Get element i, store it in in arr[i*4] = arr($t1)
		li $v0, 5
		syscall
		move $t8, $v0
		
		add $t6, $s0, $t3
		sw $t8, 0($t6)

		#print "\n"
		li $v0, 4 
		la $a0, newline
		syscall
		
		addi $t0, $t0, 1 # i = i + 1
		j initializeArrayFor
	initializeArrayDone:

	lw $s0, 4($sp)
	lw $s1, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	
#a0 is address of arr[i], a1 is address of arr[j]
#the outcome is 
#temp = arr[i]
#arr[i] = arr[j]
#arr[j] = temp
swap:
	lw $t0, 0($a0)
	lw $t1, 0($a1)
	sw $t1, 0($a0)
	sw $t0, 0($a1)
	
	jr $ra
	
#a0 is address, a1 is size
printArr:
	la $t5, newline
	la $t6, elementSeperator
	
	addi $sp, $sp, -8
	sw $s0, 4($sp)
	sw $a0, 0($sp)
	
	
	addi $s0, $a0, 0
	addi $t1, $0, 4
	addi $t0, $0, 0
	printArrFor:
		beq $t0, $a1 printArrDone
		mul $t2, $t1, $t0
		add $t3, $s0, $t2
		lw $t4, 0($t3)
		
		#print arr[i]
		addi $v0, $0, 1
		addi $a0, $t4, 0
		syscall
		

		
		#print seperator
		addi $t0, $t0, 1
		beq $t0, $a1 printArrSkipSeperator

		addi $v0, $0, 4
		addi $a0, $t6, 0
		syscall
		
		printArrSkipSeperator:
		j printArrFor
	printArrDone:
	#print newline
	addi $v0, $0, 4
	addi $a0, $t5, 0
	syscall
	
	lw $a0, 0($sp)
	lw $s0, 4($sp)
	addi $sp, $sp, 8
	jr $ra
