package Roose::Role::Engine;
{
  $Roose::Role::Engine::VERSION = '0.01';
}
use Moose::Role;

requires 'save';
requires 'delete';
requires 'find';
requires 'find_one';
requires 'query';
requires 'bucket';

=head1 name

Roose::Role::Engine

=head1 VERSION

version 0.01

=head1 DESCRIPTION

The engine role. No methods. Think of Java interfaces :). 

=cut 

1;
