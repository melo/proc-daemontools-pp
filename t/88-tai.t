#!perl

use strict;
use warnings;
use Test::More;
use Proc::Daemontools::PP::TAI;

subtest 'TAI->time' => sub {
  my @test_cases = (
    [0,          '4611686018427387914', 1073741824, 10],
    [1,          '4611686018427387915', 1073741824, 11],
    [2,          '4611686018427387916', 1073741824, 12],
    [4,          '4611686018427387918', 1073741824, 14],
    [6,          '4611686018427387920', 1073741824, 16],
    [8,          '4611686018427387922', 1073741824, 18],
    [13,         '4611686018427387927', 1073741824, 23],
    [16,         '4611686018427387930', 1073741824, 26],
    [18,         '4611686018427387932', 1073741824, 28],
    [32,         '4611686018427387946', 1073741824, 42],
    [33,         '4611686018427387947', 1073741824, 43],
    [64,         '4611686018427387978', 1073741824, 74],
    [102,        '4611686018427388016', 1073741824, 112],
    [128,        '4611686018427388042', 1073741824, 138],
    [159,        '4611686018427388073', 1073741824, 169],
    [256,        '4611686018427388170', 1073741824, 266],
    [406,        '4611686018427388320', 1073741824, 416],
    [512,        '4611686018427388426', 1073741824, 522],
    [698,        '4611686018427388612', 1073741824, 708],
    [1024,       '4611686018427388938', 1073741824, 1034],
    [1201,       '4611686018427389115', 1073741824, 1211],
    [2048,       '4611686018427389962', 1073741824, 2058],
    [2085,       '4611686018427389999', 1073741824, 2095],
    [4096,       '4611686018427392010', 1073741824, 4106],
    [6641,       '4611686018427394555', 1073741824, 6651],
    [8192,       '4611686018427396106', 1073741824, 8202],
    [12798,      '4611686018427400712', 1073741824, 12808],
    [16384,      '4611686018427404298', 1073741824, 16394],
    [31571,      '4611686018427419485', 1073741824, 31581],
    [32768,      '4611686018427420682', 1073741824, 32778],
    [49790,      '4611686018427437704', 1073741824, 49800],
    [65536,      '4611686018427453450', 1073741824, 65546],
    [115764,     '4611686018427503678', 1073741824, 115774],
    [131072,     '4611686018427518986', 1073741824, 131082],
    [166448,     '4611686018427554362', 1073741824, 166458],
    [262144,     '4611686018427650058', 1073741824, 262154],
    [411633,     '4611686018427799547', 1073741824, 411643],
    [524288,     '4611686018427912202', 1073741824, 524298],
    [808770,     '4611686018428196684', 1073741824, 808780],
    [1048576,    '4611686018428436490', 1073741824, 1048586],
    [2044108,    '4611686018429432022', 1073741824, 2044118],
    [2097152,    '4611686018429485066', 1073741824, 2097162],
    [2631939,    '4611686018430019853', 1073741824, 2631949],
    [4194304,    '4611686018431582218', 1073741824, 4194314],
    [5304034,    '4611686018432691948', 1073741824, 5304044],
    [8388608,    '4611686018435776522', 1073741824, 8388618],
    [8852889,    '4611686018436240803', 1073741824, 8852899],
    [16777216,   '4611686018444165130', 1073741824, 16777226],
    [29366447,   '4611686018456754361', 1073741824, 29366457],
    [33554432,   '4611686018460942346', 1073741824, 33554442],
    [62911149,   '4611686018490299063', 1073741824, 62911159],
    [67108864,   '4611686018494496778', 1073741824, 67108874],
    [83921390,   '4611686018511309304', 1073741824, 83921400],
    [134217728,  '4611686018561605642', 1073741824, 134217738],
    [136069174,  '4611686018563457088', 1073741824, 136069184],
    [268435456,  '4611686018695823370', 1073741824, 268435466],
    [510299338,  '4611686018937687252', 1073741824, 510299348],
    [536870912,  '4611686018964258826', 1073741824, 536870922],
    [950121665,  '4611686019377509579', 1073741824, 950121675],
    [1073741824, '4611686019501129738', 1073741824, 1073741834],
    [1811991144, '4611686020239379058', 1073741824, 1811991154],
    [2147483647, '4611686020574871561', 1073741824, 2147483657],
    [2147483647, '4611686020574871561', 1073741824, 2147483657],

    # TODO: add these three test cases when $Config{intsize} > 4 or
    # localtime() 64bit clean
    # [2153981546, '4611686020581369460', 1073741824, 2153981556],
    # [4294967296, '4611686022722355210', 1073741825, 10],
    # [5362454315, '4611686023789842229', 1073741825, 1067487029],
  );

  for my $tc (@test_cases) {
    my ($epoch, $tai, $h, $l) = @$tc;

    my $tai_obj = Proc::Daemontools::PP::TAI->time($epoch);
    ok($tai_obj, "Got something for epoch $epoch for TAI $tai...");
    ok($tai_obj->isa('Proc::Daemontools::PP::TAI'),
      '... of the expected type');
    is($tai_obj->[0], $h, '... most significant part of TAI is correct');
    is($tai_obj->[1], $l, '... and so is the least significant part');

    is($tai_obj->epoch, $epoch, '... epoch is back just fine');
  }
};


