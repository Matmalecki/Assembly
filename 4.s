.intel_syntax noprefix

.global main

.text

main:
	finit
	mov ebp, esp

	mov eax, [ebp+8]
	mov ebx, [eax+4]
	push ebx
	call atof
	add esp,4
	fstp QWORD PTR x

	mov ebp, esp
	
	mov eax, [ebp+8]
	mov ebx, [eax+8]
	push ebx
	call atof
	add esp,4
	fstp QWORD PTR dokladnosc
	

	fld QWORD PTR rok
	fld QWORD PTR wynik
	faddp
	fstp QWORD PTR wynik	


	
	fld QWORD PTR x
	fstp QWORD PTR rok

	fld QWORD PTR x
	fld QWORD PTR x
	faddp
	fstp QWORD PTR x	


	call sin

	fld QWORD PTR wynik
	fld QWORD PTR sin_value
	fsubp
	fstp QWORD PTR wynik

	fld QWORD PTR rok
	fstp QWORD PTR x
	
	fld QWORD PTR x
	fld QWORD PTR x
	fmulp
	fstp QWORD PTR x

	fld QWORD PTR rok
	fld QWORD PTR x
	fmulp
	fstp QWORD PTR x	

	call cos


	fld QWORD PTR wynik
	fld QWORD PTR cos_value
	faddp
	fstp QWORD PTR wynik
	
	fld QWORD PTR wynik
	sub esp, 8
	fstp QWORD PTR [esp]

	mov eax, offset napis
	push eax
	call printf
	add esp, 12
	
	mov eax, 0
	ret


;// edx - k

sin:
	xor edx, edx
petla_sin:

	fld1
	fstp QWORD PTR silnia_value
	
	fld1
	fstp QWORD PTR pow_value

	push edx

	mov ebx, 2
	mov eax, edx
	mul ebx
	inc eax


	push eax
	call pow	
	pop eax

	fld1
	fstp QWORD PTR pom
	
	mov ebx, eax
	call silnia
	
	fld QWORD PTR pow_value
	fld QWORD PTR silnia_value
	fdivp
	fstp QWORD PTR pom
	
	pop edx
	
	mov eax, edx
	call one_pow	
	
	inc edx	
	cmp eax, 1
	jne skok_sin

	fld QWORD PTR pom
	fld QWORD PTR sin_value
	faddp
	fstp QWORD PTR sin_value
	
	jmp dok_sin

skok_sin:

	fld QWORD PTR sin_value
	fld QWORD PTR pom
	fsubp
	fstp QWORD PTR sin_value

dok_sin:

	fld QWORD PTR pom
	fld QWORD PTR dokladnosc
	fcompp
	fstsw
	sahf

	jb petla_sin

k_s:
	fld1
	fstp QWORD PTR pom
	ret




cos:
	xor edx, edx
petla_cos:

	fld1
	fstp QWORD PTR silnia_value
	
	fld1
	fstp QWORD PTR pow_value

	push edx

	mov ebx, 2  
	mov eax, edx
	mul ebx

	push eax
	call pow	
	pop eax

	fld1
	fstp QWORD PTR pom
	
	mov ebx, eax
	call silnia
	
	fld QWORD PTR pow_value
	fld QWORD PTR silnia_value
	fdivrp
	fstp QWORD PTR pom
	
	pop edx
	
	mov eax, edx
	call one_pow	
	
	inc edx	
	cmp eax, 1
	jne skok_cos

	fld QWORD PTR cos_value
	fld QWORD PTR pom
	faddp
	fstp QWORD PTR cos_value
	
	jmp dok_cos

skok_cos:

	fld QWORD PTR cos_value
	fld QWORD PTR pom
	fsubp
	fstp QWORD PTR cos_value

dok_cos:

	fld QWORD PTR pom
	fld QWORD PTR dokladnosc
	fcompp
	fstsw
	sahf

	jb petla_cos

k_c:
	fld1
	fstp QWORD PTR pom
	ret

;// przekazanie przez eax wychodzi eax
one_pow:
	push ebp
	mov ebp, esp
	push ebx
	push ecx
	push edx
	xor edx, edx
	mov ebx, 2
	div ebx
	cmp edx, 0
	je s_o_p
	mov eax, -1
	jmp k_o_p
s_o_p:
	mov eax, 1
k_o_p:
	pop edx
	pop ecx
	pop ebx
	mov esp, ebp 
	pop ebp
	ret


;// przekazuje ebx 
silnia:
	cmp ebx, 0
	je k_silnia
	fld QWORD PTR pom
	fld QWORD PTR silnia_value
	fmulp
	fstp QWORD PTR silnia_value

	fld1
	fld QWORD PTR pom
	faddp 
	fstp QWORD PTR pom

	dec ebx
	jmp silnia
k_silnia:
	fld1
	fstp QWORD PTR pom
	ret


;// przed wywolaniem musi byc w x arg, potega poprzez eax
pow:	
	cmp eax, 0
	je k_pow 
	fld QWORD PTR pow_value
	fld QWORD PTR x
	fmulp
	fstp QWORD PTR pow_value
	dec eax
	jmp pow
k_pow:
	ret


.data
x:		.double 2.3
pow_value:	.double 1.0
sin_value:	.double 0.0
cos_value:	.double 0.0
dokladnosc:	.double 0.00001
wynik:		.double 0.0
silnia_value:	.double 1.0
rok:		.double 2017
pom:		.double 1.0
napis: .asciz "Wynik: %.10lf\n"