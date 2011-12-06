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

sub bucket {
	my $self = shift;
	my %params = @_ == 1 ? (db_name=>shift) : @_;

	my $now = delete $params{'now'};
	$self->_args( \%params );
	return $self->connect if $now || defined wantarray;
}

sub connect {
	my $self = shift;
	my %params = @_ || %{ $self->_args};
	my $key = delete( $params{'-class'} ) || 'default';
	$self->_client( Net::Riak->new(%params) ) unless ref $self->_client;

	$self->_bucket( { $key => $self->_client->bucket( $params{key} ) } );
}

sub disconnect {
	my $self = shift;
	$self->_client and $self->_client(undef);
}

sub connection {
	my $self = shift;
	$self->_client and return $self->_client;
	$self->connect and return $self->_client;
}

sub _bucket_for_class {
	my ($self, $class ) = @_;
	return $self->_bucket->{$class} || $self->_bucket->{default} if defined $self->_bucket;
	return $self->connect;
}


sub load_schema {
	my ($self, %args) = @_;
	require Module::Pluggable;
	my $shorten = delete $args{shorten};
	my $search_path = delete $args{search_path};
	Module::Pluggable->import ( search_path => $search_path );
	for my $module ($self->plugins ) {
		eval "require $module";
		croak $@ if $@; 
		if ($shorten && $module =~ m/$search_path\:\:(.*?)$/ ) {
			my $short_name = $1;

			no strict 'refs';
			*{ $short_name . "::" } = \*{ $module . "::" };
			$short_name->meta->{roose_config} =
			$module->meta->{roose_config};

		}
	}


}

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
