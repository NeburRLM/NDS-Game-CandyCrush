@;=                                                               		=
@;=== candy1_combi.s: rutinas para detectar y sugerir combinaciones   ===
@;=                                                               		=
@;=== Programador tarea 1G: ines.ortiz@estudiants.urv.cat				  ===
@;=== Programador tarea 1H: ines.ortiz@estudiants.urv.cat				  ===
@;=                                                             	 	=



.include "../include/candy1_incl.i"



@;-- .text. c�digo de las rutinas ---
.text	
		.align 2
		.arm



@;TAREA 1G;
@; hay_combinacion(*matriz): rutina para detectar si existe, por lo menos, una
@;	combinaci�n entre dos elementos (diferentes) consecutivos que provoquen
@;	una secuencia v�lida, incluyendo elementos en gelatinas simples y dobles.
@;	Par�metros:
@;		R0 = direcci�n base de la matriz de juego
@;	Resultado:
@;		R0 = 1 si hay una secuencia, 0 en otro caso
	.global hay_combinacion
hay_combinacion:
		push {r1-r8,lr}
		
		mov r1, #0 @;filas
		mov r2, #0 @;columnas
		mov r4, #0 @;posicio de la matriu
		mov r8, r0
		.Lcodi:
		ldrb r5, [r8, r4]
		cmp r5, #0 @;mirem que no es espai buit, bloc solid o forat
		beq .Lfi
		cmp r5, #7
		beq .Lfi
		cmp r5, #8
		beq .Lfi
		cmp r5, #15
		beq .Lfi
		cmp r5, #16
		beq .Lfi
		
		cmp r2, #COLUMNS-2 @;mirem que la columna sigui anterior a la ultima
		bgt .Lfi
		mov r6, r4 @;auxiliar de les posicions matriu
		add r6, #1 @;mirem la posicio de la dreta
		ldrb r7, [r8, r6]
		cmp r7, r5 @;miramos que sea diferente el numero de su derecha
		beq .Lfi
		cmp r7, #0 @;miramos que no sea u espacio en blanca ni bloque ni hueco
		beq .Lfi
		cmp r7, #7
		beq .Lfi
		cmp r7, #8
		beq .Lfi
		cmp r7, #15
		beq .Lfi
		cmp r7, #16
		beq .Lfi
		
		strb r7, [r8, r4] @;intercambiamos las posiciones
		strb r5, [r8, r6]
		
		@;0 -> este derecha, 1 -> sur, 2 -> oeste, 3->norte
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #0
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficomphor
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #1
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficomphor
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #2
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficomphor
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #3
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficomphor
		
		@;ahora hacemos lo mismo que antes pero para la posicion de la derecha
		add r2, #1
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #0
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficomphor
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #1
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficomphor
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #2
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficomphor
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #3
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficomphor
		
		strb r5, [r8, r4] @;ponemos los valores en su sitio anterior
		strb r7, [r8, r6]
		sub r2, #1 @;volvemos a poner el numero de columnas inicial
		b .Lverticales
		
		.Lficomphor:
		mov r0, #1
		strb r5, [r8, r4] @;ponemos los valores en su sitio anterior
		strb r7, [r8, r6]
		b .Lfinal
		
		.Lverticales:
		cmp r1, #ROWS-1
		bge .Lfi
		mov r6, r1 @;auxiliar de la posicion matriz
		add r6, #9 @;para mirar la posicion de abajo
		ldrb r7, [r8, r6]
		cmp r5, r7 @;miramos que las posiciones no sean iguales i que no sea hueco, etc.
		beq .Lfi
		cmp r7, #0
		beq .Lfi
		cmp r7, #7
		beq .Lfi
		cmp r7, #8
		beq .Lfi
		cmp r7, #15
		beq .Lfi
		cmp r7, #16
		beq .Lfi
		
		strb r5, [r8, r6] @;intercambiamos posiciones
		strb r7, [r8, r4]
		
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #0
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficompver
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #1
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficompver
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #2
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficompver
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #3
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficompver
		
		@;hacemos lo mismo pero para la posicion de abajo
		add r1, #1
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #0
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficompver
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #1
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficompver
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #2
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficompver
		mov r0, r8 @;miramos si hay alguna secuencia posible en alguna orientacion
		mov r3, #3
		bl cuenta_repeticiones
		cmp r0, #3
		bge .Lficompver
		
		strb r5, [r8, r4] @;ponemos los valores en su sitio anterior
		strb r7, [r8, r6]
		sub r1, #1 @;volvemos a poner el numero de columnas inicial
		b .Lfi
		
		.Lficompver:
		mov r0, #1
		strb r5, [r8, r4] @;ponemos los valores en su sitio anterior
		strb r7, [r8, r6]
		b .Lfinal
		
		.Lfi:
		cmp r2, #COLUMNS-1 @;mirem si estem a la ultima col.
		moveq r2, #0 @;si estem a la ultima col posem a 0 les col. i sumem una fila
		addeq r1, #1
		addne r2, #1 @;si no estem avancem una col.
		add r4, #1
		cmp r4, #ROWS*COLUMNS @;mirem que no estem al final de la matriu
		blo .Lcodi
		mov r0, #0
		.Lfinal:
		
		pop {r1-r8,pc}



