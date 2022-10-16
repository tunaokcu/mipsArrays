.data
arr: .word 29, 10, 14, 37, 13
size: .word 5

elementSeperator: .asciiz ", "
newline: .asciiz "\n"


.text
main:
	la $s0, arr
	lw $s1, size
	
	move $a0, $s0
	move $a1, $s1
	jal selectionSort
	
	#done
	li $v0, 10
	syscall
	
#a0 : array address
#a1 : array size
selectionSort:
	addi $sp, $sp, -4
	sw $s0, 0($sp) 
	
	addi $s0, $a1, -1 #index of last array element is s0
	selectionSortFor:
		#TEST: this causes problems?
		addi $sp, $sp, -8
		sw $t0, 4($sp)
		sw $ra, 0($sp)
		jal printArr
		lw $ra, 0($sp)
		lw $t0, 4($sp)
		addi $sp, $sp, 8
		
		ble $s0, $0, selectionSortDone #last <= 0
		

		
		#t0 = indexOfLargest(a0, s0 + 1)
		addi $sp, $sp, -12
		sw $a0, 8($sp)
		sw $a1, 4($sp)
		sw $ra, 0($sp)
		
		move $a0, $a0#just to stress that a0 = a0
		addi $a1, $s0, 1 # a1 = s0 + 1
	
		
		#something wrong here
		jal indexOfLargest
		move $t0, $v0 #t0 is now index of largest
		

		lw $ra, 0($sp)
		lw $a1, 4($sp)
		lw $a0, 8($sp)
		addi $sp, $sp, 12
		
		#swap(a0[t0], a0[s0])
		addi $sp, $sp, -12
		sw $a0, 8($sp)
		sw $a1, 4($sp)
		sw $ra, 0($sp)
		
		sll $t0, $t0, 2
		add $t0, $t0, $a0 #t0 is now a0[t0]
		move $a1, $s0
		sll $a1, $a1, 2
		add $a1, $a1, $a0 #a1 is now a0[s0]
		move $a0, $t0 #a0 is now a0[t0]
		jal swap
		
		lw $ra, 0($sp)
		lw $a1, 4($sp)
		lw $a0, 8($sp)
		addi $sp, $sp, 12
		
	

	
		addi $s0, $s0, -1
		j selectionSortFor
		
	selectionSortDone:
	lw $s0, 0($sp)
	addi $sp, $sp, 4
	jr $ra
		
		

#a0 : array address
#a1 : array size
#v0 : index of largest array element
indexOfLargest:
	addi $sp, $sp, -4
	sw $s0, 0($sp)
	
	li $s0, 0#s0 is the index of max 
	li $t0, 0#t0 is i
	
	indexOfLargestFor:
		bge $t0, $a1, indexOfLargestDone
		
		sll $t1, $t0, 2
		add $t1, $t1, $a0
		lw $t2, 0($t1)#t2 is arr[i], t0 is i
		
		sll $t3, $s0, 2
		add $t3, $t3, $a0 
		lw $t4, 0($t3) #t4 is arr[maxi]
		
		blt $t2, $t4, indexOfLargestSkip
		move $s0, $t0
		
		indexOfLargestSkip:
		
		addi $t0, $t0, 1
		j indexOfLargestFor
	indexOfLargestDone:
	move $v0, $s0
	lw $s0, 0($sp)
	addi $sp, $sp, 4
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

