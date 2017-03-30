#!/bin/bash
# this should really be a Makefile
SIZE=`awk 'BEGIN {for(i=2; i<15;i++) print i}'`
MEM=hbm
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m1 perf record -F 99 -a -g -o perf/$i-$MEM-$j.dat -- bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; srun perf script -i perf/$i-$MEM-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$i-hbm-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$i-hbm-$j.perf-folded > svg/$i-ddr-$j.svg; done; done 2>&1
MEM=ddr
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-alpha bash -c "numactl -m0 perf record -F 99 -a -g -o perf/$i-ddr-$j.dat -- bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; srun perf script -i perf/$i-ddr-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$i-ddr-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$i-ddr-$j.perf-folded > svg/$i-ddr-$j.svg; done; done 2>&1
MEM=cache
for i in sherwood nemesis distrib; do for j in $SIZE; do srun --partition=knl-delta bash -c "numactl perf record -F 99 -a -g -o perf/$i-cache-$j.dat -- bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; srun perf script -i perf/$i-cache-$j.dat | ../FlameGraph/stackcollapse-perf.pl > folded/$i-cache-$j.perf-folded; ../FlameGraph/flamegraph.pl folded/$i-cache-$j.perf-folded > svg/$i-cache-$j.svg; done; done 2>&1

