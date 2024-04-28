#!/usr/bin/perl

## combine 61 separated model into one
# This script combines 61 prediction files for each model into a single file.

$path1="./prediction/anchor/I/separated/"; # PARAMETER
$path2="./prediction/anchor/I/combined/"; # PARAMETER

# Create the combined path if it doesn't exist
system "mkdir -p $path2";

# Get all the separated model files
@mat=glob "${path1}61_*";

foreach $file (@mat){
        # Extract the relevant parts of the file path and name
        @t=split '/', $file;
        $name=pop @t;
        @t=split '61_', $name;
        $new_file=$t[1];

        # Open the new combined file for writing
        open NEW, ">${path2}${new_file}" or die;

        # Concatenate the contents of the 61 separate files into the new file
        $i=1;
        while ($i<62){
                $fff=$file;
                $fff=~s/61/$i/g; # Replace '61' in the file name with the current iteration number
                system "cat $fff >> ${path2}${new_file}"; # Concatenate the file contents
                $i++;
        }

        # Close the new combined file
        close NEW;
}

