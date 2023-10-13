#!/bin/bash/
source /dartfs-hpc/rc/home/4/f0070r4/RobustelliP/SINGULARITY_BUILDS/.gmx_container.bash


#adjustable_params
struct=structure
rest_struct_name=rest
struct_1=open
struct_2=closed
rest_struct_name_1=rest_open
rest_struct_name_2=rest_close


if [ $1 == '-rest1' ] ; then

cd ${struct}

a=1
for i in {0..19..1} ; do

	cp ${a}.${rest_struct_name}.gro ../$i/${i}.gro

	let "a+=1"
done	
cd ../

fi


if [ $1 == '-rest2' ] ; then

cd ${struct_1}

a=1
for i in {0..19..2} ; do

	cp ${a}.${rest_struct_name_1}.gro ../$i/${i}.gro

	let "a+=1"
done	
cd ../

cd ${struct_2}

a=1
for i in {1..19..2} ; do

        cp ${a}.${rest_struct_name_2}.gro ../$i/${i}.gro

        let "a+=1"
done
cd ../

fi


if [ $1 == '-rest_tpr' ] ; then
	nreps=$2

	for ((i=0; i<$nreps; i++)); do
		cd $i
		gmx_s grompp -f ../production.mdp -c $i.gro -r $i.gro -p topol.top -o prod.tpr -maxwarn 2
		cd ../
	done
fi
