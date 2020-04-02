#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <stopper.h>

double f(double t){
    return t+sin(t);
}

int main(int argc, char** argv)
{
    long int numpoints = atoi(argv[1]);
    double a;
    double b;
    double w;
    double t;
    double globalsum;
    double answer;
    int i;

    stopperOMP st;
    startSOMP(&st);
    a=0.0;
    b=1.0;
    w=(b-a)/(numpoints);

    t=a; //my starting position

    for (i=0; i<numpoints; i++){
        globalsum = globalsum+f(t);
        t=t+w;
    }

    globalsum=w*globalsum;

    answer=globalsum+w/2*(f(b)+f(a)); //Add end points

    stopSOMP(&st);
    tprintfOMP(&st, "\n");
    //printf("The answer is: %f\n", answer);

}
