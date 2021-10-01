# Sequencing Data Demultiplexing

Demultiplex reads using barcode information so that each read header is annotated with its location on a 384-well plate

## Inputs

- Barcode file (.txt)
- Paired end sequencing files, forward and reverse (fastq.gz)
- Optional: barcode length (default: <inferred>)
- Optional: prefix for log file (default: <derived from sequencing file names>)
- Optional: Number of mismatches allowed (default 0)

## Outputs

- A directory containing _n_ fastq files, one for each well in sample

## Usage

Tools are all located on NAS, `BradyLabComputerResources/Bioinformatics/Tools/`

This script automatically activates the necessary conda environment.

```bash
# Supply all parameters
amplicon_analysis/demux_wrapper/demultiplex.sh -f forward.fastq.gz -r reverse.fastq.gz -b barcode_file.txt -o log_file -l barcode_length -m max_mismatches -d fastqs_AD

# Only supply the read files and barcodes
amplicon_analysis/demux_wrapper/demultiplex.sh -f forward.fastq.gz -r reverse.fastq.gz -b barcode_file.txt
```

## Next steps

Downstream workflow usually involves dereplicating then clustering at 95% (for OTU-based analyses), eg

```bash
demux_dir=fastqs_AD
jobs=10
mkdir derep_AD clustered95_AD
# Dereplicate. Change to .fq.gz if you compressed the files first
parallel -j $jobs --bar 'vsearch --threads 30 --derep_fulllength {} --strand plus --output derep_AD/$(basename {/.} .fq)_derep.fna --sizeout --fasta_width 0' ::: "$demux_dir"/*_F.fq
# 1. Per well clustering:
parallel -j $jobs --bar 'vsearch --threads 10 --cluster_size {} --id 0.95 --iddef 1 --sizein  --sizeout --otutab clustered95_AD/{/.}_otutab.tsv --centroids clustered95_AD/{/.}_clustered95.fna --uc clustered95_AD/{/.}_clustered95.uc' ::: derep_AD/*_F_derep.fna
# Across all wells clustering (time intensive)
cat derep_AD/*derep.fna > derep_AD/all_derep_F.fna
vsearch --threads 60  --sortbylength derep_AD/all_derep_F.fna  --output derep_AD/all_derep_sorted_F.fna
vsearch  --threads 60 --cluster_size derep_AD/all_derep_sorted_F.fna  --id 0.95 --iddef 1 --sizein  --sizeout  --centroids clustered95_AD/all_derep_sorted_F_clusters.fasta  --uc clustered95_AD/all_derep_sorted_F_clusters.uc
```

Use QIIME2 for an ASV-based workflow.
