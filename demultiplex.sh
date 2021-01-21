#!/bin/bash

shopt -s nullglob

run_demultiplex() {
    barcode_length=${5:-$(($(tail -1 $3 | cut -f2 | wc -c) - 1))}
    echo "Forward: $1, Reverse: $2, Mapping: $3, Log: $4, barcode length: $barcode_length, max mismatches: $6"
    demultiplexfastq --forward_fastq <(zcat "$1") --reverse_fastq <(zcat "$2") --barcodefile "$3" --barcodelength "$barcode_length" --max_mismatches "$6" --outdirectory "$outdir" --logfile "$4"
}

export -f run_demultiplex

test_demultiplex() {
    barcode_length=${5:-$(($(tail -1 $3 | cut -f2 | wc -c) - 1))}
    mkdir -p "$outdir"
    echo "Forward: $1, Reverse: $2, Mapping: $3, Log: $4, barcode length: $barcode_length, max mismatches: $6, outdir: $outdir"
    for i in {1..100}; do echo "test_fq_$i" >"$outdir"/"$i".fq; done
    echo "Test complete" >"$4"
}

export -f test_demultiplex

conda activate amplicon_processing

#barcode_len=16
max_mismatches=0
func=run_demultiplex

while getopts ":f:r:b:d:l:m:o:th" opt; do
    case "$opt" in
    f)
        forward_fastq="$OPTARG"
        ;;
    r)
        reverse_fastq="$OPTARG"
        ;;
    b)
        barcode_file="$OPTARG"
        ;;
    d)
        outdir="$OPTARG"
        ;;
    o)
        log_file="$OPTARG"
        ;;
    l)
        barcode_len="$OPTARG"
        ;;
    m)
        max_mismatches="$OPTARG"
        ;;
    t)
        func=test_demultiplex
        ;;
    h | \?)
        echo "Usage: $0 -f forward_fq -r reverse_fq -b barcode_file -o log_file -l barcode_length -m max_mismatches"
        exit 1
        ;;
    esac
done
shift $((OPTIND - 1))

outdir=${outdir:-${forward_fastq%_L001_R[12]_001.*}"_demux"}
log_file=${log_file:-"$outdir.log"}
"$func" "$forward_fastq" "$reverse_fastq" "$barcode_file" "$log_file" "$barcode_len" "$max_mismatches"

conda deactivate
