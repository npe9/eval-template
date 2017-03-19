#!/bin/bash

TYPE=$1
BIN=~/src/ross-paper/bin

source util/setchplenv.bash >/dev/null 2>&1
cd examples/programs
chpl --fast quicksort.chpl -o $BIN/quicksort-$TYPE
cd ../../
cd test/release/examples/benchmarks/hpcc/
for i in stream stream-ep fft hpl ptrans ra-atomics; do
	chpl --fast $i.chpl -o $BIN/$i-$TYPE
done
cd ../../../../../
cd test/studies/hpcc/STREAMS/waynew/
chpl --fast stream.chpl -o $BIN/stream-$TYPE
cd ../../../../../
### need to find random access
cd examples/benchmarks/hpcc/
chpl --fast ra.chpl -o $BIN/ra-$TYPE
cd ../../../

### so it's actually a triple.
### I will script this eventually.


