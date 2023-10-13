#!/bin/bash
source /dartfs-hpc/rc/home/4/f0070r4/RobustelliP/SINGULARITY_BUILDS/.gmx_container.bash

#adjustable params

box_size=8.8872
path_to_rest_directory=/dartfs-hpc/rc/lab/R/RobustelliP/Apara/hnrnp_h/rest/open/
rest_file_name=rest_open

nreps=$2

if [ $1 = '-gen_box' ] ; then

for((i=1;i<=${nreps};i++))

do

cd $i

gmx_s editconf -f npt_2.gro -o ${i}.${rest_file_name}.gro -c -bt cubic -box ${box_size}

cd ../

done

fi


if [ $1 = '-copy' ] ; then

for((i=1;i<=${nreps};i++))

do

cd $i

cp ${i}.${rest_file_name}.gro ${path_to_rest_directory}

cd ../

done

fi


