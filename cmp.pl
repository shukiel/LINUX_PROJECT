#my implemantation of GNU cmp with the verbose and print-byte option on

use strict;
use warnings;
use Term::ANSIColor;


die "Illegal use\ncmp [file1] [file2]" if ($#ARGV != 1);

open(my $f1, '<', $ARGV[0]) || die "Cannot open file $ARGV[0]\n";
open(my $f2, '<', $ARGV[1]) || die "Cannot open file $ARGV[1]\n";

my $b1;
my $b2;
my $count = 0;

while (1)
{
	read ($f1, $b1, 1) or die "EOF on $ARGV[0]" ;
	read ($f2, $b2, 1) or die "EOF on $ARGV[1]" ;

	#print $b1 eq $b2 ? color("yellow") : color("red") ,++$count."\t".ord($b1)." - \Q$b1\E\t".ord($b2)." - \Q$b2\E\n", color("reset");
	$b1 eq $b2 ? color("yellow") : color("red");
	colored ( printf("%-5s : %-3s %-2s \t %-3s %-2s\n",++$count, ord($b1), $b1, ord($b2), $b2 ), $b1 eq $b2 ? "yellow" : "red" );
	color("reset");
}

