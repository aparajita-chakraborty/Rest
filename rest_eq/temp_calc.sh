#!/bin/bash
# 16 replicas
nrep=20
# "effective" temperature range
tmin=300
tmax=500

# build geometric progression
list=$(
awk -v n=$nrep \
    -v tmin=$tmin \
    -v tmax=$tmax \
  'BEGIN{for(i=0;i<n;i++){
    t=tmin*exp(i*log(tmax/tmin)/(n-1));
    printf(t); if(i<n-1)printf(",");
  }
}'
)

#echo $list
# clean directory
for((i=0;i<nrep;i++))

# choose lambda as T[0]/T[i]
# remember that high temperature is equivalent to low lambda
  #echo $list
do
lambda=$(echo $list | awk 'BEGIN{FS=",";}{print $1/$'$((i+1))';}')
temp=$(echo $list | awk 'BEGIN{FS=",";}{print $(('$i'+1));}')


echo "$i $lambda $temp"

done













