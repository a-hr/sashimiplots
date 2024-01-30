#!/usr/bin/env bash

# plot options
bam_tsv=input_bams.tsv
min_cov=3
gtf=gencode.v41.primary_assembly.annotation.gtf
palette=palette.txt
output_prefix=plots/
agg=mean_j

mkdir -p $output_prefix

# fetch config data from -c flag
while getopts c: option
do
    case $option in
        c) 
            config=${OPTARG}
            ;;
    esac
done

# loop over all the columns of the config file and extract first two columns
module load Singularity

while read -r eventID coords
do  
    echo "Plotting $eventID..."
    singularity exec -B /scratch:/scratch ggsashimi.sif \
        /ggsashimi.py \
        -b $bam_tsv \
        -c $coords \
        -g $gtf \
        -P $palette \
        -o ${output_prefix}sashimi_$eventID \
        -M $min_cov \
        -C 3 \
        -O 3 \
        -A $agg \
        --alpha .6 \
        --fix-y-scale \
        --ann-height 5 \
        --width 15
done < $config