@;TAREA 1H;
@; sugiere_combinacion(*matriz, *sug): rutina para detectar una combinaci�n
@;	entre dos elementos (diferentes) consecutivos que provoquen una secuencia
@;	v�lida, incluyendo elementos en gelatinas simples y dobles, y devolver
@;	las coordenadas de las tres posiciones de la combinaci�n (por referencia).
@;	Restricciones:
@;		* se supone que existe por lo menos una combinaci�n en la matriz
@;			 (se debe verificar antes con la rutina 'hay_combinacion')
@;		* la combinaci�n sugerida tiene que ser escogida aleatoriamente de
@;			 entre todas las posibles, es decir, no tiene que ser siempre
@;			 la primera empezando por el principio de la matriz (o por el final)
@;		* para obtener posiciones aleatorias, se invocar� la rutina 'mod_random'
@;			 (ver fichero "candy1_init.s")
@;	Par�metros:
@;		R0 = direcci�n base de la matriz de juego
@;		R1 = direcci�n del vector de posiciones (char *), donde la rutina
@;				guardar� las coordenadas (x1,y1,x2,y2,x3,y3), consecutivamente.
	.global sugiere_combinacion
sugiere_combinacion:
		push {r2-r12,lr}
		@; mla r6, fila actual * columna total + columna actual
		mov r4, r0 @;auxiliar posicion matriz
		mov r5, r1 @;auxiliar direccion del vector
		
		.LnumAleatorio:
		mov r0, #9 @;numeros aleatorios entre 0 y 8
		bl mod_random
		mov r1, r0	@;ponemos el numero de fila aleatorio
		mov r0, #9
		bl mod_random
		mov r2, r0 @;ponemos el numero de columna aleatorio
		
		mov r6, #COLUMNS
		mla r7, r1, r6, r2 @;calculamos la posicion de la matriz
		mov r9, r7 @;auxiliar posiciones
		.Lcodigo:
			ldrb r8, [r4, r7] @;cogemos el valor
			cmp r8, #0
			beq .Lfinal2
			cmp r8, #7
			beq .Lfinal2
			cmp r8, #8
			beq .Lfinal2
			cmp r8, #15
			beq .Lfinal2
			cmp r8, #16
			beq .Lfinal2
			mov r11, r1 @;auxiliar fila
			mov r12, r2 @;auxiliar columna
		.Lcpi0:
			mov r9, r7 @;auxiliar posiciones
			cmp r2, #0
			beq .Lcpi1
			sub r9, #1 @;miramos elemento de la izquierda
			ldrb r10, [r4, r9]
			cmp r10, #0
			moveq r2, r12
			beq .Lfinal2
			cmp r10, #7
			moveq r2, r12
			beq .Lfinal2
			cmp r10, #8
			moveq r2, r12
			beq .Lfinal2
			cmp r10, #15
			moveq r2, r12
			beq .Lfinal2
			cmp r10, #16
			moveq r2, r12
			beq .Lfinal2
			strb r8, [r4, r9] @;intercambiamos posiciones
			strb r10, [r4, r7]
			sub r2, #1
			bl detectar_orientacion
			strb r8, [r4, r7]
			strb r10, [r4, r9]
			mov r2, r12
			cmp r0, #6
			movne r12, #0
			bne .LgenerarPos
		.Lcpi1:
			mov r9, r7 @;auxiliar posiciones
			cmp r2, #COLUMNS-1
			beq .Lcpi2
			add r9, #1	@;cogemos elemento de la derecha
			ldrb r10, [r4, r9]
			cmp r10, #0
			moveq r2, r12
			beq .Lfinal2
			cmp r10, #7
			moveq r2, r12
			beq .Lfinal2
			cmp r10, #8
			moveq r2, r12
			beq .Lfinal2
			cmp r10, #15
			moveq r2, r12
			beq .Lfinal2
			cmp r10, #16
			moveq r2, r12
			beq .Lfinal2
			strb r8, [r4, r9]	@;intercambiamos posiciones
			strb r10, [r4, r7]
			add r2, #1
			bl detectar_orientacion @;devuelve el codigo de orientacion
			strb r8, [r4, r7]	@;devolvemos los numeros a su posicion
			strb r10, [r4, r9]
			mov r2, r12
			cmp r0, #6
			movne r12, #1
			bne .LgenerarPos
		.Lcpi2:
			mov r9, r7 @;auxiliar posiciones
			cmp r1, #0
			beq .Lcpi3
			sub r1, #1 @;cogemos la posicion de arriba
			sub r9, #9
			ldrb r10, [r4, r9]
			cmp r10, #0
			moveq r1, r11
			beq .Lfinal2
			cmp r10, #7
			moveq r1, r11
			beq .Lfinal2
			cmp r10, #8
			moveq r1, r11
			beq .Lfinal2
			cmp r10, #15
			moveq r1, r11
			beq .Lfinal2
			cmp r10, #16
			moveq r1, r11
			beq .Lfinal2
			strb r8, [r4, r9]	@;intercambiamos posiciones
			strb r10, [r4, r7]
			bl detectar_orientacion @;devuelve el codigo de orientacion
			strb r8, [r4, r7]	@;devolvemos los numeros a su posicion
			strb r10, [r4, r9]
			mov r1, r11
			cmp r0, #6
			movne r12, #2
			bne .LgenerarPos
		.Lcpi3:
			mov r9, r7 @;auxiliar posiciones
			cmp r1, #ROWS-1
			beq .Lfinal2
			add r1, #1
			add r9, #9
			ldrb r10, [r4, r9]
			cmp r10, #0
			moveq r1, r11
			beq .Lfinal2
			cmp r10, #7
			moveq r1, r11
			beq .Lfinal2
			cmp r10, #8
			moveq r1, r11
			beq .Lfinal2
			cmp r10, #15
			moveq r1, r11
			beq .Lfinal2
			cmp r10, #16
			moveq r1, r11
			beq .Lfinal2
			strb r8, [r4, r9]	@;intercambiamos posiciones
			strb r10, [r4, r7]
			bl detectar_orientacion @;devuelve el codigo de orientacion
			strb r8, [r4, r7]	@;devolvemos los numeros a su posicion
			strb r10, [r4, r9]
			mov r1, r11
			cmp r0, #6
			movne r12, #3
			beq .Lfinal2
		.LgenerarPos:
			mov r3, r0
			mov r0, r5
			mov r9, r4 @;nuevo auxiliar direccion matriz
			mov r4, r12
			bl generar_posiciones
			mov r4, r9 @;devolvemos la direccion de la matriz a su aux
			b .Lficodigo
		.Lfinal2:
			cmp r2, #COLUMNS-1 @;mirem si estem a la ultima col.
			moveq r2, #0 @;si estem a la ultima col posem a 0 les col. i sumem una fila
			addeq r1, #1
			addne r2, #1 @;si no estem avancem una col.
			add r7, #1
			cmp r7, #ROWS*COLUMNS @;mirem que no estem al final de la matriu
			bne .Lcodigo
			mov r1, #0
			mov r2, #0
			mov r7, #0
			b .Lcodigo
		.Lficodigo:
			mov r0, r4
			mov r1, r5
		pop {r2-r12,pc}




