section .text
	global cmmmc

;; int cmmmc(int a, int b)
;
;; calculate least common multiple fow 2 numbers, a and b
cmmmc:
	pop eax
	pop ebx
	pop ecx
	push ecx
	push ebx
	push eax
	xor eax, eax
	add eax, ecx
	mul ebx
;	Calculates greatest common denominator
cmmdc:
	cmp ebx, ecx
	jg b_greater_than_c
	cmp ebx, ecx
	je exit_cmmdc
	sub ecx, ebx
	jmp cmmdc
b_greater_than_c:
	sub ebx, ecx
	jmp cmmdc

exit_cmmdc:
	xor edx, edx
	div ebx

	ret
