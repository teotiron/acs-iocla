section .text
	global cpu_manufact_id
	global features
	global l2_cache_info

;; void cpu_manufact_id(char *id_string);
;
;  reads the manufacturer id string from cpuid and stores it in id_string
cpu_manufact_id:
	enter 	0, 0
	pushad
	xor eax, eax
	cpuid ;EAX = 0
	mov eax, [ebp + 8]
	mov [eax], ebx
	mov [eax + 4], edx
	mov [eax + 8], ecx
	popad
	leave
	ret

;; void features(char *vmx, char *rdrand, char *avx)
;
;  checks whether vmx, rdrand and avx are supported by the cpu
;  if a feature is supported, 1 is written in the corresponding variable
;  0 is written otherwise
features:
	enter 	0, 0
	pushad
	xor eax, eax
	mov eax, 1
	cpuid ;EAX = 1
	shr ecx, 5
	and ecx, 1
	mov edx, [ebp + 8]
	mov dword[edx], 0
	cmp ecx, 1
	jne no_vmx
	mov dword[edx], 1
no_vmx:

	mov eax, 1
	cpuid ;EAX = 1
	shr ecx, 30
	and ecx, 1
	mov edx, [ebp + 12]
	mov dword[edx], ecx
	cmp ecx, 1
	jne no_rdrand
	mov dword[edx], 1
no_rdrand:

	mov eax, 1
	cpuid ;EAX = 1
	shr ecx, 28
	and ecx, 1
	mov edx, [ebp + 16]
	mov dword[edx], 0
	cmp ecx, 1
	jne no_avx
	mov dword[edx], 1
no_avx:

	popad
	leave
	ret

;; void l2_cache_info(int *line_size, int *cache_size)
;
;  reads from cpuid the cache line size, and total cache size for the current
;  cpu, and stores them in the corresponding parameters
l2_cache_info:
	enter 	0, 0
	pushad
	xor eax, eax
	xor ecx, ecx
	mov eax, 4
	mov ecx, 2
	cpuid ;EAX = 4, ECX = 2
	xor eax, eax
	inc ecx
	mov eax, ecx ;set eax to value of sets
	;get line size
	xor ecx, ecx
	mov ecx, ebx
	shl ecx, 20
	shr ecx, 20
	inc ecx
	mov edx, [ebp + 8]
	mov dword[edx], ecx
	mul ecx
	;get partitions
	xor ecx, ecx
	shr ebx, 12
	mov ecx, ebx
	shl ecx, 10
	shr ecx, 22
	inc ecx
	mul ecx
	;get ways
	xor ecx, ecx
	shr ebx, 10
	inc ebx
	mul ebx
	;convert from B to KB
	shr eax, 10
	mov edx, [ebp + 12]
	mov dword[edx], eax

	popad
	leave
	ret
