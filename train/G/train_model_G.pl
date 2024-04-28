#!/usr/bin/perl

## train model

# Assign the training TF from the command line argument
$the_tf=$ARGV[0];

# Define the paths for the data and output directories
$path1='../train_test/G/';
$path2='../../data/chipseq/';
$path3='../../model/anchor/G_all/';

# Create the output directory if it doesn't exist
system "mkdir -p $path3";

# Collect names of all cell lines for the target TF
@tmp=glob "${path2}${the_tf}*";

# Open the first file in the list
open TMP, "$tmp[0]" or die;

# Read the first line of the file
$line=<TMP>;

# Chomp the line to remove any trailing newline characters
chomp $line;

# Split the line into a list of fields
@list= split "\t", $line;

# Remove the first three elements of the list
shift @list;
shift @list;
shift @list;

# Close the file
close TMP;

# Get the number of cell lines
$num_cell=scalar(@list);

# Initialize a counter
$i=0;

# Loop through each pair of cell lines
while($i<$num_cell){

    # Assign the current train and test cell lines
    $train=$list[$i];
    if($i eq $num_cell-1){
        $test=$list[0];
    }else{
        $test=$list[$i+1];
    }

    # Copy the training and testing data files
    system "cp ${path1}${the_tf}/${the_tf}.${train}.set1 train.dat";
    system "cp ${path1}${the_tf}/${the_tf}.${test}.set2 test.dat";

    # Train the model using xgboost
    system "xgboost xgtree.conf";

    # Get the list of trained models
    @all_config=glob "*model";

    # Cut the first field of the test data file
    system "cut -f 1 -d ' ' test.dat>test_gs.dat";

    # Loop through each trained model
    foreach $model (@all_config){

        # Predict using the trained model
        system "xgboost xgtree.conf task=pred model_in=$model";

        # Evaluate the model
        system "python evaluation.py";

        # Move the AUC and AUPRC results to the model directory
        system "mv auc.txt ${model}.auc.txt";
        system "mv auprc.txt ${model}.auprc.txt";
    }

    # Create a directory for the current train/test pair
    system "mkdir ${path3}${the_tf}_${train}_${test}_set1_eva";

    # Move the trained models and evaluation results to the directory
    system "mv *model ${path3}${the_tf}_${train}_${test}_set1_eva/";
    system "mv *auc.txt ${path3}${the_tf}_${train}_${test}_set1_eva/";
    system "mv *auprc.txt ${path3}${the_tf}_${train}_${test}_set1_eva/";

    # Copy the training and testing data files
    system "cp ${path1}${the_tf}/${the_tf}.${train}.set2 train.dat";
    system "cp ${path1}${the_tf}/${the_tf}.${test}.set1 test.dat";

    # Train the model using xgboost
    system "xgboost xgtree.conf";

    # Get the list of trained models
    @all_config=glob "*model";

    # Cut the first field of the test data file
    system "cut -f 1 -d ' ' test.dat>test_gs.dat";

    # Loop through each trained model
    foreach $model (@all_config){

        # Predict using the trained model
        system "xgboost xgtree.conf task=pred model_in=$model";

        # Evaluate the model
        system "python evaluation.py";

        # Move the AUC and AUPRC results to the model directory
        system "mv auc.txt ${model}.auc.txt";
        system "mv auprc.txt ${model}.auprc.txt";
    }

    # Create a directory for the current train/test pair
    system "mkdir ${path3}${the_tf}_${train}_${test}_set2_eva";

    # Move the trained models and evaluation results to the directory
    system "mv *model ${path3}${the_tf}_${train}_${test}_set2_eva/";
    system "mv *auc.txt ${path3}${the_tf}_${train}_${test}_set2_eva/";
    system "mv *auprc.txt ${path3}${the_tf}_${train}_${test}_set2_eva/";

    # Increment the counter
    $i++;
}