subtest 'now()' => sub {
  my $now_t = Proc::Daemontools::PP::TAI->now;
  my $now_e = $now_t->epoch;
  my $delta = time() - $now_e;
  ok($delta == 0 || $delta == 1, 'TAI->now() works');
};


subtest 'cmp()' => sub {
  my $now = time;
  my $t1  = Proc::Daemontools::PP::TAI->time($now - 10);
  my $t2  = Proc::Daemontools::PP::TAI->time($now + 10);

  is($t1->cmp($t1), 0,  'cmp() to self returns equal');
  is($t1->cmp($t2), -1, 'cmp() to biggers returns we are less than');
  is($t2->cmp($t1), 1,  'cmp() to smallers returns we are greater than');
};


subtest 'delta()/delta_now()' => sub {
  my $now_e = time();
  my $t0    = Proc::Daemontools::PP::TAI->time($now_e);
  my $t1    = Proc::Daemontools::PP::TAI->time($now_e - 42);
  my $now_t = Proc::Daemontools::PP::TAI->now;

  is($t1->delta($t0), 42, 'delta() works ok');
  is($t0->delta($t1), 42, '... and its commutative');

  my $d = $t1->delta_now - 42;
  ok($d == 0 || $d == 1, 'delta_now() also works fine');
};

done_testing();


__END__

# tstamp => TAI test cases was calculated with the following C program
# compiled in the compile/ directory of daemontools-0.76, to make use of
# the .h detected by the ./compile of daemontools

#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include "tai.h"

void tt(unsigned long long t0) {
  struct tai t;
  unsigned long long t1;
  unsigned long long factor = 4294967296ULL;

  tai_unix(&t, t0);
  printf("%llu\t%llu\t%llu\t%llu\n",
    t0,
    t.x,
    (unsigned long long)(t.x / factor),
    (unsigned long long)(t.x % factor)
  );
  
  if (!t0) return;
  t1 = t0 + random() % t0;
  if (t1 == t0) return;
  
  tai_unix(&t, t1);
  printf("%llu\t%llu\t%llu\t%llu\n",
    t1,
    t.x,
    (unsigned long long)(t.x / factor),
    (unsigned long long)(t.x % factor)
  );
}

int main(int argc,char **argv) {
  srandomdev();

  tt(0ULL);
  tt(1ULL);
  tt(2ULL);
  tt(4ULL);
  tt(8ULL);
  tt(16ULL);
  tt(32ULL);
  tt(64ULL);
  tt(128ULL);
  tt(256ULL);
  tt(512ULL);
  tt(1024ULL);
  tt(2048ULL);
  tt(4096ULL);
  tt(8192ULL);
  tt(16384ULL);
  tt(32768ULL);
  tt(65536ULL);
  tt(131072ULL);
  tt(262144ULL);
  tt(524288ULL);
  tt(1048576ULL);
  tt(2097152ULL);
  tt(4194304ULL);
  tt(8388608ULL);
  tt(16777216ULL);
  tt(33554432ULL);
  tt(67108864ULL);
  tt(134217728ULL);
  tt(268435456ULL);
  tt(536870912ULL);
  tt(1073741824ULL);
  tt(2147483647ULL);
  tt(4294967296ULL);
  
  return 0;
}
