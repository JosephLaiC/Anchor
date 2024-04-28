"""
Script for predicting genome-scale TF binding sites.
Use `ANCHOR_dnase.py -h` to see descriptions of the arguments.
"""

import argparse
import os

def get_args():
    # Initialize the argument parser
    parser = argparse.ArgumentParser(
        description="ANCHOR_dnase - preprocessing DNase-seq data",
        epilog='\n'.join(__doc__.strip().split('\n')[1:]).strip(),
        formatter_class=argparse.RawTextHelpFormatter
    )

    # Add arguments for input and output directories, cell line, and help texts
    parser.add_argument('-i1', '--input1', default='./data/dnase_aln/', type=str,
        help='Directory of the input DNase-seq read alignment BAM files ' +
             '(default: ./data/dnase_aln/)')
    parser.add_argument('-i2', '--input2', default='./data/dnase_fold_coverage/', type=str,
        help='Directory of the input fold-enrichement signal coverage BigWig files ' +
             '(default: ./data/dnase_fold_coverage/)')
    parser.add_argument('-cell', '--cell_line', default='H1-hESC', type=str,
        help='The cell line name of the DNase-seq data')
    parser.add_argument('-o', '--output', default='./data/', type=str,
        help='Directory of the output files ' +
             '(default: ./data/)')
    args = parser.parse_args()
    return args

def main():
    # Get command line arguments
    args = get_args()

    # step1. convert bam to txt file; require samtools; # 16 minutes (e.g. for H1-hESC with 2 replicates)
    cmd = 'perl ./preprocess/dnase/transform_bam_to_track.pl ' + \
        args.input1 + ' ' + \
        args.output + 'dnase_track/'
    os.system(cmd)   

    # ... (other steps follow)

