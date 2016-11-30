use strict;
use warnings;
use bignum;
use Math::BigInt;
use Crypt::Primes qw( maurer );
use Crypt::Random qw( makerandom_itv);

my $e;	#public	 key index
my $d;	#private key index
my $n;  #modulo size
my $phiN;
my $p;
my $q; #temp of very large prime nums

$p = maurer( Size=>128, Verbosity=>0);
$q = maurer( Size=>128, Verbosity=>0);
$phiN = ($p-1)*($q-1);
$n = $p * $q;


#calculate the public key index
for ( my $i=  2 ;$i<  $phiN; ++$i) 
{
	if ( euclid( $i, $phiN ) == 1 )
	{	
		if (int(rand(10000)) % 1234  == 0 )	#Put a random factor in
		{
			$e = $i;
			last;
		}
	}
}

my $x = $e ** 1;

my $mod = $phiN;
  
$x->bmodinv($mod);    # modular multiplicative inverse
$d = $x;

print "PU{$e,$n}\tPR{$d,$n}";

#function that will find the GCD of 2 numbers
sub euclid 
{
   my( $a, $b ) = @_;
 return ($b) ? euclid( $b, $a % $b ) : $a;
}

=pod

sub getPrime
{
	my ( $minBits ) = @_;
	my $start = 2 ** $minBits;
	my $randAdd  = rand( 2** ( $minBits +1) - 2**$minBits );
	
	$start+=$randAdd;
	
}

=cut
