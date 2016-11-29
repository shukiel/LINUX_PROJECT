use Cwd;
use strict;

#print "args : $#ARGV\n";

my $d = undef;
my $argOption = undef;

if ($#ARGV == 1)
{
	#print "2 Arguments\n ";
	$d = @ARGV[1];
	$argOption = @ARGV[0];
	if (!$argOption =~ m/-[la]+/) { die "Incorrect option\n";}

}

if($#ARGV == 0)
{
	#print "one arg : \n";
	if(@ARGV[0] =~ m/-[la]+/)
	{
		print "the arg is option\n";	
		$argOption = @ARGV[0];
		$d = undef;
		
	} 

	else
	{
		#print "the arg is dir\n";
		$d = @ARGV[0];
		$argOption = undef;
	}
}


if ( ! defined $d ) 			# User didn't provided a path
{
	#print "No Dir arg\n";
	#print getcwd, "\n";
	$d = getcwd;
}

print "dir :: $d\n";

opendir(D, "$d") || die "Can't open directory $d: $!\n";
my @list = readdir(D);
closedir(D);
foreach my $f (@list) {
	if ( defined $argOption) 			#if there is options in the command
	{
		{
		    if ( $f !~ m/^\..*/ || $argOption =~ m/a/ )
			{
				if( $argOption =~ m/l/ )
				{		
					print "$f\n";
				}
				else
				{
					print "$f\t";
				}
      			}   
    		}
	}
	else 
	{
	    if ( $f !~ m/^\..*/)
		{
		    print "$f\t";
      		}   
    	}
}
print("\n");
