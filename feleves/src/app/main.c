#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <math.h>
#include <stopper.h>

double geomseq_sum(double i, double n, double a, double q);

int main(int argc, char** argv){

    stopperOMP st;

    double first_element = atof(argv[1]);
    double q = atof(argv[2]);
    long int n = atoi(argv[3]);
    int chunk_n = atoi(argv[4]);
    int threads_n = atoi(argv[5]);
    double sum[threads_n];
    double final_sum = 0;
    long int i;
    long int chunk_size = n/chunk_n;

    startSOMP(&st);
    #pragma omp parallel num_threads(threads_n) if(atoi(argv[6]))
    {
        #pragma omp for private(i) reduction(+:final_sum)
        for(i=0; i<chunk_n; i++){
            final_sum += geomseq_sum(i*(chunk_size),
                                     (i+1)*chunk_size-1,
                                     first_element*pow(q, i*(chunk_size)),
                                     q);
        }
    }
    stopSOMP(&st);

    tprintfOMP(&st, "\n");

    //printf("%f\n", final_sum);

    return 0;
}

double geomseq_sum(double i, double n, double a, double q){

    if(i <= n)
    {
        return a + geomseq_sum(i+1, n, a*q, q);
    }
    else
    {
        return 0;
    }  
}
