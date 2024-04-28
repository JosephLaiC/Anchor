#!/usr/bin/perl

## train model

# Assign the training TF from command line argument
$the_tf=$ARGV[0];

# Define paths
$path1='../train_test/H/'; # path to the data directory
$path2='../../data/chipseq/'; # path to the chipseq directory 
$path3='../../model/anchor/H_all/'; # output directory 

# Create output directory if it doesn't exist
system "mkdir -p $path3";

# Collect names of all cell lines for target tf
@tmp=glob "${path2}${the_tf}*";

# Open the first file in the list
open TMP, "$tmp[0]" or die;

# Read the first line and store the list of cell lines
$line=<TMP>;
chomp $line;
@list= split "\t", $line;
shift @list;
shift @list;
shift @list;
close TMP;

# Get the number of cell lines
$num_cell=scalar(@list);

# Loop through each pair of cell lines
for ($i=0; $i<$num_cell; $i++) {
    $train=$list[$i];
    if($i eq $num_cell-1){
        $test=$list[0];
    }else{
        $test=$list[$i+1];
    }

    # Copy the training and testing data files
    system "cp ${path1}${the_tf}/${the_tf}.${train}.set1 train.dat";
    system "cp ${path1}${the_tf}/${the_tf}.${test}.set2 test.dat";

    # Train the model
    system "xgboost xgtree.conf";

    # Get the list of trained models
    @all_config=glob "*model";

    # Prepare test data
    system "cut -f 1 -d ' ' test.dat>test_gs.dat";

    # Loop through each trained model
    foreach $model (@all_config){
        # Predict using the model
        system "xgboost xgtree.conf task=pred model_in=$model";

        # Evaluate the model
        system "python evaluation.py";

        # Save AUC and AUPRC results
        system "mv auc.txt ${model}.auc.txt";
        system "mv auprc.txt ${model}.auprc.txt";
    }

    # Save the models and evaluation results
    system "mkdir ${path3}${the_tf}_${train}_${test}_set1_eva";
    system "mv *model ${path3}${the_tf}_${train}_${test}_set1_eva/";
    system "mv *auc.txt ${path3}${the_tf}_${train}_${test}_set1_eva/";
    system "mv *auprc.txt ${path3}${the_tf}_${train}_${test}_set1_eva/";

    # Copy the training and testing data files
    system "cp ${path1}${the_tf}/${the_tf}.${train}.set2 train.dat";
    system "cp ${path1}${the_tf}/${the_tf}.${test}.set1 test.dat";

    # Train the model
    system "xgboost xgtree.conf";

    # Get the list of trained models
    @all_config=glob "*model";

    # Prepare test data
    system "cut -f 1 -d ' ' test.dat>test_gs.dat";

    # Loop through each trained model
    foreach $model (@all_config){
        # Predict using the model
        system "xgboost xgtree.conf task=pred model_in=$model";

        # Evaluate the model
        system "python evaluation.py";

        # Save AUC and AUPRC results
        system "mv auc.txt ${model}.auc.txt";
        system "mv auprc.txt ${model}.auprc.txt";
    }

    # Save the models and evaluation results
    system "mkdir ${path3}${the_tf}_${train}_${test}_set2_eva";
    system "mv *model ${path3}${the_tf}_${train}_${test}_set2_eva/";
    system "mv *auc.txt ${path3}${the_tf}_${train}_${test}_set2_eva/";
    system "mv *auprc.txt ${path3}${the_tf}_${train}_${test}_set2_eva/";
}
