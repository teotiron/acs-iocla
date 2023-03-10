section .text
	global sort

; struct node {
;     	int val;
;    	struct node* next;
; };

;; struct node* sort(int n, struct node* node);
; 	The function will link the nodes in the array
;	in ascending order and will return the address
;	of the new found head of the list
; @params:
;	n -> the number of nodes in the array
;	node -> a pointer to the beginning in the array
; @returns:
;	the address of the head of the sorted list
sort:
	enter 0, 0
	xor esi, esi
	xor edx, edx ;initial value is 0x0 (NULL)
	mov ecx, [ebp + 8]
;	Resets eax to head of array
set_head:
	mov eax, [ebp + 12]
	xor ebx, ebx
;	Searches in array for node with value of current ecx
find_value:
	mov esi, [eax]
	cmp esi, ecx
	jne ignore
;	When found, sets *next to edx, then sets edx to current node
	mov [eax + 4], edx
	mov edx, eax
	jmp skip_rest
ignore:
	add eax, 8
	inc ebx
	cmp ebx, [ebp + 8]
	jne find_value
skip_rest:
	loop set_head
;	In the end, eax will have pointer to node with value 1
	leave
	ret
