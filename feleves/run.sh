#! /bin/bash
ulimit -S -s 524288

# QUOTIENS="-3 -2 -1"
# NUMBERS="2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576"
THREADS="2 4 8"

CHUNK_SIZES="1 2 4 8 16 32 64"

NUMBERS="32768 65536 131072 262144 524288"

OUTPUTDIR="results/runtimes"

REPEATS="3"

A="10"
Q="0.5"


sudo rm -rf ${OUTPUTDIR}
sudo mkdir ${OUTPUTDIR}

CHUNKK="1"

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
       ./bin/geomseq ${A} ${Q} ${N} ${CHUNKK} 1 0 >> ./${OUTPUTDIR}/${OUTPUT0}
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
            ./bin/geomseq ${A} ${Q} ${N} ${CHUNKK} ${THREAD} 1 >> ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt
        done
    done
    echo -e "[\e[92mPárhuzamos futás ${THREAD} szálon\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUTPREF}${THREAD}.txt fájlba."
    echo ""
done

BASE_N="262144"


# Szekvenciális futás Chunk paraméter
for CHUNK in ${CHUNK_SIZES}
do
    echo -e "[\e[92mSzekvenciális futás\e[0m] Chunk_size = ${CHUNK} paraméterrel"
    for I in `seq 1 1 ${REPEATS}`
    do
        echo -n ${CHUNK} " " >> ./${OUTPUTDIR}/${OUTPUT4}
        ./bin/geomseq ${A} ${Q} ${BASE_N} ${CHUNK} 1 0 >> ./${OUTPUTDIR}/${OUTPUT4}
    done
done

echo -e "[\e[92mSzekvenciális futás\e[0m] Futáseredmények kiírva a(z) ./${OUTPUTDIR}/${OUTPUT4} fájlba."
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

echo "se"
