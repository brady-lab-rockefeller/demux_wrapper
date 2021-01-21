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

```bash
# Supply all parameters
amplicon_analysis/demux_wrapper/demultiplex.sh -f forward.fastq.gz -r reverse.fastq.gz -b barcode_file.txt -o log_file -l barcode_length -m max_mismatches

# Only supply the read files and barcodes
amplicon_analysis/demux_wrapper/demultiplex.sh -f forward.fastq.gz -r reverse.fastq.gz -b barcode_file.txt
```
