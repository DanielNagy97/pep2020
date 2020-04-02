#! /bin/bash
# ulimit -S -s 262144

# NUMBERS="2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144"
NUMBERS="65536 131072 262144 524288 1048576"

THREADS="2 4"

OUTPUTDIR="results"

REPEATS="10"

rm -rf ${OUTPUTDIR}
mkdir ${OUTPUTDIR}

OUTPUT0=numint-szekv.txt
OUTPUT1=numint-par.txt

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}

# Szekvenciális futás
for N in ${NUMBERS}
do
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
        ./numint_szekv/bin/numint_szekv ${N} >> ./${OUTPUTDIR}/${OUTPUT0}
    done
done

# Párhuzamos futás N paraméter

for N in ${NUMBERS}
do
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT1}
        ./numint/bin/numint 2 ${N} >> ./${OUTPUTDIR}/${OUTPUT1}
    done
done


sudo Rscript graph.R ${REPEATS}

echo "se"


