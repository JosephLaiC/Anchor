#!/usr/bin/perl

# Read input and output directories from command-line arguments
$dir_input = $ARGV[0];
$dir_output = $ARGV[1];

# Read all files from the input directory
@mat = glob "$dir_input/*";

# Create the output directory if it doesn't exist
system("mkdir", "-p", $dir_output);

foreach $file (@mat) {
    # Open the file for reading
    open(OLD, "$file") or die;

    # Initialize arrays to store the content of the file
    @all1 = ();
    @all2 = ();
    @all3 = ();
    @all4 = ();

    # Read the file line by line and populate the arrays
    while ($line = <OLD>) {
        chomp $line;
        @table = split("\t", $line);
        push @all1, $table[0];
        push @all2, $table[1];
        push @all3, $table[2];
        push @all4, $table[3];
    }

    close(OLD);

    # Extract the file name
    @t = split('/', $file);
    $name = pop @t;

    # Open the file for writing in the output directory
    open(NEW, ">$dir_output/$name") or die;

    # Process the arrays and write the output
    $i = 0;
    foreach $aaa (@all1) {
        # Calculate the maximum values for each element and its neighbors
        printf NEW "%.4f", $aaa;
        for ($j = 1; $j < 15; $j++) {
            $max = -100;
            $max = $all1[$i - $j] if ($all1[$i - $j] > $max);
            $max = $all1[$i + $j] if ($all1[$i + $j] > $max);
            printf NEW "\t%.4f", $max;
        }

        # Repeat the calculation for the other three arrays
        printf NEW "\t%.4f", $all2[$i];
        for ($j = 1; $j < 15; $j++) {
            $max = -100;
            $max = $all2[$i - $j] if ($all2[$i - $j] > $max);
            $max = $all2[$i + $j] if ($all2[$i + $j] > $max);
            printf NEW "\t%.4f", $max;
        }

        printf NEW "\t%.4f", $all3[$i];
        for ($j = 1; $j < 15; $j++) {
            $max = -100;
            $max = $all3[$i - $j] if ($all3[$i - $j] > $max);
            $max = $all3[$i + $j] if ($all3[$i + $j] > $max);
            printf NEW "\t%.4f", $max;
        }

        printf NEW "\t%.4f", $all4[$i];
        for ($j = 1; $j < 15; $j++) {
            $max = -100;
            $max = $all4[$i - $j] if ($all4[$i - $j] > $max);
            $max = $all4[$i + $j] if ($all4[$i + $j] > $max);
            printf NEW "\t%.4f", $max;
        }

        print NEW "\n";
        $i++;
    }

    close(NEW);
}
