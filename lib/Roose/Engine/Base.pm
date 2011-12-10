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
	}
sub delete {}
sub find {}
sub find_one {}
sub query {}
sub bucket {
	my ($self, $new_buck) = @_;
	}

sub expand {}
sub collapse {}

1;
