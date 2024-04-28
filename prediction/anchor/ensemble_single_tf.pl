#!/usr/bin/perl

# This script is used to ensemble and average the predictions of models F, G, H, and I.

$path="./prediction/anchor/final/";
# Define the path for the output files
system "mkdir -p $path";
# Create the output directory if it doesn't exist

@list=("./prediction/anchor/F/combined/",
    "./prediction/anchor/G/combined/");
# Specify the directories containing the predictions for models F and G

$first=shift @list;
# Store the first directory in the @list array

@mat=glob "$first/*";
# Get a list of all files in the first directory

foreach $file (@mat){
    # Loop through each file in the list

    @t=split '/', $file;
    # Split the file path into an array @t

    $name=pop @t;
    # Get the filename by removing the last element from the array @t

    open OLD, "$file" or die;
    # Open the current file for reading

    $i=0;
    foreach $dir (@list){
        # Loop through the directories for models F and G

        $handle='handle'.$i;
        open $handle, "$dir/$name" ;
        # Open the corresponding file in the current directory for reading

        $i++;
    }

    $imax=$i;
    # Store the number of models (F, G, H, and I)

    open NEW, ">${path}${name}" or die;
    # Open a new file in the output directory for writing

    while ($old=<OLD>){
        # Loop through each line in the current file

        chomp $old;
        # Remove the newline character from the line

        $i=0;
        while ($i<$imax){
            # Loop through the lines in the corresponding files for models F, G, H, and I

            $handle='handle'.$i;
            $line=<$handle>;
            chomp $line;
            # Read the line, remove the newline character, and store it in $line

            $old=$line+$old;
            # Add the current line from the model to the current line from the original file

            $i++;
        }

        $val=$old/($imax+1);
        # Calculate the new line value by averaging the sum of lines from models F, G, H, and I and the original line

        print NEW "$val\n";
        # Write the new line value to the output file
    }

    close NEW;
    close FILE1;
    close FILE2;
}

# Directory path for model H and I predictions
#[guanlab11]/state4/hongyang/TF/code_combine_final/F_G_H_I/
