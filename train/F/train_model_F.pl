#!/usr/bin/perl

## train model

# Assign the input argument (training TF) to the variable $the_tf
$the_tf=$ARGV[0];

# Define the paths to the data directory, chipseq directory, and output directory
$path1='../train_test/F/';
$path2='../../data/chipseq/';
$path3='../../model/anchor/F_all/';

# Create the output directory if it doesn't exist
system "mkdir -p $path3";

# Collect names of all cell lines for the target TF
@tmp=glob "${path2}${the_tf}*";

# Open the first file in the list of cell lines
open TMP, "$tmp[0]" or die;

# Read the first line of the file
$line=<TMP>;

# Remove the newline character from the end of the line
chomp $line;

# Split the line into a list of fields
@list= split "\t", $line;

# Remove the first three elements of the list
shift @list;
shift @list;
shift @list;

# Close the file
close TMP;

# Assign the number of cell lines to the variable $num_cell
$num_cell=scalar(@list);

# Initialize the loop variable $i to 0
$i=0;

# Loop through all pairs of cell lines
while($i<$num_cell){

    # Assign the current and next cell lines to the variables $train and $test
    $train=$list[$i];
    if($i eq $num_cell-1){
        $test=$list[0];
    }else{
        $test=$list[$i+1];
    }

    # Copy the training and test data files to the current directory
    system "cp ${path1}${the_tf}/${the_tf}.${train}.set1 train.dat";
    system "cp ${path1}${the_tf}/${the_tf}.${test}.set2 test.dat";

    # Train the model using xgboost
    system "xgboost xgtree.conf";

    # Save the trained models to a list
    @all_config=glob "*model";

    # Extract the test labels
    system "cut -f 1 -d ' ' test.dat>test_gs.dat";

    # Loop through all trained models
    foreach $model (@all_config){

        # Predict the test labels using the current model
        system "xgboost xgtree.conf task=pred model_in=$model";

        # Evaluate the model using the evaluation.py script
        system "python evaluation.py";

        # Save the AUC and AUPRC scores to files
        system "mv auc.txt ${model}.auc.txt";
        system "mv auprc.txt ${model}.auprc.txt";
    }

    # Create a directory for the current pair of cell lines
    system "mkdir ${path3}${the_tf}_${train}_${test}_set1_eva";

    # Move the trained models and evaluation scores to the current directory
    system "mv *model ${path3}${the_tf}_${train}_${test}_set1_eva/";
    system "mv *auc.txt ${path3}${the_tf}_${train}_${test}_set1_eva/";
    system "mv *auprc.txt ${path3}${the_tf}_${train}_${test}_set1_eva/";

    # Copy the training and test data files to the current directory
    system "cp ${path1}${the_tf}/${the_tf}.${train}.set2 train.dat";
    system "cp ${path1}${the_tf}/${the_tf}.${test}.set1 test.dat";

    # Train the model using xgboost
    system "xgboost xgtree.conf";

    # Save the trained models to a list
    @all_config=glob "*model";

    # Extract the test labels
    system "cut -f 1 -d ' ' test.dat>test_gs.dat";

    # Loop through all trained models
    foreach $model (@all_config){

        # Predict the test labels using the current model
        system "xgboost xgtree.conf task=pred model_in=$model";

        # Evaluate the model using the evaluation.py script
        system "python evaluation.py";

        # Save the AUC and AUPRC scores to files
        system "mv auc.txt ${model}.auc.txt";
        system "mv auprc.txt ${model}.auprc.txt";
    }

    # Create a directory for the current pair of cell lines
    system "mkdir ${path3}${the_tf}_${train}_${test}_set2_eva";

    # Move the trained models and evaluation scores to the current directory
    system "mv *model ${path3}${the_tf}_${train}_${test}_set2_eva/";
    system "mv *auc.txt ${path3}${the_tf}_${train}_${test}_set2_eva/";
    system "mv *auprc.txt ${path3}${the_tf}_${train}_${test}_set2_eva/";

    # Increment the loop variable
    $i++;
}
