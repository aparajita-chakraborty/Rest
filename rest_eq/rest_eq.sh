#!/bin/bash
source /dartfs-hpc/rc/home/4/f0070r4/RobustelliP/SINGULARITY_BUILDS/.gmx_container.bash

#adjustable params
struct=h_open_md_rest
top=h_open
force_field=a99SBdisp.ff

nreps=$2

if [ $1 = '-setup' ] ; then

for((i=1;i<=${nreps};i++))

do

rm -rf $i
mkdir $i

cp -r $force_field $struct.gro $top.top $i


done

fi

#if [ $1 = '-make_gro' ] ; then

#gmx_s editconf -f $struct.pdb -o $struct.gro

#fi


if [ $1 = '-solv' ] ; then

for((i=1;i<=${nreps};i++)) ; do

cd $i

gmx_s editconf -f h_open_md_rest.gro -o ${i}.box.gro -c -bt cubic -box 8

gmx_s solvate -cp ${i}.box.gro -cs ../params/disp_water_inp.gro -o ${i}.solv.gro -p h_open.top

cd ../

done

tail */*.top

fi

if [ $1 = '-solv_2' ] ; then

for((i=1;i<=${nreps};i++)) ; do

cp h_open.top $i

cd $i

gmx_s editconf -f h_open_md_rest.gro -o ${i}.box.gro -c -bt cubic -box 8

gmx_s solvate -cp ${i}.box.gro -cs ../params/disp_water_inp.gro --maxsol 15493 -o ${i}.solv.gro -p h_open.top 

gmx_s grompp -f ../params/minimz.mdp -c ${i}.solv.gro -p h_open.top -o ${i}.ion.tpr -maxwarn 2
echo 13 | gmx_s genion -s ${i}.ion.tpr -o ${i}.ion.gro -p h_open.top -neutral

gmx_s grompp -f ../params/minimz.mdp -c ${i}.ion.gro -p h_open.top -o em.tpr -maxwarn 2

cd ../

done

module purge
module load openmpi/4.1.1-gnu9.3.1

mpi_threads ${nreps}
gmx_gpu_mpi mdrun -v -multidir {1..10} -deffnm em -s em.tpr

fi

if [ $1 = '-nvt' ] ; then

for((i=1;i<=${nreps};i++)) ; do

cp params/posre.itp $i

cd $i

gmx_s grompp -f ../params/NVT.mdp -c em.gro -r em.gro -p h_open.top -o nvt.tpr -maxwarn 2
cd ../

done

module purge
module load openmpi/4.1.1-gnu9.3.1

mpi_threads ${nreps}
gmx_gpu_mpi mdrun -v -multidir {1..10} -deffnm nvt -s nvt.tpr -nb gpu -bonded gpu -pme gpu -pmefft gpu -pin on -pinstride 0 -pinoffset 0

fi


if [ $1 = '-npt_0' ] ; then

for((i=1;i<=${nreps};i++)) ; do

cd $i

gmx_s grompp -f ../params/NPT0.mdp -c nvt.gro -r em.gro -p h_open.top -o npt_0.tpr -maxwarn 2
cd ../

done

module purge
module load openmpi/4.1.1-gnu9.3.1

mpi_threads ${nreps}
gmx_gpu_mpi mdrun -v -multidir {1..10} -deffnm npt_0 -s npt_0.tpr -nb gpu -bonded gpu -pme gpu -pmefft gpu -pin on -pinstride 0 -pinoffset 0

fi

if [ $1 = '-npt_1' ] ; then

for((i=1;i<=${nreps};i++)) ; do

cd $i

gmx_s grompp -f ../params/NPT1.mdp -c npt_0.gro -r em.gro -p h_open.top -o npt_1.tpr -maxwarn 2
cd ../

done

module purge
module load openmpi/4.1.1-gnu9.3.1

mpi_threads ${nreps}
gmx_gpu_mpi mdrun -v -multidir {1..10} -deffnm npt_1 -s npt_1.tpr -nb gpu -bonded gpu -pme gpu -pmefft gpu -pin on -pinstride 0 -pinoffset 0

fi

if [ $1 = '-npt_2' ] ; then

for((i=1;i<=${nreps};i++)) ; do

cd $i

gmx_s grompp -f ../params/NPT2.mdp -c npt_1.gro -r em.gro -p h_open.top -o npt_2.tpr -maxwarn 2
cd ../

done

module purge
module load openmpi/4.1.1-gnu9.3.1

mpi_threads ${nreps}
gmx_gpu_mpi mdrun -v -multidir {1..10} -deffnm npt_2 -s npt_2.tpr -nb gpu -bonded gpu -pme gpu -pmefft gpu -pin on -pinstride 0 -pinoffset 0

fi

