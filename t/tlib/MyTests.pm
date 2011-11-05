package MyTests;

use strict;
use warnings;
use Test::More;
use Test::Fatal;
use Proc::Daemontools::PP::Service;

sub service {
  my ($class, @rest) = @_;

  local $Test::Builder::Level = $Test::Builder::Level + 1;

  my $dt;
  is(exception { $dt = Proc::Daemontools::PP::Service->new(@rest) },
    undef, 'Create P::D::PP::Service ok');
  ok($dt,                                        '... got something');
  ok($dt->isa('Proc::Daemontools::PP::Service'), '... of the proper type');

  return $dt;
}


1;
