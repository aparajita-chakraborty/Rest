#!/bin/bash/

grep "Repl pr" 0/prod.log
#off by factor of 2 - not splitting exchanges
n=`grep "Repl ex" 0/prod.log | wc -l`
echo $n
for i in {0..8}
do 
j=$[$i+1]
echo "$i x  $j"
a=`grep "Repl ex" $i/prod.log | grep "$i x  $j" | wc -l`
echo $a $n > ex
awk '{print($1,$2/2,$1/$2*2)}' ex > accep_ratio_1.log
done

for i in {9..14}
do
j=$[$i+1]
echo "$i x $j"
#grep "Repl ex" $i/prod.log | wc -l
#grep "Repl ex" $i/prod.log | grep "$i x  $j" | wc -l 
a=`grep "Repl ex" $i/prod.log | grep "$i x $j" | wc -l`
echo $a $n > ex
awk '{print($1,$2/2,$1/$2*2)}' ex >accep_ratio_2.log
done

for i in {15..18}
do
    j=$[$i+1]
    echo "$i x $j"
    #grep "Repl ex" $i/prod.log | wc -l
    #grep "Repl ex" $i/prod.log | grep "$i x  $j" | wc -l 
    a=`grep "Repl ex" $i/prod.log | grep "$i x $j" | wc -l`
    echo $a $n > ex
    awk '{print($1,$2/2,$1/$2*2)}' ex >accep_ratio_3.log
done
