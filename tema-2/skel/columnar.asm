section .data
    extern len_cheie, len_haystack
    line_count db '0'

section .text
    global columnar_transposition

;; void columnar_transposition(int key[], char *haystack, char *ciphertext);
columnar_transposition:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha 

    mov edi, [ebp + 8]   ;key
    mov esi, [ebp + 12]  ;haystack
    mov ebx, [ebp + 16]  ;ciphertext
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE
    ; calculate ceil(len_haystack / len_cheie)
    xor eax, eax
    mov eax, [len_haystack]
    xor edx, edx
    mov edx, [len_cheie]
    div dl
    cmp ah, 0
    je int_div
    inc al
int_div:
    xor ah, ah
    mov [line_count], al

    xor ecx, ecx ;key iterator / haystack iterator
    xor edx, edx ;ciphertext iterator
key_loop:
    mov eax, [edi + 4 * ecx]
    push ecx
    xor ecx, ecx

haystack_loop:
    push eax
    mov eax, esi
    add eax, [esp]
    push ebx
    xor ebx, ebx

product_loop:
    add eax, ecx
    inc ebx
    cmp ebx, [len_cheie]
    jne product_loop

    pop ebx
    push ecx
    xor ecx, ecx
    mov cl, byte[eax]
    cmp ecx, 127
    jg skip
    cmp ecx, 31
    jl skip
    mov byte[ebx + edx], cl
    inc edx
skip:
    pop ecx
    pop eax
    inc ecx
    cmp ecx, [line_count]
    jne haystack_loop

    pop ecx
    inc ecx
    cmp ecx, [len_cheie]
    jne key_loop

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY