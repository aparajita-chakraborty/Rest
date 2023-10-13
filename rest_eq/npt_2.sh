#!/bin/bash

source /dartfs-hpc/rc/home/0/f006f50/labhome/SINGULARITY_BUILDS/.gmx_container.bash

module purge
module load openmpi/4.1.1-gnu9.3.1
mpi_threads $1

now=`date +'%Y-%m-%d.%Hh-%Mm'`

nfsDIR=`pwd`

pid=$BASHPID

rundata=/data/${pid}

mkdir $rundata

echo "creating backup (${nsfDIR}) and the run folder (${rundata})"

for i in $(ls |grep -v setup | grep -v topol | grep -v gennewtop | grep -v partial)
do
#   cp -r $i backup.${now}/
   cp -r $i $rundata/
done

echo "Completed copy, now running simulation "

cd $rundata

pwd

sh rest_eq.sh -npt_2 10 #change your number of reps

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


