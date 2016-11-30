use strict;
use warnings;
use bigint;
use Math::BigInt lib => 'GMP';


my $isEncrypt;

die "Use : RSA [DECRYPT(0)/ENCRYPT(1)] [KEYS] [INPUT TEXT]" if ($#ARGV!=2);
die "Decrypt/Encrypt flag must be 0 or 1"if ( $ARGV[0] != 0 && $ARGV[0] != 1 );

$isEncrypt = $ARGV[0];
$_ = $ARGV[1];

die "Key file does not match the format" if (! m/PU\{(\d+),(\d+)\}\s*PR\{(\d+),(\d+)\}/);
my $e = $1 + 1 - 1;
my $d = $3 + 1 - 1;
my $n = $2 + 1 - 1;

#print "e = $e\nd = $d\nn=$n\n";
my $m;
my $input;
die "Input is empty" if ($ARGV[2] eq '');
if ($isEncrypt ==1 )
{
    my $input = '';
    $input = ($ARGV[2]);
    $input = "h".$input; #PAD
    my $m = (join ( '', map (sprintf ("%03d",ord), split (//,$input)) )) + 1 - 1;
    die "Input too large" if ( $m > $n );
    my $res = $m->bmodpow($e, $n);
    print $res;
}


if ($isEncrypt == 0 )
{
    $input = ($ARGV[2]);
    die "Input too large" if ( $input > $n );
    $m  = $input +1 -1;
    my $res = $m->bmodpow($d, $n);
    my $output = join ('', map(sprintf("%s",chr), ($res =~ /\d{3}/g))) . "\n";
    $output =~ s/^.//;   #remove pad
    print $output;
}
