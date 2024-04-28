#!/usr/bin/perl
# This line specifies the interpreter to use for this script.

$dir_input1=$ARGV[0];
$dir_input2=$ARGV[1];
$dir_output=$ARGV[2];
# These lines retrieve the command-line arguments and assign them to variables.

@mat=glob "$dir_input1/*";
# This line uses the glob function to get a list of files in the first directory.

system "mkdir -p $dir_output";
# This line creates the output directory if it doesn't already exist.

foreach $file1 (@mat){
# This loop iterates through each file in the first directory.

        @table=split "/", $file1;
        $tf=pop @table;
        $file2="$dir_input2/$tf";
# These lines extract the filename from the full path and construct the corresponding filename in the second directory.

        $new="$dir_output/$tf";
# This line constructs the full path for the output file.

	open OLD1, "$file1" or die;
	open OLD2, "$file2" or die;
	open NEW, ">$new" or die;
# These lines open the input files and the output file for processing.

	while ($line1=<OLD1>){
		chomp $line1;
		@table1=split "\t", $line1;
		$line2=<OLD2>;
		chomp $line2;
		@table2=split "\t", $line2;
		push @table1, @table2;
# These lines read the input files line by line, split each line into fields, and combine the fields into a single array.

		@all=sort{$b<=>$a}@table1;
		print NEW "$all[0]\t$all[1]\t$all[2]\t$all[3]\n";
# These lines sort the combined array in descending order and write the first four elements to the output file.

	
	}
	close OLD1;
	close OLD2;
	close NEW;
}

