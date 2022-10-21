/*------------------------------------------------------------------------------

	$ candy1_main.c $

	Programa principal para la pr?ctica de Computadores: candy-crash para NDS
	(2? curso de Grado de Ingenier?a Inform?tica - ETSE - URV)
	
	Analista-programador: santiago.romani@urv.cat
	Programador 1: ruben.lopezm@estudiants.urv.cat
	Programador 2: yyy.yyy@estudiants.urv.cat
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
int movements;					// n?mero de movimientos restantes
int gelees;						// n?mero de gelatinas restantes



/* actualizar_contadores(code): actualiza los contadores que se indican con el
	par?metro 'code', que es una combinaci?n binaria de booleanos, con el
	siguiente significado para cada bit:
		bit 0:	nivel
		bit 1:	puntos
		bit 2:	movimientos
		bit 3:	gelatinas  */
void actualizar_contadores(int code)
{
	if (code & 1) printf("\x1b[38m\x1b[1;7H %d", level);
	if (code & 2) printf("\x1b[39m\x1b[2;8H %d  ", points);
	if (code & 4) printf("\x1b[38m\x1b[1;28H %d ", movements);
	if (code & 8) printf("\x1b[37m\x1b[2;28H %d ", gelees);
}



/* ---------------------------------------------------------------- */
/* candy1_main.c : funci?n principal main() para test de tarea 1E 	*/
/* ---------------------------------------------------------------- */
#define NUMTESTS 14

int main(void)
{



	consoleDemoInit();			// inicializaci?n de pantalla de texto
	printf("candyNDS (prueba tarea 1F y 1A)\n");
	printf("\x1b[38m\x1b[1;0H  mapa:");
	actualizar_contadores(1);
	
	do							// bucle principal de pruebas
	{	
		inicializa_matriz(matrix, level);
		escribe_matriz(matrix);
		printf("\x1b[39m\x1b[3;0H Muestra inicializa_matriz");
		printf("\x1b[33m\x1b[4;0H (pulse A/B para baja_elementos)");
		do
		{	swiWaitForVBlank();
			scanKeys();					// esperar pulsaci?n tecla 'A' o 'B'
		} while (!(keysHeld() & (KEY_A | KEY_B)));
		printf("\x1b[39m\x1b[3;0H                                 ");
		printf("\x1b[33m\x1b[4;0H                                 ");
		copia_mapa(matrix, level);
		escribe_matriz(matrix);
		if(baja_elementos(matrix)==1){
			printf("\x1b[39m\x1b[3;0H hay cambios: SI");
			printf("\x1b[38m\x1b[4;0H (pulse DOWN para ver cambios)");
			do
            {    swiWaitForVBlank();
                scanKeys();                    // esperar pulsaci?n tecla 'START'
            } while (!(keysHeld() & (KEY_DOWN)));
			printf("\x1b[38m\x1b[4;0H                               ");
            do{
				escribe_matriz(matrix);
				retardo(1);
            }while(baja_elementos(matrix)==1);
		}else{
			printf("\x1b[39m\x1b[3;0H hay cambios: NO");
		}
		retardo(5);
		printf("\x1b[38m\x1b[5;19H (pulse A/B)");
		do
		{	swiWaitForVBlank();
			scanKeys();					// esperar pulsaci?n tecla 'A' o 'B'
		} while (!(keysHeld() & (KEY_A | KEY_B)));
		printf("\x1b[38m\x1b[5;19H                      ");
		retardo(5);
		if (keysHeld() & KEY_A)		// si pulsa 'A',
		{
			level = (level + 1) % MAXLEVEL;
			actualizar_contadores(1);
		}
	} while (1);		// bucle de pruebas
	
	return(0);
}