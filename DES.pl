# http://page.math.tu-berlin.de/~kant/teaching/hess/krypto-ws2006/des.htm
use strict;
	#Initial Permutation table
	my @IP = (	
		58, 50, 42, 34, 26, 18, 10, 2,
		60, 52, 44, 36, 28, 20, 12, 4,
		62, 54, 46, 38, 30, 22, 14, 6,
		64, 56, 48, 40, 32, 24, 16, 8,
		57, 49, 41, 33, 25, 17, 9,  1,
		59, 51, 43, 35, 27, 19, 11, 3,
		61, 53, 45, 37, 29, 21, 13, 5,
		63, 55, 47, 39, 31, 23, 15, 7);
	
	#Permuted Choice 1 table
	my @PC1 = (	
		57, 49, 41, 33, 25, 17, 9,
		1,  58, 50, 42, 34, 26, 18,
		10, 2,  59, 51, 43, 35, 27,
		19, 11, 3,  60, 52, 44, 36,
		63, 55, 47, 39, 31, 23, 15,
		7,  62, 54, 46, 38, 30, 22,
		14, 6,  61, 53, 45, 37, 29,
		21, 13, 5,  28, 20, 12, 4);
	
	#Permuted Choice 2 table
	my @PC2 = (	
		14, 17, 11, 24, 1,  5,
		3,  28, 15, 6,  21, 10,
		23, 19, 12, 4,  26, 8,
		16, 7,  27, 20, 13, 2,
		41, 52, 31, 37, 47, 55,
		30, 40, 51, 45, 33, 48,
		44, 49, 39, 56, 34, 53,
		46, 42, 50, 36, 29, 32);
	
	my @shifts = (1, 1, 2, 2, 2, 2, 2, 2, 1, 2, 2, 2, 2, 2, 2, 1);
	
	#Expansion (aka P-box) table
	my @E = (
		32, 1,  2,  3,  4,  5,
		4,  5,  6,  7,  8,  9,
		8,  9,  10, 11, 12, 13,
		12, 13, 14, 15, 16, 17,
		16, 17, 18, 19, 20, 21,
		20, 21, 22, 23, 24, 25,
		24, 25, 26, 27, 28, 29,
		28, 29, 30, 31, 32, 1);
	
	#S-boxes (i.e. Substitution boxes)
	my @S1 = (
		14, 4,  13, 1,  2,  15, 11, 8,  3,  10, 6,  12, 5,  9,  0,  7,
		0,  15, 7,  4,  14, 2,  13, 1,  10, 6,  12, 11, 9,  5,  3,  8,
		4,  1,  14, 8,  13, 6,  2,  11, 15, 12, 9,  7,  3,  10, 5,  0,
		15, 12, 8,  2,  4,  9,  1,  7,  5,  11, 3,  14, 10, 0,  6,  13);
	my @S2 = (
		15, 1,  8,  14, 6,  11, 3,  4,  9,  7,  2,  13, 12, 0,  5,  10,
		3,  13, 4,  7,  15, 2,  8,  14, 12, 0,  1,  10, 6,  9,  11, 5,
		0,  14, 7,  11, 10, 4,  13, 1,  5,  8,  12, 6,  9,  3,  2,  15,
		13, 8,  10, 1,  3,  15, 4,  2,  11, 6,  7,  12, 0,  5,  14, 9);
	my @S3 = (
		10, 0,  9,  14, 6,  3,  15, 5,  1,  13, 12, 7,  11, 4,  2,  8,
		13, 7,  0,  9,  3,  4,  6,  10, 2,  8,  5,  14, 12, 11, 15, 1,
		13, 6,  4,  9,  8,  15, 3,  0,  11, 1,  2,  12, 5,  10, 14, 7,
		1,  10, 13, 0,  6,  9,  8,  7,  4,  15, 14, 3,  11, 5,  2,  12);
	my @S4 = (
		7,  13, 14, 3,  0,  6,  9,  10, 1,  2,  8,  5,  11, 12, 4,  15,
		13, 8,  11, 5,  6,  15, 0,  3,  4,  7,  2,  12, 1,  10, 14, 9,
		10, 6,  9,  0,  12, 11, 7,  13, 15, 1,  3,  14, 5,  2,  8,  4,
		3,  15, 0,  6,  10, 1,  13, 8,  9,  4,  5,  11, 12, 7,  2,  14);
	my @S5 = (
		2,  12, 4,  1,  7,  10, 11, 6,  8,  5,  3,  15, 13, 0,  14, 9,
		14, 11, 2,  12, 4,  7,  13, 1,  5,  0,  15, 10, 3,  9,  8,  6,
		4,  2,  1,  11, 10, 13, 7,  8,  15, 9,  12, 5,  6,  3,  0,  14,
		11, 8,  12, 7,  1,  14, 2,  13, 6,  15, 0,  9,  10, 4,  5,  3);
	my @S6 = (
		12, 1,  10, 15, 9,  2,  6,  8,  0,  13, 3,  4,  14, 7,  5,  11,
		10, 15, 4,  2,  7,  12, 9,  5,  6,  1,  13, 14, 0,  11, 3,  8,
		9,  14, 15, 5,  2,  8,  12, 3,  7,  0,  4,  10, 1,  13, 11, 6,
		4,  3,  2,  12, 9,  5,  15, 10, 11, 14, 1,  7,  6,  0,  8,  13);
	my @S7 = (
		4,  11, 2,  14, 15, 0,  8,  13, 3,  12, 9,  7,  5,  10, 6,  1,
		13, 0,  11, 7,  4,  9,  1,  10, 14, 3,  5,  12, 2,  15, 8,  6,
		1,  4,  11, 13, 12, 3,  7,  14, 10, 15, 6,  8,  0,  5,  9,  2,
		6,  11, 13, 8,  1,  4,  10, 7,  9,  5,  0,  15, 14, 2,  3,  12);
	my @S8 = (
		13, 2,  8,  4,  6,  15, 11, 1,  10, 9,  3,  14, 5,  0,  12, 7,
		1,  15, 13, 8,  10, 3,  7,  4,  12, 5,  6,  11, 0,  14, 9,  2,
		7,  11, 4,  1,  9,  12, 14, 2,  0,  6,  10, 13, 15, 3,  5,  8,
		2,  1,  14, 7,  4,  10, 8,  13, 15, 12, 9,  0,  3,  5,  6,  11);
		
	#Permutation table
	my @P = (
		16, 7,  20, 21,
		29, 12, 28, 17,
		1,  15, 23, 26,
		5,  18, 31, 10,
		2,  8,  24, 14,
		32, 27, 3,  9,
		19, 13, 30, 6,
		22, 11, 4,  25);

	#Final permutation (aka Inverse permutation) table
	my @FP = (
		40, 8, 48, 16, 56, 24, 64, 32,
		39, 7, 47, 15, 55, 23, 63, 31,
		38, 6, 46, 14, 54, 22, 62, 30,
		37, 5, 45, 13, 53, 21, 61, 29,
		36, 4, 44, 12, 52, 20, 60, 28,
		35, 3, 43, 11, 51, 19, 59, 27,
		34, 2, 42, 10, 50, 18, 58, 26,
		33, 1, 41, 9, 49, 17, 57, 25);

		
