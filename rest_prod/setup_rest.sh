#!/bin/bash

source /dartfs-hpc/rc/home/4/f0070r4/RobustelliP/SINGULARITY_BUILDS/.gmx_container.bash

#adjustable_params

# 20 replicas
nrep=20
# "effective" temperature range
tmin=300
tmax=500

now=`date +"%Y-%m-%d"`

exec 1>RUN_REST.${now}.log 2>&1

module load openmpi/4.1.1-gnu9.3.1 


# Set number of mpi threads
mpi_threads $nrep

# build geometric progression
list=$(
awk -v n=$nrep \
    -v tmin=$tmin \
    -v tmax=$tmax \
  'BEGIN{for(i=0;i<n;i++){
    t=tmin*exp((i)*log(tmax/tmin)/(n-1));
    printf(t); if(i<=n-1)printf(",");
  }
}'
)
echo $list
# clean directory
rm -fr \#*
rm -fr topol*

if [[ ! -f ./plumed.dat ]]
then
	touch plumed.dat
fi

if [[ ! -f ./ref.pdb ]]
then
	echo "missing ref.pdb exiting now!"
	exit 1
fi

for((i=0;i<nrep;i++))
do

rm -rf $i
if [[ ! -d ./${i}/ ]]
then
mkdir $i  
fi
cp plumed.dat ${i}/plumed.dat
cp ref.pdb ${i}/ref.pdb

# choose lambda as T[0]/T[i]
# remember that high temperature is equivalent to low lambda
  #echo $list
lambda=$(echo $list | awk 'BEGIN{FS=",";}{print $1/$'$((i))';}')
temp=$(echo $list | awk 'BEGIN{FS=",";}{print $(('$i'));}')
 
echo "$i $lambda $temp"
plumed partial_tempering $lambda < REST.top > $i/topol.top

# prepare tpr file
# -maxwarn is often needed because box could be charged

#gmx_gpu grompp -maxwarn 2 -c structure/${i}.new.gro -o $i/production.tpr -f prod.mdp -p ${i}/topol.top

done

wait 
