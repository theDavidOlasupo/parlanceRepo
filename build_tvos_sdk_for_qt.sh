#!/bin/bash
  
mkdir -p build-tvos
pushd build-tvos
../Src/configure -prefix `pwd`/../tvos -opensource -confirm-license -verbose -debug-and-release -nomake tests -nomake examples -xplatform macx-tvos-clang
make -j5
make install
popd
