use strict;
use warnings;
use bignum;
use Crypt::Primes qw( maurer );
use Crypt::Random qw( makerandom_itv);

my $e;	#public	 key index
my $d;	#private key index
my $n;  #modulo size
my $phiN;
my $p;
my $q; #temp of very large prime nums

$p = maurer( Size=>32, Verbosity=>1);
$q = maurer( Size=>32, Verbosity=>1 );
$phiN = ($p-1)*($q-1);
$n = $p * $q;

#calculate the public key index
for ( my $i=  2 ;$i<  $phiN; ++$i) 
{
	if ( euclid( $i, $phiN ) == 1 )
	{	
		if (int(rand(1000)) % 33  == 0 )	#Put a random factor in
		{
			$e = $i;
			last;
		}
	}
}

print "\n" . $e . "\n";

#calculate the private key
for ( my $i = 2 ; $i < $phiN ; $i++ )
{
	if (($e * $i) % $phiN == 1 )
	{
		$d = $i;
		print $i . "\n";
		last;
		
	}


	print "Running ... " . $i . "\n" if ($i %1000 ==0);
}


print $d . "\n";

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
