#!/usr/bin/perl

use strict;
use warnings;

# Check if the correct number of arguments are provided
if (@ARGV != 2) {
    die "Usage: $0 <input_path_to_bam_files> <output_path_for_text_files>\n";
}

my $path1 = $ARGV[0];
my $path2 = $ARGV[1];

# Get a list of all BAM files in the input path
my @mat = glob "$path1*bam";

# Create the output directory if it doesn't exist
system "mkdir -p $path2";

# Iterate over each BAM file
foreach my $file (@mat) {
    # Extract the file name
    my @t = split '/', $file;
    my $name = pop @t;

    # Print the file name to the console
    print "$name\n";

    # Run the samtools depth command on the file and redirect the output to a text file
    system "samtools depth $file > ${path2}${name}";
}
