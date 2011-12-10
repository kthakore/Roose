package Roose::Engine::Base;
{
  $Roose::Engine::Base::VERSION = '0.11';
}

use Moose::Role;
use Params::Coerce;
use Scalar::Util qw/refaddr reftype/;
use Carp;
use List::Util qw/first/;

with 'Roose::Role::Collapser';
with 'Roose::Role::Expander';
with 'Roose::Role::Engine';


sub save {}
sub delete {}
sub find {}
sub find_one {}
sub query {}
sub collection {}

sub expand {}
sub collapse {}

1;
