use strict;
use warnings;
use Test::More;
use lib 't/lib';
use_ok('Roose');

use RooseT; # Connects to riak db (similar to t/lib/MongooseT.pm in Mongoose)

my $bucket = bucket;

{
	package Person;
	use Moose;
	with 'Roose::Document';

	has 'name' => ( is => 'rw', isa => 'Str', required => 1 );
	has 'age' => ( is => 'rw', isa => 'Int', default => 40 );
	has 'spouse' => ( is => 'rw', isa => 'Person' );
	has 'crc' => ( is => 'rw', isa => 'Str', traits => ['DoNotRooseSerialize'], default => 'ABCD' );


}

package main;
{
	my $homer = Person->new( name => 'Homer Simpson' );
	my $id = $homer->save;

	diag 'Bucket of homer:'. $homer->bucket;
	diag $bucket;

}

done_testing();
