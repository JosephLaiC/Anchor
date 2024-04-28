# Input training TF name
my $the_tf = $ARGV[0];

# Paths for feature directory, chipseq directory, sample directory, and output directory
my $path1 = '/state2/hyangl/TF_model/data/feature/';
my $path2 = './data/chipseq/';
my $path3 = './train/sample/';
my $path4 = './train/train_test/G/';

# Create output directory if it doesn't exist
system("mkdir -p $path4");


# Array for TF feature files
my @tf_feature = glob("${path1}tf_ru_max_top4_rank_largespace/$the_tf");

# Array for cell feature files
my @cell_feature = (
    "${path1}anchor_bam_DNAse_largespace/",
    "${path1}anchor_bam_DNAse_diff_largespace/",
    "${path1}anchor_bam_DNAse_max_min_largespace/",
    "${path1}anchor_bam_DNAse_max_min_diff_largespace/",
    "${path1}orange_rank_largespace/",
    "${path1}orange_rank_diff_largespace/"
);

# Hash for chromosome set1 index
my %chr_set1 = ();
open(INDEX_SET1, "./data/index/ind_chr_set1.txt") or die;
while ($line = <INDEX_SET1>) {
    chomp $line;
    $chr_set1{$line} = 0;
}
close(INDEX_SET1);


# Process each cell type for the target TF
system("mkdir -p ${path4}${the_tf}");
my @tmp = glob("${path2}${the_tf}*"); # collect names of all cell types for target tf
open(TMP, "$tmp[0]") or die;
my $line = <TMP>;
chomp $line;
my @list = split("\t", $line);
shift @list;
shift @list;
shift @list;
close(TMP);

foreach my $cell (@list) {
    # ... (code for processing each cell type)
}


foreach my $cell (@list) {
    # Read target data for the current cell type
    open(SAMPLE, "${path3}${the_tf}/F.${the_tf}.${cell}.tab") or die;
    my %target = ();
    while ($line = <SAMPLE>) {
        chomp $line;
        my @tmp = split("\t", $line);
        my $chr = shift @tmp;
        my $start = shift @tmp;
        my $y = shift @tmp;
        $target{$chr}{$start} = $y;
    }
    close(SAMPLE);

    # Read feature files for the current cell type
    open(INDEX, "$rna_feature") or die;
    my $num = 0;
    foreach my $file (@cell_feature) {
        my $name = "INPUT" . $num;
        open($name, "${file}${cell}") or die;
        $num++;
    }
    foreach my $file (@tf_feature) {
        my $name = "INPUT" . $num;
        open($name, "${file}") or die;
        $num++;
    }

    # Write output files for set1 and set2
    open(OUTPUT1, ">${path4}${the_tf}/${the_tf}.${cell}.set1") or die;
    open(OUTPUT2, ">${path4}${the_tf}/${the_tf}.${cell}.set2") or die;
    while ($line = <INDEX>) {
        chomp $line;
        my @rna = split("\t", $line);
        my $chr = shift @rna;
        my $start = shift @rna;
        shift @rna;

        # If the line is a target, write it to set1 or set2 based on the chromosome
        if (defined $target{$chr}{$start}) {
            if (exists $chr_set1{$chr}) {
                print OUTPUT1 "$target{$chr}{$start}";
            } else {
                print OUTPUT2 "$target{$chr}{$start}";
            }

            # Print RNA features and other features
            my $j = 21;
            foreach my $x (@rna) {
                print OUTPUT1 " $j:$x";
              `$j++;
            }
            my $i = 0;
            while ($i < $num) {
                my $name = "INPUT" . $i;
                my $line = <$name>;
                chomp $line;
                my @tmp = split("\t", $line);
                foreach my $x (@tmp) {
                    print OUTPUT1 " $j:$x";
                    $j++;
                }
                $i++;
            }
            print OUTPUT1 "\n";
        } else {
            # Skip lines that are not targets
            my $i = 0;
            while ($i < $num) {
                my $name = "INPUT" . $i;
                <$name>;
                $i++;
            }
        }
    }
    close(OUTPUT1);
    close(OUTPUT2);
    close(INDEX);

    # Close input feature files
    my $i = 0;
    while ($i < $num) {
        my $name = "INPUT" . $i;
        close($name);
        $i++;
    }
}
