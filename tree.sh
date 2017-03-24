#!/bin/bash
SIZE=`awk 'BEGIN {for(i=2; i<15;i++) print i}'`
echo scheduler mem size real user sys
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i hbm $j" "; srun --partition=knl-alpha bash -c "TIMEFORMAT='%R %U %S'; time numactl -m1 bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; done; done 2>&1
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i ddr $j" "; srun --partition=knl-alpha bash -c "TIMEFORMAT='%R %U %S'; time numactl -m0 bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; done; done 2>&1
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i cache $j" "; srun --partition=knl-delta bash -c "TIMEFORMAT='%R %U %S'; time numactl bin/tree-$i --treeHeight=$j 2>&1 1>/dev/null" ; done; done 2>&1
