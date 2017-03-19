#!/bin/bash

PART="knl-alpha knl-bravo knl-charlie knl-delta knl-echo knl-foxtrot knl-golf"
STEP=`awk 'BEGIN { for(i=2**8; i<=2**33; i*=2) print i}'`
DIR=graph

if [[ ! -d $DIR ]]; then
    mkdir -p $DIR
fi
BIN=bin

# need to compile qthreads with a different scheduler

# I also need multiple runs for error bars.
# so what is the variation I'm seeing?
# and how do I justify it statistically?

# figure out how lulesh is run.
echo scheduler size partition type time
for j in $STEP; do
    echo $PART
    for k in $PART; do
        for prog in $BIN/*; do
            echo $i
            i=`echo $prog | sed 's/.*-//g'`
            ( srun --partition=$k bash -c "time -p $prog --n=$j" >/dev/null ) 2>&1 | awk '$0 != "" {print "'$i'","'$j'","'$k'",$0}' >$DIR/$prog-$j-$k.dat
            ( srun --partition=$k perf stat -r1 $prog --n=$j >/dev/null ) 2>&1 | awk '$0 != "" {print "'$i'","'$j'","'$k'",$0}' >dat/$prog-$j-$k.stat.dat
        done
    done
done
