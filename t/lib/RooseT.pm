use strict;
use warnings;
use Roose;

my $bucket;
sub bucket { return $bucket }

$ENV{ROOSE_SKIP} and plan skip_all => 'ROOSE_SKIP is set. Test skipped'.
eval {
	$bucket = Roose->init( $ENV{ROOSEDB} ? split( /,/, $ENV{ROOSEDB} ) : undef )
};
if( $@ ) {
	$ENV{ROOSE_SKIP} = 1;
    plan skip_all =>
	'Could not find a Riak instance to connect. Set the env variable ROOSEDB if your instance is not default';
}

1;

