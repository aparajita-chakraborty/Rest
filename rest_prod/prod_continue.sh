#!/bin/bash

source .gmx_container.bash

module purge
module load openmpi/4.1.1-gnu9.3.1
mpi_threads 20

now=`date +'%Y-%m-%d.%Hh-%Mm'`

nfsDIR=`pwd`

pid=$BASHPID

rundata=/data/${pid}

mkdir $rundata

echo "creating backup (${nsfDIR}) and the run folder (${rundata})"

for i in $(ls | grep -v 'gmx_container.bash' |grep -v run.20 | grep -v setup | grep -v topol | grep -v gennewtop | grep -v partial)
do
#   cp -r $i backup.${now}/
   cp -r $i $rundata/
done

echo "Completed copy, now running simulation "

cd $rundata

pwd

gmx_gpu_mpi mdrun -s prod.tpr -cpi prod.cpt -append -nstlist 200 -deffnm prod -multidir {0..19} -plumed ./plumed.dat -replex 800 -hrex -dlb no -pin on -ntomp 2 -nb gpu -pme gpu -pmefft gpu -bonded gpu -tunepme no -v 

echo ""

echo "Finished simulation"

echo "making nsf folder ${nfsDIR}/run.${now}"

mkdir ${nfsDIR}/run.${now}/

echo "Syncing data from run folder to nfs"

rsync -avx ./* ${nfsDIR}/run.${now}/

cd $nfsDIR

echo "Cleaing up ${rundata}"

#rm -rf $rundata

echo "Done!"

