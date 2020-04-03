#! /bin/bash

CMAKE=CMakeLists.txt

rm ${CMAKE}
touch ./${CMAKE}

OUTPUTDIR="results"

rm -rf ${OUTPUTDIR}
mkdir ${OUTPUTDIR}

OUTPUT0=runtimes.txt

touch ${OUTPUTDIR}/${OUTPUT0}

echo -n 'CMAKE_MINIMUM_REQUIRED(VERSION 2.8)
PROJECT(jj181j C)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_BINARY_DIR}/libo)
SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_BINARY_DIR}/bin)
SUBDIRS(src/lib src/app)
SET(CMAKE_VERBOSE_MAKEFILE on)
SET(CMAKE_C_FLAGS "-fopenmp -O0")' >> ./${CMAKE}

cmake .
make

echo -n -O0 " " >> ./${OUTPUTDIR}/${OUTPUT0}
./bin/matrixnn | tail -n1 >> ./${OUTPUTDIR}/${OUTPUT0}

sed '$d' < ${CMAKE} > temp ; mv temp ${CMAKE}
echo -n 'SET(CMAKE_C_FLAGS "-fopenmp -O3")' >> ./${CMAKE}

cmake .
make
echo -n -O3 " " >> ./${OUTPUTDIR}/${OUTPUT0}
./bin/matrixnn | tail -n1 >> ./${OUTPUTDIR}/${OUTPUT0}

Rscript bar.R
