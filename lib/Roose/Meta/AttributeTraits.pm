package Roose::Meta::AttributeTraits;
{
  $Roose::Meta::AttributeTraits::VERSION = '0.01';
}

package Roose::Meta::Attribute::Trait::Binary;
{
  $Roose::Meta::Attribute::Trait::Binary::VERSION = '0.01';
}
use strict;
use Moose::Role;

has 'column' => (
    isa             => 'Str',
    is              => 'rw',
);

has 'lazy_select' => (
    isa             => 'Bool',
    is              => 'rw',
    default         => 0,
);

# -----------------------------------------------------------------

{
    package Moose::Meta::Attribute::Custom::Trait::Binary;
{
  $Moose::Meta::Attribute::Custom::Trait::Binary::VERSION = '0.01';
}
    sub register_implementation {'Roose::Meta::Attribute::Trait::Binary'}
}

# -----------------------------------------------------------------

package Roose::Meta::Attribute::Trait::DoNotRooseSerialize;
{
  $Roose::Meta::Attribute::Trait::DoNotRooseSerialize::VERSION = '0.01';
}
use strict;
use Moose::Role;

has 'column' => (
    isa             => 'Str',
    is              => 'rw',
);

has 'lazy_select' => (
    isa             => 'Bool',
    is              => 'rw',
    default         => 0,
);

# -----------------------------------------------------------------

{
    package Moose::Meta::Attribute::Custom::Trait::DoNotRooseSerialize;
{
  $Moose::Meta::Attribute::Custom::Trait::DoNotRooseSerialize::VERSION = '0.01';
}
    sub register_implementation {'Roose::Meta::Attribute::Trait::DoNotRooseSerialize'}
}

# -----------------------------------------------------------------

{
    package Roose::Meta::Attribute::Trait::Raw;
{
  $Roose::Meta::Attribute::Trait::Raw::VERSION = '0.01';
}
    use strict;
    use Moose::Role;
}
{
    package Moose::Meta::Attribute::Custom::Trait::Raw;
{
  $Moose::Meta::Attribute::Custom::Trait::Raw::VERSION = '0.01';
}
    sub register_implementation {'Roose::Meta::Attribute::Trait::Raw'}
}

=head1 NAME

Roose::Meta::AttributeTraits - Roose related attribute traits

=head1 VERSION

version 0.01

=head1 DESCRIPTION

All Moose attribute traits used by Roose are defined here.

=head2 DoNotRooseSerialize

Makes Roose skip collapsing or expanding the attribute.

=head2 Raw

Skips unblessing of an attribute when saving an object. 

=cut

1
