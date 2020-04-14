#! /bin/bash
# ulimit -S -s 262144

NUMBERS="256 512 1024 2048 4096"

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

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}
touch ${OUTPUTDIR}/${OUTPUT2}
touch ${OUTPUTDIR}/${OUTPUT3}
touch ${OUTPUTDIR}/${OUTPUT4}
touch ${OUTPUTDIR}/${OUTPUT5}

echo "-----Ranksort OpenMP párhuzamosítással-----"
echo ""

# futás N paraméterekre
for N in ${NUMBERS}
do
    echo -e "[\e[92mSzekvenciális futás és párhuzamos futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
        ./bin/matrixnm ${N} ${BASE_VAL} ${BASE_VAL} ${BASE_VAL} 0 >> ./${OUTPUTDIR}/${OUTPUT0}

        echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT3}
        ./bin/matrixnm ${N} ${BASE_VAL} ${BASE_VAL} ${BASE_VAL} 1 >> ./${OUTPUTDIR}/${OUTPUT3}
    done
done
echo -e "[\e[92mSzekvenciális futás és párhuzamos futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT0} és ./${OUTPUTDIR}/${OUTPUT3} fájlokba."
echo ""

# futás M paraméterekre
for M in ${NUMBERS}
do
    echo -e "[\e[92mSzekvenciális futás és párhuzamos futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${M} " " >> ./${OUTPUTDIR}/${OUTPUT1}
        ./bin/matrixnm ${BASE_VAL} ${M} ${BASE_VAL} ${BASE_VAL} 0 >> ./${OUTPUTDIR}/${OUTPUT1}

        echo -n ${M} " " >> ./${OUTPUTDIR}/${OUTPUT4}
        ./bin/matrixnm ${BASE_VAL} ${M} ${BASE_VAL} ${BASE_VAL} 1 >> ./${OUTPUTDIR}/${OUTPUT4}
    done
done
echo -e "[\e[92mSzekvenciális futás és párhuzamos futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT1} és ./${OUTPUTDIR}/${OUTPUT4} fájlokba."
echo ""

# futás P paraméterekre
for P in ${NUMBERS}
do
    echo -e "[\e[92mSzekvenciális futás és párhuzamos futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${P} " " >> ./${OUTPUTDIR}/${OUTPUT2}
        ./bin/matrixnm ${BASE_VAL} ${BASE_VAL} ${P} ${BASE_VAL} 0 >> ./${OUTPUTDIR}/${OUTPUT2}

        echo -n ${P} " " >> ./${OUTPUTDIR}/${OUTPUT5}
        ./bin/matrixnm ${BASE_VAL} ${BASE_VAL} ${P} ${BASE_VAL} 1 >> ./${OUTPUTDIR}/${OUTPUT5}
    done
done
echo -e "[\e[92mSzekvenciális futás és párhuzamos futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT2} és ./${OUTPUTDIR}/${OUTPUT5} fájlokba."
echo ""

echo -e "[\e[92mRscript\e[0m] Gráfok generálása\e[5m... \e[25m"
sudo Rscript graph.R ${REPEATS}

