use 5.010;
use strict;
use warnings;

package App::MP4Meta;
{
  $App::MP4Meta::VERSION = '1.130420';
}

# ABSTRACT: Apply iTunes-like metadata to an mp4 file.

use App::Cmd::Setup -app;

1;



=pod

=head1 NAME

App::MP4Meta - Apply iTunes-like metadata to an mp4 file.

=head1 VERSION

version 1.130420

=head1 DESCRIPTION

The C<mp4meta> command applies iTunes-like metadata to an mp4 file. The metadata is obtained by parsing the filename and searching the Internet to find its title, description and cover image, amongst others.

=head2 film

The C<film> command parses the filename and searches the IMDB for film metadata. See L<App::MP4Meta::Command::film> for more information.

=head2 tv

The C<tv> command parses the filename and searches the TVDB and the IMDB for TV Series metadata. See L<App::MP4Meta::Command::tv> for more information.

=head2 musicvideo

The C<musicvideo> command parses the filename in order to get the videos artist and song title. See L<App::MP4Meta::Command::musicvideo> for more information.

=head1 AUTHOR

Andrew Jones <andrew@arjones.co.uk>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Andrew Jones.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


__END__

