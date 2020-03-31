#! /bin/bash
# ulimit -S -s 262144

# NUMBERS="2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144"

NUMBERS="256 512 1024 2048 4096"

RANDOMS="32 64 128 256 512"

# THREADS="2"

BASE_VAL="128"

REPEATS="3"

OUTPUTDIR="results"

rm -rf ${OUTPUTDIR}
mkdir ${OUTPUTDIR}

OUTPUT0=matrixnm-szekv-N.txt
OUTPUT1=matrixnm-szekv-M.txt
OUTPUT2=matrixnm-szekv-P.txt
OUTPUT3=matrixnm-par-N.txt
OUTPUT4=matrixnm-par-M.txt
OUTPUT5=matrixnm-par-P.txt
OUTPUT6=matrixnm-szekv-R.txt
OUTPUT7=matrixnm-par-R.txt

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}
touch ${OUTPUTDIR}/${OUTPUT2}
touch ${OUTPUTDIR}/${OUTPUT3}
touch ${OUTPUTDIR}/${OUTPUT4}
touch ${OUTPUTDIR}/${OUTPUT5}
touch ${OUTPUTDIR}/${OUTPUT6}
touch ${OUTPUTDIR}/${OUTPUT7}

# futás N paraméterekre
for N in ${NUMBERS}
do
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
        ./bin/matrixnm ${N} ${BASE_VAL} ${BASE_VAL} ${BASE_VAL} 0 >> ./${OUTPUTDIR}/${OUTPUT0}

        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT3}
        ./bin/matrixnm ${N} ${BASE_VAL} ${BASE_VAL} ${BASE_VAL} 1 >> ./${OUTPUTDIR}/${OUTPUT3}
    done
done

# futás M paraméterekre
for M in ${NUMBERS}
do
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${M} " " >> ./${OUTPUTDIR}/${OUTPUT1}
        ./bin/matrixnm ${BASE_VAL} ${M} ${BASE_VAL} ${BASE_VAL} 0 >> ./${OUTPUTDIR}/${OUTPUT1}

        echo -n ${M} " " >> ./${OUTPUTDIR}/${OUTPUT4}
        ./bin/matrixnm ${BASE_VAL} ${M} ${BASE_VAL} ${BASE_VAL} 1 >> ./${OUTPUTDIR}/${OUTPUT4}
    done
done

# futás P paraméterekre
for P in ${NUMBERS}
do
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${P} " " >> ./${OUTPUTDIR}/${OUTPUT2}
        ./bin/matrixnm ${BASE_VAL} ${BASE_VAL} ${P} ${BASE_VAL} 0 >> ./${OUTPUTDIR}/${OUTPUT2}

        echo -n ${P} " " >> ./${OUTPUTDIR}/${OUTPUT5}
        ./bin/matrixnm ${BASE_VAL} ${BASE_VAL} ${P} ${BASE_VAL} 1 >> ./${OUTPUTDIR}/${OUTPUT5}
    done
done

# futás a random számok felső korlátjainak paramétereire paramétereire
for R in ${RANDOMS}
do
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${R} " " >> ./${OUTPUTDIR}/${OUTPUT6}
        ./bin/matrixnm ${BASE_VAL} ${BASE_VAL} ${BASE_VAL} ${R} 0 >> ./${OUTPUTDIR}/${OUTPUT6}

        echo -n ${R} " " >> ./${OUTPUTDIR}/${OUTPUT7}
        ./bin/matrixnm ${BASE_VAL} ${BASE_VAL} ${BASE_VAL} ${R} 1 >> ./${OUTPUTDIR}/${OUTPUT7}
    done
done


sudo Rscript graph.R ${REPEATS}

echo "se"
