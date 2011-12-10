package Roose::Document;
{
	$Roose::Document::VERSION = '0.11';
}

use strict;
use Roose;
use MooseX::Role::Parameterized;
use Roose::Meta::AttributeTraits;

parameter '-engine' => ( isa => 'Roose::Role::Engine', );
parameter '-bucket_name' => ( isa => 'Str', );
parameter '-pk' => ( isa => 'ArrayRef[Str]', );
parameter '-as' => ( isa => 'Str', );

role {
    my $p          = shift;
    my %args       = @_;
    my $class_name = $args{consumer}->name;

    my $bucket_name = $p->{'-bucket_name'} || do {
        # sanitize the class name
        Roose->naming->("$class_name");
    };

    # load the selected engine
    my $engine = $p->{'-engine'} || 'Roose::Engine::Base';
    Class::MOP::load_class($engine);

    # import the engine role into this class
    with $engine;

    # attributes
    has '_id' =>
      ( is => 'rw', isa => 'MongoDB::OID', traits => ['DoNotRooseSerialize'] );

    my $config = {
        pk              => $p->{'-pk'},
        as              => $p->{'-as'},
        bucket_name => $bucket_name,
    };

    #method "_mxm_config" => sub{ $config };
    $class_name->meta->{roose_config} = $config;

    # aliasing
    if ( my $as = $p->{'-as'} ) {
        no strict 'refs';
        *{ $as . "::" } = \*{ $class_name . "::" };
        $as->meta->{roose_config} = $config;
    }

};



1;
