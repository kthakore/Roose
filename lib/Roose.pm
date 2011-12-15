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
use Data::Dumper;

has '_bucket' => (is => 'rw', isa => 'HashRef[Net::Riak::Bucket]');

has '_client' => (
    is => 'rw',
	isa => 'Net::Riak'
);

has '_args' => ( is => 'rw', 
				isa => 'HashRef', 
				default => sub { 
				 { host => 'http://127.0.0.1:8091' }
							   }
				);

sub init {
	my $self = shift;
	my %params = @_ == 1 ? (host=>shift) : @_;

	my $now = delete $params{'now'};
	$self->_args( \%params );
}

sub bucket {
	my $self = shift;
	my $name = shift; 
	my %params =  %{ $self->_args};
	my $key = delete( $params{'-class'} ) || 'default';
	$self->_client( Net::Riak->new(%params) ) unless ref $self->_client;
	$self->_bucket( { $key => $self->_client->bucket( $name ) } );
	return $self->_bucket->{$key};
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


# naming templates
my %naming_template = (
    same       => sub { $_[0] },
    short      => sub { $_[0] =~ s{^.*\:\:(.*?)$}{$1}g; $_[0] },
    plural     => sub { $_[0] =~ s{^.*\:\:(.*?)$}{$1}g; lc "$_[0]s" },
    decamel    => sub { $_[0] =~ s{([a-z])([A-Z])}{$1_$2}g; lc $_[0] },
    undercolon => sub { $_[0] =~ s{\:\:}{_}g; lc $_[0] },
    lower      => sub { lc $_[0] },
    lc         => sub { lc $_[0] },
    upper      => sub { uc $_[0] },
    uc         => sub { uc $_[0] },
    default => sub {
        $_[0] =~ s{([a-z])([A-Z])}{$1_$2}g;
        $_[0] =~ s{\:\:}{_}g;
        lc $_[0];
    }
);
subtype 'Roose::CodeRef' => as 'CodeRef';
coerce 'Roose::CodeRef'
    => from 'Str' => via {
        my $template = $naming_template{ $_[0] }
            or die "naming template '$_[0]' not found";
        return $template;
    }
    => from 'ArrayRef' => via {
        my @filters;
        for( @{ $_[0] } ) {
            my $template = $naming_template{ $_ }
                or die "naming template '$_' not found";
            # add filter to list
            push @filters, sub { 
                my $name = shift;
                return $template->($name);
            } 
        }
        # now, accumulate all filters
        return sub {
            my $name = shift;
            map { $name = $_->($name) } @filters;
            return $name;
        }
    };

has 'naming' => (
    is      => 'rw',
    isa     => 'Roose::CodeRef',
    coerce  => 1,
    default => sub {$naming_template{default} }
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
