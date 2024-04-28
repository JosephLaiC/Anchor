#!/usr/bin/perl

# Define the base directory path containing the model subdirectories
$path1 = "./model/anchor/H_all/";

# Get an array of model files' directories
@model_dir = glob "${path1}*";

# Loop through each model directory
foreach $the_dir (@model_dir) {
    print "$the_dir\n"; # Print the current model directory path

    # Remove '_all//g' from the directory name and store it in $new_dir
    $new_dir = $the_dir;
    $new_dir =~ s/_all//g;

    # Create the new directory if it doesn't exist
    system "mkdir -p $new_dir";

    $perf = $model = ''; # Initialize the performance variable and model variable

    # Get an array of AUPRC files for each model
    @all_models = glob "$the_dir/*auprc.txt";

    # Loop through each AUPRC file
    foreach $the_model (@all_models) {
        open OLD, "$the_model" or die; # Open the AUPRC file
        $line = $line = <OLD>; # Read the first line (performance score)

        # If the current performance score is greater than the stored performance score
        if ($line > $perf) {
            $perf = $line; # Update the performance score
            $model = $the_model; # Store the model with the highest performance score
        }
    }

    print "$model\n"; # Print the model with the highest performance score

    # Remove '.auprc.txt' from the model name and copy the model to the new directory
    $model =~ s/\.auprc\.txt//g;
    system "cp $model ${new_dir}/the_model";
}
