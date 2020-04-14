#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stopper.h>

void fill_array(int* arr, long int array_size)
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

    int * arr;
    arr = malloc(sizeof(*arr) * array_size);
 
    fill_array(arr, array_size);

    stopperOMP st;
    startSOMP(&st);

    min = arr[0];

    for (int i = 0; i < array_size; i++)
    {
        if (arr[i] < min)
        {
            min = arr[i];
        }
    }

    stopSOMP(&st);
    tprintfOMP(&st, "\n");

    //printf("Min is %d\n", min);
}
