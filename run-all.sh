#!/bin/bash

for i in tree qsort stream ra SSCA2 graph500; do
	./$i.sh >dat/$i.dat
done

