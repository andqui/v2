#!/bin/bash

set -e

if [ -d tmp ]; then
    rm -rf tmp
fi

mkdir tmp
cd tmp
# Subset of protobuf to have a faster setup
curl -OL https://github.com/protocolbuffers/protobuf/releases/download/v3.6.1/protobuf-cpp-3.6.1.tar.gz
tar -xvzf protobuf-cpp-3.6.1.tar.gz
cd protobuf-3.6.1
./autogen.sh
./configure
make
make check
sudo make install
sudo ldconfig # refresh shared library cache.
cd ..
rm -rf tmp