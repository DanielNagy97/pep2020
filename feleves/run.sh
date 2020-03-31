#! /bin/bash
ulimit -S -s 262144

# QUOTIENS="-3 -2 -1"
# NUMBERS="2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576"
THREADS="2 4 8"

CHUNK_SIZES="1 2 4 8 16 32 64"

NUMBERS="16384 32768 65536 131072 262144"

OUTPUTDIR="results/runtimes"

REPEATS="10"

A="10"
Q="0.5"

sudo mkdir results

sudo rm -rf ${OUTPUTDIR}
sudo mkdir ${OUTPUTDIR}

CHUNKK="2"

OUTPUT0=numbers-szekv.txt
OUTPUT1=numbers-par-2.txt
OUTPUT2=numbers-par-4.txt
OUTPUT3=numbers-par-8.txt

OUTPUT4=chunks-szekv.txt
OUTPUT5=chunks-par-2.txt
OUTPUT6=chunks-par-4.txt
OUTPUT7=chunks-par-8.txt

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}
touch ${OUTPUTDIR}/${OUTPUT2}
touch ${OUTPUTDIR}/${OUTPUT3}
touch ${OUTPUTDIR}/${OUTPUT4}
touch ${OUTPUTDIR}/${OUTPUT5}
touch ${OUTPUTDIR}/${OUTPUT6}
touch ${OUTPUTDIR}/${OUTPUT7}

    # Szekvenciális futás N paraméter
    for N in ${NUMBERS}
    do
        for I in `seq 1 1 ${REPEATS}`
        do
            echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
            ./bin/geomseq ${A} ${Q} ${N} ${CHUNKK} 1 0 >> ./${OUTPUTDIR}/${OUTPUT0}
        done
    done

    # Párhuzamos futás N paraméter szálakra
    for THREAD in ${THREADS}
    do
        OUTPUTPREF="numbers-par-"
        for N in ${NUMBERS}
        do
            for I in `seq 1 1 ${REPEATS}`
            do
                echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
                ./bin/geomseq ${A} ${Q} ${N} ${CHUNKK} ${THREAD} 1 >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
            done
        done
    done

BASE_N="262144"

    # Szekvenciális futás Chunk paraméter
    for CHUNK in ${CHUNK_SIZES}
    do
        for I in `seq 1 1 ${REPEATS}`
        do
            echo -n ${CHUNK} " " >> ./${OUTPUTDIR}/${OUTPUT4}
            ./bin/geomseq ${A} ${Q} ${BASE_N} ${CHUNK} 1 0 >> ./${OUTPUTDIR}/${OUTPUT4}
        done
    done

    # Párhuzamos futás N paraméter szálakra
    for THREAD in ${THREADS}
    do
        OUTPUTPREF="chunks-par-"
        for CHUNK in ${CHUNK_SIZES}
        do
            for I in `seq 1 1 ${REPEATS}`
            do
                echo -n ${CHUNK} " " >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
                ./bin/geomseq ${A} ${Q} ${BASE_N} ${CHUNK} ${THREAD} 1 >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
            done
        done
    done




sudo Rscript graph.R ${REPEATS}

echo "se"
