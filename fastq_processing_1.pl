# @Author: Yu Zhu
# @Correspondence: School of Biology and Basic Medical Sciences, Soochow University, No.199 Ren'ai Road, Suzhou 215123, China.
# @Email: 1830416012@stu.suda.edu.cn

#! /usr/bin/perl -w
use strict;

unless (@ARGV==2) {
	die "Usage: perl $0 <input.fq><out.q>\n";
}

### Code in Terminal:
# perl fastq_processing_1.pl 1.fastq out.txt

open(FASTQ,"$ARGV[0]") || die "error: can't open infile: $ARGV[0]\n";
open(OUT,">$ARGV[1]") || die "error: can't make outfile: $ARGV[1]\n";

while (<FASTQ>) {
	if (/(\@SRR.*)\HWI/) {					#Match the first line and get the IDs.
		print OUT "$1\t";
	}
	if (($.-2)%4==0) {						#Match the reads sequence.
		chomp;
		s/\r//g;
		my @F = split//;
		print "@F\n";
		print OUT scalar(@F);				#Print the length of reads.
		
		my $GC = 0;
		foreach (@F) {
			$GC ++ if /G/;
			$GC ++ if /C/;
		}
		$GC = int(100*$GC/@F);
		print OUT "\t$GC\t";				#Print the GC proportion of the reads.
	}
	if ($.%4==0) {
		chomp;
		s/\r//g;
		my @F = split//;
		my $mean = 0;
		my $sum = 0;
		foreach (@F) {
			my $num = ord($_);
			$num -= 33;
			$sum += $num;
		}
		$mean = int($sum/@F);
		print OUT "$mean\n";
	}
}

close FASTQ;
close OUT;