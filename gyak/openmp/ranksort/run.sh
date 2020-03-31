#! /bin/bash
# ulimit -S -s 262144

# NUMBERS="2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144"
NUMBERS="2048 4096 8192 16384 32768"
THREADS="2 4"

OUTPUTDIR="results"

REPEATS="3"

A="10"
Q="0.5"

rm -rf ${OUTPUTDIR}
mkdir ${OUTPUTDIR}

OUTPUT0=ranksort-szekv.txt
OUTPUT1=ranksort-par-2.txt
OUTPUT2=ranksort-par-4.txt

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}
touch ${OUTPUTDIR}/${OUTPUT2}

# Szekvenciális futás
for N in ${NUMBERS}
do
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
        ./bin/ranksort ${N} 1 0 >> ./${OUTPUTDIR}/${OUTPUT0}
    done
done

# Párhuzamos futás N paraméter szálakra
for THREAD in ${THREADS}
do
    OUTPUTPREF="ranksort-par-"
    for N in ${NUMBERS}
    do
        for I in `seq 1 1 ${REPEATS}`
        do
            echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
            ./bin/ranksort ${N} ${THREAD} 1 >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
        done
    done
done

sudo Rscript graph.R ${REPEATS}

echo "se"


