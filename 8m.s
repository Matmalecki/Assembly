.intel_syntax noprefix

.global _start

.text

_start:
    	mov ebp, esp

	mov eax, [ebp]
	cmp eax,3
	jne argc_error

	mov eax, [ebp+8]
	push eax
	call dlugosc_napis 
	add esp,4

	mov ecx, eax

	mov eax,[ebp+8]
	add eax, ecx
	push eax

	mov ebx, [ebp+12]

	mov ecx, [ebp+8]

	xor edx, edx
	
petla_main:
	cmp byte ptr [ebx], 0
	je next
	mov al, [ecx]
	mov ah, [ebx]
	cmp al, ah
	jne skok
	inc ecx
	mov eax, [esp]
	cmp eax, ecx
	jne k_p_main
	inc edx
skok:
	mov ecx, [ebp+8]
	mov al, [ecx]
	cmp al, ah
	jne k_p_main
	inc ecx
k_p_main:
	inc ebx
	jmp petla_main

next:
	add esp,4
	mov eax, edx
	cmp eax, 0
	jne wypisz
	add eax, '0'
	push eax
	mov eax, 4
	mov ebx, 1
	mov ecx, esp
	mov edx, 1
	int 0x80
	add esp,4
	jmp wyjscie
wypisz:
	call liczba_napis
wyjscie:
  	mov edx, 1
  	mov ecx, offset eol
   	mov ebx, 1
   	mov eax, 4
   	int 0x80;

	jmp koniec
	
liczba_napis:
	push ebp
   	mov ebp, esp
   	push ebx
    	push ecx
    	push edx
	xor ecx, ecx
p_l_n:
	cmp eax, 0
	je loop_l_n
	xor edx, edx
	mov ebx, 10
	div ebx		
	add edx,'0'
	push edx
	inc ecx	
	jmp p_l_n
loop_l_n:
	cmp ecx, 0
	je k_l_n
	dec ecx	
	pop eax
	push ecx
	push eax
	
	mov eax, 4
	mov ebx, 1
	mov ecx, esp
	mov edx, 1
	int 0x80
	add esp,4
	pop ecx
	jmp loop_l_n

k_l_n:
	pop edx
	pop ecx
	pop ebx
	mov esp, ebp
	pop ebp
	ret

dlugosc_napis:

    	push ebp
    	mov ebp, esp
    	push ebx
    	push ecx
	push edx

	mov ebx, [ebp+8]
	xor ecx, ecx

p_d_n:
    	cmp byte ptr [ebx], 0
    	je k_d_n
    	inc ecx
    	inc ebx
    	jmp p_d_n

k_d_n:
    	mov eax, ecx
    	pop edx
    	pop ecx
    	pop ebx
    	mov esp, ebp
    	pop ebp
    	ret



argc_error:
	add al, '0'
	mov [msg+1], al

	mov eax, 4
	mov ebx, 1
	mov ecx, offset msg
	mov edx, offset dlugosc
	int 0x80
	

koniec:
	mov eax, 1
	mov ebx, 0
	int 0x80


.data
eol: .ascii "\n"

msg: .ascii "[ ] Zla liczba argumentow \n"
     .equ dlugosc,$-msg