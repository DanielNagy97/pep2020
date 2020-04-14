#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stopper.h>

int* arr;

typedef struct ThreadParameters
{
    int* array;
    int start_point;
    int end_point;

    int min;
} ThreadParameters;

void* find_min(void* args)
{
    struct ThreadParameters* params = (struct ThreadParameters*)args;
    int *array = params->array;
    int start_point = params->start_point;
    int end_point = params->end_point;
    int min = array[start_point];

    for (int i = start_point; i < end_point; i++)
    {
        if (array[i] < min)
        {
            min = array[i];
        }
    }

    params->min = min;

    return NULL;
}

void fill_array(long int array_size)
{
    for (int i = 0; i < array_size; i++)
    {
        arr[i] = rand() % 1000 + 1;
    }
}

int main(int argc, char** argv)
{
    int min;

    long int array_size = atoi(argv[1]);
    int threads_count = atoi(argv[2]);
    int chunk_size = array_size / threads_count;

    arr = malloc(sizeof(*arr) * array_size);

    pthread_t* threads= (pthread_t*)malloc(sizeof(pthread_t)*threads_count);
    ThreadParameters* thread_parameters= (ThreadParameters*)malloc(sizeof(ThreadParameters)*threads_count);
  
    fill_array(array_size);

    stopperOMP st;
    startSOMP(&st);

    min = arr[0];

    for (int i = 0; i < threads_count; i++)
    {
        thread_parameters[i].array = arr;
        thread_parameters[i].start_point = i * chunk_size;
        thread_parameters[i].end_point = (i+1) * chunk_size;
        pthread_create(&threads[i], NULL, find_min, &thread_parameters[i]);
    }

    for (int i = 0; i < threads_count; i++)
    {
        pthread_join(threads[i], NULL);
    }
 
    for (int i = 0; i < threads_count; i++)
    {
        if (thread_parameters[i].min < min)
        {
            min = thread_parameters[i].min;
        }
    }
    stopSOMP(&st);
    tprintfOMP(&st, "\n");

    //printf("Min is %d\n", min);
}
