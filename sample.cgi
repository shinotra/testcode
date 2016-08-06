#!/usr/local/bin/perl
select( STDOUT );
$| = 1;

use lib qw{./lib};
use Data::Dumper;
use utf8;
use Encode;
use ManageCSV;

binmode(STDOUT, ":utf8");

print "Content-type: text/html \n\n";

print "Hello!";

my $obj = new ManageCSV();
print Dumper $obj;

