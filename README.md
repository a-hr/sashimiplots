# Batch sashimi plots

Basic script to get publication-ready sashimi plots using [ggsashimi](https://github.com/guigolab/ggsashimi).

In order to pull the Singularity image:
```bash
module load Singularity Go
singularity pull ggsashimi.sif docker://guigolab/ggsashimi
```

To run the script:

- Make sure you have the following files:
    - `*.bam` files
    - `*.gtf` file
    - `*.sif` singularity image
    - `config.tab` file containing EventIDs and Coordinates separated with tabs

- Run the script:
```bash
bash create_plots.sh -c config.tab
```