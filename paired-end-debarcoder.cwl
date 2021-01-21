#!/usr/bin/env cwl-runner
cwlVersion: 'v1.0'
class: CommandLineTool
id: "paired-end-debarcoder_wrapped"
label: "Demultiplexing of paired end amplicon sequences"
inputs:
  forward_fastq:
    type: File
    doc: |
      Path to the forward FASTQ file. Must be uncompressed.
    inputBinding:
      position: 1
      prefix: "-f"
  reverse_fastq:
    type: File
    doc: |
      Path to the reverse FASTQ file. Must be uncompressed.
    inputBinding:
      position: 2
      prefix: "-r"
  barcodefile:
    type: File
    doc: |
      Path to the barcode file.
    inputBinding:
      position: 3
      prefix: "-b"
  log_file:
    type: string
    default: ""
    doc: |
      Precomputed log name
    inputBinding:
      position: 4
      prefix: "-o"
  barcodelength:
    type: int
    doc: |
      Length of barcode. Usually 16 (but check the mapping file).
    default: 16
    inputBinding:
      position: 5
      prefix: "-l"
  max_mismatches:
    type: int
    default: 0
    doc: |
      Maximum difference between sequence and barcode. Defaults to 0.
    inputBinding:
      position: 6
      prefix: "-m"
  test_mode:
    type: boolean
    default: false
    doc: |
      Test wrapper script. Prints a message with all parameters to visually verify, then exit.
    inputBinding:
      position: 6
      prefix: "-t"
outputs:
  demux_fastqs:
    type:
      type: array
      items: File
    outputBinding:
      glob: "fastqs/*.fq"
  log_files:
    type: File
    outputBinding:
      glob: "*.log"
requirements:
  InitialWorkDirRequirement:
    listing:
      - class: File
        location: "demultiplex.sh"
baseCommand: ["bash", "demultiplex.sh"]
arguments: []
doc: |
  Usage: demultiplexfastq [OPTIONS]

    Demultiplexing paired Fastq files with a barcode file.

    This is intended for use with MiSeq reads where the paired ends have
    barcodes inside of the Illlumina sequencing primers. The full barcode is a
    concatenation of barcodes on  the forward and reverse read. A two-column
    barcode file must be provided that gives the barcode-to-sample
    relationship.

    Fasta files are expected to have been pretrimmed for quality using, for
    example, seqtk.

    This script will:

    1. check the barcode allowing for a minimal distance to the supplied
    barcode file. 2. truncate forward and reverse to specified values 3.
    concatenate the forward and reverse together 4. trim by size 5. output
    fasta to specified file

  Options:
    --forward_fastq PATH            name of the fastq forward file
    --reverse_fastq PATH            name of the fastq reverse file
    --barcodefile PATH              name of the barcode file
    --barcodelength INTEGER         how long is the barcode
    --max_mismatches INTEGER        maximum difference between sequence and
                                    barcode
    --outdirectory PATH             output directory file
    --logfile FILENAME              outputlogfile
    --checkbarcodes / --no-checkbarcodes
                                    check the barcodes file
    --keepunassigned / --no-keepunassigned
    --chunksize INTEGER
    --help                          Show this message and exit.
