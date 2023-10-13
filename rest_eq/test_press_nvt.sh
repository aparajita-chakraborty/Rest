source /dartfs-hpc/rc/home/4/f0070r4/RobustelliP/SINGULARITY_BUILDS/.gmx_container.bash

#adjustable_params
top=h_open
rest_file_name=rest_open
num_reps=20

module purge
module load openmpi/4.1.1-gnu9.3.1

mpi_threads ${num_reps}

#krenew -aK60 -vL -b
echo I AM RUNNING, BOSDIKE
for i in {1..10}
do
	gmx_s grompp -f params/test_press.mdp -c /dartfs-hpc/rc/lab/R/RobustelliP/Apara/hnrnp_h/rest/open/${i}.${rest_file_name}.gro -p ${i}/${top}.top -o ${i}/test_press.tpr 
done

gmx_gpu_mpi mdrun -deffnm test_press -multidir {1..10} -v -dlb no -s test_press.tpr &> log_test_press.txt &

#gmx_gpu_mpi mdrun -s prod.tpr -deffnm prod -multidir {0..19} -plumed ./plumed.dat -replex 800 -hrex -dlb no -pin on -nb gpu -pme gpu -pmefft gpu -bonded gpu -tunepme no -v -pinoffset 0 -pinstride 0
