package Proc::Daemontools::PP::Service;

# ABSTRACT: a Daemontools supervised service

use strict;
use warnings;
use Carp;
use File::Spec::Functions 'catfile';
use Fcntl qw(O_WRONLY O_NDELAY);
use Errno qw(ENXIO);

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

# cf svstat.c, lines 55-66
sub is_running {
  my $self = shift;

  my $is_running = sysopen(my $fh, catfile($$self, 'supervise', 'ok'), O_WRONLY | O_NDELAY);
  my $errno = $!;
  close($fh);

  return 1 if $is_running;
  return 0 if $errno == ENXIO;
  return undef;
}

1;
