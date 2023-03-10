; This is your structure
struc  my_date
    .day: resw 1
    .month: resw 1
    .year: resd 1
endstruc

section .text
    global ages

; void ages(int len, struct my_date* present, struct my_date* dates, int* all_ages);
ages:
    ;; DO NOT MODIFY
    push    ebp
    mov     ebp, esp
    pusha

    mov     edx, [ebp + 8]  ; len
    mov     esi, [ebp + 12] ; present
    mov     edi, [ebp + 16] ; dates
    mov     ecx, [ebp + 20] ; all_ages
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE
    xor ebx, ebx
for_loop:
    mov eax, [esi + my_date.year]
    sub eax, [edi + my_date_size * ebx + my_date.year]
    push eax
    mov eax, [edi + my_date_size * ebx + my_date.month]
    cmp ax, word[esi + my_date.month]
    jne day_check
    mov eax, [edi + my_date_size * ebx + my_date.day]
    cmp ax, word[esi + my_date.day]
    jle had_bday
day_check:
    mov eax, [edi + my_date_size * ebx + my_date.month]
    cmp ax, word[esi + my_date.month]
    jl had_bday
    pop eax
    dec eax
    push eax
had_bday:
    pop eax
    cmp eax, 0
    jnl is_ok
    xor eax, eax
is_ok:
    mov dword[ecx + 4 * ebx], eax
    inc ebx
    cmp ebx, edx
    jne for_loop

    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY
