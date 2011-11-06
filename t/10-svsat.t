#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More;
use MyTests;
use File::Spec::Functions 'catdir', 'catfile';
use Fcntl qw(O_RDONLY O_NDELAY);
use POSIX 'mkfifo';

my $t = 'MyTests';
my $case = sub { catdir('t/tlib/test_cases', @_) };

subtest 'normally up' => sub {
  my $dt = $t->service($case->('case_1'));
  ok($dt->is_normally_up, 'is_normally_up() shoud be true');
};

subtest 'normally down' => sub {
  my $dt = $t->service($case->('case_2'));
  ok(!$dt->is_normally_up, 'is_normally_up() shoud be true');
};

subtest 'is down' => sub {
  my $dt = $t->service($case->('case_1'));
  is($dt->is_running, undef, 'is_running() shoud be undef for case_1');

  $dt = $t->service($case->('case_2'));
  is($dt->is_running, undef, 'is_running() shoud be undef for case_2');
};

subtest 'is up' => sub {
  my $ok = catfile($case->('case_3'), 'supervise', 'ok');
  unlink($ok);
  mkfifo($ok, 0755)
    or die "Failed to create FIFO '$ok': $!";

  my $dt = $t->service($case->('case_3'));
  is($dt->is_running, 0,
    'is_running() shoud be false but defined (fifo exists)');

  sysopen(my $fifo, $ok, O_RDONLY|O_NDELAY)
    or die "Failed to open FIFO '$ok' for reading: $!";

  is($dt->is_running, 1, 'is_running() true');
};


done_testing();
