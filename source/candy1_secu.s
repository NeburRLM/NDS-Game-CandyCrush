@;=                                                               		=
@;=== candy1_secu.s: rutinas para detectar y elimnar secuencias 	  ===
@;=                                                             	  	=
@;=== Programador tarea 1C: ines.ortiz@estudiants.urv.cat				  ===
@;=== Programador tarea 1D: ines.ortiz@estudiants.urv.cat				  ===
@;=                                                           		   	=



.include "../include/candy1_incl.i"


@;-- .bss. variables (globales) no inicializadas ---
.bss
		.align 2
@; número de secuencia: se utiliza para generar números de secuencia únicos,
@;	(ver rutinas 'marcar_horizontales' y 'marcar_verticales') 
	num_sec:	.space 1



@;-- .text. código de las rutinas ---
.text	
		.align 2
		.arm



@;TAREA 1C;
@; hay_secuencia(*matriz): rutina para detectar si existe, por lo menos, una
@;	secuencia de tres elementos iguales consecutivos, en horizontal o en
@;	vertical, incluyendo elementos en gelatinas simples y dobles.
@;	Restricciones:
@;		* para detectar secuencias se invocará la rutina 'cuenta_repeticiones'
@;			(ver fichero "candy1_move.s")
@;	Parámetros:
@;		R0 = dirección base de la matriz de juego
@;	Resultado:
@;		R0 = 1 si hay una secuencia, 0 en otro caso
	.global hay_secuencia
hay_secuencia:
		push {r1-r5,lr}
		
			mov r4, #0 @;posició de la matriu
			mov r5, r0 @;direccio matriu
		
			mov r1, #0 @;files
		.Lcanvicol:
			mov r2, #0 @;columnes
		.Lformatriu:
			ldrb r3, [r5, r4] @;carreguem el valor de la posició de la matriu
			.Lifbuit:
				cmp r3, #0
				beq .Lsalt
				cmp r3, #7
				beq .Lsalt
				cmp r3, #8
				beq .Lsalt
				cmp r3, #15
				beq .Lsalt
				cmp r3, #16
				beq .Lsalt
			.Lifantcol:
				cmp r2, #COLUMNS-2 @;penultima columna
				bge .Lsalt
				mov r0, r5
				mov r3, #0
				bl cuenta_repeticiones
				cmp r0, #3
				movge r0, #1
				bge .Lfiambsec
			.Lifantfil:
				cmp r1, #ROWS-2 @;penultima fila
				bge .Lsalt
				mov r0, r5
				mov r3, #1
				bl cuenta_repeticiones
				cmp r0, #3
				movge r0, #1
				bge .Lfiambsec
		.Lsalt:
			cmp r2, #COLUMNS-1 @;ultima columna
			beq .Lmirarfi
			add r2, #1
			add r4, #1
			b .Lformatriu
		.Lmirarfi:
			cmp r1, #ROWS-1
			beq .Lfisensesec
			add r1, #1
			add r4, #1
			b .Lcanvicol
		.Lfisensesec:
			mov r0, #0
		.Lfiambsec:
		
		
		pop {r1-r5,pc}



@;TAREA 1D;
@; elimina_secuencias(*matriz, *marcas): rutina para eliminar todas las
@;	secuencias de 3 o más elementos repetidos consecutivamente en horizontal,
@;	vertical o combinaciones, así como de reducir el nivel de gelatina en caso
@;	de que alguna casilla se encuentre en dicho modo; 
@;	además, la rutina marca todos los conjuntos de secuencias sobre una matriz
@;	de marcas que se pasa por referencia, utilizando un identificador único para
@;	cada conjunto de secuencias (el resto de las posiciones se inicializan a 0). 
@;	Parámetros:
@;		R0 = dirección base de la matriz de juego
@;		R1 = dirección de la matriz de marcas
		.global elimina_secuencias
elimina_secuencias:
		push {r2-r8, lr}
		
		mov r5, #8
		mov r6, #0
		mov r8, #0				@;R8 es desplazamiento posiciones matriz
	.Lelisec_for0:
		strb r6, [r1, r8]		@;poner matriz de marcas a cero
		add r8, #1
		cmp r8, #ROWS*COLUMNS
		blo .Lelisec_for0
		
		bl marcar_horizontales
		bl marcar_verticales
		
		mov r3, #0 @;posicions matriu marques
	.Leliminarsec:
		ldrb r2, [r1, r3]
		cmp r2, #0
		beq .Lfieliminarsec @;si es igual passem a la seg. posicio
		ldrb r4, [r0, r3]
		cmp r4, #14
		bgt .Ltegeldob
		strb r6, [r0, r3]
		b .Lfieliminarsec
	.Ltegeldob:
		strb r5, [r0, r3]
	.Lfieliminarsec:
		add r3, #1
		cmp r3, #ROWS*COLUMNS
		blo .Leliminarsec
		
		pop {r2-r8, pc}


	
@;:::RUTINAS DE SOPORTE:::



