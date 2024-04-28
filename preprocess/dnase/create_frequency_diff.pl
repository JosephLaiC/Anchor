#!/usr/bin/perl

# Take two command-line arguments: input path and output location
$path1=$ARGV[0]; # input raw read
$path2=$ARGV[1]; # output location

# Create a new directory at the output location if it doesn't already exist
system "mkdir -p $path2";

# Read all files in the input path using glob and store the file names in the @mat array
@mat=glob "${path1}*";

# Iterate through the files, reading the content of each file into an element of the @ref array
# and accumulating the sum of the lines in the file. The variable $count is used to keep track of the number of files.
foreach $file (@mat){
	$i=0;
	open OLD, "$file" or die;
	while ($line=<OLD>){
		chomp $line;
		$ref[$i]+=$line; # Add the line to the sum
		$i++;
	}
	close OLD;
	$count++;
}

# Iterate through the files again, calculating the average of the lines in each file
# by dividing the sum of the lines by the number of files. Subtract the average from each line in the file
# and write the result to a new file in the output location. The new file has the same name as the original file.
foreach $file (@mat){
	@t=split '/', $file;
	$name=pop @t;
	$i=0;
	open OLD, "$file" or die;
	open NEW, ">${path2}$name" or die;
	while ($line=<OLD>){
		chomp $line;
		$avg=$ref[$i]/$count; # Calculate the average
		$val=$line-$avg; # Subtract the average from each line
		print NEW "$val\n";
		$i++;
	}
	close OLD;
	close NEW;
}

