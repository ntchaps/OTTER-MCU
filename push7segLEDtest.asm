.data
array: .space 10          	# 10 8 bit numbers = 10 bytes
qoutients: .space 10		# 10 8 bit numbers = 10 bytes
remainders: .space 10		# 10 8 bit numbers = 10 bytes

.text
	la s0, qoutients	# qoutients
	la s1, remainders	# remainders
	li s2, 0x11000040	# 7 seg
	li s3, 0x11000020	# LEDs
	la s4, array		# array

mv a0, s0		# qoutients address to argument
	mv a1, s1		# remainders address to argument
	li t0, 0		# i = 0
	li t1, 10		# 10
	loop: 
		lb t2, 0(a0)	# put qoutient into t2
		lb t3, 0(a1)	# put remainder into t3
		sb t2, 0(s2)	# store qoutients into 7 seg
		sb t3, 0(s3)	# store remainders into LEDs
		addi t0, t0, 1	# i++
		add a0, s0, t0	# shift qoutient array to next number
		add a1, s1, t0	# shift remainder array to next number
		ble t0, t1, loop# if i < 10, loop