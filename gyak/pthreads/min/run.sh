#! /bin/bash

NUMBERS="131072 262144 524288 1048576 2097152"

THREADS="2 4"

OUTPUTDIR="results"

REPEATS="5"

rm -rf ${OUTPUTDIR}
mkdir ${OUTPUTDIR}

OUTPUT0=min-szekv.txt
OUTPUT1=min-par-2.txt
OUTPUT2=min-par-4.txt

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}
touch ${OUTPUTDIR}/${OUTPUT2}

clear

echo "-----Minimum keresés Pthreads párhuzamosítással-----"
echo ""

# Szekvenciális futás
for N in ${NUMBERS}
do
    echo -e "[\e[92mSzekvenciális futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
        ./min_szekv/bin/min_szekv ${N} >> ./${OUTPUTDIR}/${OUTPUT0}
    done
done
echo -e "[\e[92mSzekvenciális futás\e[0m] Futáseredmények kiírva a(z) ${OUTPUTDIR}/${OUTPUT0} fájlba."
echo ""
# Párhuzamos futás N paraméter

for N in ${NUMBERS}
do
    echo -e "[\e[92mPárhuzamos futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT1}
        ./min/bin/min ${N} 2 >> ./${OUTPUTDIR}/${OUTPUT1}
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT2}
        ./min/bin/min ${N} 4 >> ./${OUTPUTDIR}/${OUTPUT2}
    done
done
echo -e "[\e[92mPárhuzamos futás\e[0m] Futáseredmények kiírva a(z) ${OUTPUTDIR}/${OUTPUT1} és ${OUTPUTDIR}/${OUTPUT2} fájlokba."
echo ""

echo -e "[\e[92mRscript\e[0m] Gráf generálása\e[5m... \e[25m"
sudo Rscript graph.R ${REPEATS}