@;:::RUTINAS DE SOPORTE:::



@; generar_posiciones(vect_pos,f,c,ori,cpi): genera las posiciones de sugerencia
@;	de combinaci�n, a partir de la posici�n inicial (f,c), el c�digo de
@;	orientaci�n 'ori' y el c�digo de posici�n inicial 'cpi', dejando las
@;	coordenadas en el vector 'vect_pos'.
@;	Restricciones:
@;		* se supone que la posici�n y orientaci�n pasadas por par�metro se
@;			corresponden con una disposici�n de posiciones dentro de los l�mites
@;			de la matriz de juego
@;	Par�metros:
@;		R0 = direcci�n del vector de posiciones 'vect_pos'
@;		R1 = fila inicial 'f'
@;		R2 = columna inicial 'c'
@;		R3 = c�digo de orientaci�n;
@;				inicio de secuencia: 0 -> Este, 1 -> Sur, 2 -> Oeste, 3 -> Norte
@;				en medio de secuencia: 4 -> horizontal, 5 -> vertical
@;		R4 = c�digo de posici�n inicial:
@;				0 -> izquierda, 1 -> derecha, 2 -> arriba, 3 -> abajo
@;	Resultado:
@;		vector de posiciones (x1,y1,x2,y2,x3,y3), devuelto por referencia
generar_posiciones:
		push {r5-r9,lr}
		
		mov r5, #0 @;posiciones del vector
		mov r6, r1 @;filas
		mov r7, r2 @;columnas
		mov r8, r1
		mov r9, r2
		
		.Lguardar:
			strb r2, [r0, r5] @;guardamos la columna pi
			add r5, #1
			strb r1, [r0, r5] @;guardamos la fila pi
			
			cmp r3, #0 @;miramos la orientaci�n que coge
			beq .Leste
			cmp r3, #1
			beq .Lsur
			cmp r3, #2
			beq .Loeste
			cmp r3, #3
			beq .Lnorte
			cmp r3, #4
			beq .Lhorizontal
			cmp r3, #5
			beq .Lvertical
			
		.Leste:
			cmp r4, #0
			beq .Lincompatible
			cmp r4, #1
			beq .Le1
			cmp r4, #2
			beq .Le2
			cmp r4, #3
			beq .Le3
		.Le1:
			add r7, #2
			add r5, #1
			strb r7, [r0, r5]
			add r5, #1
			strb r1, [r0, r5]
			add r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r5, #1
			strb r1, [r0, r5]
			b .Lincompatible
		.Le2:
			add r7, #1
			add r5, #1
			strb r7, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
		.Le3:
			add r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
			
		.Lsur:
			cmp r4, #0
			beq .Ls0
			cmp r4, #1
			beq .Ls1
			cmp r4, #2
			beq .Lincompatible
			cmp r4, #3
			beq .Ls3
		.Ls0:
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r5, #1
			strb r7, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
		.Ls1:
			add r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r5, #1
			strb r7, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
		.Ls3:
			add r5, #1
			strb r2, [r0, r5]
			add r6, #2
			add r5, #1
			strb r6, [r0, r5]
			add r5, #1
			strb r2, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
			
		.Loeste:
			cmp r4, #0
			beq .Lo0
			cmp r4, #1
			beq .Lincompatible
			cmp r4, #2
			beq .Lo2
			cmp r4, #3
			beq .Lo3
		.Lo0:
			sub r7, #2
			add r5, #1
			strb r7, [r0, r5]
			add r5, #1
			strb r1, [r0, r5]
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r5, #1
			strb r1, [r0, r5]
			b .Lincompatible
		.Lo2:
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
		.Lo3:
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
			
		.Lnorte:
			cmp r4, #0
			beq .Ln0
			cmp r4, #1
			beq .Ln1
			cmp r4, #2
			beq .Ln2
			cmp r4, #3
			beq .Lincompatible
		.Ln0:
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r5, #1
			strb r7, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
		.Ln1:
			add r7, #1
			add r5, #1
			strb r7, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r5, #1
			strb r7, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
		.Ln2:
			add r5, #1
			strb r2, [r0, r5]
			sub r6, #2
			add r5, #1
			strb r6, [r0, r5]
			add r5, #1
			strb r2, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible	
		
		.Lhorizontal:
			cmp r4, #0
			beq .Lincompatible
			cmp r4, #1
			beq .Lincompatible
			cmp r4, #2
			beq .Lh2
			cmp r4, #3
			beq .Lh3
		.Lh2:
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r9, #1
			add r5, #1
			strb r9, [r0, r5]
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
		.Lh3:
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r9, #1
			add r5, #1
			strb r9, [r0, r5]
			add r5, #1
			strb r6, [r0, r5]
			b .Lincompatible
		
		.Lvertical:
			cmp r4, #0
			beq .Lv0
			cmp r4, #1
			beq .Lv1
			cmp r4, #2
			beq .Lincompatible
			cmp r4, #3
			beq .Lincompatible
		.Lv0:
			sub r7, #1
			add r5, #1
			strb r7, [r0, r5]
			sub r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r5, #1
			strb r7, [r0, r5]
			add r8, #1
			add r5, #1
			strb r8, [r0, r5]
			b .Lincompatible
		.Lv1:
			add r7, #1
			add r5, #1
			strb r7, [r0, r5]
			add r6, #1
			add r5, #1
			strb r6, [r0, r5]
			add r5, #1
			strb r7, [r0, r5]
			sub r8, #1
			add r5, #1
			strb r8, [r0, r5]
		
		.Lincompatible:
		
		pop {r5-r9,pc}



