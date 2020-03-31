#include <stdio.h>
#include <stdlib.h>
#include <omp.h>

#include <stopper.h>
#define lower_limit -1000
#define upper_limit 1000

int main(int argc, char** argv){

    long int n = atoi(argv[1]);
    int threads = atoi(argv[2]);
    int to_parallel = atoi(argv[3]);

    int a[n];
    int final[n];
    int i, j;
    int rank, count;


    srand(0);

    for (i = 0; i < n; i++)
    {
        a[i] = (rand()%(upper_limit - lower_limit + 1)) + lower_limit;
    }

    stopperOMP sw;
    startSOMP(&sw);
    #pragma omp parallel if(to_parallel), num_threads(threads)
    {
    #pragma omp for private(j, rank, count) schedule(auto)
    for (i = 0; i < n; i++)
    {
        rank = 0;
        count = 0;

        for(j = 0; j < n; j++)
        {
            if(a[i] > a[j])
                rank++;
            
            if(a[i] == a[j] && j < i)
                count++;
        }
        rank = rank + count;
        final[rank] = a[i];    
    }
    }
    stopSOMP(&sw);
    tprintfOMP(&sw, "\n");

    return 0;
}
