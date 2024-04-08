#!/usr/bin/env bash

# plot options
output_prefix=plots/
min_cov=3
agg=mean_j
alpha=0.6

bam_tsv=input_bams.tsv
gtf=gencode.v41.primary_assembly.annotation.gtf
palette=palette.txt

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

module load Singularity

# loop over all the columns of the config file and extract first two columns
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
        --alpha $alpha \
        --fix-y-scale \
        --ann-height 5 \
        --width 15
done < $config
