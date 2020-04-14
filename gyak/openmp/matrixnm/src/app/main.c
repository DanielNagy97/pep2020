#include <stdlib.h>
#include <stdio.h>
#include <omp.h>
#include <stopper.h>

#define THREADS 2

int** allocate_matrix(int, int);

int main(int argc, char** argv)
{
    int N = atoi(argv[1]);
    int M = atoi(argv[2]);
    int P = atoi(argv[3]);
    int upper_limit = atoi(argv[4]);
    int to_parallel = atoi(argv[5]);

    int **A = allocate_matrix(M, N);
    int **B = allocate_matrix(N, P);
    int **C = allocate_matrix(M, P);

    int i, j, k;

    int sum = 0;

    srand(0);

    for (i = 0; i < M; i++)
    {
        for (j = 0; j < N; j++)
        {
            A[i][j] = rand()%upper_limit;
        }
    }

    for (i = 0; i < N; i++)
    {
        for (j = 0; j < P; j++)
        {
            B[i][j] = rand()%upper_limit;
        }
    }

    stopperOMP sw;
    startSOMP(&sw);
    #pragma omp parallel if(to_parallel), num_threads(THREADS)
    {
    #pragma omp for private(k, sum) schedule(auto)
    for (i = 0; i < M; i++)
    {
        for (j = 0; j < P; j++)
        {
            sum = 0;
            for (k = 0; k < N; k++)
            {
                sum = sum + (A[i][k]*B[k][j]);
            }
            C[i][j] = sum;
        }
    }
    }
    stopSOMP(&sw);
    tprintfOMP(&sw, "\n");

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
