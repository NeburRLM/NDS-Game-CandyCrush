@;=                                                         	      	=
@;=== candy1_move: rutinas para contar repeticiones y bajar elementos ===
@;=                                                          			=
@;=== Programador tarea 1E: ruben.lopezm@estudiants.urv.cat				  ===
@;=== Programador tarea 1F: ruben.lopezm@estudiants.urv.cat				  ===
@;=                                                         	      	=



.include "../include/candy1_incl.i"

MASK_VALOR_SENSE_GEL = 0b00111
VALOR = 0b00111
MIRAR_GEL = 0b11000
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
cuenta_repeticiones:
		push {r1-r12,lr}
		
		mov r4, #1 									@;r4 contindr� num_repeticions, inicialment =1
		mov r5, #COLUMNS 							@;columnas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
		mov r6, #ROWS 								@;filas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
			
		mla r9, r1, r5, r2
		ldrb r8, [r0,r9]
		and r10, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedar-nos amb els 3 bits de menor pes
		cmp r3, #1 									@;analitzem la orientaci�
		bgt .Nord_o_Oest 							@;si r3>1 salta (ja que podria ser 2->oest o 3->nord)
		beq .Lconrep_sur 							@;si r3==1, salta a Sud
		
		.Lconrep_este: 								@;r3 no �s ni 1 ni �s m�s gran que 1, per tant 0 (Est)
		sub r7, r5, #1 								@;r7=COLUMNS-1 (per a comparar dins de la posici� m�xima de la matriu)
		cmp r2, r7 									@;comparem la columna actual(r2) amb el m�xim de columnes de la matriu(r5-1)
		bge .Lconrep_fin 							@;si r2>=r7 (si la columna actual es superior o igual a la m�xima), acaba el programa
		add r2,#1									@;si segueix dins de les dimensions de la matriu, s'incrementa una columna per seguir amb el recorregut Est
		mla r9,r1,r5,r2 							@;obtenim la nova posici� segons la nova columna a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posici� calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la m�scara)
		bne .Lconrep_fin							@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el n�mero de repeticions consecutius 
		b .Lconrep_este								@;torna a comen�ar el bucle del recorregut
		
		.Lconrep_sur: 								@;r3 �s 1
		sub r7, r6, #1 								@;r7=ROWS-1 (per a comparar dins de la posici� m�xima de la matriu)
		cmp r1, r7 									@;comparem la fila actual(r1) amb el m�xim de files de la matriu(r6-1)
		bge .Lconrep_fin 							@;si r1>=r7 (si la fila actual es superior o igual a la m�xima), acaba el programa
		add r1,#1									@;si segueix dins de les dimensions de la matriu, s'incrementa una fila per seguir amb el recorregut Sud
		mla r9,r1,r5,r2 							@;obtenim la nova posici� segons la nova fila a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posici� calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la m�scara)
		bne .Lconrep_fin							@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el n�mero de repeticions consecutius
		b .Lconrep_sur								@;torna a comen�ar el bucle del recorregut
		
		.Nord_o_Oest:								@;salt a estudiar possible nord o oest
		cmp r3, #2 									@;comparem la orientaci� amb el valor 2
		beq .Lconrep_oeste							@;si r3==2, t� orientaci� de oest, sin� ser� nord(r3==3)
		
		.Lconrep_norte: 							@;si no es oest, ser� nord(r3==3)
		cmp r1, #0 									@;comparem la fila actual(r1) amb la posici� m�nima de la matriu(#0)
		ble .Lconrep_fin							@;si r1<=0 (si la fila actual es inferior o igual a la m�nima), acaba el programa
		sub r1,#1									@;si segueix dins de les dimensions de la matriu, restem una fila per fer el recorregut NORD
		mla r9,r1,r5,r2 							@;obtenim la nova posici� segons la nova fila a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posici� calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la m�scara)
		bne .Lconrep_fin							@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el n�mero de repeticions consecutius
		b .Lconrep_norte							@;torna a comen�ar el bucle del recorregut
			
		.Lconrep_oeste:								@;r3 �s 2 (oest)
		cmp r2, #0 									@;comparem la columna actual(r2) amb la posici� m�nima de la matriu(#0)
		ble .Lconrep_fin 							@;si r2<=0 (si la columna actual es inferior o igual a la m�nima), acaba el programa
		sub r2,#1 									@;si segueix dins de les dimensions de la matriu, restem una columna per fer el recorregut OEST
		mla r9,r1,r5,r2 							@;obtenim la nova posici� segons la nova columna a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posici� calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem m�scara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la m�scara)
		bne .Lconrep_fin							@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el n�mero de repeticions consecutius
		b .Lconrep_oeste							@;torna a comen�ar el bucle del recorregut
		
			
		.Lconrep_fin:								@;acaba el programa
		mov r0, r4
		
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
		push {r4,lr}
		
		mov r4, r0 									@;direcci� base de la matriu en r4 (per a les rutines auxiliars)
		mov r1, #0 									@;r1=0 -> cap moviment inicial(registre per anotar si hi ha o no moviment)

        bl baja_verticales 							@;mirem si en baja_verticales es produeix un moviment
      
        mov r1, r0 									@;posem en r1 el valor de anotaci� de moviments que retorna la funci� baja_verticales en r0

        cmp r1, #0									@;comprovem si s'ha produ�t algun moviment
        bne .Lfinal_baja_elementos 					@;si hi ha canvis (r1!=0) llavors sortim de baja_elementos, si no hi ha canvis (r1==0) 
										 
		bl baja_laterales 							@;si no hi ha canvis, continuar� la execuci� a la rutina baja_laterales
        mov r1, r0 									@;posem en r1 el valor de anotaci� de moviments que retorna la funci� baja_laterales en r0

		.Lfinal_baja_elementos:				
		strb r1, [r0] 								@;guardem en r0 el contingut del registre r1 (anotaci� de moviment)
		
		pop {r4,pc}