sub generateSubKeys { # gets key as 8 chars.
	my($key)=@_;
	
	my @KEY = string2BitsArr($key);#split('',$key);
	my @permutedPC1 = permut(\@KEY,\@PC1);
	#split to c and d:
	my @c = @permutedPC1[0..27];
	my @d = @permutedPC1[28..55];
	my @cd; 
	my $i = 0;
	my @subKeys; 
	#shift
	for $a (@shifts){
		@c = cycleLeftShift(\@c,$a);
		@d = cycleLeftShift(\@d,$a);
		@cd = (@c , @d) ;
		my @Ki = permut(\@cd,\@PC2);
		$subKeys[$i++] =  join('',@Ki);
	}
	return @subKeys;
}
sub cycleLeftShift { #gets an array of bites and returns the cycledPermutation as string.
	my ($one_ref, $shifts) = @_;
	my @bitsToShift = @{ $one_ref }; 
	my @new;
	my $j = 0;
	for (my $i = $shifts ; $i < @bitsToShift ; $i++){
		$new[$j++]= $bitsToShift[$i];
	}
	for (my $i =0 ; $i < $shifts ; $i++){
		$new[$j++] = $bitsToShift[$i];
	}
	return @new;	
}
	
sub permut { #gets an array of bites and returns the permutation of it.
	my ($one_ref, $two_ref) = @_;
	my @bitsToPermut = @{ $one_ref }; 
	my @PermutationMatrix = @{ $two_ref };
	my @new;
	my $i = 0;
	for $a (@PermutationMatrix){
		$new[$i++] = $bitsToPermut[$a -1];
	}
	return @new;	
}
sub string2BitsArr {
  my($s)=@_;
  my $r;
  my $bin = "";
  for (my $i=0; $i<length($s); $i++)
  {
	  $r = unpack("C8",substr($s,$i,1));
	  $bin.= sprintf("%08b",$r); 
  }
  my @binArr = split('',$bin);
  return @binArr;
}

