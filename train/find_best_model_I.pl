#!/usr/bin/perl

# Define the path to the model directories
$path1="./model/anchor/I_all/";

# Get a list of all model directories
@model_dir = glob "${path1}*";

# Iterate through each model directory
foreach $the_dir (@model_dir){
    print "$the_dir\n"; # Print the current model directory path

    # Replace '_all' in the directory name with an empty string
    $new_dir = $the_dir;
    $new_dir =~ s/_all//g;

    # Create the new directory without '_all'
    system "mkdir -p $new_dir";

    # Initialize variables for performance tracking
    $perf = 0;
    $model = '';

    # Find the model with the highest AUPRC value
    @all_models = glob "$the_dir/*auprc.txt";
    foreach $the_model (@all_models){
        open OLD, "$the_model" or die; # Open the current model file
        $line = <OLD>; # Read the first line (AUPRC value)
        if ($line > $perf){
            $perf = $line; # Update the highest AUPRC value
            $model = $the_model; # Store the model file with the highest AUPRC value
        }
    }

    print "$model\n"; # Print the model file with the highest AUPRC value

    # Replace '.auprc.txt' in the model file name with an empty string
    $model =~ s/\.auprc\.txt//g;

    # Copy the model file with the highest AUPRC value to the new directory
    system "cp $model ${new_dir}/the_model";
}
