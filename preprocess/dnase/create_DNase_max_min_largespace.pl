#!/usr/bin/perl

# Store the input path and output location from command-line arguments
$path1=$ARGV[0];
$path2=$ARGV[1];

# Create the output directory if it doesn't exist
system "mkdir -p $path2";

# Get all files in the input path
@mat=glob "${path1}/*";

foreach $file (@mat){
    # Print the current file being processed
    print "$file\n";

    # Open the current file for reading
    open OLD, "$file" or die;

    # Initialize arrays to store data from the file
    @all1=();
    @all2=();

    # Read the file line by line, split each line by tab, and store the values in the arrays
    while ($line=<OLD>){
        chomp $line;
        @table=split "\t", $line;
        push @all1, $table[0];
        push @all2, $table[1];
    }

    # Close the file
    close OLD;

    # Extract the file name from the full path
    @t=split '/', $file;
    $name=pop @t;

    # Open (or create) the output file for writing
    open NEW, ">${path2}/$name" or die;

    # Process the data and write it to the output file
    $i=0;
    foreach $aaa (@all1){
        # Print the current value and its surrounding values with a step of 1
        printf NEW "%.4f", $aaa;
        $j=1;
        while ($j<15){
            if (defined $all1[$i-$j]){
                printf NEW "\t%.4f", $all1[$i-$j];
            }else{
                printf NEW "\t0";
            }

            if (defined $all1[$i+$j]){
                printf NEW "\t%.4f", $all1[$i+$j];
            }else{
                printf NEW "\t0";
            }
            $j++;
            $j++;
        }

        # Print the corresponding value from @all2 and its surrounding values with a step of 1
        printf NEW "\t%.4f", $all2[$i];
        $j=1;
        while ($j<15){
            if (defined $all2[$i-$j]){
                printf NEW "\t%.4f", $all2[$i-$j];
            }else{
                printf NEW "\t0";
            }

            if (defined $all2[$i+$j]){
                printf NEW "\t%.4f", $all2[$i+$j];
            }else{
                printf NEW "\t0";
            }
            $j++;
            $j++;
        }

        # Move to the next line in the output file
        print NEW "\n";
        $i++;
    }

    # Close the output file
    close NEW;
}
