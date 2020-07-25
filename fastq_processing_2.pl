# @Author: Yu Zhu
# @Correspondence: School of Biology and Basic Medical Sciences, Soochow University, No.199 Ren'ai Road, Suzhou 215123, China.
# @Email: 1830416012@stu.suda.edu.cn

#! /usr/bin/perl -w
use strict;
use List::Util qw/sum/;

unless (@ARGV==2) {												
    die"Usage: perl $0 <input.fa> <out.len>\n";					
}

### Code in Terminal:
#perl fastq_processing_2.pl 1.fastq out.txt


my ($infile,$outfile) =  @ARGV;	
open(IN,$infile) || die "error: can't open infile: $infile\n";
open(OUT,">$outfile") || die "error: can't make outfile: $outfile\n";

while (<IN>){
	chomp;
# Match the first line.
	if ($. %4 == 1) {
		my $ID = $_;
		my $id=$1 if($ID =~ /^(\S+)/);
		print OUT "ID:$ID\t";
	} 
# Calculate the length of reads and GC proportion.
	elsif ($. %4 == 2) {
		my $seq = $_;
		my $seqlen = length($seq);
		print OUT "The length of sequence:$seqlen\t";
		my $sum = ($seq=~s/[GC]//g);
		my $percent = $sum/$seqlen;
		print OUT "The percent of GC:$percent\t";
	}
# Calculate Q values.
	elsif ($. %4 == 0) {
		my $qua = $_;
		my @qua = split(//, $_);

		for (my $i = 0; $i < scalar(@qua); $i++) {
			$qua[$i] = ord($qua[$i]);
			$qua[$i] -= 33;
		}
		my $sum = sum @qua; 
		my $numbers = scalar(@qua);
		my $avgQ = $sum/$numbers;
		print OUT "The average Q:$avgQ\n";
	}

}
