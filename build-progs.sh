#!/bin/bash

TYPE=$1
BIN=~/src/ross-paper/bin

source util/setchplenv.bash >/dev/null 2>&1
CHPL_COMM=none

cd examples/benchmarks/miniMD/
make
cp miniMD $BIN/miniMD-$TYPE
cd ../../../

cd test/studies/graph500/v2/
chpl --fast *.chpl -o $BIN/graph500v2-$TYPE
cd ../../../../

cd test/release/examples/benchmarks/ssca2
make clean
make "DO_PRINT_TIMING_STATISTICS=1"
cp SSCA2_main $BIN/SSCA2_main-$TYPE
cd ../../../../../

cd examples/programs
for i in quicksort tree; do
	chpl --fast $i.chpl -o $BIN/$i-$TYPE
done
cd ../../

cd test/release/examples/benchmarks/hpcc/
for i in stream stream-ep fft hpl ptrans ra ra-atomics; do
	chpl --fast $i.chpl -o $BIN/$i-$TYPE
done



### so it's actually a triple.
### I will script this eventually.