@;:::RUTINAS DE SOPORTE:::



@; baja_verticales(mat): rutina para bajar elementos hacia las posiciones vac�as
@;	en vertical; cada llamada a la funci�n s�lo baja elementos una posici�n y
@;	devuelve cierto (1) si se ha realizado alg�n movimiento.
@;	Par�metros:
@;		R4 = direcci�n base de la matriz de juego
@;	Resultado:
@;		R0 = 1 indica que se ha realizado alg�n movimiento. 
baja_verticales:
		push {r1-r12, lr}
		
		mov r0, #0									@;r0=0 cap moviment ->registre per saber si hi ha o no moviments
		mov r2, #COLUMNS							@;columnas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
		sub r1, r2, #1								@;ems situem a l'ultima columna per rec�rrer la matriu en sentit invers		
		mov r3, #ROWS								@;filas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
	
		.for_1:										@;primer bucle
		cmp r1, #0									
		bge .entra_for_1							@;mentre r1 (columna) sigui >=0 (dins dimensi� matriu)
		b .final_baja_verticales					@;si r1 �s m�s petit que 0, s'acaba el recorregut i , per tant la rutina
		
		.entra_for_1:
		mov r5, #0 									@;posici� de la fila m�s alta (r5=0) a partir de la columna actual (r1)

		@;mirar si el valor es 15 
		.for_2: 									@;bucle per mirar posici� m�s alta tenint en compte els buits
		mla r6, r5, r2, r1							@;obtenim posici� segons fila (r5->inicialment 0) i columna (r1->inicialment #COLUMNS-1)
		ldrb r7, [r4, r6]							@;obtenim valor de la posici� anterior obtinguda
		cmp r7, #15
		beq .entra_for_2							@;si el valor obtingut es 15, es segueix analitzant la columna actual cap a baix (r5)
		b .continuar_for_1							@;sino anem pujant files 
		
		.entra_for_2:								@;si el valor anterior obtingut es 15
		add r5, r5, #1								@;baixem una fila cap a baix de la columna en estudi actual (r5)
		b .for_2									@;saltem un altre cop al for_2 per mirar si ens situem amb un valor 15

		.continuar_for_1:							@;si el valor obtingut va ser !=15
		sub r6, r3, #1								@;registre de la fila de pujada a partir de la columna actual (inicialment la fila comen�a a l'ultima fila inferior de la matriu)

		.for_3:										@;comprova si la fila de pujada calculada es >=0
		cmp r6, #0									
		bge .entra_for_3							@;si la fila es >=0 (dins de la matriu) saltem per estudiar el valor
		b .disminuir_j_for_1						@;sino, saltem a mirar la seg�ent columna de l'esquerra, deixant la columna actual

		.entra_for_3:								@;quan la fila de pujada de for_3 calculada es >=0 (dins de la matriu)					
		@;PRIMER IF
		mla r7, r6, r2, r1							@;obtenim la posici� de r6 (fila de pujada) i r1 (columna actual)
		ldrb r8, [r4, r7] 							@;obtenim el valor de la posici� calculada
		@;mirarem si aquest valor anterior es un valor buit (0,8,16)
		@;si �s algun valor buit, mirem si es troba a la fila superior !=15 (r5)
		cmp r8, #0						
		beq .entra_if_1	
		cmp r8, #8
		beq .entra_if_1							
		cmp r8, #16
		beq .entra_if_1		 
		b .disminuir_i_for_3 						@;si el valor no es buit, salta per pujar una fila m�s

		.entra_if_1:								@;quan �s buit, mirem si aquest (r6->fila de pujada) coincideix amb la fila superior !=15 (r5)
		@;SEGON IF
		cmp r6, r5
		beq .entra_if_2								@;si es troba a la posici� m�s alta amb valor !=15, es salta per generar el valor random						
		
		@;TERCER IF									@;si no es troba a la posici� m�s alta !=15, pujem una fila desde la fila de pujada on estava el buit a partir del registre r9
		@;r7-r8 matriu[i-1][j]
		sub r9, r6, #1								@;pujem una fila a partir de la fila de pujada (r6)
		mla r7, r9, r2, r1 							@;posici� de r9(fila nova a partir de la fila de pujada) i r1(columna actual)
		ldrb r8, [r4, r7] 							@;adquirim el nou valor a partir de la posici� anterior 
		and r9, r8, #VALOR 							@;calculem el valor sense gelatina		
		cmp r9, #0									@;mirem si aquest valor sense gelatina est� entre el 0 i el 7 (element simple)
		bgt .segunda_comprobacio_if_3				@;si r9>0, saltem per comprovar si tamb� cumpleix que r9<7
		
		.continuar_if_2_1:							@;quan el valor de la fila de pujada superior(r9) no �s un element simple, mirem si el valor de la fila de pujada inferior(r6) sense m�scara es =15
		@;QUART IF	
		cmp r8, #15
		beq .entra_if_4								@;si es 15, saltem la fila de r6 2 posicions per adquirir el valor que est� damunt del 15
		b .disminuir_i_for_3						@;si no es 15, mirem la seg�ent fila de la fila de pujada inferior 
		
		@;aquest if s'encarrega de mirar si hi ha algun element a la part superior en cas que hi hagi buits
		@;si el troba, li assigna a la posici� que est�vem mirant i la posici� major li assigna un zero (respectant el seu valor de gelatina).
		.entra_if_4:								@;quan el valor de r6 es 15, adquirim el valor que est� damunt de ell
		sub r7, r6, #2 								@;r7->aux de r6
	
		.for_if_4:	
		mla r8, r7, r2, r1							@;adquirim la posici� de la fila r7 (registre aux de r6 per sobre del valor 15)
		ldrb r9, [r4, r8]							@;obtenim el valor de la posici� anterior calculada	
		cmp r9, #15				
		beq .disminuir_for_if_4						@;si aquest valor tamb� es 15, r7 puja una altra fila cap a dalt per sobre d'aquest altra 15
		and r9, r9, #VALOR							@;si el valor obtingut no es 15, ens quedem amb el seu valor sense gelatina
		cmp r9, #0									
		beq .disminuir_i_for_3						@;si el valor sense gelatina �s 0, fem el mateix que quan estavem al cas del if_3 (pujem una fila r6) 
		cmp r9, #7																
		beq .disminuir_i_for_3						@;si el valor sense gelatina no �s 0 per� si 7, fem el mateix que quan estavem al cas del if_3 (pujem una fila r6)   
		b .continuar_if_4_1							@;si no �s ni 0 ni 7, fem la suma de valors per baixar l'element a la posici� inferior
	
		@; o matriu<=0 o matriu >= 7
		.disminuir_for_if_4:
		sub r7, r7, #1
		b .for_if_4
	
		.continuar_if_4_1:
		mov r0, #1
		mla r8, r6, r2, r1
		ldrb r9, [r4, r8]							@;r9->matriu[i][j]
		@;r10, 
		mla r10, r7, r2, r1
		ldrb r11, [r4, r10]							@;r11->matriz[aux][j]
		@;combinacio matriu[i][j] = matriu[aux][j] | BitsMajorPes
		orr r9, r9, r11
		strb r9, [r4, r8]
		@;combinacio matriu [aux][j] = 0 | bitsMajorPes
		and r11, r11, #MIRAR_GEL
		strb r11, [r4, r10]
		b .disminuir_i_for_3

		.entrar_if_3:								@;quan si r9<7 (comprovaci� element simple) fem la suma del valor de la fila de pujada inferior(r6) i el valor de pujada superior a r6 (r9)  
		mla r10, r6, r2, r1							@;obtenim la posici� del valor de fila de pujada inferior (r6)
		ldrb r11, [r4, r10]							@;obtenim el valor de la posici� calculada anteriorment
		orr r12, r11, r9							@;fem la suma del valor de la fila de pujada superior (r11) amb el valor de la fila de pujada inferior (r9)
		strb r12, [r4, r10]							@;guardem el resultat de la suma a la matriu en la posici� de la fila de pujada inferior 
		and r8, r8, #MIRAR_GEL						@;fem una m�scara en AND per adquirir el valor base de gelatina
		strb r8, [r4, r7]							@;guardem el valor base de gelatina a la seva posici� (fila de pujada superior r9)
		mov r0, #1									@;actalitzem registre de moviments a 1 (per tal d'indicar que s'ha produ�t un moviment)					
		b .disminuir_i_for_3						@;saltem per passar a una fila superior

		.segunda_comprobacio_if_3:					@;com que r9>0, comprovem si tamb� cumpleix que r9<7 (element simple)
		cmp r9, #7
		blt .entrar_if_3							@;si r9<7, �s un element simple i per tant saltar� a fer la suma del valor de la fila de pujada inferior(r6) i el valor de pujada superior a r6 (r9) 
		b .continuar_if_2_1							@;si r9 no compleix la condici� de element simple, saltem per mirar si el valor de la fila de pujada inferior (r6) es =15
		
		.entra_if_2:								@;com que el valor es un buit (0,8,16) i es troba a la posici� m�s alta !=15 (r6==r5), es generar� un valor nou random 
		mla r7, r5, r2, r1							@;obtenim la posici� m�s alta diferent de !=15 [r5,r1]
		ldrb r8, [r4, r7]							@;obtenim el valor de la posici� anterior
		mov r12, r0									@;per no perdre les anotacions del registre de moviments r0
																			
		.buscar_num_random:							@;si es troba a la posici� m�s alta, assignem a la posici� amb valor 0 un num random(respetant per descomptat el seu valor de gelatina)
		mov r0, #7									@;valor m�xim 7 dins del rang random (li passem aquest valor per r0 a la rutina mod_random)
		bl mod_random								@;cridem a la rutina mod_random per generar un valor random
		cmp r0, #0									
		beq .buscar_num_random						@;si el nou valor random obtingut �s 0, repetim una altra vegada la crida fins que sigui !=0
		orr r9, r8, r0								@;quan el nou valor random ja es !=0, sumem el nou valor random obtingut amb el valor buit obtingut de la fila m�s alta !=15(r5==r6)
		strb r9, [r4, r7]							@;guardem el resultat de la suma en la posici� de la fila m�s alta !=15 (r5==r6)
		mov r0, #1									@;anotem al registre r0 que s'ha produ�t un moviment
		b .disminuir_i_for_3						@;saltem per pujar una fila sobre la columna actual 
		
		.disminuir_i_for_3:							@;pujem una fila sobre la columna actual i seguim analitzant si hi ha un valor buit (fila de pujada)
		sub r6, r6, #1								
		b .for_3  

		.disminuir_j_for_1:							@;saltem a mirar la seg�ent columna de l'esquerra quan hem acabat de recorrer les files de la columna actual, deixant la columna actual
		sub r1, r1, #1								@;i comencem de nou mirant si el valor de la seva posici� superior es 15
		b .for_1

		.final_baja_verticales:						@;surt de la rutina de baja_laterales, passant per r0 l'estat de moviments(0 o 1)
				
		pop {r1-r12, pc}



@; baja_laterales(mat): rutina para bajar elementos hacia las posiciones vac�as
@;	en diagonal; cada llamada a la funci�n s�lo baja elementos una posici�n y
@;	devuelve cierto (1) si se ha realizado alg�n movimiento.
@;	Par�metros:
@;		R4 = direcci�n base de la matriz de juego
@;	Resultado:
@;		R0 = 1 indica que se ha realizado alg�n movimiento. 
baja_laterales:
		push {r1-r12, lr}
		
		mov r0, #0									@;r0=0 cap moviment ->registre per saber si hi ha o no moviments
		mov r1, #ROWS								@;filas (carreguem constant com a valor inmediat ja que es menor que 12 bits)	
		sub r2, r1, #1								@;ems situem a l'ultima fila (dins dimensions de la matriu-fila actual) per rec�rrer la matriu en sentit invers
		mov r3, #COLUMNS							@;columnas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
			
		.for_1_bl:									@;primer bucle baja laterales
		cmp r2, #0										
		bge .entra_for_1_bl							@;mentre r2 (fila actual) sigui >=0 (dins dimensi� matriu) 
		b .final_bl									@;si r2 �s m�s petit que 0, s'acaba el recorregut i , per tant la rutina
		
		.entra_for_1_bl:							@;si la fila actual est� dins de les dimensions la matriu
		sub r5, r3, #1								@;ens situem a l'�ltima columna (columna actual r5) per fer el recorregut invers de cada fila. Quan columna -1, r5=COLUMNS-1
		
		.for_2_bl:		
		mov r6, #0									@;superior dreta
		mov r7, #0									@;superior esquerra	
		cmp r5, #0
		bge .entra_for_2_bl							@;mentre r5 (columna actual) sigui >=0 (dins dimensi� matriu)
		b .disminuir_i_for_1_bl						@;si no, saltem a mirar la seg�ent fila
		
		.entra_for_2_bl:
		@;PRIMER IF
		mla r8, r2, r3, r5							@;ens situem a la posici� actual de r2,r5
		ldrb r9, [r4, r8]							@;obtenim valor de la posici� anterior calculada
		and r9, r9, #VALOR							@;apliquem m�scara al valor per quedar-nos amb el seu valor sense gelatina
		cmp r9, #0									@;veiem si es una pocisio buida	
		beq .condicio_1_if_1						@;si el valor sense gelatina es == 0, saltar 
		b .disminuir_j_for_2_bl						@;si no es == 0 (valor buit) saltem per passar a la columna del costat esquerra
		
		.condicio_1_if_1:							@;si trobem un valor =0, mirem el valor que t� en la posici� superior a la que es troba aquest valor =0
		sub r12, r2, #1								@;pujem una fila a partir de la fila actual r2
		mla r11, r12, r3, r5						@;calculem la posici� de r2,r5
		ldrb r10, [r4, r11]							@;obtenim el valor de la posici� anterior calculada
		and r11, r10, #VALOR						@;ens quedem amb el valor sense gelatines (apliquem m�scara 0b0111) 
		cmp r11, #7									@;mirar si la posicio superior es un 15 buit o un 7 o en l'ultim dels casos un 0
		beq .entra_if_1_bl							@;si el valor �s 7
		cmp r10, #15
		beq .buscar_7_posicio_superior				@;si el valor �s 15		
		cmp r11, #0
		beq .entra_if_1_bl							@;si el valor �s 0
		.buscar_7_posicio_superior:					@;si el valor �s 15, o no �s ni 7 ni 15 es busca un 7 en la superior

		.for_buscar_7:								@;mira si hi ha algun 7(bloc solid) sobre algun 15 (posici� doble suprerior)
		mla r11, r12, r3, r5						@;obtenir posici� r12,r5
		ldrb r10, [r4, r11]							@;obtenim valor de la posici� calculada
		cmp r10,  #15
		beq .entra_for_buscar_7						@;si hi ha un 15, salta per trobar un 7
		and r11, r10, #VALOR
		cmp r11, #7
		beq .entra_if_1_bl							@;si �s un 7, ja comen�o a mirar els possibles elements simples per baixar-los lateralment
		cmp r10, #15
		bne .disminuir_j_for_2_bl					@;si no cumpleix cap cas (no t� cap 7 i es diferent de 15) comen�a un altre cop executant el for_2 amb la seg�ent columna de la fila actual
	
		.entra_for_buscar_7:						@;mira la fila superior per trobar un 7 i aix� baixar algun element simple de manera lateral
		sub r12, r2, #1
		b .for_buscar_7
		
		.entra_if_1_bl:								@;quan el valor de la posici� superior al 0 trobat �s un 7 o un 0, miro el valor de la posici� superior esquerra al 0 trobat
		@;SEGUNDO IF								@;este if serveix per mirar si el valor de la posicio superior esquerra esta entre 1 y 6
		sub r12, r2, #1								@;fila superior								
		sub r11, r5, #1 							@;columna esquerra
		mla r8, r12, r3, r11						@;calculem nova posici� superior esquerra del valor anterior
		ldrb r9, [r4, r8]							@;obtenim el valor de la posici� calculada anterior
		and r10, r9, #VALOR							@;apliquem m�scara per quedar-nos amb el valor sense gelatina
		cmp r11, #0									@;si la columna calculada anteriorment (r11=r5-1) est� fora de rang de les dimensions de la matriu
		bge .condicio_1_if_2_bl						@;si la columna est� dins, mirem si aquest valor (r10) �s un element simple
		b .continuar_if_1_bl_1						@;si la columna est� fora de rang
		
		.condicio_1_if_2_bl:						@;quan la columna superior esquerra est� dins de la matriu (r11>=0)
		cmp r10, #0									@;mirem si el valor d'aquesta columna i fila es un element simple (7<r10>0)
		bgt .condicio_2_if_2_bl
		b .continuar_if_1_bl_1

		.condicio_2_if_2_bl:						@;quan es cumpleix que l'element es >0, mirem si �s <7, per assegurar-nos de si �s un element simple
		cmp r10, #7									@;mirem si el valor d'aquesta columna i fila es un element simple (7<r10>0)
		blt .entra_if_2_bl							@;si �s un element simple (entre el 0 i el 7, comencem amb les comprovacions disponibles per baixar l'element lateral)
		b .continuar_if_1_bl_1							
				
		.entra_if_2_bl:								@;quan el valor superior esquerra es element simple
		@;r7	superior esquerra
		mov r7, r10									@;guardem en el registre r7 el valor superior r10(que cumpleix ser un element simple en la posici� superior esquerra)
		b .continuar_if_1_bl_1						


		.continuar_if_1_bl_1:						@;ara s'analitzar� el valor de la posici� superior dret
		@;TERCER IF									@;aquest if serveix per veure si el valor de la dreta a la part superior est� entre 1 i 6
		add r12, r5, #1								@;ara mirarem la columna dreta de la fila superior
		sub r11, r2, #1								@;pujem la fila
		mla r8, r11, r3, r12						@;calculem la nova posici� (costat superior dret) a partir de r11,r12
		ldrb r9, [r4, r8]							@;obtenim el valor de la posici� calculada 
		cmp r12, r3									@;mirar si la columna actual es m�s petita que el n�mero de columnes que cont� la matriu
		blt .condicio_1_if_3_bl						@;si cumpleix que la columna est� dins de la matriu
		b .continuar_if_1_bl_2						@;sino salta
		
		.condicio_1_if_3_bl:						@;si la columna est� dins de la matriu (r12<COLUMNS)
		and r10, r9, #VALOR							@;apliquem m�scara al valor calcular anteriorment (valor superior dret sobre el valor 0 trobat anterior bucle de recorregut)
		cmp r10, #0						
		bgt .condicio_2_if_3_bl						@;si el valor sense gelatina es m�s gran que 0 mirarem si �s petit que 7 (element simple)
		b .continuar_if_1_bl_2						@;si �s m�s petit (no �s m�s gran que 0)

		.condicio_2_if_3_bl:						@;si l'element cumpleix que �s superior a 0, per �ltim mirarem si l'element �s simple (inferior a 7)
		cmp r10, #7
		blt .entra_if_3_bl							@;si el valor es inferior a 7, element simple
		b .continuar_if_1_bl_2						@;si no �s un element simple	
													@;veig el valor de la part superior dreta i esquerra, de manera que pugui saber si tots dos valors s�n v�lids i poder mirar 
													@;si he d'aplicar l'aleatorietat o no
		
		.entra_if_3_bl:								@;quan el valor superior dret es element simple
		@;superior_dreta
		mov r6, r10									@;guardem en el registre r6 el valor superior r10(que cumpleix ser un element simple en la posici� superior dreta)

		.continuar_if_1_bl_2:						
		@;QUART IF									@;en aquest if el que fem �s veure si hi ha valor v�lid a l'esquerra i no a la dreta
													@;en el cas de que si, llavors la posici� que est� a zero, agafar� el valor de la posici� superior esquerra.
		cmp r6, #0									@;r6 superior dret						
		beq .entrar_if_4_bl							@;si el superior dret r6==0
		b .continuar_if_1_bl_3						@;si el superior dret r6!=0 (el valor superior dret es element simple disponible per moidificar al inferior)
		.entrar_if_4_bl:
		cmp r7, #0									@;r7 superior esquerra
		bne .entra_if_4_bl							@;si el superior esquerra r7!=0
		b .continuar_if_1_bl_3

		.entra_if_4_bl:								@;quan l'elemet superior esquerra �s v�lid
		mov r0, #1									@;assigmen que s'ha produ�t un moviment al registre r0
		mla r8, r2, r3, r5							@;calculem la posici� r2,r5 a la qual es modificar� el valor
		ldrb r9, [r4, r8]							@;obtenim el valor de la posici� anterior calculada (aquest valor ser� un buit 0,8,16)	
		sub r11, r2, #1		 						@;calculem la fila superior on est� el valor que modificar� al de sota
		sub r12, r5, #1		 						@;calculem la columna (pos superior esquerra) on est� el valor que modificar� al de sota
		mla r10, r11, r3, r12						@;calculem la posici� superior on esta el valor que modificar� al de sota a partir de r11,r12
		ldrb r11, [r4, r10]							@;obtenim el valor de la posici� superior esquerra
		and r12, r11, #VALOR						@;ens quedem amb el valor sense gelatines del valor superior que modificar� al de sota				
		orr r9, r9, r12								@;fem una orr (suma) del valor de sota r9(amb gelatina) i el valor de dalt r12(sense gelatina)
		strb r9, [r4, r8]							@;guardem el valor resultant en la seva respectiva posici� (posic� de sota on estaba el buit)
		and r11, r11, #MIRAR_GEL					@;ens quedem amb el valor de gelatina del element superior que modificar� el de sota
		strb r11, [r4, r10]							@;guardem aquest valor de gelatina en la posici� superior esquerra
		b .final_bl									@;com que ja s'ha produ�t un moviment, s'acaba amb el recorregut de la matriu i , per tant, s'acaba la rutina baja_laterales
		
		.continuar_if_1_bl_3:
		@;CINQU� IF									@;en aquest if el que fem �s veure si hi ha valor v�lid a la dreta i no a l'esquerra
													@;en el cas de que si, llavors la posici� que est� a zero, agafar� el valor de la posici� superior dreta.
		cmp r7, #0									@;r7 superior esquerra
		beq .condicio_1_if_5_bl						@;si el superior esquerra r7==0
		b .continuar_if_1_bl_4
																									
		.condicio_1_if_5_bl:						@;quan el superior esquerra r7==0
		cmp r6, #0									@;r6 superior dret
		bne .entrar_if_5_bl							@;si el superior dret r6!=0
		b .continuar_if_1_bl_4
	
		.entrar_if_5_bl:							@;quan l'elemet superior dret �s v�lid
		mov r0, #1									@;assigmen que s'ha produ�t un moviment al registre r0
		mla r8, r2, r3, r5							@;calculem la posici� r2,r5 a la qual es modificar� el valor
		ldrb r9, [r4, r8]							@;obtenim el valor de la posici� anterior calculada (aquest valor ser� un buit 0,8,16)
		sub r11, r2, #1 							@;calculem la fila superior on est� el valor que modificar� al de sota
		add r12, r5, #1  							@;calculem la columna (pos superior dret) on est� el valor que modificar� al de sota
		mla r10, r11, r3, r12						@;calculem la posici� superior on esta el valor que modificar� al de sota a partir de r11,r12
		ldrb r11, [r4, r10]							@;obtenim el valor de la posici� superior dreta
		and r12, r11, #VALOR						@;ens quedem amb el valor sense gelatines del valor superior que modificar� al de sota			
		orr r9, r9, r12								@;fem una orr (suma) del valor de sota r9(amb gelatina) i el valor de dalt r12(sense gelatina)
		strb r9, [r4, r8]							@;guardem el valor resultant en la seva respectiva posici� (posic� de sota on estaba el buit)
		and r11, r11, #MIRAR_GEL					@;ens quedem amb el valor de gelatina del element superior que modificar� el de sota
		strb r11, [r4, r10]							@;guardem aquest valor de gelatina en la posici� superior dreta
		b .final_bl									@;com que ja s'ha produ�t un moviment, s'acaba amb el recorregut de la matriu i , per tant, s'acaba la rutina baja_laterales 

		.continuar_if_1_bl_4:						
		@;SIS� IF									@;en aquest if si es veu que les dues posicions s�n v�lides(i !=0), llavors recorre a l'aleatorietat per veure qui ser� 
		cmp r7, #0									
		bne .condicio_1_if_6						@;si el valor esquerra es v�lid, es comprovar� el valor dret
		b .disminuir_j_for_2_bl						@;si el valor esquerra r7 no �s v�lid, saltem per comen�ar a analitzar la seg�ent columna de la fila actual
													
		.condicio_1_if_6:							@;es comprovar� el valor dret (ja que el valor esquerra ja es v�lid)
		cmp r6, #0
		bne .entrar_if_6_bl							@;si el valor dret tamb� es v�lid, es salta per fer la aleatorietat
		b .disminuir_j_for_2_bl						@;si el valor dret r6 no �s v�lid, saltem per comen�ar a analitzar la seg�ent columna de la fila actual

		.entrar_if_6_bl:							@;quan r6 i r7 son v�lids
		mov r0, #2									@;es passa el valor 2 a la funci� mod_random per posar rang del 0 al 1 inclu�ts 
		bl mod_random								@;cridem a la funci� random
		cmp r0, #0									@;si �s 0, farem el moviment del costat esquerra
		beq .superior_esquerra
		cmp r0, #1									@;si �s 1, farem el moviment del costat dret
		beq .superior_dreta					
	
		.superior_dreta:
		mov r0, #1									@;assigmen que s'ha produ�t un moviment al registre r0
		mla r8, r2, r3, r5							@;calculem la posici� r2,r5 a la qual es modificar� el valor
		ldrb r9, [r4, r8]							@;obtenim el valor de la posici� anterior calculada (aquest valor ser� un buit 0,8,16)	
		sub r11, r2, #1								@;calculem la fila superior on est� el valor que modificar� al de sota
		add r12, r5, #1								@;calculem la columna (pos superior dret) on est� el valor que modificar� al de sota
		mla r10, r11, r3, r12						@;calculem la posici� superior on esta el valor que modificar� al de sota a partir de r11,r12
		ldrb r11, [r4, r10]							@;obtenim el valor de la posici� superior dreta
		and r12, r11, #VALOR  						@;ens quedem amb el valor sense gelatines del valor superior que modificar� al de sota	
		orr r9, r9, r12								@;fem una orr (suma) del valor de sota r9(amb gelatina) i el valor de dalt r12(sense gelatina)
		strb r9, [r4, r8]							@;guardem el valor resultant en la seva respectiva posici� (posic� de sota on estaba el buit)
		and r11, r11, #MIRAR_GEL					@;ens quedem amb el valor de gelatina del element superior que modificar� el de sota
		strb r11, [r4, r10]							@;guardem aquest valor de gelatina en la posici� superior dreta
		b .final_bl									@;com que ja s'ha produ�t un moviment, s'acaba amb el recorregut de la matriu i , per tant, s'acaba la rutina baja_laterales 

		.superior_esquerra:
		mov r0, #1									@;assigmen que s'ha produ�t un moviment al registre r0
		mla r8, r2, r3, r5							@;calculem la posici� r2,r5 a la qual es modificar� el valor
		ldrb r9, [r4, r8]							@;obtenim el valor de la posici� anterior calculada (aquest valor ser� un buit 0,8,16)	
		sub r11, r2, #1								@;calculem la fila superior on est� el valor que modificar� al de sota
		sub r12, r5, #1								@;calculem la columna (pos superior esquerra) on est� el valor que modificar� al de sota
		mla r10, r11, r3, r12						@;calculem la posici� superior on esta el valor que modificar� al de sota a partir de r11,r12
		ldrb r11, [r4, r10]							@;obtenim el valor de la posici� superior esquerra
		and r12, r11, #VALOR						@;ens quedem amb el valor sense gelatines del valor superior que modificar� al de sota	
		orr r9, r9, r12								@;fem una orr (suma) del valor de sota r9(amb gelatina) i el valor de dalt r12(sense gelatina)
		strb r9, [r4, r8]							@;guardem el valor resultant en la seva respectiva posici� (posic� de sota on estaba el buit)
		and r11, r11, #MIRAR_GEL					@;ens quedem amb el valor de gelatina del element superior que modificar� el de sota
		strb r11, [r4, r10]							@;guardem aquest valor de gelatina en la posici� superior esquerra
		b .final_bl									@;com que ja s'ha produ�t un moviment, s'acaba amb el recorregut de la matriu i , per tant, s'acaba la rutina baja_laterales 

		.disminuir_j_for_2_bl:
		sub r5, r5, #1								@;passem a la seg�ent columna esquerra 
		b .for_2_bl									@;comencem de nou mirant si la columna es troba dins de la matriu, sino es redueix una fila (a fila superior sobre l'actual)

		.disminuir_i_for_1_bl:
		sub r2, r2, #1								@;passem a la seg�ent fila superior sobre l'actual
		b .for_1_bl									@;comencem de nou per la fila superior i la �ltima columna de la fila, (si la fila est� fora de rang s'acaba la rutina)

		.final_bl:									@;final rutina baja_laterales
		
		pop {r1-r12, pc}




@;=                                                               		=
@;=== candy1_init.s: rutinas para inicializar la matriz de juego	  ===
@;=                                                               		=

	.global mod_random
mod_random:
		push {r1-r4, lr}
		
		cmp r0, #2				@;compara el rango de entrada con el m�nimo
		bge .Lmodran_cont
		mov r0, #2				@;si menor, fija el rango m�nimo
	.Lmodran_cont:
		and r0, #0xff			@;filtra los 8 bits de menos peso
		sub r2, r0, #1			@;R2 = R0-1 (n�mero m�s alto permitido)
		mov r3, #1				@;R3 = m�scara de bits
	.Lmodran_forbits:
		cmp r3, r2				@;genera una m�scara superior al rango requerido
		bhs .Lmodran_loop
		mov r3, r3, lsl #1
		orr r3, #1				@;inyecta otro bit
		b .Lmodran_forbits
		
	.Lmodran_loop:
		bl random				@;R0 = n�mero aleatorio de 32 bits
		and r4, r0, r3			@;filtra los bits de menos peso seg�n m�scara
		cmp r4, r2				@;si resultado superior al permitido,
		bhi .Lmodran_loop		@; repite el proceso
		mov r0, r4			@; R0 devuelve n�mero aleatorio restringido a rango
		
		pop {r1-r4, pc}
.end