@; marcar_horizontales(mat): rutina para marcar todas las secuencias de 3 o más
@;	elementos repetidos consecutivamente en horizontal, con un número identifi-
@;	cativo diferente para cada secuencia, que empezará siempre por 1 y se irá
@;	incrementando para cada nueva secuencia, y cuyo último valor se guardará en
@;	la variable global 'num_sec'; las marcas se guardarán en la matriz que se
@;	pasa por parámetro 'mat' (por referencia).
@;	Restricciones:
@;		* se supone que la matriz 'mat' está toda a ceros
@;		* para detectar secuencias se invocará la rutina 'cuenta_repeticiones'
@;			(ver fichero "candy1_move.s")
@;	Parámetros:
@;		R0 = dirección base de la matriz de juego
@;		R1 = dirección de la matriz de marcas
marcar_horizontales:
		push {r2-r10,lr}
		
		ldr r4, =num_sec
		mov r5, r0
		mov r6, r1
		mov r1, #0 @;files
		mov r2, #0 @;columnes
		mov r3, #0 @;orientacio est
		mov r7, #1 @;num_sec
		mov r9, #0 @;posicions matrius
		.Lformatriuh:
			ldrb r8, [r5, r9]
			
			cmp r8, #0
			beq .Lfiformatriuh
			cmp r8, #7
			beq .Lfiformatriuh
			cmp r8, #8
			beq .Lfiformatriuh
			cmp r8, #15
			beq .Lfiformatriuh
			cmp r8, #16
			beq .Lfiformatriuh
			
			mov r0, r5
			bl cuenta_repeticiones
			cmp r0, #3
			blt .Lfiformatriuh @;en el cas de que no hi hagi secuencia
			mov r10, #0 @;repeticions del bucle
			.Lforguardarmarca:
				add r10, #1 @;incrementem contador
				strb r7, [r6, r9] @;guardem num_sec
				cmp r10, r0
				beq .Lfiformatriuh 
				add r9, #1 @;si no es igual passem a la seguent posicio
				add r2, #1 @;afegim una columna
				b .Lforguardarmarca
				add r7, #1 @;quan hem acabat canviem num_sec
		.Lfiformatriuh:
			cmp r2, #COLUMNS-1
			moveq r2, #0 @;si arrivem al maxim de col. posem a 0
			addeq r1, #1 @;i sumem 1 fila
			addne r2, #1 @;si no es max. incrementem col.
			add r9, #1
			cmp r9, #ROWS*COLUMNS
			blo .Lformatriuh
			strb r7, [r4]
			mov r0, r5
			mov r1, r6		
		
		pop {r2-r10,pc}



@; marcar_verticales(mat): rutina para marcar todas las secuencias de 3 o más
@;	elementos repetidos consecutivamente en vertical, con un número identifi-
@;	cativo diferente para cada secuencia, que seguirá al último valor almacenado
@;	en la variable global 'num_sec'; las marcas se guardarán en la matriz que se
@;	pasa por parámetro 'mat' (por referencia);
@;	sin embargo, habrá que preservar los identificadores de las secuencias
@;	horizontales que intersecten con las secuencias verticales, que se habrán
@;	almacenado en en la matriz de referencia con la rutina anterior.
@;	Restricciones:
@;		* se supone que la matriz 'mat' está marcada con los identificadores
@;			de las secuencias horizontales
@;		* la variable 'num_sec' contendrá el siguiente indentificador (>=1)
@;		* para detectar secuencias se invocará la rutina 'cuenta_repeticiones'
@;			(ver fichero "candy1_move.s")
@;	Parámetros:
@;		R0 = dirección base de la matriz de juego
@;		R1 = dirección de la matriz de marcas
marcar_verticales:
		push {r2-r12,lr}
		
		ldr r4, =num_sec
		mov r5, r0
		mov r6, r1
		mov r1, #0 @;files
		mov r2, #0 @;columnes
		mov r3, #1 @;orientacio sud
		ldrb r7, [r4] @;num_sec
		mov r9, #0 @;posicions matrius
		
		.Lformatriuv:
			ldrb r8, [r5, r9]
			
			cmp r8, #0
			beq .Lfiformatriuv
			cmp r8, #7
			beq .Lfiformatriuv
			cmp r8, #8
			beq .Lfiformatriuv
			cmp r8, #15
			beq .Lfiformatriuv
			cmp r8, #16
			beq .Lfiformatriuv
			
			mov r0, r5
			bl cuenta_repeticiones
			cmp r0, #3
			blt .Lfiformatriuv
			
		.Lhihasec:
			ldrb r10, [r6, r9]
			cmp r10, #0
			@;si es igual
			mov r11, #0 @;contador
			mov r12, r9
			bne .Lsecexis
			add r7, #1
			.Lnovasec:
				add r11, #1 @;incrementem contador
				strb r7, [r6, r12]
				cmp r11, r0
				beq .Lfiformatriuv
				add r12, #9 @;passem a la fila seg.
				add r1, #1 @;passem a la seg. fila
				b .Lnovasec
			.Lsecexis:
				add r11, #1
				strb r10, [r6, r12]
				cmp r11, r0
				beq .Lfiformatriuv
				add r12, #9
				add r1, #1
				b .Lsecexis
		.Lfiformatriuv:
			add r7, #1
			cmp r1, #ROWS-1
			moveq r1, #0 @;si arrivem al maxim de fila posem a 0
			addeq r2, #1 @;i sumem 1 col
			addne r1, #1 @;si no es max. incrementem fila
			mov r10, #ROWS
			mla r9, r1, r10, r2
			cmp r2, #COLUMNS-1
			ble .Lformatriuv
			strb r7, [r4]
			mov r0, r5
			mov r1, r6
		
		pop {r2-r12,pc}



.end
