// Program written by Charles Reiss

#define _GNU_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define SIZE 994

double matrix[SIZE * SIZE];
volatile double result;

#define NOINLINE __attribute__((noinline))

__asm__("\
nop\n\
.align 256\n\
");

NOINLINE
int InitApplication() {
    puts("Initialize application.");
    srand48(time(0));
    for (int i = 0; i < SIZE * SIZE; ++i) {
        matrix[i] = drand48();
    }
    for (int i = 0; i < SIZE; ++i) {
        for (int j = 0; j < SIZE - 1; ++j) {
            matrix[i * SIZE + j] += (double) i;
        }
    }
    return 0;
}

NOINLINE
double ExecApplication(int x) {
    puts("Begin application execution.");
    for (int iteration = 0; iteration < 4; ++iteration) {
        for (int i = 0; i < SIZE; ++i) {
            for (int j = 0; j < SIZE - x; ++j) {
                matrix[i * SIZE + j] = (
                    matrix[j * SIZE + i] +
                    matrix[(j + x) * SIZE + i]
                ) / 2.;
            }
        }
    }
    double temp = 0.0;
    for (int i = 0; i < SIZE; ++i) {
        for (int j = 0; j < SIZE; ++j) {
            temp += matrix[i * SIZE + j];
        }
    }
    result = temp;
    return result;
}

NOINLINE
int TerminateApplication() {
    puts("Terminate application.");
    if (result > 0) {
        return 0;
    } else {
        return -1;
    }
}

NOINLINE
int DoApplication(int x) {
    InitApplication();
    ExecApplication(x);
    return TerminateApplication();
}

int main(int argc, char **argv) {
    int x = 1;
    if (argc > 1) {
        x = atoi(argv[0]);
    } 
    DoApplication(x);
    return 0;
}
