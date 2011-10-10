use 5.010;
use strict;
use warnings;

package App::MP4Meta::Base;
{
  $App::MP4Meta::Base::VERSION = '1.112830';
}

# ABSTRACT: Base class.

use AtomicParsley::Command;

sub new {
    my $class = shift;
    my $args  = shift;
    my $self  = {};

    # the path to AtomicParsley
    $self->{'ap'} = AtomicParsley::Command->new( { ap => $args->{'ap'} } );

    # if true, replace file
    $self->{'noreplace'} = $args->{'noreplace'};

    # stores tmp files which we clean up later
    $self->{'tmp_files'} = ();

    bless( $self, $class );
    return $self;
}

sub DESTROY {
    my $self = shift;

    # remove all tmp files
    for my $f ( @{ $self->{tmp_files} } ) {
        unlink $f;
    }
}

1;


__END__
=pod

=head1 NAME

App::MP4Meta::Base - Base class.

=head1 VERSION

version 1.112830

=head1 SYNOPSIS

  my $film = App::MP4Meta::Base->new( ap => 'path/to/ap' );
  $film->apply_meta( '/path/to/The_Truman_Show.m4v' );

=head1 METHODS

=head2 new( %args )

Create new object. Takes the following arguments:

=over 4

=item *

ap - Path to the AtomicParsley command. Optional.

=item *

noreplace - If true, do not replace file, but save to temp instead

=back

=head1 AUTHOR

Andrew Jones <andrew@arjones.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Andrew Jones.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

