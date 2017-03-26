#!/bin/bash
# this should really be a Makefile
SIZE=`awk 'BEGIN {for(i=2; i<15;i++) print i}'`
echo scheduler mem size real user sys
for i in sherwood nemesis distrib; do for j in $SIZE; do echo -n $i hbm $j" "; srun --partition=knl-alpha bash -c "numactl -m1 perf record -F 99 -a -g -o perf/$i-hbm-$j.dat -- bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; srun perf script -i ../ross-paper/perf/$i-hbm-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $i-hbm-$j.perf-folded; ../FlameGraph/flamegraph.pl $i-hbm-$j.perf-folded > $i-ddr-$j.svg; done; done 2>&1
for i in sherwood nemesis distrib; do for j in $SIZE; do echo -n $i ddr $j" "; srun --partition=knl-alpha bash -c "numactl -m0 perf record -F 99 -a -g -o perf/$i-ddr-$j.dat -- bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; srun perf script -i ../ross-paper/perf/$i-ddr-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $i-ddr-$j.perf-folded; ../FlameGraph/flamegraph.pl $i-ddr-$j.perf-folded > $i-ddr-$j.svg; done; done 2>&1
for i in sherwood nemesis distrib; do for j in $SIZE; do echo -n $i cache $j" "; srun --partition=knl-delta bash -c "numactl perf record -F 99 -a -g -o perf/$i-cache-$j.dat -- bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; srun perf script -i ../ross-paper/perf/$i-cache-$j.dat | ../FlameGraph/stackcollapse-perf.pl > $i-cache-$j.perf-folded; ../FlameGraph/flamegraph.pl $i-cache-$j.perf-folded > $i-cache-$j.svg; done; done 2>&1

