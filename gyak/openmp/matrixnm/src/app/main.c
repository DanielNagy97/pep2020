#include <stdlib.h>
#include <stdio.h>
#include <omp.h>
#include <stopper.h>

#define threads 2

int main(int argc, char** argv){

    int N = atoi(argv[1]);
    int M = atoi(argv[2]);
    int P = atoi(argv[3]);
    int upper_limit = atoi(argv[4]);
    int to_parallel = atoi(argv[5]);

    int A[M][N];
    int B[N][P];
    int C[M][P];

    int i, j, k;

    int sum = 0;

    srand(0);

    for (i = 0; i < M; i++)
        for (j = 0; j < N; j++)
            A[i][j] = rand()%upper_limit;

    for (i = 0; i < N; i++)
        for (j = 0; j < P; j++)
            B[i][j] = rand()%upper_limit;

    stopperOMP sw;
    startSOMP(&sw);
    #pragma omp parallel if(to_parallel), num_threads(threads)
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
