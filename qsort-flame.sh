#!/bin/bash
SIZE=`awk 'BEGIN {for(i=12; i<18;i++) print 2**i}'`
THRESH=`awk 'BEGIN {print 2**32}'`
PROG=quicksort
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m1  perf record -F 99 -a -g -o perf/$PROG-$i-hbm-$j.dat --  bin/$PROG-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null" ; perf script -i ../ross-paper/perf/$PROG-$i-hbm-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $PROG-$i-hbm-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-hbm-$j.perf-folded > $PROG-$i-hbm-$j.svg; done; done 2>&1
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m0   perf record -F 99 -a -g -o perf/$PROG-$i-ddr-$j.dat bin/PROG-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null" ; perf script -i ../ross-paper/perf/$PROG-$i-ddr-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $PROG-$i-ddr-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-ddr-$j.perf-folded > $PROG-$i-ddr-$j.svg; done; done 2>&1
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-delta bash -c "numactl bin/$PROG-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null"; srun perf script -i ../ross-paper/perf/$PROG-$i-cache-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $PROG-$i-cache-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-hbm-$j.perf-folded > $PROG-$i-cache-$j.svg; done; done 2>&1
