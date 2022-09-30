@;=                                                         	      	=
@;=== candy1_move: rutinas para contar repeticiones y bajar elementos ===
@;=                                                          			=
@;=== Programador tarea 1E: xxx.xxx@estudiants.urv.cat				  ===
@;=== Programador tarea 1F: yyy.yyy@estudiants.urv.cat				  ===
@;=                                                         	      	=



.include "../include/candy1_incl.i"

MASK_VALOR_SENSE_GEL = 0b00111


@;-- .text. c�digo de las rutinas ---
.text	
		.align 2
		.arm



@;TAREA 1E;
@; cuenta_repeticiones(*matriz,f,c,ori): rutina para contar el n�mero de
@;	repeticiones del elemento situado en la posici�n (f,c) de la matriz, 
@;	visitando las siguientes posiciones seg�n indique el par�metro de
@;	orientaci�n 'ori'.
@;	Restricciones:
@;		* s�lo se tendr�n en cuenta los 3 bits de menor peso de los c�digos
@;			almacenados en las posiciones de la matriz, de modo que se ignorar�n
@;			las marcas de gelatina (+8, +16)
@;		* la primera posici�n tambi�n se tiene en cuenta, de modo que el n�mero
@;			m�nimo de repeticiones ser� 1, es decir, el propio elemento de la
@;			posici�n inicial
@;	Par�metros:
@;		R0 = direcci�n base de la matriz
@;		R1 = fila 'f'
@;		R2 = columna 'c'
@;		R3 = orientaci�n 'ori' (0 -> Este, 1 -> Sur, 2 -> Oeste, 3 -> Norte)
@;	Resultado:
@;		R0 = n�mero de repeticiones detectadas (m�nimo 1)
	.global cuenta_repeticiones
cuenta_repeticiones:														@;		   |
		push {r1-r12,lr}													@;oest<--|   |--->est
																			@;         |
																			@;		  sud
		
		mov r4, #1 									@;r4 contindr� num_repeticions, inicialment =1
		mov r5, #COLUMNS 							@;columnas (carreguem com a valor inmediat ja que es menor que 32 bits)
		mov r6, #ROWS 								@;filas (carreguem com a valor inmediat ja que es menor que 32 bits)
			
		mla r9, r1, r5, r2
		ldrb r8, [r0,r9]
		and r10, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r3, #1 									@;analitzem la orientaci�
		bgt .Nord_Oest 								@;si r3>1 salta (ja que podria ser 2->oest o 3->nord)
		beq .Sud 									@;si r3==1, salta a Sud
		
		.Est: 										@;r3 no �s ni 1 ni �s m�s gran que 1, per tant 0 (Est)
		sub r7, r5, #1 								@;r7=COLUMNS-1=8 (per a comparar dins de la posici� m�xima de la matriu)
		cmp r2, r7 									@;comparem la columna actual amb el m�xim de columnes de la matriu
		bge .Fi 									@;si r2>=r7 (si la columna actual es superior o igual a la m�xima), acaba el programa
		add r2,#1									@;si segueix dins de les dimensions de la matriu, s'incrementa una columna per seguir amb el recorregut Est
		mla r9,r1,r5,r2 							@;obtenim la nova posici� segons la nova columna a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posici� calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la m�scara)
		bne .Fi										@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el n�mero de repeticions consecutius 
		b .Est										@;torna a comen�ar el bucle del recorregut
		
		.Sud: 										@;r3 �s 1
		sub r7, r6, #1 								@;r7=ROWS-1=8 (per a comparar dins de la posici� m�xima de la matriu)
		cmp r1, r7 									@;comparem la fila actual amb el m�xim de columnes de la matriu
		bge .Fi 									@;si r1>=r7 (si la fila actual es superior o igual a la m�xima), acaba el programa
		add r1,#1									@;si segueix dins de les dimensions de la matriu, s'incrementa una fila per seguir amb el recorregut Sud
		mla r9,r1,r5,r2 							@;obtenim la nova posici� segons la nova fila a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posici� calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la m�scara)
		bne .Fi										@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el n�mero de repeticions consecutius
		b .Sud										@;torna a comen�ar el bucle del recorregut
		
		.Nord_Oest:									@;salt a estudiar possible nord o oest
		cmp r3, #2 									@;comparem la orientaci� amb el valor 2
		beq .Oest									@;si r3==2, t� orientaci� de oest, sin� ser� nord
		
		.Nord: 										@;si no es oest, ser� nord
		cmp r1, #0 									@;comparem amb la posici� m�nima de la matriu
		ble .Fi										@;si r1<=0 (si la fila actual es inferior o igual a la m�nima), acaba el programa
		sub r1,#1									@;si segueix dins de les dimensions de la matriu, restem una fila per fer el recorregut NORD
		mla r9,r1,r5,r2 							@;obtenim la nova posici� segons la nova fila a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posici� calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la m�scara)
		bne .Fi										@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el n�mero de repeticions consecutius
		b .Nord										@;torna a comen�ar el bucle del recorregut
			
		.Oest:										@;r3 �s 2 (oest)
		cmp r2, #0 									@;comparem amb la posici� m�nima de la matriu
		ble .Fi 									@;si r2<=0 (si la columna actual es inferior o igual a la m�nima), acaba el programa
		sub r2,#1 									@;si segueix dins de les dimensions de la matriu, restem una columna per fer el recorregut OEST
		mla r9,r1,r5,r2 							@;obtenim la nova posici� segons la nova columna a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posici� calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la m�scara)
		bne .Fi										@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el n�mero de repeticions consecutius
		b .Oest										@;torna a comen�ar el bucle del recorregut
		
			
		.Fi:										@;acaba el programa
		mov r0, r4									@;guardem el valor del registre r4 al registre r0
		
		pop {r1-r12, pc}



