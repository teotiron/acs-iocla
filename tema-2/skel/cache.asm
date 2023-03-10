;; defining constants, you can use these as immediate values in your code
CACHE_LINES  EQU 100
CACHE_LINE_SIZE EQU 8
OFFSET_BITS  EQU 3
TAG_BITS EQU 29 ; 32 - OFSSET_BITS

section .text
    global load

;; void load(char* reg, char** tags, char cache[CACHE_LINES][CACHE_LINE_SIZE], char* address, int to_replace);
load:
    ;; DO NOT MODIFY
    push ebp
    mov ebp, esp
    pusha

    mov eax, [ebp + 8]  ; address of reg
    mov ebx, [ebp + 12] ; tags
    mov ecx, [ebp + 16] ; cache
    mov edx, [ebp + 20] ; address
    mov edi, [ebp + 24] ; to_replace (index of the cache line that needs to be replaced in case of a cache MISS)
    ;; DO NOT MODIFY

    ;; FREESTYLE STARTS HERE
    mov esi, edx
    shr esi, OFFSET_BITS
    shl esi, OFFSET_BITS
    push eax
    xor eax, eax
    push edx
find_tag:
    mov edx, [ebx + eax * 8]
    cmp edx, esi
    je cache_hit
    inc eax
    cmp eax, CACHE_LINES
    je cache_miss
    jmp find_tag

cache_hit:
    push ecx
    mov ecx, [esp]
    xor edx, edx

hit_product:
    add ecx, eax
    inc edx
    cmp edx, CACHE_LINE_SIZE
    jne hit_product

    xor eax, eax
    mov eax, ecx
    pop ecx
    pop edx
    mov esi, edx
    and esi, 7
    add eax, esi
    xor esi, esi
    mov esi, eax
    pop eax
    push ebx
    xor ebx, ebx
    mov bl, byte[esi]
    mov [eax], ebx
    pop ebx
    jmp finish

cache_miss:
    mov [ebx + edi * 8], esi
    xor edx, edx
    xor eax, eax
    push ecx
    mov ecx, [esp]

miss_product:
    add ecx, edi
    inc edx
    cmp edx, CACHE_LINE_SIZE
    jne miss_product

    xor edx, edx
set_ram:
    mov al, byte[esi + edx]
    mov [ecx + edx], al
    inc edx
    cmp edx, CACHE_LINE_SIZE
    jne set_ram
    xor eax, eax
    mov eax, ecx
    pop ecx
    pop edx
    mov esi, edx
    and esi, 7
    add eax, esi
    xor esi, esi
    mov esi, eax
    pop eax
    push ebx
    xor ebx, ebx
    mov bl, byte[esi]
    mov [eax], ebx
    pop ebx
    jmp finish

finish:
    ;; FREESTYLE ENDS HERE
    ;; DO NOT MODIFY
    popa
    leave
    ret
    ;; DO NOT MODIFY


