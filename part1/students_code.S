.global hamming_weight, negate_first_k, bring_balance_to_the_word, read_input

.section .bss
.lcomm path, 1024

.section .text


read_input:

	pushq %rbx
	pushq %rsp
	pushq %rbp
	pushq %r12 
	pushq %r13 
	pushq %r14
	pushq %r15
	
	pushq %rdi # this is the adress to codeword
	
	Leaq path(%rip), %rdi
	call get_path
	
	# SysOpen
	movq $2, %rax
	movq $0, %rsi
	syscall
	pushq %rax # this is the file descriptor
	
	popq %rdi
	popq %rsi
	pushq %rsi
	pushq %rdi
	loop_char_HW2:
	movq $1, %rdx
	movq $0, %rax
	syscall # SysRead one char
	
	cmpb $0xa, (%rsi)
	je done_loop_HW2
	inc %rsi
	jmp loop_char_HW2
	
	done_loop_HW2:
	movq $0, (%rsi)
	
	popq %r12
	popq %rdi
	pushq %rdi
	pushq %r12
	
	pushq %rax
	pushq %rdi
	pushq %rsi
	pushq %R10
	pushq %R12
	call atam_atol
	movq %rax, %rdx
	popq %R12
	popq %R10
	popq %rsi
	popq %rdi
	popq %rax
	
	popq %rdi
	popq %rsi
	pushq %rsi
	pushq %rdi
	movq $0, %rax
	syscall # SysRead right amount of char's
	movq %rax, %r14
	movq $3, %rax
	popq %rdi
	syscall # SysClose to the file

	movq %r14, %rax # Returning rax/8
	movq $8, %r13
	xor %rdx, %rdx
	divq %r13

	popq %r15 # on purpose
	
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbp
	popq %rsp
	popq %rbx

	ret



hamming_weight: 

	pushq %rbx
	pushq %rsp
	pushq %rbp
	pushq %r12 
	pushq %r13 
	pushq %r14
	pushq %r15

	movq %rdi, %r8	# r8 <- pointer to codeword
	movq %rsi, %r9	# r9 <- amount of 8 Bytes
	
	xor %r11, %r11	# r11 <- counter of 1's


	main_loop_hamming_HW2:
		cmp $0, %r9
		je main_loop_hamming_HW2_end
		movq (%r8), %R10
		second_loop_hamming_HW2:
			shr $1, %R10
			jae second_loop_hamming_HW2_end
			inc %r11
			second_loop_hamming_HW2_end:
				cmp $0, %R10
				jne second_loop_hamming_HW2
		addq $8, %r8
		dec %r9
		jmp main_loop_hamming_HW2

	main_loop_hamming_HW2_end:
	
	movq %r11, %rax

	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbp
	popq %rsp
	popq %rbx

  	ret

negate_first_k:

	pushq %rbx
	pushq %rsp
	pushq %rbp
	pushq %r12 
	pushq %r13 
	pushq %r14
	pushq %r15

	movq %rdi, %r8	# r8 <- codeword to r8
	movq %rsi, %r9	# r9 <- value of k

	xor %r10, %r10	# r10 <- will be the temporary small negated word
	xor %r11, %r11 # r11 <- counter to 64 bits

	not_to_bits_in_word_HW2:
	cmpq $64, %r11
	je end_of_not_to_bits_in_word_HW2
	test %r9, %r9
	jz ror_to_word_HW2
	shr $1, %r8
	
	jae carry_is_zero_but_inserting_one_HW2
	sal $1, %r8
	dec %r9
	jmp ror_to_word_HW2 
	
	carry_is_zero_but_inserting_one_HW2:
	sal $1, %r8
	addq $1, %r8
	dec %r9

	ror_to_word_HW2:
	ror %r8
	inc %r11
	jmp not_to_bits_in_word_HW2

	end_of_not_to_bits_in_word_HW2:
	movq %r8, %rax
	
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbp
	popq %rsp
	popq %rbx

  ret

bring_balance_to_the_word:

	pushq %rbx
	pushq %rsp
	pushq %rbp
	pushq %r12 
	pushq %r13 
	pushq %r14
	pushq %r15
	pushq %rbx

	movq %rdi, %r12 # r12 <- pointer to codeword
	movq %rsi, %r13 # r13 <- amount of doubled word'
	xor %r15, %r15
	movq $1, %r15
	xor %rdx, %rdx
	xor %rcx, %rcx
	xor %rbx, %rbx

	next_iteration_HW2:
	cmpq %r13, %rcx
	jg finished_HW2
	movq %r12, %rdi
	movq %r13, %rsi
	pushq %rdx
	pushq %rcx
	call hamming_weight
	popq %rcx
	popq %rdx
	movq %r13, %r8
	shl $5, %r8
	cmpq %r8, %rax
	je finished_HW2
	xor %r15, (%r12, %rcx, 8)
	incq %rbx
	rol %r15
	incq %rdx
	cmpq $0x40, %rdx 
	jne next_iteration_HW2
	xorq %rdx, %rdx
	incq %rcx
	jmp next_iteration_HW2

	finished_HW2:
	movq %rbx, %rax
	popq %rbx
	popq %r15
	popq %r14
	popq %r13
	popq %r12
	popq %rbp
	popq %rsp
	popq %rbx

	ret

