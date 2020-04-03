#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stopper.h>

int* arr;

typedef struct ThreadParameters
{
    // input
    int* array;
    int start;
    int end;

    // output
    int smallest;
} ThreadParameters;

void* find_min_max(void* args)
{
    struct ThreadParameters* params = (struct ThreadParameters*)args;
    int *array = params->array;
    int start = params->start;
    int end = params->end;
    int smallest = array[start];

    for (int i = start; i < end; i++)
    {
        if (array[i] < smallest)
        {
            smallest = array[i];
        }
    }

    // write the result back to the parameter structure
    params->smallest = smallest;

    return NULL;
}

void fillArray(long int array_size)
{
    for (int i = 0; i < array_size; i++)
    {
        arr[i] = rand() % 1000 + 1;
    }
}

int main(int argc, char** argv)
{
    int smallest;

    long int array_size = atoi(argv[1]);
    int threads_count = atoi(argv[2]);

    arr = malloc(sizeof(*arr) * array_size);

    // declare an array of threads and associated parameter instances
    pthread_t* threads= (pthread_t*)malloc(sizeof(pthread_t)*threads_count);
    ThreadParameters* thread_parameters= (ThreadParameters*)malloc(sizeof(ThreadParameters)*threads_count);

    // intialize the array    
    fillArray(array_size);

    stopperOMP st;
    startSOMP(&st);

    // smallest and largest needs to be set to something
    smallest = arr[0];

    // start all the threads
    for (int i = 0; i < threads_count; i++)
    {
        thread_parameters[i].array = arr;
        thread_parameters[i].start = i * (array_size / threads_count);
        thread_parameters[i].end = (i+1) * (array_size / threads_count);
        pthread_create(&threads[i], NULL, find_min_max, &thread_parameters[i]);
    }

    // wait for all the threads to complete
    for (int i = 0; i < threads_count; i++)
    {
        pthread_join(threads[i], NULL);
    }

    // Now aggregate the "smallest" and "largest" results from all thread runs    
    for (int i = 0; i < threads_count; i++)
    {
        if (thread_parameters[i].smallest < smallest)
        {
            smallest = thread_parameters[i].smallest;
        }
    }
    stopSOMP(&st);
    tprintfOMP(&st, "\n");

    //printf("Smallest is %d\n", smallest);
}
