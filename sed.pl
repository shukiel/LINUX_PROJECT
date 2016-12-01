#!/usr/bin/perl

use Cwd;
use strict;

#print "args : $#ARGV\n";

my $input 	 = undef;
my $startFlag	 = undef;
my $firstStr	 = undef;
my $secondStr	 = undef;
my $lastFlag 	 = undef;
my $output	 = undef;
my $repeat	 = 1;
my @matchs;


if ($#ARGV != 1)
{
	#No Arguments
	die "Please enter command and input as arguments\n";
}

#print "0 :: $ARGV[0]\n";
#print "1 :: $ARGV[1]\n";

#check the command
$_ = $ARGV[0];
#m([^/\\]
if (! m/\'?(s?)\/(\"?(?:(?:\\\/)?[^\/](?:\\\/)?)+\"?)\/(\"?(?:(?:\\\/)?[^\/](?:\\\/)?)*\"?\/?)([gi]{0,2})(\d*)\'?/ )
{
	die "Command not in right format";
}


$startFlag = $1;
$firstStr  = $2;
$secondStr = $3;
$lastFlag  = $4;
$repeat    = $5 ne '' ? $5 : 1;

#print $2 . "\n";

#remove the / after the second string
if ($secondStr ne '')
{
	$secondStr =  substr $secondStr, 0, -1;
}

#remove quotes in case there are any...
$firstStr =~ s/\"//g;
$secondStr =~ s/\"//g;


$input  = $ARGV[1];

#print "Old :: $firstStr\t New :: $secondStr" . "\tStartFlag :: $startFlag\t EndFlag :: $lastFlag\t". "Repeat :: $repeat:\n";

if ($startFlag eq 's')		#Replace
{
	my $count = 0;
	if (! defined $secondStr)
		{die "The input does not match the function\n";}	
	#print "Replace\n";
	#print "Input :: $input\n";
	if ($lastFlag =~ m/ig|gi/)
		{@matchs = $input =~ s/($firstStr)/$secondStr/ig;}
	elsif ($lastFlag =~ m/i+/)
		{@matchs = $input =~ s/($firstStr)/++$count==$repeat ? $secondStr:$1/eig;}
	elsif ($lastFlag =~ m/g+/)
		{@matchs = $input =~ s/$firstStr/$secondStr/g;}
	else
		{@matchs = $input =~ s/($firstStr)/++$count==$repeat ? $secondStr:$1/eg;}
	$output = $input;
}

elsif ( $secondStr eq '' )	#Match!
{
	#print "Match!\n";

	if ($lastFlag =~ m/ig|gi/)
		{ @matchs = $input =~ m/\Q$firstStr/ig; }
	elsif ($lastFlag =~ m/i+/)
		{ @matchs = $input =~ m/\Q$firstStr/i; }
	elsif ($lastFlag =~ m/g+/)
		{ @matchs = $input =~ m/\Q$firstStr/g; }
	else
		{ @matchs = $input =~ /\Q$firstStr/; }
	$output = scalar @matchs;
}

else
{
	die "Match need to be in this : \"\/\<toMatch\>\/\<i\>" ;
}

print "$output";
exit $output;
