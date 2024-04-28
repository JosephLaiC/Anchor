#!/usr/bin/perl

# Define the path to the directories containing the models
$path1 = "./model/anchor/F_all/";

# Get a list of all model directories
@model_dir = glob "${path1}" . "*";

# Loop through each model directory
foreach $the_dir (@model_dir) {
    print "$the_dir\n"; # Print the current model directory
}

# Create a new directory name by removing "_all" from the current directory name
$new_dir = $the_dir;
$new_dir =~ s/_all//g;
print "$new_dir\n";

# Create the new directory
system "mkdir -p $new_dir";

# Initialize variables to store the model with the highest AUPRC score and its score
$perf = 0;
$model = '';

# Get a list of all AUPRCs for the models in the current directory
@all_models = glob "$the_dir/*auprc.txt";

# Loop through each AUPRC file
foreach $the_model (@all_models) {
    open OLD, "$the_model" or die; # Open the AUPRC file
    $line = <OLD>;
    if ($line>$perf) {
        # If the current AUPRC score is higher than the previous highest score, then update the highest score and the corresponding model
        $perf=$line;
        $model=$the_model;
    }
    close OLD;
}

print "$model\n"; # Print the model with the highest AUPRC score

# Remove the ".auprc.txt" extension from the model name
$new_model = $model;

$new_model =~ s/\.auprc\.txt//g;

# Copy the selected model to the new directory
system "cp $model ${new_dir}/the_model";