@; detectar_orientacion(f,c,mat): devuelve el c�digo de la primera orientaci�n
@;	en la que detecta una secuencia de 3 o m�s repeticiones del elemento de la
@;	matriz situado en la posici�n (f,c).
@;	Restricciones:
@;		* para proporcionar aleatoriedad a la detecci�n de orientaciones en las
@;			que se detectan secuencias, se invocar� la rutina 'mod_random'
@;			(ver fichero "candy1_init.s")
@;		* para detectar secuencias se invocar� la rutina 'cuenta_repeticiones'
@;			(ver fichero "candy1_move.s")
@;		* s�lo se tendr�n en cuenta los 3 bits de menor peso de los c�digos
@;			almacenados en las posiciones de la matriz, de modo que se ignorar�n
@;			las marcas de gelatina (+8, +16)
@;	Par�metros:
@;		R1 = fila 'f'
@;		R2 = columna 'c'
@;		R4 = direcci�n base de la matriz
@;	Resultado:
@;		R0 = c�digo de orientaci�n;
@;				inicio de secuencia: 0 -> Este, 1 -> Sur, 2 -> Oeste, 3 -> Norte
@;				en medio de secuencia: 4 -> horizontal, 5 -> vertical
@;				sin secuencia: 6 
detectar_orientacion:
		push {r3,r5,lr}
		
		mov r5, #0				@;R5 = �ndice bucle de orientaciones
		mov r0, #4
		bl mod_random
		mov r3, r0				@;R3 = orientaci�n aleatoria (0..3)
	.Ldetori_for:
		mov r0, r4
		bl cuenta_repeticiones
		cmp r0, #1
		beq .Ldetori_cont		@;no hay inicio de secuencia
		cmp r0, #3
		bhs .Ldetori_fin		@;hay inicio de secuencia
		add r3, #2
		and r3, #3				@;R3 = salta dos orientaciones (m�dulo 4)
		mov r0, r4
		bl cuenta_repeticiones
		add r3, #2
		and r3, #3				@;restituye orientaci�n (m�dulo 4)
		cmp r0, #1
		beq .Ldetori_cont		@;no hay continuaci�n de secuencia
		tst r3, #1
		bne .Ldetori_vert
		mov r3, #4				@;detecci�n secuencia horizontal
		b .Ldetori_fin
	.Ldetori_vert:
		mov r3, #5				@;detecci�n secuencia vertical
		b .Ldetori_fin
	.Ldetori_cont:
		add r3, #1
		and r3, #3				@;R3 = siguiente orientaci�n (m�dulo 4)
		add r5, #1
		cmp r5, #4
		blo .Ldetori_for		@;repetir 4 veces
		
		mov r3, #6				@;marca de no encontrada
		
	.Ldetori_fin:
		mov r0, r3				@;devuelve orientaci�n o marca de no encontrada
		
		pop {r3,r5,pc}



.end
