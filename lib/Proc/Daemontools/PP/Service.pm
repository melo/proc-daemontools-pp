package Proc::Daemontools::PP::Service;

# ABSTRACT: a Daemontools supervised service

use strict;
use warnings;
use Carp;
use File::Spec::Functions 'catfile';

# VERSION
# AUTHORITY

sub new {
  my ($class, $dir) = @_;

  croak("Could not read directory '$dir': $!") unless -r $dir;

  return bless \$dir, $class;
}

# cf svstat.c, lines 44-53
sub is_normally_up {
  my $self = shift;

  return !-e catfile($$self, 'down');
}


1;