sub bin2char {
    return pack("C",unpack("N", pack("B32", substr("0" x 32 . shift, -32))));
}

sub bin2dec {
    return unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
}

sub bin2Hexa{
	my($s)=@_;
	my $r;
	my $bin = "";
	for (my $i=0; $i<length($s); $i+=4)
	{
		$r = substr($s,$i,4);
		$bin.= sprintf("%X", oct( "0b$r" ) );
	}
	return $bin;
}
sub bin2String{
	my($s)=@_;
	my $r;
	my $bin = "";
	for (my $i=0; $i<length($s); $i+=8)
	{
		$r = bin2char(substr($s,$i,8));
		$bin.= $r;
	}
	return $bin;
}

sub xorBitArr { 
	my ($one_ref, $two_ref) = @_;
	my @first = @{ $one_ref }; 
	my @second = @{ $two_ref };
	my @new;
	for (my $i=0; $i<@first; $i++){
		$new[$i] = ($first[$i] + $second[$i])%2
	}
	return @new;	
}
sub fFunc {
	my ($one_ref, $two_ref) = @_;
	my @r = @{ $one_ref };
	my @key = @{ $two_ref }; 
	my @permutedE = permut(\@r,\@E);
	my @xor = xorBitArr(\@permutedE,\@key);
	my $xor = join('',@xor);
	my $r1 = substr($xor,0,6);
	my $r2 = substr($xor,6,6);
	my $r3 = substr($xor,12,6);
	my $r4 = substr($xor,18,6);
	my $r5 = substr($xor,24,6);
	my $r6 = substr($xor,30,6);
	my $r7 = substr($xor,36,6);
	my $r8 = substr($xor,42,6);
	my $s = getFromS($r1, \@S1) . getFromS($r2, \@S2) . getFromS($r3, \@S3) . getFromS($r4, \@S4) . getFromS($r5, \@S5) .  getFromS($r6, \@S6) . getFromS($r7, \@S7) . getFromS($r8, \@S8); 
	my @s = split('', $s);
	my @f = permut(\@s,\@P);
	return @f;
}
sub getFromS {
	my ($binNumber, $S_ref) = @_;
	my @s = @{ $S_ref };
	my $row = bin2dec(substr($binNumber, 0, 1) . substr($binNumber, 5, 1));
	my $col = bin2dec(substr($binNumber, 1, 4));
	my $i = $row*16 + $col;
	my $fromS = sprintf("%04b",$s[$i]);
	return $fromS;
}
sub des {
	my ($key, $msg,$isEncrypt) = @_;
	my @subKeys = generateSubKeys($key);
	my @MSG = string2BitsArr($msg);
	my @permutedIP = permut(\@MSG,\@IP);
	my @L = @permutedIP[0..31];
	my @R = @permutedIP[32..63];
	
	for (my $i=0; $i<@subKeys; $i++){
		my @curK = ($isEncrypt== 1) ? split('',$subKeys[$i]) : split('',$subKeys[15 - $i]);
		my @lNew = @R;
		my @f = fFunc(\@R,\@curK,);
		my @rNew = xorBitArr(\@L,\@f);
		@R = @rNew;
		@L = @lNew;
	}
	my @rl = (@R, @L);
	my @crypt = permut(\@rl,\@FP);
	my $crypt = bin2String(join('',@crypt));
	return $crypt;
}

if ($#ARGV != 2)
{
    die "use - des [msg] [key] [decrypt_flag]";
}

my $key = ($ARGV[0]);
my $msg = ($ARGV[1]);

if ( $ARGV[2] == 1 )
{
    my $crypt = des($key,$msg,1);
    print $crypt ;
}

elsif ( $ARGV[2] ==  0)
{
    my $decrypt = des($key, $msg, 0);
    print $decrypt;
}

else
{
	die "0 - for decrypt\t1 - for encrypt";
}


#my $key= '0001001100110100010101110111100110011011101111001101111111110001';
#my $msg = '0000000100100011010001010110011110001001101010111100110111101111';
#print "msg = $msg\n";
exit(0);