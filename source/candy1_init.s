@;=                                                          	     	=
@;=== candy1_init.s: rutinas para inicializar la matriz de juego	  ===
@;=                                                           	    	=
@;=== Programador tarea 1A: ruben.lopezm@estudiants.urv.cat				  ===
@;=== Programador tarea 1B: yyy.yyy@estudiants.urv.cat				  ===
@;=                                                       	        	=



.include "../include/candy1_incl.i"



@;-- .bss. variables (globales) no inicializadas ---
.bss
		.align 2
@; matrices de recombinación: matrices de soporte para generar una nueva matriz
@;	de juego recombinando los elementos de la matriz original.
	mat_recomb1:	.space ROWS*COLUMNS
	mat_recomb2:	.space ROWS*COLUMNS



@;-- .text. código de las rutinas ---
.text	
		.align 2
		.arm



@;TAREA 1A;
@; inicializa_matriz(*matriz, num_mapa): rutina para inicializar la matriz de
@;	juego, primero cargando el mapa de configuración indicado por parámetro (a
@;	obtener de la variable global 'mapas'), y después cargando las posiciones
@;	libres (valor 0) o las posiciones de gelatina (valores 8 o 16) con valores
@;	aleatorios entre 1 y 6 (+8 o +16, para gelatinas)
@;	Restricciones:
@;		* para obtener elementos de forma aleatoria se invocará la rutina
@;			'mod_random'
@;		* para evitar generar secuencias se invocará la rutina
@;			'cuenta_repeticiones' (ver fichero "candy1_move.s")
@;	Parámetros:
@;		R0 = dirección base de la matriz de juego
@;		R1 = número de mapa de configuración
	.global inicializa_matriz
inicializa_matriz:
	push {r1-r12, lr}							@;guardar registros utilizados
		
		ldr r2, =mapas								@;carreguem la variable global mapas (mapa de configuracio)
		mov r10, r0									@;carreguem el mapa de matriz de juego (mapa actualitzat)	
		mov r4, #ROWS								@;carreguem el número de files que conté les matrius
		mov r5, #COLUMNS							@;carreguem el número de columnes que conté les matrius
		mul r6, r4, r5								@;obtenim el total de posicions de la matriu (files·columnes)
		mla r4, r6, r1, r2							@;carreguem la direcció del mapa de conf N (tenint en compte la seva dimensió i el seu número)
		
		@;comencem amb el recorregut de la matriu de configuració
		mov r1, #0									@;fila actual (inicialment a 0)
		.Lfor:
		mov r2, #0									@;columna actual (inicialment a 0)
		.Lfor1:
		mla r7, r1, r5, r2 							@;obtenim la posició actual de la matriu [r1,r2]
		ldrb r8, [r4, r7]							@;obtenim el valor de la posició actual calculada del mapa de configuració N
		
		@;mirem si el valor de la posició actual es un objecte variable (0,8,16)
		cmp r8, #0
		beq .objecteVariable
		cmp r8, #8
		beq .objecteVariable
		cmp r8, #16
		beq .objecteVariable
		b .objecteFixe
	
		.objecteVariable:							@;generem valor random (quan es un valor variable o hi ha una seqüencia del valor major o igual a 3) 
		mov r0, #7									@;li passem un 7 per a que es creï un valor random entre el 0 i el 6 
		bl mod_random								
		cmp r0, #0									
		beq .objecteVariable						@;si crea un 0, repetim un altre cop l'execució del random
		add r9,r0,r8								@;una vegada creat el random correctament, fem la suma del valor r0(random) i r8(valor buit anterior 0,8,16 respectant el seu valor)
		strb r9, [r10,r7]							@;guardem el resultat de la posició actual a la nova matriu de joc		
		mov r0, r10									@;passem la direcció de la matriu de joc a r0 per cridar a la funció cuenta_repeticiones
		mov r3, #2									@;oeste
		bl cuenta_repeticiones						@;cridem al cuenta_repeticiones(r0=@matriu_joc, r1=fil, r2=col, r3=ori)
		cmp  r0, #3									@;mirem si hi ha seqüencia (3 o superior)
		bge .objecteVariable						@;si hi ha seqüencia, repetim un altre cop la crida al mod_random
		
		mov r0, r10									@;passem la direcció de la matriu de joc a r0 per cridar a la funció cuenta_repeticiones
		mov r3, #3									@;norte
		bl cuenta_repeticiones						@;cridem al cuenta_repeticiones(r0=@matriu_joc, r1=fil, r2=col, r3=ori)
		cmp  r0, #3									@;mirem si hi ha seqüencia (3 o superior)
		bge .objecteVariable						@;si hi ha seqüencia, repetim un altre cop la crida al mod_random
		b .valorNoFixeJaGuardat						@;si en les crides de oeste i norte no hi ha cap seqüencia, passem a la seüent posició (amb el valor adquirit ja guardat a la matriu de joc)
		
		.objecteFixe:								@;si el valor de la posició actual era !=0,8,16 guardem el valor directament a la nova matriu de joc i passem a la següent posició
		strb r8, [r10,r7]  							@;guardem el valor fixe en la nova matriu de joc en la mateixa posicó on es troba en la matriu de conf	
		.valorNoFixeJaGuardat:						@;saltem el strb anterior en el cas de que el valor s'hagi adquirit pel random (objecte variable)
		add r2, #1									@;sumem una columna (r2) per passar a la següent columna de la posició actual de la matriu de conf
		cmp r2, #COLUMNS			
		blt .Lfor1									@;si es més petit que el número total de columnes (dins dimensió), seguim amb el recorregut en la fila actual
		add r1, #1									@;si es troba fora del número màxim de columnes, baixem a la fila de sota incrementant r1, i inicialitzem a 0 (la columna r2 de la fila actual)
		cmp r1, #ROWS
		blt .Lfor									@;si es més petit que el número total de files (dins dimensió), seguim amb el recorregut
													@;sino, s'acaba la rutina de inicializa_matriz
		pop {r1-r12, pc}



@;TAREA 1B;
@; recombina_elementos(*matriz): rutina para generar una nueva matriz de juego
@;	mediante la reubicación de los elementos de la matriz original, para crear
@;	nuevas jugadas.
@;	Inicialmente se copiará la matriz original en 'mat_recomb1', para luego ir
@;	escogiendo elementos de forma aleatoria y colocandolos en 'mat_recomb2',
@;	conservando las marcas de gelatina.
@;	Restricciones:
@;		* para obtener elementos de forma aleatoria se invocará la rutina
@;			'mod_random'
@;		* para evitar generar secuencias se invocará la rutina
@;			'cuenta_repeticiones' (ver fichero "candy1_move.s")
@;		* para determinar si existen combinaciones en la nueva matriz, se
@;			invocará la rutina 'hay_combinacion' (ver fichero "candy1_comb.s")
@;		* se supondrá que siempre existirá una recombinación sin secuencias y
@;			con combinaciones
@;	Parámetros:
@;		R0 = dirección base de la matriz de juego
	.global recombina_elementos
recombina_elementos:
		push {lr}
		
		
		pop {pc}



@;:::RUTINAS DE SOPORTE:::







.end
