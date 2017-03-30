#!/bin/bash

SIZE=`awk 'BEGIN {for(i=2; i<19;i++) print i}'`
PROG=graph500v2
MEM=hbm
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m1 perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat -- bin/$PROG-$i --SCALE=$j 2>&1 1>/dev/null" ; srun perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
MEM=ddr
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m0 perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat -- bin/$PROG-$i --SCALE=$j 2>&1 1>/dev/null" ; srun perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
MEM=cache
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-delta bash -c "numactl perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat -- bin/$PROG-$i --SCALE=$j  2>&1 1>/dev/null" ; srun perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
