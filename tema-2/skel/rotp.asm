section .text
    global rotp

;; void rotp(char *ciphertext, char *plaintext, char *key, int len);
rotp:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; ciphertext
    mov     esi, [ebp + 12] ; plaintext
    mov     edi, [ebp + 16] ; key
    mov     ecx, [ebp + 20] ; len
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE
    xor eax, eax
    xor ebx, ebx
for_loop:
    mov al, byte[esi + ebx]
    push ebx
    mov ebx, edi
    add ebx, ecx
    sub ebx, 1
    sub ebx, [esp]
    xor al, byte[ebx]
    pop ebx
    mov byte[edx + ebx], al
    inc ebx
    cmp ebx, ecx
    jne for_loop
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY