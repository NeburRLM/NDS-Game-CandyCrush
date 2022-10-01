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


@;-- .text. código de las rutinas ---
.text	
		.align 2
		.arm



@;TAREA 1E;
@; cuenta_repeticiones(*matriz,f,c,ori): rutina para contar el número de
@;	repeticiones del elemento situado en la posición (f,c) de la matriz, 
@;	visitando las siguientes posiciones según indique el parámetro de
@;	orientación 'ori'.
@;	Restricciones:
@;		* sólo se tendrán en cuenta los 3 bits de menor peso de los códigos
@;			almacenados en las posiciones de la matriz, de modo que se ignorarán
@;			las marcas de gelatina (+8, +16)
@;		* la primera posición también se tiene en cuenta, de modo que el número
@;			mínimo de repeticiones será 1, es decir, el propio elemento de la
@;			posición inicial
@;	Parámetros:
@;		R0 = dirección base de la matriz
@;		R1 = fila 'f'
@;		R2 = columna 'c'
@;		R3 = orientación 'ori' (0 -> Este, 1 -> Sur, 2 -> Oeste, 3 -> Norte)
@;	Resultado:
@;		R0 = número de repeticiones detectadas (mínimo 1)
	.global cuenta_repeticiones
cuenta_repeticiones:
		push {r1-r12,lr}
		
		mov r4, #1 									@;r4 contindrà num_repeticions, inicialment =1
		mov r5, #COLUMNS 							@;columnas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
		mov r6, #ROWS 								@;filas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
			
		mla r9, r1, r5, r2							@;obtenim posició inicial a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la posició inicial a estudiar
		and r10, r8, #MASK_VALOR_SENSE_GEL			@;apliquem màscara per quedar-nos amb els 3 bits de menor pes
		cmp r3, #1 									@;analitzem la orientació
		bgt .Nord_o_Oest 							@;si r3>1 salta (ja que podria ser 2->oest o 3->nord)
		beq .Lconrep_sur 							@;si r3==1, salta a Sud
		
		.Lconrep_este: 								@;r3 no és ni 1 ni és més gran que 1, per tant 0 (Est)
		sub r7, r5, #1 								@;r7=COLUMNS-1 (per a comparar dins de la posició màxima de la matriu)
		cmp r2, r7 									@;comparem la columna actual(r2) amb el màxim de columnes de la matriu(r5-1)
		bge .Lconrep_fin 							@;si r2>=r7 (si la columna actual es superior o igual a la màxima), acaba el programa
		add r2,#1									@;si segueix dins de les dimensions de la matriu, s'incrementa una columna per seguir amb el recorregut Est
		mla r9,r1,r5,r2 							@;obtenim la nova posició segons la nova columna a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posició calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem màscara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la màscara)
		bne .Lconrep_fin							@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el número de repeticions consecutius 
		b .Lconrep_este								@;torna a començar el bucle del recorregut
		
		.Lconrep_sur: 								@;r3 és 1
		sub r7, r6, #1 								@;r7=ROWS-1 (per a comparar dins de la posició màxima de la matriu)
		cmp r1, r7 									@;comparem la fila actual(r1) amb el màxim de files de la matriu(r6-1)
		bge .Lconrep_fin 							@;si r1>=r7 (si la fila actual es superior o igual a la màxima), acaba el programa
		add r1,#1									@;si segueix dins de les dimensions de la matriu, s'incrementa una fila per seguir amb el recorregut Sud
		mla r9,r1,r5,r2 							@;obtenim la nova posició segons la nova fila a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posició calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem màscara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la màscara)
		bne .Lconrep_fin							@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el número de repeticions consecutius
		b .Lconrep_sur								@;torna a començar el bucle del recorregut
		
		.Nord_o_Oest:								@;salt a estudiar possible nord o oest
		cmp r3, #2 									@;comparem la orientació amb el valor 2
		beq .Lconrep_oeste							@;si r3==2, té orientació de oest, sinò serà nord(r3==3)
		
		.Lconrep_norte: 							@;si no es oest, serà nord(r3==3)
		cmp r1, #0 									@;comparem la fila actual(r1) amb la posició mínima de la matriu(#0)
		ble .Lconrep_fin							@;si r1<=0 (si la fila actual es inferior o igual a la mínima), acaba el programa
		sub r1,#1									@;si segueix dins de les dimensions de la matriu, restem una fila per fer el recorregut NORD
		mla r9,r1,r5,r2 							@;obtenim la nova posició segons la nova fila a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posició calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem màscara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la màscara)
		bne .Lconrep_fin							@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el número de repeticions consecutius
		b .Lconrep_norte							@;torna a començar el bucle del recorregut
			
		.Lconrep_oeste:								@;r3 és 2 (oest)
		cmp r2, #0 									@;comparem la columna actual(r2) amb la posició mínima de la matriu(#0)
		ble .Lconrep_fin 							@;si r2<=0 (si la columna actual es inferior o igual a la mínima), acaba el programa
		sub r2,#1 									@;si segueix dins de les dimensions de la matriu, restem una columna per fer el recorregut OEST
		mla r9,r1,r5,r2 							@;obtenim la nova posició segons la nova columna a estudiar
		ldrb r8, [r0,r9]							@;obtenim el valor de la nova posició calculada
		and r8, r8, #MASK_VALOR_SENSE_GEL			@;apliquem màscara per quedarnos amb els 3 bits de menor pes
		cmp r8,r10									@;comparem el valor recent amb el inicial (aplicada ja la màscara)
		bne .Lconrep_fin							@;si son diferents, s'acaba el recorregut i el programa
		add r4,#1									@;si els dos valors son iguals, s'incrementa el número de repeticions consecutius
		b .Lconrep_oeste							@;torna a començar el bucle del recorregut
		
			
		.Lconrep_fin:								@;acaba el programa
		mov r0, r4

		
		pop {r1-r12, pc}


@;TAREA 1F;
@; baja_elementos(*matriz): rutina para bajar elementos hacia las posiciones
@;	vacías, primero en vertical y después en sentido inclinado; cada llamada a
@;	la función sólo baja elementos una posición y devuelve cierto (1) si se ha
@;	realizado algún movimiento, o falso (0) si está todo quieto.
@;	Restricciones:
@;		* para las casillas vacías de la primera fila se generarán nuevos
@;			elementos, invocando la rutina 'mod_random' (ver fichero
@;			"candy1_init.s")
@;	Parámetros:
@;		R0 = dirección base de la matriz de juego
@;	Resultado:
@;		R0 = 1 indica se ha realizado algún movimiento, de modo que puede que
@;				queden movimientos pendientes. 
	.global baja_elementos
baja_elementos:
		push {r4,lr}
		
		mov r4, r0 									@;direcció base de la matriu en r4 (per a les rutines auxiliars)
		mov r1, #0 									@;r1=0 -> cap moviment inicial(registre per anotar si hi ha o no moviment)

        bl baja_verticales 							@;mirem si en baja_verticales es produeix un moviment
      
        mov r1, r0 									@;posem en r1 el valor de anotació de moviments que retorna la funció baja_verticales en r0

        cmp r1, #0									@;comprovem si s'ha produït algun moviment
        bne .Lfinal_baja_elementos 					@;si hi ha canvis (r1!=0) llavors sortim de baja_elementos, si no hi ha canvis (r1==0) 
										 
		bl baja_laterales 							@;si no hi ha canvis, continuarà la execució a la rutina baja_laterales
        mov r1, r0 									@;posem en r1 el valor de anotació de moviments que retorna la funció baja_laterales en r0

		.Lfinal_baja_elementos:				
		strb r1, [r0] 								@;guardem en r0 el contingut del registre r1 (anotació de moviment)
		
		pop {r4,pc}



@;:::RUTINAS DE SOPORTE:::



@; baja_verticales(mat): rutina para bajar elementos hacia las posiciones vacías
@;	en vertical; cada llamada a la función sólo baja elementos una posición y
@;	devuelve cierto (1) si se ha realizado algún movimiento.
@;	Parámetros:
@;		R4 = dirección base de la matriz de juego
@;	Resultado:
@;		R0 = 1 indica que se ha realizado algún movimiento. 
baja_verticales:
		push {r1-r12, lr}
		
		mov r0, #0									@;r0=0 cap moviment ->registre per saber si hi ha o no moviments
		mov r2, #COLUMNS							@;columnas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
		sub r1, r2, #1								@;ems situem a l'ultima columna per recórrer la matriu en sentit invers		
		mov r3, #ROWS								@;filas (carreguem constant com a valor inmediat ja que es menor que 12 bits)
	
		.for_1:										@;primer bucle
		cmp r1, #0									
		bge .entra_for_1							@;mentre r1 (columna) sigui >=0 (dins dimensió matriu)
		b .final_baja_laterales						@;si r1 és més petit que 0, s'acaba el recorregut i , per tant la rutina
		
		.entra_for_1:
		mov r5, #0 									@;posició de la fila més alta (r5=0) a partir de la columna actual (r1)

		@;mirar si el valor es 15 
		.for_2: 									@;bucle per mirar posició més alta tenint en compte els buits
		mla r6, r5, r2, r1							@;obtenim posició segons fila (r5->inicialment 0) i columna (r1->inicialment #COLUMNS-1)
		ldrb r7, [r4, r6]							@;obtenim valor de la posició anterior obtinguda
		cmp r7, #15
		beq .entra_for_2							@;si el valor obtingut es 15, es segueix analitzant la columna actual cap a baix (r5)
		b .continuar_for_1							@;sino anem pujant files 
		
		.entra_for_2:								@;si el valor anterior obtingut es 15
		add r5, r5, #1								@;baixem una fila cap a baix de la columna en estudi actual (r5)
		b .for_2									@;saltem un altre cop al for_2 per mirar si ens situem amb un valor 15

		.continuar_for_1:							@;si el valor obtingut va ser !=15
		sub r6, r3, #1								@;registre de la fila de pujada a partir de la columna actual (inicialment la fila comença a l'ultima fila inferior de la matriu)

		.for_3:										@;comprova si la fila de pujada calculada es >=0
		cmp r6, #0									
		bge .entra_for_3							@;si la fila es >=0 (dins de la matriu) saltem per estudiar el valor
		b .disminuir_j_for_1						@;sino, saltem a mirar la següent columna de l'esquerra, deixant la columna actual

		.entra_for_3:								@;quan la fila de pujada de for_3 calculada es >=0 (dins de la matriu)					
		@;PRIMER IF
		mla r7, r6, r2, r1							@;obtenim la posició de r6 (fila de pujada) i r1 (columna actual)
		ldrb r8, [r4, r7] 							@;obtenim el valor de la posició calculada
		@;mirarem si aquest valor anterior es un valor buit (0,8,16)
		@;si és algun valor buit, mirem si es troba a la fila superior !=15 (r5)
		cmp r8, #0						
		beq .entra_if_1	
		cmp r8, #8
		beq .entra_if_1							
		cmp r8, #16
		beq .entra_if_1		 
		b .disminuir_i_for_3 						@;si el valor no es buit, salta per pujar una fila més

		.entra_if_1:								@;quan és buit, mirem si aquest (r6->fila de pujada) coincideix amb la fila superior !=15 (r5)
		@;SEGON IF
		cmp r6, r5
		beq .entra_if_2								@;si es troba a la posició més alta amb valor !=15, es salta per generar el valor random						
		
		@;TERCER IF									@;si no es troba a la posició més alta !=15, pujem una fila desde la fila de pujada on estava el buit a partir del registre r9
		@;r7-r8 matriu[i-1][j]
		sub r9, r6, #1								@;pujem una fila a partir de la fila de pujada (r6)
		mla r7, r9, r2, r1 							@;posició de r9(fila nova a partir de la fila de pujada) i r1(columna actual)
		ldrb r8, [r4, r7] 							@;adquirim el nou valor a partir de la posició anterior 
		and r9, r8, #VALOR 							@;calculem el valor sense gelatina		
		cmp r9, #0									@;mirem si aquest valor sense gelatina està entre el 0 i el 7 (element simple)
		bgt .segunda_comprobacio_if_3				@;si r9>0, saltem per comprovar si també cumpleix que r9<7
		
		.continuar_if_2_1:							@;quan el valor de la fila de pujada superior(r9) no és un element simple, mirem si el valor de la fila de pujada inferior(r6) sense màscara es =15
		@;QUART IF	
		cmp r8, #15
		beq .entra_if_4								@;si es 15, saltem la fila de r6 2 posicions per adquirir el valor que està damunt del 15
		b .disminuir_i_for_3						@;si no es 15, mirem la següent fila de la fila de pujada inferior 
		
		@;aquest if s'encarrega de mirar si hi ha algun element a la part superior en cas que hi hagi buits
		@;si el troba, li assigna a la posició que estàvem mirant i la posició major li assigna un zero (respectant el seu valor de gelatina).
		.entra_if_4:								@;quan el valor de r6 es 15, adquirim el valor que està damunt de ell
		sub r7, r6, #2 								@;r7->aux de r6
	
		.for_if_4:	
		mla r8, r7, r2, r1							@;adquirim la posició de la fila r7 (registre aux de r6 per sobre del valor 15)
		ldrb r9, [r4, r8]							@;obtenim el valor de la posició anterior calculada	
		cmp r9, #15				
		beq .disminuir_for_if_4						@;si aquest valor també es 15, r7 puja una altra fila cap a dalt per sobre d'aquest altra 15
		and r9, r9, #VALOR							@;si el valor obtingut no es 15, ens quedem amb el seu valor sense gelatina
		cmp r9, #0									
		beq .disminuir_i_for_3						@;si el valor sense gelatina és 0, fem el mateix que quan estavem al cas del if_3 (pujem una fila r6) 
		cmp r9, #7																
		beq .disminuir_i_for_3						@;si el valor sense gelatina no és 0 però si 7, fem el mateix que quan estavem al cas del if_3 (pujem una fila r6)   
		b .continuar_if_4_1							@;si no és ni 0 ni 7, fem la suma de valors per baixar l'element a la posició inferior
	
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

		.entrar_if_3:								@;quan si r9<7 (comprovació element simple) fem la suma del valor de la fila de pujada inferior(r6) i el valor de pujada superior a r6 (r9)  
		mla r10, r6, r2, r1							@;obtenim la posició del valor de fila de pujada inferior (r6)
		ldrb r11, [r4, r10]							@;obtenim el valor de la posició calculada anteriorment
		orr r12, r11, r9							@;fem la suma del valor de la fila de pujada superior (r11) amb el valor de la fila de pujada inferior (r9)
		strb r12, [r4, r10]							@;guardem el resultat de la suma a la matriu en la posició de la fila de pujada inferior 
		and r8, r8, #MIRAR_GEL						@;fem una màscara en AND per adquirir el valor base de gelatina
		strb r8, [r4, r7]							@;guardem el valor base de gelatina a la seva posició (fila de pujada superior r9)
		mov r0, #1									@;actalitzem registre de moviments a 1 (per tal d'indicar que s'ha produït un moviment)					
		b .disminuir_i_for_3						@;saltem per passar a una fila superior

		.segunda_comprobacio_if_3:					@;com que r9>0, comprovem si també cumpleix que r9<7 (element simple)
		cmp r9, #7
		blt .entrar_if_3							@;si r9<7, és un element simple i per tant saltarà a fer la suma del valor de la fila de pujada inferior(r6) i el valor de pujada superior a r6 (r9) 
		b .continuar_if_2_1							@;si r9 no compleix la condició de element simple, saltem per mirar si el valor de la fila de pujada inferior (r6) es =15
		
		.entra_if_2:								@;com que el valor es un buit (0,8,16) i es troba a la posició més alta !=15 (r6==r5), es generarà un valor nou random 
		mla r7, r5, r2, r1							@;obtenim la posició més alta diferent de !=15 [r5,r1]
		ldrb r8, [r4, r7]							@;obtenim el valor de la posició anterior
		mov r12, r0									@;per no perdre les anotacions del registre de moviments r0
																			
		.buscar_num_random:							@;si es troba a la posició més alta, assignem a la posició amb valor 0 un num random(respetant per descomptat el seu valor de gelatina)
		mov r0, #7									@;valor màxim 7 dins del rang random (li passem aquest valor per r0 a la rutina mod_random)
		bl mod_random								@;cridem a la rutina mod_random per generar un valor random
		cmp r0, #0									
		beq .buscar_num_random						@;si el nou valor random obtingut és 0, repetim una altra vegada la crida fins que sigui !=0
		orr r9, r8, r0								@;quan el nou valor random ja es !=0, sumem el nou valor random obtingut amb el valor buit obtingut de la fila més alta !=15(r5==r6)
		strb r9, [r4, r7]							@;guardem el resultat de la suma en la posició de la fila més alta !=15 (r5==r6)
		mov r0, #1									@;anotem al registre r0 que s'ha produït un moviment
		b .disminuir_i_for_3						@;saltem per pujar una fila sobre la columna actual 
		
		.disminuir_i_for_3:							@;pujem una fila sobre la columna actual i seguim analitzant si hi ha un valor buit (fila de pujada)
		sub r6, r6, #1								
		b .for_3  

		.disminuir_j_for_1:							@;saltem a mirar la següent columna de l'esquerra quan hem acabat de recorrer les files de la columna actual, deixant la columna actual
		sub r1, r1, #1								@;i comencem de nou mirant si el valor de la seva posició superior es 15
		b .for_1

		.final_baja_laterales:						@;surt de la rutina de baja_laterales, passant per r0 l'estat de moviments(0 o 1)
		
		
		pop {r1-r12, pc}



@; baja_laterales(mat): rutina para bajar elementos hacia las posiciones vacías
@;	en diagonal; cada llamada a la función sólo baja elementos una posición y
@;	devuelve cierto (1) si se ha realizado algún movimiento.
@;	Parámetros:
@;		R4 = dirección base de la matriz de juego
@;	Resultado:
@;		R0 = 1 indica que se ha realizado algún movimiento. 
baja_laterales:
		push {lr}
		
		
		pop {pc}




@;=                                                               		=
@;=== candy1_init.s: rutinas para inicializar la matriz de juego	  ===
@;=                                                               		=

	.global mod_random
mod_random:
		push {r1-r4, lr}
		
		cmp r0, #2				@;compara el rango de entrada con el mínimo
		bge .Lmodran_cont
		mov r0, #2				@;si menor, fija el rango mínimo
	.Lmodran_cont:
		and r0, #0xff			@;filtra los 8 bits de menos peso
		sub r2, r0, #1			@;R2 = R0-1 (número más alto permitido)
		mov r3, #1				@;R3 = máscara de bits
	.Lmodran_forbits:
		cmp r3, r2				@;genera una máscara superior al rango requerido
		bhs .Lmodran_loop
		mov r3, r3, lsl #1
		orr r3, #1				@;inyecta otro bit
		b .Lmodran_forbits
		
	.Lmodran_loop:
		bl random				@;R0 = número aleatorio de 32 bits
		and r4, r0, r3			@;filtra los bits de menos peso según máscara
		cmp r4, r2				@;si resultado superior al permitido,
		bhi .Lmodran_loop		@; repite el proceso
		mov r0, r4			@; R0 devuelve número aleatorio restringido a rango
		
		pop {r1-r4, pc}





.end
