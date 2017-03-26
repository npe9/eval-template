#!/bin/bash
SIZE=`awk 'BEGIN {for(i=1; i<2**8;i*=2) print i}'`
UPDATES=`awk 'BEGIN {print 2**21}'`
echo scheduler mem size gups
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i hbm $j; srun --partition=knl-alpha sh -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl -m1 bin/ra-$i --n=16 --N_U=$UPDATES" 2>/dev/null | grep GUPS | sed 's/.*=//g'; done; done
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i ddr $j; srun --partition=knl-delta sh -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl -m0 bin/ra-$i --n=16 --N_U=$UPDATES" 2>/dev/null | grep GUPS | sed 's/.*=//g'; done; done
for i in mutexfifo nemesis distrib; do for j in $SIZE; do echo -n $i cache $j; srun --partition=knl-delta sh -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl bin/ra-$i --n=16 --N_U=$UPDATES" 2>/dev/null | grep GUPS | sed 's/.*=//g'; done; done
