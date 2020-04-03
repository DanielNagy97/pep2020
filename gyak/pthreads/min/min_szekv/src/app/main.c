#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <stopper.h>

void fillArray(long int* arr, long int array_size)
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

    long int arr[array_size];

    // intialize the array    
    fillArray(arr, array_size);

    stopperOMP st;
    startSOMP(&st);

    // smallest and largest needs to be set to something
    smallest = arr[0];

    for (int i = 0; i < array_size; i++)
    {
        if (arr[i] < smallest)
        {
            smallest = arr[i];
        }
    }

    stopSOMP(&st);
    tprintfOMP(&st, "\n");

    //printf("Smallest is %d\n", smallest);
}
