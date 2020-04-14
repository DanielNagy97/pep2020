#! /bin/bash
ulimit -S -s 262144

REPEATS="10"

THREADS="2 4"

CHUNK_SIZES="1 2 4 8 16 32 64"

NUMBERS="65536 131072 262144 524288 1048576"

BASE_CHUNK="4"
BASE_N="1048576"

A="10"
Q="0.5"

RESULTSDIR="results"

RUNTIMESDIR="runtimes"

OUTPUTDIR="results/runtimes"

sudo rm -rf ${RESULTSDIR}
sudo mkdir ${RESULTSDIR}

sudo mkdir ${OUTPUTDIR}

OUTPUT0=numbers-szekv.txt
OUTPUT1=numbers-par-2.txt
OUTPUT2=numbers-par-4.txt
OUTPUT3=chunks-szekv.txt
OUTPUT4=chunks-par-2.txt
OUTPUT5=chunks-par-4.txt

touch ${OUTPUTDIR}/${OUTPUT0}
touch ${OUTPUTDIR}/${OUTPUT1}
touch ${OUTPUTDIR}/${OUTPUT2}
touch ${OUTPUTDIR}/${OUTPUT3}
touch ${OUTPUTDIR}/${OUTPUT4}
touch ${OUTPUTDIR}/${OUTPUT5}

clear

echo "-----Mértani sorozat összege rekurzívan OpenMP párhuzamosítással-----"
echo ""


# Szekvenciális futás N paraméter
for N in ${NUMBERS}
do
    echo -e "[\e[92mSzekvenciális futás\e[0m] N = ${N} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
       echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUT0}
       ./bin/geomseq ${A} ${Q} ${N} ${BASE_CHUNK} 1 0 >> ./${OUTPUTDIR}/${OUTPUT0}
    done
done
echo -e "[\e[92mSzekvenciális futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT0} fájlba."
echo ""


# Párhuzamos futás N paraméter szálakra
for THREAD in ${THREADS}
do
    OUTPUTPREF="numbers-par-"
    for N in ${NUMBERS}
    do
        echo -e "[\e[92mPárhuzamos futás ${THREAD} szálon\e[0m] N = ${N} paraméterrel"
        for I in `seq 1 1 ${REPEATS}`
        do
            echo -n ${N} " " >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
            ./bin/geomseq ${A} ${Q} ${N} ${BASE_CHUNK} ${THREAD} 1 >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
        done
    done
    echo -e "[\e[92mPárhuzamos futás ${THREAD} szálon\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt fájlba."
    echo ""
done


# Szekvenciális futás Chunk paraméter
for CHUNK in ${CHUNK_SIZES}
do
    echo -e "[\e[92mSzekvenciális futás\e[0m] Chunk_size = ${CHUNK} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${CHUNK} " " >> ./${OUTPUTDIR}/${OUTPUT3}
        ./bin/geomseq ${A} ${Q} ${BASE_N} ${CHUNK} 1 0 >> ./${OUTPUTDIR}/${OUTPUT3}
    done
done

echo -e "[\e[92mSzekvenciális futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT3} fájlba."
echo ""


# Párhuzamos futás N paraméter szálakra
for THREAD in ${THREADS}
do
    OUTPUTPREF="chunks-par-"
    for CHUNK in ${CHUNK_SIZES}
    do
        echo -e "[\e[92mPárhuzamos futás ${THREAD} szálon\e[0m] Chunk_size = ${CHUNK} paraméterrel"
        for I in `seq 1 1 ${REPEATS}`
        do
            echo -n ${CHUNK} " " >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
            ./bin/geomseq ${A} ${Q} ${BASE_N} ${CHUNK} ${THREAD} 1 >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
        done
    done
    echo -e "[\e[92mPárhuzamos futás ${THREAD} szálon\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt fájlba."
    echo ""
done

echo -e "[\e[92mRscript\e[0m] Gráfok generálása\e[5m... \e[25m"
sudo Rscript graph.R ${REPEATS}
