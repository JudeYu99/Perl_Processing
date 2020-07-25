# @Author: Yu Zhu
# @Correspondence: School of Biology and Basic Medical Sciences, Soochow University, No.199 Ren'ai Road, Suzhou 215123, China.
# @Email: 1830416012@stu.suda.edu.cn

#!usr/bin/perl -w
use strict;

### Code in Terminal:
#perl motif_searching.pl coordinate-mm10 chr19.fa out.txt

open(IN,"$ARGV[0]")||die "not open the file\n";
open(FA,"$ARGV[1]")||die "not open the file\n";
open(OUT,">$ARGV[2]")|| die "not make the file\n";

my $chr19;
<FA>;
while(<FA>){
	chomp;
	$chr19 .= $_;
}

#$chr19 = uc($chr19);
$chr19 =~tr/atcg/ATCG/;

my $motifSeq = "TTCATTCATTCA";
my $motifSeq2 = "TGAATGAATGAA";

while (my $line = <IN>){
	my @data = split(/\t/, $line);
	if ($data[2] eq "chr19"){
		my $name = $data[1];
		my $strand = $data[3];
		my $cdsStart = $data[6];
		my $cdsEnd = $data[7];

		if ($strand eq "+") {
			my $promoter = substr($chr19, $cdsStart-1-10000, 10000);
			my @positions = &GetMotifPos($promoter, $motifSeq);
			print OUT "$name\t$strand\t@positions\n";

		} else {
			my $promoter = substr($chr19, $cdsEnd, 10000);
			my @positions = &GetMotifPos($promoter, $motifSeq2);
			print OUT "$name\t$strand\t@positions\n";
		}
	}
}

sub GetMotifPos()
{
	my ($seq, $motif) = @_;
	my $seqLen=length($seq);
	my $motifLen=length($motif);
	my @pos;
	my $count=0;
	for(my $i=0;$i <= $seqLen - $motifLen; $i++)
	{
		if(substr($seq,$i,$motifLen) eq $motif)
		{
			$pos[$count]=$i;
			$count++;
		}
	}
	return @pos;
 }

close IN;
close FA;
close OUT;