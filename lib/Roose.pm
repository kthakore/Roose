use strict;
use warnings;
package Roose;
{
	$Roose::VERSION = '0.11';
}
use Net::Riak;
use MooseX::Singleton;
use Moose::Util::TypeConstraints;
use Carp;

has '_bucket' => (is => 'rw', isa => 'HashRef[Net::Riak::Bucket]');

has '_client' => (
    is => 'rw',
	isa => 'Net::Riak::Client'
);

has '_args' => ( is => 'rw', 
				isa => 'HashRef', 
				default => sub { 
				 { host => 'http://127.0.0.1:8091' }
							   }
				);


1;

=pod

=head1 NAME

Roose - Riak document to Moose object mapper

=head1 VERSION

version 0.01

=head1 SYNOPSIS

Nothing yet

=head1 REPOSITORY

To go on github: L<http://github.com/kthakore/roose>

=head1 BUGS

Based on a WIP module C<Mongoose>. So very *alpha*.

Report bugs via RT. Send test cases :) .

=head1 TODO

* Translate over C<Mongoose> 

=head1 SEE ALSO

L<Mongoose>, L<KiokuDB>

=head1

	kthakore, C<kthakore@cpan.org>

=head1 LICENSE

This library is free software. You can redistribute it and/or modify it under
the same terms as Perl itself.
