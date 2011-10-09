
use strict;
use warnings;

use 5.010;

use ExtUtils::MakeMaker 6.30;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Apply iTunes-like metadata to an mp4 file.",
  "AUTHOR" => "Andrew Jones <andrew\@arjones.co.uk>",
  "BUILD_REQUIRES" => {
    "App::Cmd::Tester" => 0,
    "English" => 0,
    "Test::More" => 0
  },
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.30"
  },
  "DISTNAME" => "App-MP4Meta",
  "EXE_FILES" => [
    "bin/mp4meta"
  ],
  "LICENSE" => "perl",
  "NAME" => "App::MP4Meta",
  "PREREQ_PM" => {
    "App::Cmd::Setup" => 0,
    "AtomicParsley::Command" => 0,
    "AtomicParsley::Command::Tags" => 0,
    "File::Copy" => 0,
    "File::Spec" => 0,
    "File::Temp" => 0,
    "IMDB::Film" => 0,
    "LWP::Simple" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "VERSION" => "1.112820",
  "test" => {
    "TESTS" => "t/*.t t/film/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



