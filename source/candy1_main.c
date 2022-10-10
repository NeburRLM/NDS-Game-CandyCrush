/*------------------------------------------------------------------------------

	$ candy1_main.c $

	Programa principal para la pr?ctica de Computadores: candy-crash para NDS
	(2? curso de Grado de Ingenier?a Inform?tica - ETSE - URV)
	
	Analista-programador: santiago.romani@urv.cat
	Programador 1: xxx.xxx@estudiants.urv.cat
	Programador 2: ines.ortiz@estudiants.urv.cat
	Programador 3: ruben.lopezm@estudiants.urv.cat
	Programador 4: uuu.uuu@estudiants.urv.cat

------------------------------------------------------------------------------*/
#include <nds.h>
#include <stdio.h>
#include <time.h>
#include <candy1_incl.h>


/* variables globales */
char matrix[ROWS][COLUMNS];		// matriz global de juego
int seed32;						// semilla de n?meros aleatorios
int level = 0;					// nivel del juego (nivel inicial = 0)
int points;						// contador global de puntos
int movements;					// número de movimientos restantes
int gelees;						// número de gelatinas restantes
char marca[ROWS][COLUMNS];		// matriu de marques


/* actualizar_contadores(code): actualiza los contadores que se indican con el
	par?metro 'code', que es una combinaci?n binaria de booleanos, con el
	siguiente significado para cada bit:
		bit 0:	nivel
		bit 1:	puntos
		bit 2:	movimientos
		bit 3:	gelatinas  */
void actualizar_contadores(int code)
{
	if (code & 1) printf("\x1b[38m\x1b[1;8H %d", level);
	if (code & 2) printf("\x1b[39m\x1b[2;8H %d  ", points);
	if (code & 4) printf("\x1b[38m\x1b[1;28H %d ", movements);
	if (code & 8) printf("\x1b[37m\x1b[2;28H %d ", gelees);
}


int main(void)
{
	consoleDemoInit();			// inicialización de pantalla de texto
	printf("candyNDS (prueba tarea 1C)\n");
	printf("\x1b[38m\x1b[1;0H  nivel:");
	actualizar_contadores(1);
	int i,j,yes;

	do							// bucle principal de pruebas
	{
		copia_mapa(matrix, level);		// sustituye a inicializa_matriz()
		escribe_matriz_debug(matrix);
		if (hay_secuencia(matrix)){			// si hay secuencias
			printf("\x1b[39m\x1b[3;0H hay secuencia: SI");
			do
			{	swiWaitForVBlank();
				scanKeys();										// esperar pulsación tecla 'START'
			} while (!(keysHeld() & (KEY_START)));
			elimina_secuencias(matrix, marca);
			escribe_matriz_debug(matrix);
			yes=0;
			for(i=0; i<ROWS-1; i++){
				for(j=0; j<COLUMNS-1; j++){
					if(matrix[i][j] == 0 || matrix[i][j]==8 || matrix[i][j]==16)
						yes=1;
				}
			}
			if(baja_elementos(matrix)==yes){
				printf("\x1b[39m\x1b[3;0H hay cambios: SI");
				do{
					escribe_matriz_debug(matrix);
					retardo(5);
				}while(baja_elementos(matrix)==1);
			}else{
				printf("\x1b[39m\x1b[3;0H hay cambios: NO");
			}
		}else{
			printf("\x1b[39m\x1b[3;0H hay secuencia: NO");
			retardo(5);
			if(baja_elementos(matrix)==1){
			printf("\x1b[39m\x1b[3;0H hay cambios: SI");
				do{
					escribe_matriz_debug(matrix);
					retardo(1);
				}while(baja_elementos(matrix)==1);
			}else{
				printf("\x1b[39m\x1b[3;0H hay cambios: NO");
			}
		}
		retardo(5);
		printf("\x1b[38m\x1b[3;19H (pulse A/B)");
		do
		{	swiWaitForVBlank();
			scanKeys();					// esperar pulsación tecla 'A' o 'B'
		} while (!(keysHeld() & (KEY_A | KEY_B)));
			printf("\x1b[3;0H                               ");
			retardo(5);
		if (keysHeld() & KEY_A)			// si pulsa 'A',
		{								// pasa a siguiente nivel
			level = (level + 1) % MAXLEVEL;
			actualizar_contadores(1);
		}
	} while (1);
	return(0);
}