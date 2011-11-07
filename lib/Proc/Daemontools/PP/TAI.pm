package Proc::Daemontools::PP::TAI;

# ABSTRACT: minimal set of TAI utilities

use strict;
use warnings;

# VERSION
# AUTHORITY

sub new {
  my ($class, $h, $l) = @_;

  # TODO: accept single 64-bit value (undef $l)

  return bless [$h, $l], $class;
}

sub time {
  my ($class, $t) = @_;

# cf tai.h, tai_unix macro, magic constant 4611686018427387914ULL
# 4611686018427387914ULL == 1073741824 * 2^32 + 10
# we assume 32bit Perl for now, I don't have a single 64bit CPU to test 64bit version of this
# TODO: check $Config{intsize}, and if 8, use 64bit version of this code, simpler

  my $h = 1073741824;
  if ($t >= 4294967286) {    ## 2^32-10 + 10 => would overflow
    $t -= 4294967286;        ## === $t + 10 % 2^32
    $h++;
  }
  else {
    $t += 10;
  }

  return $class->new($h, $t);
}

sub now { shift->time(CORE::time()) }

sub epoch {
  my ($self) = @_;
  my ($h, $l) = @$self;

  # TODO: can we check for 64-bit clean localtime()?
  die "Epoch overflow (for 32bit systems, 31bit epoch) H:$h L:$l"
    if $h != 1073741824
      or $l > 2147483657
      or $l < 10;

  return $l - 10;
}

sub cmp {
  my ($self, $other) = @_;
  return $self->[0] <=> $other->[0] || $self->[1] <=> $other->[1];
}

1;
