#!/bin/bash

echo scheduler mem size real user sys
SIZE=`awk 'BEGIN {for(i=2; i<2**9;i*=2) print i}'`
SCALE=14
for i in sherwood nemesis distrib; do for j in $SIZE; do echo -n $i hbm $j" "; srun --partition=knl-alpha bash -c "TIMEFORMAT='%R %U %S'; time numactl -m1 bin/SSCA2_main-$i --SCALE=$SCALE --TEST_TORUS_1D=true --TEST_TORUS_2D=true --TEST_TORUS_3D=true --TEST_TORUS_4D=true --dataParTasksPerLocale=$j 2>&1 1>/dev/null" ; done; done 2>&1
for i in sherwood nemesis distrib; do for j in $SIZE; do echo -n $i ddr $j" "; srun --partition=knl-alpha bash -c "TIMEFORMAT='%R %U %S'; time numactl -m0 bin/SSCA2_main-$i --SCALE=$SCALE --TEST_TORUS_1D=true --TEST_TORUS_2D=true --TEST_TORUS_3D=true --TEST_TORUS_4D=true --dataParTasksPerLocale=$j 2>&1 1>/dev/null" ; done; done 2>&1
for i in sherwood nemesis distrib; do for j in $SIZE; do echo -n $i cache $j" "; srun --partition=knl-delta bash -c "TIMEFORMAT='%R %U %S'; time numactl bin/SSCA2_main-$i --SCALE=$SCALE --TEST_TORUS_1D=true --TEST_TORUS_2D=true --TEST_TORUS_3D=true --TEST_TORUS_4D=true --dataParTasksPerLocale=$j 2>&1 1>/dev/null" ; done; done 2>&1
c
