#!/bin/bash

source /dartfs-hpc/rc/home/4/f0070r4/RobustelliP/SINGULARITY_BUILDS/.gmx_container.bash

GMX=gmx_s

for(( i=1;i<=10;i++))
do
	cd $i
	printf "11 12 13 15 17 48 49 0\n" | $GMX energy -s npt_2.tpr -f npt_2.edr -o npt_2.energy1.xvg
	printf "19 22 23 24 25 0\n" | $GMX energy -s npt_2.tpr -f npt_2.edr -o npt_2.energy2.xvg

	cd ../

done

mkdir Pressure_analysis
