#include <stdio.h>
#include <stdlib.h>
#include <stopper.h>

#define SIZE 1024

int** allocate_matrix(int, int);

int main(void)
{
    int i, j, k;

    int **A = allocate_matrix(SIZE, SIZE);
    int **B = allocate_matrix(SIZE, SIZE);
    int **C = allocate_matrix(SIZE, SIZE);

    long int sum;

    srand(0);
    stopperOMP st;

    for(i = 0; i < SIZE; i++)
    {
        for(j = 0; j < SIZE; j++)
        {
            A[i][j] = rand() % 255;
        }
    }

    for(i = 0; i < SIZE; i++)
    {
        for(j = 0; j < SIZE; j++)
        {
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

    printf("%d\n", C[SIZE-1][SIZE-1]);

    tprintfOMP(&st, "\n");

    free(A);
    free(B);
    free(C);

    return 0;
}

int** allocate_matrix(int m, int n)
{
    int i;
    int **a = (int **)malloc(m * sizeof(int *));

    for (i = 0; i < m; i++)
         a[i] = (int *)malloc(n * sizeof(int));

    return a;
}
