#a0 is arr base
#a1 is arr n
bubbleSort:
	addi $sp, $sp, -16
	sw $s3, 12($sp)
	sw $s2, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)

	move $s0, $a0
	move $s1, $a1

	li $s2, 1 #pass
	bubbleSortFor:
		bge $s2, $s1, bubbleSortDone
		
		#call bubble(s0, s1, s2);
		#let s3 be sorted
		addi $sp, $sp, -16
		sw $a0, 12($sp)
		sw $a1, 8($sp)
		sw $a2, 4($sp)
		sw $ra, 0($sp)
		move $a0, $s0
		move $a1, $s1
		move $a2, $s2
		
		jal bubble
		move $s3, $v0

		lw $a0, 12($sp)
		lw $a1, 8($sp)
		lw $a2, 4($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 16
		#if sorted != false, done
		bne $s3, $0, bubbleSortDone 
		addi $s2, $s2, 1
		j bubbleSortFor
	bubbleSortDone:

	lw $s3, 12($sp)
	lw $s2, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 16
	jr $ra

#a0 is arr base
#a1 is arr n
#a2 is pass 
bubble:
	addi $sp, $sp, -32
	sw   $s7, 28($sp)
	sw   $s0, 24($sp)
	sw   $s1, 20($sp)
	sw   $s2, 16($sp)
	sw   $s3, 12($sp)
	sw   $s4, 8($sp)
	sw   $s5, 4($sp)
	sw   $s6, 0($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	li $s3, 1 #sorted = true
	
	li $s4, 0 #index = 0
	sub $s5, $s1, $s2
	bubbleFor:
		bge $s4, $s5, bubbleDone

		
		addi $s6, $s4, 1 #nextIndex
		sll $s6, $s6, 2
		add $s6, $s6, $s0
		move $t0, $s6
		lw $s6, 0($s6) #s6 is arr[nextIndex]
		sll $s7, $s4, 2
		add $s7, $s7, $s0
		move $t1, $s7
		lw $s7, 0($s7) #s7 is arr[index]

		bge $s6, $s7, bubbleForSkipSwap
		#call swap(s6, s7);
		addi $sp, $sp, -12
		sw $a1, 8($sp)
		sw $a0, 4($sp)
		sw $ra, 0($sp)
		move $a0, $t0
		move $a1, $t1
		jal swap
		lw $a0, 4($sp)
		lw $a1, 8($sp)
		lw $ra, 0($sp)
		addi $sp, $sp, 12
		li $s3, 0

		bubbleForSkipSwap:
		addi $s4, $s4, 1
		j bubbleFor
	bubbleDone:		
	move $v0, $s3 #sorted 

	lw   $s7, 28($sp)
	lw   $s0, 24($sp)
	lw   $s1, 20($sp)
	lw   $s2, 16($sp)
	lw   $s3, 12($sp)
	lw   $s4, 8($sp)
	lw   $s5, 4($sp)
	lw   $s6, 0($sp)
	addi $sp, $sp, 32
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