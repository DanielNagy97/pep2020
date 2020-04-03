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
OUTPUT1=numint-par-2.txt
OUTPUT2=numint-par-4.txt

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}
touch ${OUTPUTDIR}/${OUTPUT2}

clear

echo "-----Numerikus integrálás Pthreads párhuzamosítással-----"
echo ""

# Szekvenciális futás
for N in ${NUMBERS}
do
    echo -e "[\e[92mSzekvenciális futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
        ./numint_szekv/bin/numint_szekv ${N} >> ./${OUTPUTDIR}/${OUTPUT0}
    done
done
echo -e "[\e[92mSzekvenciális futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT0} fájlba."
echo ""
# Párhuzamos futás N paraméter

for N in ${NUMBERS}
do
    echo -e "[\e[92mPárhuzamos futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT1}
        ./numint/bin/numint 2 ${N} >> ./${OUTPUTDIR}/${OUTPUT1}
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT2}
        ./numint/bin/numint 4 ${N} >> ./${OUTPUTDIR}/${OUTPUT2}
    done
done
echo -e "[\e[92mPárhuzamos futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT1}, ${OUTPUTDIR}/${OUTPUT2} fájlokba."
echo ""

echo -e "[\e[92mRscript\e[0m] Gráf generálása\e[5m... \e[25m"
sudo Rscript graph.R ${REPEATS}

