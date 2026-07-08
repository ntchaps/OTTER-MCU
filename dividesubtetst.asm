.data
array: .space 10          	# 10 8 bit numbers = 10 bytes
qoutients: .space 10		# 10 8 bit numbers = 10 bytes
remainders: .space 10		# 10 8 bit numbers = 10 bytes

.text
la t0, array		# load address of array
la a0, qoutients	# qoutients
la a1, remainders	# remainders

divide:	## dividing each number in the array by 3
	lbu t1, 0(t0)		# number from array into t1
	li t3, 0		# quotient = 0
	mv t4, t1		# copy t1 into t4 (working number)
	li t2, 3		# divisor 3
	blt t4, t2, divisiable	# if the number < 3, don't do any subtraction
	subtract: 
		sub t4, t4, t2	# working - 3
		addi t3, t3, 1	# quotient + 1
		bge t4, t2, subtract 	# if working is greater than 3, subtract again
	## number has been divided, not greater than 0
	beqz t4, divisiable	# go to divisible if remainder = 0
	divisiable:		# if no remainder, skip here (perfectly divisable)
	sb t3, 0(a0)		# quotient to quotient array
	sb t4, 0(a1)		# remainder to remainder array
	addi t0, t0, 1		# shift array pointer by 1 byte
	addi a0, a0, 1		# shift qoutients by 1 byte
	addi a1, a1, 1		# shift remainders by 1 byte
	addi t5, t5, 1		# s++
	li t6, 10		# t6 = 10
	bne t5, t6, divide	# if s!=10, repeat for next number