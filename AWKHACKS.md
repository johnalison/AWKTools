
# Grep
cat log_runAddFvTToScratchOneOffset|awk '/Aver/'
awk '/rchi2/ || /Training/ || /Vali/ {print $0}' ZZ4b/nTupleAnalysis/pytorchModels/3bDvTMix4bDvT.v0.nf12FvT_HCR+attention_12_np2076_lr0.01_epochs20_offset0.log 

# Grep with watch
watch "awk '/Training/ || /Vali/ {print \$0}'" ZZ4b/nTupleAnalysis/pytorchModels/3bDvTMix4bDvT.v1.nf12FvT_HCR+attention_12_np2076_lr0.01_epochs20_offset0.log 

#
As an aside, it's easy to test your understanding of regular expressions interactively: the program
$1 ~ $2
lets you type in a string and a regular expression; it echoes the line back if the string matches the regular expression.


# Display a block of text with AWK
awk ‘/start_pattern/,/stop_pattern/’ file.txt

eg: 
cat log_runAddFvTToScratchOneOffset|awk '/Aver/,/.pkl/'


# replace

ls |awk '/Extended/ {printf("mv %s ",$0); gsub("Extended","",$0); print $0}'


# System within AWK
ls /home/scratch/jalison//closureTests/ULTrig/*/*nf8* | awk  '{ s=$0; gsub("nf8.h5","nf8_offset0.h5"); d=$0; system(" mv "s" "d)  } '


# Graph
printf "width 100\n height 30 \n label x-axis  " | cat trafficDeathsTEST - |awk  -f graph.awk 