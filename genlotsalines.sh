#!/bin/bash

rm -f lotsalines
for i in `seq 1 1000000`
do 
    echo "Line $i" >> lotsalines
done