@;TAREA 1F;
@; baja_elementos(*matriz): rutina para bajar elementos hacia las posiciones
@;	vac�as, primero en vertical y despu�s en sentido inclinado; cada llamada a
@;	la funci�n s�lo baja elementos una posici�n y devuelve cierto (1) si se ha
@;	realizado alg�n movimiento, o falso (0) si est� todo quieto.
@;	Restricciones:
@;		* para las casillas vac�as de la primera fila se generar�n nuevos
@;			elementos, invocando la rutina 'mod_random' (ver fichero
@;			"candy1_init.s")
@;	Par�metros:
@;		R0 = direcci�n base de la matriz de juego
@;	Resultado:
@;		R0 = 1 indica se ha realizado alg�n movimiento, de modo que puede que
@;				queden movimientos pendientes. 
	.global baja_elementos
baja_elementos:
		push {lr}
		
		
		pop {pc}



@;:::RUTINAS DE SOPORTE:::



@; baja_verticales(mat): rutina para bajar elementos hacia las posiciones vac�as
@;	en vertical; cada llamada a la funci�n s�lo baja elementos una posici�n y
@;	devuelve cierto (1) si se ha realizado alg�n movimiento.
@;	Par�metros:
@;		R4 = direcci�n base de la matriz de juego
@;	Resultado:
@;		R0 = 1 indica que se ha realizado alg�n movimiento. 
baja_verticales:
		push {lr}
		
		
		pop {pc}



@; baja_laterales(mat): rutina para bajar elementos hacia las posiciones vac�as
@;	en diagonal; cada llamada a la funci�n s�lo baja elementos una posici�n y
@;	devuelve cierto (1) si se ha realizado alg�n movimiento.
@;	Par�metros:
@;		R4 = direcci�n base de la matriz de juego
@;	Resultado:
@;		R0 = 1 indica que se ha realizado alg�n movimiento. 
baja_laterales:
		push {lr}
		
		
		pop {pc}



.end
