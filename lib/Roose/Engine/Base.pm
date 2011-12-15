package Roose::Engine::Base;
{
  $Roose::Engine::Base::VERSION = '0.11';
}

use Moose::Role;
use Params::Coerce;
use Scalar::Util qw/refaddr reftype/;
use Carp;
use List::Util qw/first/;
use Data::Dumper;

with 'Roose::Role::Collapser';
with 'Roose::Role::Expander';
with 'Roose::Role::Engine';


sub save { 
	my ($self, @scope) = @_;
	my $b = $self->bucket;
	my $document = $self->collapse( @scope );
	my $obj = $b->new_object( undef, $document );

	$obj->store;

	warn $obj->key;
	
	}
sub delete {}
sub find {}
sub find_one {}
sub query {}

sub bucket {
	my ($self, $new_bucket) = @_;
	#getter 
	# get the current bucket or make it with the bucket_name
	my $config = $self->meta->{roose_config};
	$new_bucket or return $config->{bucket} ||
	( $config->{bucket} = Roose->bucket(  $config->{bucket_name} ) );

	# setter
	my $is_singleton = ! ref $self;

	if( ref($new_bucket) eq 'Net::Riak::Bucket' )
	{
        # changing collection objects directly
        if( $is_singleton ) {
            $config->{bucket_name} = $new_bucket->name;
            return $config->{bucket} = $new_bucket;
        } else {
            my $class = ref $self;
            Carp::confess "Changing the object bucket is not currently supported. Use $class->bucket() instead";
        }
	}
	elsif( $new_bucket )
	{
        # setup a new bucket by name
        if( $is_singleton ) {
            $config->{bucket_name} = $new_bucket;
            return $config->{bucket} = Roose->bucket( $new_bucket );
        } else {
            my $class = ref $self;
            Carp::confess "Changing the object bucket is not currently supported. Use $class->bucket() instead";
        }


	}

}

sub expand {}
sub collapse {
	my ($self, @scope)= @_;
	
	if( my $duplicate = first { refaddr($self) == refaddr($_) } @scope ) {
		my $class = blessed $duplicate;
		my $ref_id = $duplicate->_id;
		return undef unless defined $class && $ref_id;
		return { '$ref' => $class->meta->{roose_config}->{bucket_name}, '$id' => $ref_id	 };
	}

	my $packed = {%$self};

}

1;
