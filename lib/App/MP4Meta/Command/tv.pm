use 5.010;
use strict;
use warnings;

package App::MP4Meta::Command::tv;
{
  $App::MP4Meta::Command::tv::VERSION = '1.113520';
}

# ABSTRACT: Apply metadata to a TV Series. Parses the filename in order to get the shows title and its season and episode number.

use App::MP4Meta -command;


sub usage_desc { "tv %o [file ...]" }

sub abstract {
'Apply metadata to a TV Series. Parses the filename in order to get the shows title and its season and episode number.';
}

sub opt_spec {
    return (
        [ "genre=s",     "The genre of the TV Show" ],
        [ "coverfile=s", "The location of the cover image" ],
        [ "title=s",     "The title of the TV Show" ],
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

    require App::MP4Meta::TV;
    my $tv = App::MP4Meta::TV->new(
        {
            noreplace => $opt->{noreplace},
            genre     => $opt->{genre},
            title     => $opt->{title},
            coverfile => $opt->{coverfile},
        }
    );

    for my $file (@$args) {
        my $error = $tv->apply_meta($file);
        say $error if $error;
    }
}

1;

__END__
=pod

=head1 NAME

App::MP4Meta::Command::tv - Apply metadata to a TV Series. Parses the filename in order to get the shows title and its season and episode number.

=head1 VERSION

version 1.113520

=head1 SYNOPSIS

  mp4meta tv THE_MIGHTY_BOOSH_S1E1.m4v THE_MIGHTY_BOOSH_S1E2.m4v

  mp4meta film --noreplace 24.S01E01.m4v

This command applies metadata to one or more TV Series. It parses the filename in order to get the shows title and its season and episode number.

It gets the TV Series metadata by querying the IMDB. It then uses AtomicParsley to apply the metadata to the file.

By default, it will apply the metadata to the existing file. If you want it to write to a temporary file and leave the existing file untouched, provide the C<--noreplace> option.

=head1 AUTHOR

Andrew Jones <andrew@arjones.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Andrew Jones.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

