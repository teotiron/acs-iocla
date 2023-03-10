section .text
	global intertwine

;; void intertwine(int *v1, int n1, int *v2, int n2, int *v);
;
;  Take the 2 arrays, v1 and v2 with varying lengths, n1 and n2,
;  and intertwine them
;  The resulting array is stored in v
intertwine:
	enter 0, 0
	xor r10, r10 ;counter for v
	xor r11, r11 ;counter for v1
	xor r12, r12 ;counter for v2

add_from_v1:
	cmp r11, rsi
	je exit
	xor rax, rax
	mov eax, dword[rdi + 4 * r11]
	inc r11
	mov dword[r8 + 4 * r10], eax
	inc r10
	cmp r12, rcx
	jne add_from_v2
	jmp add_from_v1

add_from_v2:
	cmp r12, rcx
	je exit
	xor rax, rax
	mov eax, dword[rdx + 4 * r12]
	inc r12
	mov dword[r8 + 4 * r10], eax
	inc r10
	cmp r11, rsi
	jne add_from_v1
	jmp add_from_v2

exit:
	leave
	ret
