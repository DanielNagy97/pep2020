#! /bin/bash

NUMBERS="2048 4096 8192 16384 32768"
THREADS="2 4"

OUTPUTDIR="results"

REPEATS="3"

rm -rf ${OUTPUTDIR}
mkdir ${OUTPUTDIR}

OUTPUT0=ranksort-szekv.txt
OUTPUT1=ranksort-par-2.txt
OUTPUT2=ranksort-par-4.txt

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}
touch ${OUTPUTDIR}/${OUTPUT2}

echo "-----Ranksort OpenMP párhuzamosítással-----"
echo ""

# Szekvenciális futás
for N in ${NUMBERS}
do
    echo -e "[\e[92mSzekvenciális futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
        ./bin/ranksort ${N} 1 0 >> ./${OUTPUTDIR}/${OUTPUT0}
    done
done
echo -e "[\e[92mSzekvenciális futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT0} fájlba."
echo ""

# Párhuzamos futás N paraméter szálakra
for THREAD in ${THREADS}
do
    OUTPUTPREF="ranksort-par-"
    for N in ${NUMBERS}
    do
        echo -e "[\e[92mPárhuzamos futás ${THREAD} szálon\e[0m] N = ${N} paraméterrel"
        for I in `seq 1 1 ${REPEATS}`
        do
            echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
            ./bin/ranksort ${N} ${THREAD} 1 >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
        done
    done
    echo -e "[\e[92mPárhuzamos futás ${THREAD} szálon\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt fájlba."
    echo ""
done

echo -e "[\e[92mRscript\e[0m] Gráf generálása\e[5m... \e[25m"
sudo Rscript graph.R ${REPEATS}

