global get_words
global compare_func
global sort

extern strtok
extern strlen
extern qsort
extern strcmp

section .data
	delim: db " ,.", 10, 0

section .text

;; sort(char **words, int number_of_words, int size)
;  functia va trebui sa apeleze qsort pentru soratrea cuvintelor 
;  dupa lungime si apoi lexicografix
sort:
    enter 0, 0
    push ebx
    mov eax, [ebp + 8]
    mov ebx, [ebp + 12]
    mov ecx, [ebp + 16]
    mov edx, compare_func
    push edx
    push ecx
    push ebx
    push eax
    call qsort
    pop ebx
    leave
    ret

;; get_words(char *s, char **words, int number_of_words)
;  separa stringul s in cuvinte si salveaza cuvintele in words
;  number_of_words reprezinta numarul de cuvinte
get_words:
    enter 0, 0
    xor eax, eax
    xor ebx, ebx
    mov ebx, [ebp + 8]
    push delim
    push ebx
    call strtok
    add esp, 8
    push esi
    push edi
    mov edi, [ebp + 16]
    mov esi, [ebp + 12]
set_words:
    mov dword[esi], eax
    push delim
    xor eax, eax
    push eax
    call strtok
    add esp, 8
    dec edi
    add esi, 4
    cmp edi, 0
    jne set_words
    pop edi
    pop esi
    leave
    ret

compare_func:
	enter 0, 0
	push esi
	push ebx
	xor eax, eax
	mov ebx, [ebp + 8]
	mov ebx, [ebx]
	push ebx
	call strlen
	add esp, 4
	mov esi, eax
	mov ebx, [ebp + 12]
	mov ebx, [ebx]
	push ebx
	call strlen
	add esp, 4
	cmp eax, esi
	je do_strcmp
	xchg eax, esi
	sub eax, esi
	jmp exit

do_strcmp:
	mov ebx, [ebp + 8]
	mov ebx, [ebx]
	mov ecx, [ebp + 12]
	mov ecx, [ecx]
	push ecx
	push ebx
	call strcmp
	add esp, 8

exit:
	pop ebx
	pop esi
	leave
	ret