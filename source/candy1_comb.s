@;=                                                               		=
@;=== candy1_combi.s: rutinas para detectar y sugerir combinaciones   ===
@;=                                                               		=
@;=== Programador tarea 1G: ines.ortiz@estudiants.urv.cat				  ===
@;=== Programador tarea 1H: yyy.yyy@estudiants.urv.cat				  ===
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
		b .Lfi
		
		.Lficomphor:
		mov r0, #1
		strb r5, [r8, r4] @;ponemos los valores en su sitio anterior
		strb r7, [r8, r6]
		b .Lfinal
		
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
		push {lr}
		
		
		
		
		pop {pc}




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
		push {lr}
		
		
		pop {pc}



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
