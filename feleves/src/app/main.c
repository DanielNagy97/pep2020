#include <stdio.h>
#include <stdlib.h>
#include <omp.h>
#include <math.h>
#include <stopper.h>

// first_element q n chunk_n threads_n if_parallel

double recursive_geomseq_sum(double i, double n, double a, double q);

int main(int argc, char** argv){

    stopperOMP sw;

    double first_element = atof(argv[1]);
    double q = atof(argv[2]);
    long int n = atoi(argv[3]);
    int chunk_n = atoi(argv[4]);
    int threads_n = atoi(argv[5]);
    double sum[threads_n];
    double final_sum = 0;
    long int i;
    long int chunk_size = n/chunk_n;


    //omp_set_nested(1);

    startSOMP(&sw);
    #pragma omp parallel num_threads(threads_n) if(atoi(argv[6]))
    {
        #pragma omp for private(i) reduction(+:final_sum)
        for(i=0; i<chunk_n; i++){
            final_sum = recursive_geomseq_sum(i*(chunk_size), (i+1)*chunk_size-1, first_element*pow(q, i*(chunk_size)), q);
        }

/*
            #pragma omp for private(i)
            for(i=0; i<chunk_n; i++){
                final_sum = final_sum + sum[i];
            }
*/
    }
    stopSOMP(&sw);

    tprintfOMP(&sw, "\n");

    //printf("%f\n", final_sum);

    return 0;
}

double recursive_geomseq_sum(double i, double n, double a, double q){

    if(i <= n)
    {
        double x;
        #pragma omp task shared(x)
        x = recursive_geomseq_sum(i+1, n, a*q, q);
            
        #pragma omp taskwait
        return a + x;
    }
    else
    {
        return 0;
    }  
}
/*
        //#pragma omp for private(i)
        for(i=0; i<threads_n; i++){
            #pragma omp task
            sum[i] = recursive_geomseq_sum(i*(chunk_size), (i+1)*chunk_size-1, first_element*pow(q, i*(chunk_size)), q);
        }

*/
