# Batch sashimi plots

Basic script to get publication-ready sashimi plots using [ggsashimi](https://github.com/guigolab/ggsashimi).

- [Batch sashimi plots](#batch-sashimi-plots)
  - [Requirements](#requirements)
  - [Running the script](#running-the-script)
  - [Input files](#input-files)
  - [Run options](#run-options)

## Requirements

This script can either be run on a local machine or on a High Performance Computing (HPC) cluster. The following software is required:

- HPC cluster:
	- Singularity
	- Go

- Local machine:
  - Docker

In order to pull the Singularity image:
```bash
module load Singularity Go  # Load the modules if using HPC
singularity pull ggsashimi.sif docker://guigolab/ggsashimi
```

## Running the script

- Make sure you have the following files:
    - `*.bam` files	(sorted and indexed)
    - `*.gtf` file	(Ensembl GTF annotations to show isoforms)
    - `*.sif` singularity image (if running on HPC)
    - `config.tab` file containing EventIDs and Coordinates separated with tabs
    - `input_bams.tsv` file containing the list of bam files

- Run the script:
```bash
bash create_plots_local.sh -c config.tab  # Run the script as a local job
sbatch create_plots_cluster.sh -c config.tab  # Run the script as a batch job
```

## Input files

- The `config.tab` (tab-separated) file should have the following format:

```bash
EventName	chrN:start-end  # no header needed
PKM	chr15:72,199,867-72,207,724
```

- The `input_bams.tsv` (tab-separated, arbitrary name) file should have the following format:

```bash
unique_file_id	bam_file_path	group  # no header needed
sample1	/path/to/sample1.bam	WT
sample2	/path/to/sample2.bam	WT
sample3	/path/to/sample3.bam	KO
```

- The `*.gtf` can be any GTF file containing the exons of the gene of interest.

- BAM files should be sorted and indexed before running the script.

## Run options

The basic options are:

- `output_prefix` is the directory where the plots will be saved.
- `min_cov` is the minimum number of reads supporting a junction to be drawn.
- `agg` is the aggregate function for overlay. Defaults to `mean_j`.
- `alpha` is the transparency level for the density histogram.
- `bam_tsv` is the list of bam files.
- `gtf` is the GTF file with annotations.
- `palette` is the color palette file.

For further configuration, check the help message below and modify the script accordingly.

```plaintext
usage: ggsashimi.py [-h] -b BAM -c COORDINATES [-o OUT_PREFIX] [-S OUT_STRAND] [-M MIN_COVERAGE] [-j JUNCTIONS_BED] [-g GTF] [-s STRAND]
                    [--shrink] [-O OVERLAY] [-A AGGR] [-C COLOR_FACTOR] [--alpha ALPHA] [-P PALETTE] [-L LABELS] [--fix-y-scale]
                    [--height HEIGHT] [--ann-height ANN_HEIGHT] [--width WIDTH] [--base-size BASE_SIZE] [-F OUT_FORMAT] [-R OUT_RESOLUTION]
                    [--debug-info] [--version]

Create sashimi plot for a given genomic region

optional arguments:
  -h, --help            show this help message and exit
  -b BAM, --bam BAM     Individual bam file or file with a list of bam files. In the case of a list of files the format is tsv: 1col: id for bam
                        file, 2col: path of bam file, 3+col: additional columns
  -c COORDINATES, --coordinates COORDINATES
                        Genomic region. Format: chr:start-end. Remember that bam coordinates are 0-based
  -o OUT_PREFIX, --out-prefix OUT_PREFIX
                        Prefix for plot file name [default=sashimi]
  -S OUT_STRAND, --out-strand OUT_STRAND
                        Only for --strand other than 'NONE'. Choose which signal strand to plot: <both> <plus> <minus> [default=both]
  -M MIN_COVERAGE, --min-coverage MIN_COVERAGE
                        Minimum number of reads supporting a junction to be drawn [default=1]
  -j JUNCTIONS_BED, --junctions-bed JUNCTIONS_BED
                        Junction BED file name [default=no junction file]
  -g GTF, --gtf GTF     Gtf file with annotation (only exons is enough)
  -s STRAND, --strand STRAND
                        Strand specificity: <NONE> <SENSE> <ANTISENSE> <MATE1_SENSE> <MATE2_SENSE> [default=NONE]
  --shrink              Shrink the junctions by a factor for nicer display [default=False]
  -O OVERLAY, --overlay OVERLAY
                        Index of column with overlay levels (1-based)
  -A AGGR, --aggr AGGR  Aggregate function for overlay: <mean> <median> <mean_j> <median_j>. Use mean_j | median_j to keep density overlay but
                        aggregate junction counts [default=no aggregation]
  -C COLOR_FACTOR, --color-factor COLOR_FACTOR
                        Index of column with color levels (1-based)
  --alpha ALPHA         Transparency level for density histogram [default=0.5]
  -P PALETTE, --palette PALETTE
                        Color palette file. tsv file with >=1 columns, where the color is the first column. Both R color names and hexadecimal
                        values are valid
  -L LABELS, --labels LABELS
                        Index of column with labels (1-based) [default=1]
  --fix-y-scale         Fix y-scale across individual signal plots [default=False]
  --height HEIGHT       Height of the individual signal plot in inches [default=2]
  --ann-height ANN_HEIGHT
                        Height of annotation plot in inches [default=1.5]
  --width WIDTH         Width of the plot in inches [default=10]
  --base-size BASE_SIZE
                        Base font size of the plot in pch [default=14]
  -F OUT_FORMAT, --out-format OUT_FORMAT
                        Output file format: <pdf> <svg> <png> <jpeg> <tiff> [default=pdf]
  -R OUT_RESOLUTION, --out-resolution OUT_RESOLUTION
                        Output file resolution in PPI (pixels per inch). Applies only to raster output formats [default=300]
  --debug-info          Show several system information useful for debugging purposes [default=None]
  --version             show program's version number and exit
```