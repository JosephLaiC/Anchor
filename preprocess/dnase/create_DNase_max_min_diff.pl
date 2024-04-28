#!/usr/bin/perl

use strict;
use warnings;

# Read input and output paths from command-line arguments
my $path1 = $ARGV[0];
my $path2 = $ARGV[1];

# Create output directory if it doesn't exist
system("mkdir -p $path2");

# Read all files in the input path
my @mat = glob("${path1}/*");

# Initialize arrays to store the sum of the first and second columns
my @ref_0;
my @ref_1;

# Process all files in the input path in the first pass
foreach my $file (@mat) {
    my $i = 0;
    open(my $OLD, "<", $file) or die;
    while (my $line = <$OLD>) {
        chomp($line);
        my @table = split("\t", $line);
        $ref_0[$i] += $table[0];
        $ref_1[$i] += $table[1];
        $i++;
    }
    close($OLD);
}

# Calculate the count of files
my $count = scalar(@mat);

# Process all files in the input path in the second pass
foreach my $file (@mat) {
    print "$file\n";

    # Extract the file name
    my @t = split('/', $file);
    my $name = pop(@t);

    my $i = 0;
    open(my $OLD, "<", $file) or die;
    open(my $NEW, ">", "${path2}/$name") or die;

    # Process each line in the file
    while (my $line = <$OLD>) {
        chomp($line);
        my @table = split("\t", $line);

        # Calculate the average of the first and second columns
        my $avg = $ref_0[$i] / $count;
        my $val = $table[0] - $avg;

        # Write the processed data to the output file
        print $NEW "$val";

        $avg = $ref_1[$i] / $count;
        $val = $table[1] - $avg;
        print $NEW "\t$val\n";

        $i++;
    }

    close($OLD);
    close($NEW);
}
