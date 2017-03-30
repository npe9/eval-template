#!/bin/bash
SIZE=`awk 'BEGIN {for(i=12; i<18;i++) print 2**i}'`
THRESH=`awk 'BEGIN {print 2**32}'`
PROG=quicksort
MEM=hbm
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m1  perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat --  bin/$PROG-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null" ; perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
MEM=ddr
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m0   perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat bin/PROG-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null" ; perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
MEM=cache
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-delta bash -c "numactl perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat bin/$PROG-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null"; srun perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$PROG-$i-hbm-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1

