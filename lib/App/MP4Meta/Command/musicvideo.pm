use 5.010;
use strict;
use warnings;

package App::MP4Meta::Command::musicvideo;
{
  $App::MP4Meta::Command::musicvideo::VERSION = '1.120500';
}

# ABSTRACT: Apply metadata to a music video. Parses the filename in order to get its artist and title.

use App::MP4Meta -command;


sub usage_desc { "musicvideo %o [file ...]" }

sub abstract {
'Apply metadata to a music video. Parses the filename in order to get its artist and title.';
}

sub opt_spec {
    return (
        [ "genre=s",     "The genre of the music video" ],
        [ "coverfile=s", "The location of the cover image" ],
        [ "title=s",     "The title of the music video" ],
        [ "noreplace", "Don't replace the file - creates a temp file instead" ],
    );
}

sub validate_args {
    my ( $self, $opt, $args ) = @_;

    # we need at least one file to work with
    $self->usage_error("too few arguments") unless @$args;

    # check each file
    for my $f (@$args) {
        unless ( -e $f ) {
            $self->usage_error("$f does not exist");
        }
        unless ( -r $f ) {
            $self->usage_error("can not read $f");
        }

        # TODO: is $f an mp4?
    }
}

sub execute {
    my ( $self, $opt, $args ) = @_;

    require App::MP4Meta::MusicVideo;
    my $mv = App::MP4Meta::MusicVideo->new(
        {
            noreplace => $opt->{noreplace},
            genre     => $opt->{genre},
            title     => $opt->{title},
            coverfile => $opt->{coverfile},
        }
    );

    for my $file (@$args) {
        my $error = $mv->apply_meta($file);
        say $error if $error;
    }
}

1;

__END__
=pod

=head1 NAME

App::MP4Meta::Command::musicvideo - Apply metadata to a music video. Parses the filename in order to get its artist and title.

=head1 VERSION

version 1.120500

=head1 SYNOPSIS

  mp4meta musicvideo "Michael Jackson vs Prodigy - Bille Girl.m4v"

This command applies metadata to one or more music videos. It parses the filename in order to get the videos artist and title.

It currently supports the following file formats:

  artist - title.m4v

By default, it will apply the metadata to the existing file. If you want it to write to a temporary file and leave the existing file untouched, provide the C<--noreplace> option.

=head1 AUTHOR

Andrew Jones <andrew@arjones.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Andrew Jones.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

