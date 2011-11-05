#!perl

use strict;
use warnings;
use Test::More;
use Test::Fatal;
use Proc::Daemontools::PP;

subtest 'non-existent supervise directory' => sub {
  like(exception { Proc::Daemontools::PP::Service->new('t/tlib/test_cases/no_such_dir')}, qr{^Could not read directory 't/tlib/test_cases/no_such_dir': }, 'Service with a non-existing directory, dies');
};


done_testing();
