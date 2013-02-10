use 5.010;
use strict;
use warnings;

package App::MP4Meta::Source::IMDB;
{
  $App::MP4Meta::Source::IMDB::VERSION = '1.130410';
}

# ABSTRACT: Fetches film data from the IMDB.

use App::MP4Meta::Source::Base;
our @ISA = 'App::MP4Meta::Source::Base';

use App::MP4Meta::Source::Data::Film;

use WebService::IMDBAPI;
use File::Temp  ();
use LWP::Simple ();

use constant NAME => 'IMDB';

sub new {
    my $class = shift;
    my $args  = shift;
    my $self  = $class->SUPER::new($args);

    $self->{imdb} = WebService::IMDBAPI->new();

    return $self;
}

sub name {
    return NAME;
}

sub get_film {
    my ( $self, $args ) = @_;

    $self->SUPER::get_film($args);

    my $result = $self->{imdb}->search_by_title(
        $args->{title},
        {
            year    => $args->{year},
            limit   => 1,
            episode => 0
        }
    )->[0];

    # get cover file
    # FIXME: never set
    my $cover_file;
    unless ($cover_file) {
        $cover_file = $self->_get_cover_file( $result->poster );
    }

    return App::MP4Meta::Source::Data::Film->new(
        overview => $result->plot_simple,
        title    => $result->title,
        genre    => $result->genres->[0],
        cover    => $cover_file,
        year     => $result->year,
    );
}

# gets the cover file for the season and returns the filename
# also stores in cache
sub _get_cover_file {
    my ( $self, $url ) = @_;

    my $temp = File::Temp->new( SUFFIX => '.jpg' );
    push @{ $self->{tempfiles} }, $temp;
    if (
        LWP::Simple::is_success(
            LWP::Simple::getstore( $url, $temp->filename )
        )
      )
    {
        return $temp->filename;
    }
}

1;



=pod

=head1 NAME

App::MP4Meta::Source::IMDB - Fetches film data from the IMDB.

=head1 VERSION

version 1.130410

=head1 METHODS

=head2 name()

Returns the name of this source.

=head1 AUTHOR

Andrew Jones <andrew@arjones.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Andrew Jones.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

