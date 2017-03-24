#!/bin/bash
NTASKS=`awk 'BEGIN {for(i=1; i<=2**8;i*=2) print i}'`
PROBSIZE=`awk 'BEGIN {print 2**19}'`
echo scheduler mem size gbs
for i in mutexfifo nemesis distrib; do for j in $NTASKS; do echo -n $i hbm $j; srun --partition=knl-alpha sh -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl -m1 bin/stream-ep-$i --m=$PROBSIZE" 2>/dev/null | grep 'avg' | grep -v seconds | sed 's/.*=//g'; done; done
for i in mutexfifo nemesis distrib; do for j in $NTASKS; do echo -n $i ddr $j; srun --partition=knl-alpha sh -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl -m0 bin/stream-ep-$i --m=$PROBSIZE" 2>/dev/null | grep 'avg' | grep -v seconds | sed 's/.*=//g'; done; done
for i in mutexfifo nemesis distrib; do for j in $NTASKS; do echo -n $i cache $j; srun --partition=knl-delta sh -c "CHPL_RT_NUM_THREADS_PER_LOCALE=$j numactl bin/stream-ep-$i --m=$PROBSIZE" 2>/dev/null | grep 'avg' | grep -v seconds | sed 's/.*=//g'; done; done
