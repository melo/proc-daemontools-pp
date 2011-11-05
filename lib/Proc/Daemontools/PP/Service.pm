package Proc::Daemontools::PP::Service;

# ABSTRACT: a Daemontools supervised service

use strict;
use warnings;
use Carp;

# VERSION
# AUTHORITY

sub new {
  my ($class, $dir) = @_;

  croak("Could not read directory '$dir': $!") unless -r $dir;

  return bless \$dir, $class;
}

1;
