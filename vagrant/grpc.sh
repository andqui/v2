#!/bin/bash

set -e

if [ -d tmp ]; then
    rm -rf tmp
fi

mkdir tmp
cd tmp
git clone https://github.com/protocolbuffers/protobuf.git
cd protobuf
git submodule update --init --recursive
./autogen.sh
./configure
make
make check
sudo make install
sudo ldconfig # refresh shared library cache.
cd ..
rm -rf tmp