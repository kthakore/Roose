use strict;
use warnings;
use lib 'lib';
use Roose;
{
	package Person;
	use Moose;
	with 'Roose::Document';

	has 'name' => ( is => 'rw', isa => 'Str', required => 1 );
	has 'age' => ( is => 'rw', isa => 'Int', default => 40 );
	has 'spouse' => ( is => 'rw', isa => 'Person' );
	has 'crc' => ( is => 'rw', isa => 'Str', traits => ['DoNotRooseSerialize'], default => 'ABCD' );

}
{
package main;
 Roose->init( 'http://127.0.0.1:8091');

my $homer = Person->new( name => 'Homer' );
$homer->save();

}
