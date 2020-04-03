#include <stdio.h>
#include <stdlib.h>
#include <stopper.h>

#define SIZE 1024

int main(void){


    static long int A[SIZE][SIZE];
    static long int B[SIZE][SIZE];
    static long int C[SIZE][SIZE];

    int i, j, k;

    long int sum;

    srand(0);
    stopperOMP st;

    for(i = 0; i<SIZE; i++)
        for(j = 0; j<SIZE; j++)
            A[i][j] = rand() % 255;

    for(i = 0; i<SIZE; i++){
        for(j = 0; j<SIZE; j++){
            B[i][j] = rand() % 255;
        }
    }

    startSOMP(&st);
    for (i = 0; i < SIZE; i++)
    {
        for (j = 0; j < SIZE; j++)
        {
            sum = 0;
            for (k = 0; k < SIZE; k++)
            {
                sum = sum + (A[i][k]*B[k][j]);
            }
            C[i][j] = sum;
        }
    }
    stopSOMP(&st);

    printf("%ld\n",C[SIZE-1][SIZE-1]);

    tprintfOMP(&st, "\n");

    return 0;
}
