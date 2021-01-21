#!/usr/bin/env cwl-runner

cwlVersion: v1.0
class: Workflow
inputs:
  forward_fastq_array:
    type: File[]
  reverse_fastq_array:
    type: File[]
  barcodefile_array:
    type: File[]

outputs:
  demux_fastqs:
    type:
      type: array
      items: File
    outputSource: demultiplex/demux_fastqs
  log_files:
    type:
      type: array
      items: File
    outputSource: demultiplex/log_files

steps:
  demultiplex:
    requirements:
      StepInputExpressionRequirement:
        class: StepInputExpressionRequirement
    run: paired-end-debarcoder.cwl
    in:
      #forward_fastq: gunzip_forward/unzipped_file
      forward_fastq: forward_fastq_array
      #reverse_fastq: gunzip_reverse/unzipped_file
      reverse_fastq: reverse_fastq_array
      barcodefile: barcodefile_array
    out: 
      - demux_fastqs
      - log_files

