#include <stdio.h>
#include <stdlib.h>
#include <pthread.h>
#include <math.h>
#include <stopper.h>

int threads_count;
long int numpoints;
double a;
double b;
double w;
long double globalsum;
int i;
pthread_mutex_t Lock;

typedef struct ThreadParameters
{
    int myindex;
} ThreadParameters;

double f(double t)
{
    return t+sin(t);
}

void* integrate(void* args)
{
    struct ThreadParameters* params = (struct ThreadParameters*)args;
    int myindex = params->myindex;

    double localsum, t;
    int j;

    t=a+myindex*(b-a)/threads_count; //my starting position

    for (j=0; j<numpoints; j++)
    {
        localsum = localsum+f(t);
        t=t+w;
    }

    localsum=w*localsum;

    pthread_mutex_lock(&Lock);
    globalsum=globalsum+localsum; //atomic update
    pthread_mutex_unlock(&Lock);

    return NULL;
}


int main(int argc, char** argv)
{
    threads_count = atoi(argv[1]);
    int n = atoi(argv[2]);
    numpoints = n / threads_count;
    double answer;
    stopperOMP st;
    startSOMP(&st);
    a=0.0;
    b=1.0;
    w=(b-a)/(n);

    pthread_t* threads= (pthread_t*)malloc(sizeof(pthread_t)*threads_count);
    ThreadParameters* thread_parameters= (ThreadParameters*)malloc(sizeof(ThreadParameters)*threads_count);

    for (int i = 0; i < threads_count; i++)
    {
        thread_parameters[i].myindex = i;
        pthread_create(&threads[i], NULL, integrate, &thread_parameters[i]);
    }

    for (int i = 0; i < threads_count; i++)
    {
        pthread_join(threads[i], NULL);
    }

    answer=globalsum+w/2*(f(b)+f(a)); //Add end points

    stopSOMP(&st);
    tprintfOMP(&st, "\n");
    //printf("The answer is: %f\n", answer);
}
