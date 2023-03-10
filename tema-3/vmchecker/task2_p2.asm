section .text
	global par

;; int par(int str_length, char* str)
;
; check for balanced brackets in an expression
par:
	pop eax
	pop ebx
	pop ecx
	push ecx
	push ebx
	push eax
	push esi
	xor esi, esi
	push 0
	add esi, 4
	xor edx, edx
	xor eax, eax
;	Parses the string byte by byte
parse_string:
	add dl, byte[ecx]
	cmp dl, 40
	jne pop_from_stack
	push 1
	add esi, 4
	jmp advance
pop_from_stack:
	pop eax
	sub esi, 4
	cmp eax, 0
	je clear_stack
	cmp esi, 0
	jl clear_stack
advance:
	inc ecx
	dec ebx
	xor edx, edx
	cmp ebx, 0
	jne parse_string

	xor eax, eax
	inc eax
;	Clears stack of unneeded values
clear_stack:
	add esp, esi
	pop esi
	ret
