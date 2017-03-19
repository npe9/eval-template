#!/bin/bash

PAPER=ross-qthreads
PART=knl-alpha knl-bravo knl-charlie knl-delta knl-echo knl-foxtrot knl-golf
STEP=`awk 'BEGIN { for(i=2**8; i<=2**33; i*=2) print i}'`
DIRS=chapel-mutexfifo chapel-sherwood chapel-nemesis chapel-distrib
DIR=$HOME/src/$PAPER/graph

if [[ ! -d $DIR ]]; then
    mkdir -p $DIR
fi
BIN=$HOME/src/$PAPER/bin
if [[ ! -d $BIN]]; then
    mkdir -p $BIN
fi

# need to compile qthreads with a different scheduler

# I also need multiple runs for error bars.
# so what is the variation I'm seeing?
# and how do I justify it statistically?

# figure out how lulesh is run.
echo scheduler size partition type time
for i in $DIRS; do
    cd $i
    source util/setchplenv.bash >/dev/null 2>&1
    # need to build the programs
    #source build-progs.sh
        # need to background these.
    for j in $STEP; do
        for k in $PART; do
            for prog in $BIN/*; do
                ( srun --partition=$k bash -c "time -p $prog --n=$j" >/dev/null ) 2>&1 | awk '$0 != "" {print "'$i'","'$j'","'$k'",$0}' >$DIR/$i-$j-$k-$l.dat
                ( srun --partition=$k perf stat $prog --n=$j >/dev/null ) 2>&1 | awk '$0 != "" {print "'$i'","'$j'","'$k'",$0}' >dat/$i-$j-$k-$l.stat.dat
        done
    done
    cd ..
done
