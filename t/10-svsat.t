#!perl

use strict;
use warnings;
use lib 't/tlib';
use Test::More;
use MyTests;

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
};


done_testing();
