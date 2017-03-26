#!/bin/bash

echo scheduler mem size real user sys
SIZE=`awk 'BEGIN {for(i=2; i<2**9;i*=2) print i}'`
SCALE=14
PROG=SSCA2
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m1 perf record -F 99 -a -g -o perf/$PROG-$i-hbm-$j.dat -- bin/SSCA2_main-$i --SCALE=$SCALE --TEST_TORUS_1D=true --TEST_TORUS_2D=true --TEST_TORUS_3D=true --TEST_TORUS_4D=true --dataParTasksPerLocale=$j 2>&1 1>/dev/null" ; srun perf script -i ../ross-paper/perf/$PROG-$i-hbm-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $PROG-$i-hbm-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-hbm-$j.perf-folded > $PROG-$i-ddr-$j.svg; done; done 2>&1
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m0  perf record -F 99 -a -g -o perf/$PROG-$i-hbm-$j.dat --  bin/SSCA2_main-$i --SCALE=$SCALE --TEST_TORUS_1D=true --TEST_TORUS_2D=true --TEST_TORUS_3D=true --TEST_TORUS_4D=true --dataParTasksPerLocale=$j 2>&1 1>/dev/null" ; srun perf script -i ../ross-paper/perf/$PROG-$i-hbm-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $PROG-$i-hbm-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-hbm-$j.perf-folded > $PROG-$i-ddr-$j.svg; done; done 2>&1
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-delta bash -c "numactl  perf record -F 99 -a -g -o perf/$PROG-$i-hbm-$j.dat -- bin/SSCA2_main-$i --SCALE=$SCALE --TEST_TORUS_1D=true --TEST_TORUS_2D=true --TEST_TORUS_3D=true --TEST_TORUS_4D=true --dataParTasksPerLocale=$j 2>&1 1>/dev/null" ; srun perf script -i ../ross-paper/perf/$PROG-$i-hbm-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $PROG-$i-hbm-$j.perf-folded; ../FlameGraph/flamegraph.pl $PROG-$i-hbm-$j.perf-folded > $PROG-$i-ddr-$j.svg; done; done 2>&1
