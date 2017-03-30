#!/bin/bash
SIZE=`awk 'BEGIN {for(i=1; i<2**11;i*=2) print i}'`
PROBSIZE=`awk 'BEGIN {print 2**24}'`
PROG=stream
MEM=hbm
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl -m0 perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat bin/$PROG-$i --m=$PROBSIZE 2>&1 1>/dev/null" ; pwd; perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl >folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
MEM=ddr
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j; numactl -m1   perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat bin/$PROG-$i --m=$PROBSIZE 2>&1 1>/dev/null" ; perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl >folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
MEM=cache
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-delta bash -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl perf record -F 99 -a -g -o perf/$PROG-$i-$MEM-$j.dat bin/$PROG-$i --m=$PROBSIZE 2>&1 1>/dev/null" ; perf script -i perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl >folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
