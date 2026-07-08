.data
array: .space 10          	# 10 8 bit numbers = 10 bytes

.text
la a0, array
	call sort
### sorting stage	
sort:
	mv t0, a0		# copy base address to t0
	li t4, 0		# j
	li t5, 0		# i
	jcycle:	
	lbu t1, 0(t0)		# Array[j]
	lbu t2, 1(t0) 		# Array[j+1]
	ble t1, t2, noswap	# branch if Array[j] < Array[j+1]
		mv t3, t1	# Array[j] into temp (t3)
		sb t2, 0(t0)	# Array[j+1] into Array[j]
		sb t3, 1(t0)	# temp(old j) into Array[j+1]
	noswap: 
	addi t4, t4, 1		# j++
	addi t0, t0, 1		# add 1 to old address
	li t6, 9		# 10 (N - 1)
	sub t6, t6, t5		# N - i - 1
	bgt t6, t4, jcycle	# if j < N - i - 1, go to check array[j] > array[j+1]
	li t4, 0		# j = 0
	addi t5, t5, 1		# i++
	li t6, 9		# 10 (N - 1)
	mv t0, a0		# copy base address to t0
	blt t5, t6, jcycle	# jcycle until i = N - 1