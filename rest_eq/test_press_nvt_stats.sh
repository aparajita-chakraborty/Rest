#!/bin/bash

source /dartfs-hpc/rc/home/4/f0070r4/RobustelliP/SINGULARITY_BUILDS/.gmx_container.bash

GMX=gmx_s

for(( i=1;i<=10;i++))
do
        cd $i
        printf "11 12 13 15 17 0\n" | $GMX energy -s test_press.tpr -f test_press.edr -o test_press.energy1.xvg>test_press1.log
        printf "19 22 23 24 25 0\n" | $GMX energy -s test_press.tpr -f test_press.edr -o test_press.energy2.xvg>test_press2.log

        cd ../

done

mkdir Pressure_analysis_nvt

tail */test_press1.log
