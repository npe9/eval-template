#!/bin/bash
SIZE=`awk 'BEGIN {for(i=12; i<18;i++) print 2**i}'`
THRESH=`awk 'BEGIN {print 2**32}'`
echo scheduler mem size real user sys 
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i hbm $j" "; srun --partition=knl-alpha bash -c "TIMEFORMAT='%R %U %S'; time numactl -m1 bin/quicksort-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null" ; done; done 2>&1
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i ddr $j" "; srun --partition=knl-alpha bash -c "TIMEFORMAT='%R %U %S'; time numactl -m0 bin/quicksort-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null" ; done; done 2>&1
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i cache $j" "; srun --partition=knl-delta bash -c "TIMEFORMAT='%R %U %S'; time numactl bin/quicksort-$i --n=$j --thresh=$THRESH 2>&1 1>/dev/null" ; done; done 2>&1
