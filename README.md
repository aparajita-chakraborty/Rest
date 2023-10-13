###REST Protocol

There are two parts to this:
=>Equilibrating all the replica
=>Running actual REST


Equilibrating all the replica:

=>Folder organisation:
Feel free to customise this but the path to files is going to depend on this, please change the scripts accordingly. 

rest/rest_eq/params/*.mdp
rest/rest_eq/(we will have all the run folders and files here)


=>Start with copying your structure file, preferably .gro, if not un-hash, rest_eq.sh -make_gro

=>Run rest_eq.sh for all the flags, apart from the flag npt_2, run command: sh rest_eq.sh -flag nreps

=>Runnpt_2.sh, check the number of reps. Run command: sh npt_2.sh

=>After npt equilibration, you should check the pressure and the box size, we are also going to check temperature, energy, etc. Run npt_stats.sh, followed by npt_stats.py 

Run command: sh npt_stats.sh 
python npt_stats.py -eqnpt starting_replica_number end_replica_number replica_interval(1, if you want to analyse each reps)

=>You should end up with a folder called Pressure_analysis with a bunch of .tiff files. Open and check them with eog filename.tiff (make sure you'd logged into the cluster with ssh -X userid@discovery)

=>We wanna check the box size, with box_size.py, 
run command: box_size.py >box_size.log
This should give you two box sizes, check that they are not very different and take average of the two as your box size for REST.

=>Generate rest starting structures with the box size calculated in the above step (check for adjustable params in the script before running the script). Run command: sh gen_rest_struct.sh -setup -gen_box 

=>Now there is one last step before we start prepping for REST production run. We are going to check that the pressure for all the reps are still stable after we have adjusted the box size. 
Run command: sh test_press_nvt.sh
After the run has finished, we want to check for the pressure etc. 
Run command: sh test_press_nvt_stats.sh 
It should print out the average pressure etc. For each of the reps on your terminal window. We are looking for not having too much variation in the average pressure. 
Also run python test_press_nvt.py (ignore the error). You should have similar plots to what we had after npt_2, in a folder called Pressure_analysis_nvt.
If the pressure looks good we are fine, otherwise, we have to adjust the box size minutely (to the 3rd, 4th decimal point) and repeat the steps again until the pressure looks stable in the adjusted box size. 

=> To copy the finally adjusted starting structures, 
Run command: sh gen_rest_struct.sh -setup -copy


REST Production run:

=>Folder management:

rest/rest_prod/structure
rest/rest_prod/(we will have all the run folders and files here)

=>gen_rest_struct.sh will have already copied all the starting structures to the 'structure' folder. We need to copy three more things in this folder production.mdp, a .gro file with just protein in it and a topology file with same topology of the rest starting structures. 


=>We are going to run three steps manually here, 

Run command: gmx grompp -f production.mdp -c structure/name.gro -pp processed.top -p topol.top

Run command: Vi processed.top (search and locate the line number for atoms of the protein)

Run command: awk '{n++; if(n>starting_line) if(n<ending_line) if(NF>7) if($1+0==$1){$2=$2"_"}; print;}' processed.top > REST.top

=>After we have created REST.top we are going to run command: sh setup_rest.sh (look for adjustable_params)

=>After this we are going to copy the starting the structures from the structure folder into respective folders. I am dealing with a system where I have two kinds of starting structures and I want to alternate between them, for a situation like this 
Run command: sh copy_struct.sh -rest2
For a general situation 
Run command: sh copy_struct.sh -rest1

=>Generate .tpr for the production run, 
Run command: sh copy_struct.sh -rest_tpr

=>Finally to run the production run:

Run command: krenew -aK 60 -vL -b # This will stop the cluster from kicking your jobs out

Your renew might fail. In that case, run:

kdestroy -A
pkill -15 krenew

log out of the node
log out of discovery

login
login

krenew -aK 60 -vL -b


After this, run:

nohup ./prod.sh > nohup_prod.log 2>&1 &

This should create a nohup_prod.log file that you can check your job status at, also top/htop to see the jobs are actually running. 

=>While the jobs re running we have to make sure of one thing, the acceptance ratios are acceptable and how the performance is, for the performance, we can just look at the nohup_prod.log file for calculatingg acceptance ratio, we are going to use the script Acceptance_Ratio.sh

We can just run the script Acceptance_Ratio.sh everyday or every couple of hours or we can schedule a cronjob to do it. To set up a cronjob:

crontab -e

Put the line: @daily /path/to/your/Acceptance_Ratio.sh
