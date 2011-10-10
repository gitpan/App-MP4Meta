use 5.010;
use strict;
use warnings;

package App::MP4Meta::Film;
{
  $App::MP4Meta::Film::VERSION = '1.112830';
}

# ABSTRACT: Add metadata to a film

use App::MP4Meta::Base;
our @ISA = 'App::MP4Meta::Base';

use IMDB::Film '0.50';

use LWP::Simple '5.835';
use File::Spec '3.33';
use File::Temp '0.22', ();
use File::Copy;

use AtomicParsley::Command;
use AtomicParsley::Command::Tags;

sub apply_meta {
    my ( $self, $path ) = @_;

    # get the file name
    my ( $volume, $directories, $file ) = File::Spec->splitpath($path);

    # parse the filename for the film title and optional year
    my ( $title, $year ) = $self->_parse_filename($file);

    # get data from IMDB
    my $imdb = $self->_query_imdb( $title, $year );
    unless ($imdb) {
        return "Error: could not find '$title' on the IMDB (for $path)";
    }

    # try and get a cover file
    my $cover_file;
    if ( $imdb->cover ) {
        $cover_file = $self->_get_cover_image( $imdb->cover );
    }

    my @genres = @{ $imdb->genres };
    my $genre  = $genres[0];

    my $tags = AtomicParsley::Command::Tags->new(
        title       => $imdb->title,
        description => $imdb->storyline,
        genre       => $genre,
        year        => $imdb->year,
        artwork     => $cover_file
    );

    my $tempfile = $self->{ap}->write_tags( $path, $tags, !$self->{noreplace} );

    if ( !$self->{ap}->{success} ) {
        return $self->{ap}->{'stdout_buf'}[0];
    }

    if ( !$tempfile ) {
        return "Error writing to file";
    }
    return;
}

# Parse the filename in order to get the film title. Returns the title.
sub _parse_filename {
    my ( $self, $file ) = @_;

    # strip suffix
    $file =~ s/\.m4v$//;

    # is there a year?
    my $year;
    if ( $file =~ s/(\d\d\d\d)$// ) {
        $year = $1;
        chop $file;
    }

    # make space
    $file =~ s/(-|_)/ /g;

    return ( $file, $year );
}

# Make a query to imdb and get the film data.
# Returns undef if we couldn't find the film.
# Returns an IMDB::Film object.
sub _query_imdb {
    my ( $self, $title, $year ) = @_;

    my $imdb = IMDB::Film->new( crit => $title, year => $year );

    if ( $imdb->status ) {
        return $imdb;
    }
    return;
}

# Gets the cover image and stores in a tmp file
sub _get_cover_image {
    my ( $self, $cover_url ) = @_;

    if ( $cover_url =~ m/\.(jpg|png)$/ ) {
        my $tmp = File::Temp->new( UNLINK => 0, SUFFIX => ".$1" );

        # save the tmp file for later
        push @{ $self->{tmp_files} }, $tmp->filename;

        # get the cover image
        getstore( $cover_url, $tmp->filename );

        # return cover file
        return $tmp->filename;
    }
    else {

        # can't use cover
        return;
    }
}

1;


__END__
=pod

=head1 NAME

App::MP4Meta::Film - Add metadata to a film

=head1 VERSION

version 1.112830

=head1 SYNOPSIS

  my $film = App::MP4Meta::Film->new;
  $film->apply_meta( '/path/to/The_Truman_Show.m4v' );

=head1 METHODS

=head2 apply_meta( $path )

Apply metadata to the file at this path.

Returns undef if success; string if error.

=head1 AUTHOR

Andrew Jones <andrew@arjones.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Andrew Jones.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

