#!/bin/bash

echo scheduler mem size real user sys
SIZE=`awk 'BEGIN {for(i=2; i<15;i++) print i}'`
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i hbm $j" "; srun --partition=knl-alpha bash -c "TIMEFORMAT='%R %U %S'; time numactl -m1 bin/graph500v2-$i --SCALE=$j 2>&1 1>/dev/null" ; done; done 2>&1
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i ddr $j" "; srun --partition=knl-alpha bash -c "TIMEFORMAT='%R %U %S'; time numactl -m0 bin/graph500v2-$i --SCALE=$j 2>&1 1>/dev/null" ; done; done 2>&1
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i cache $j" "; srun --partition=knl-delta bash -c "TIMEFORMAT='%R %U %S'; time numactl bin/graph500v2-$i --SCALE=$j 2>&1 1>/dev/null" ; done; done 2>&1
