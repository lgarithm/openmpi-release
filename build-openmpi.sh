#!/bin/sh

set -e

# FIXME:
# ./build-openmpi.sh: 6: [: Linux: unexpected operator
# if [ "$(uname)" == "Darwin" ]; then
#     NPROC=$(sysctl -n hw.ncpu)
# else
#     NPROC=$(nproc)
# fi

NPROC=$(nproc)

cd $(dirname $0)
SCRIPT_DIR=$(pwd)

measure() {
    echo "begin $@"
    local begin=$(date +%s)
    $@
    local end=$(date +%s)
    local duration=$((end - begin))
    echo "$@ took ${duration}s"
}

build_openmpi() {
    local TARBAL=$1
    local PREFIX=$2
    local FOLDER=${TARBAL%.tar.bz2}

    cd $(mktemp -d)
    cp -v ${SCRIPT_DIR}/${TARBAL} .

    measure tar -xf ${TARBAL}
    cd ${FOLDER}

    measure ./configure --prefix=${PREFIX}
    measure make -j ${NPROC} all
    measure make install
}

PREFIX=$HOME/local
[ ! -z "$1" ] && PREFIX=$1

OUTPUT=openmpi-bin-${VERSION}.tar.bz2
[ ! -z "$2" ] && OUTPUT=$2

VERSION=3.1.0
measure build_openmpi openmpi-${VERSION}.tar.bz2 ${PREFIX}/openmpi

# pack
cd ${PREFIX}
tar -cf openmpi-bin-${VERSION}.tar openmpi
bzip2 openmpi-bin-${VERSION}.tar

mkdir -p /host/releases
cp openmpi-bin-${VERSION}.tar.bz2 /host/releases/${OUTPUT}
