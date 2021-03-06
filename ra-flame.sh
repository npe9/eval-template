#!/bin/bash
SIZE=`awk 'BEGIN {for(i=1; i<2**8;i*=2) print i}'`
UPDATES=`awk 'BEGIN {print 2**21}'`
PROG=ra
MEM=hbm
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m0   perf record -F 99 -a -g -o perf/$PROG-$i-hbm-$j.dat CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl -m1 bin/$PROG-$i --n=16 --N_U=$UPDATES 2>&1 1>/dev/null" ; perf script -i ../ross-paper/perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl >folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
MEM=ddr
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m1   perf record -F 99 -a -g -o perf/$PROG-$i-hbm-$j.dat CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl -m1 bin/$PROG-$i --n=16 --N_U=$UPDATES 2>&1 1>/dev/null" ; perf script -i ../ross-paper/perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl >folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
MEM=cache
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-delta bash -c "numactl -m0   perf record -F 99 -a -g -o perf/$PROG-$i-hbm-$j.dat CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl -m1 bin/$PROG-$i --n=16 --N_U=$UPDATES 2>&1 1>/dev/null" ; perf script -i ../ross-paper/perf/$PROG-$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl >folded/$PROG-$i-$MEM-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-$MEM-$j.perf-folded > svg/$PROG-$i-$MEM-$j.svg; done; done 2>&1
