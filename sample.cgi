#!/usr/local/bin/perl
# select( STDOUT );
# $| = 1;

use lib qw{./lib};
use Data::Dumper;
use utf8;
use Encode qw/encode decode/;
use ManageCSV;

#binmode(STDOUT, ":utf8");

print "Content-type: text/html \n\n";
print "<?xml version=\"1.0\" encoding=\"UTF-8\">";
print "<HTML>";
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
print "<BODY>";

my $obj = new ManageCSV();

$obj->set_datapath('C:\develop\HTDOCS\testcode\data\sampledatas.csv');

#print Dumper $obj;

$obj->read_CSV;

my $fields = $obj->get_fields();

my $lines  = $obj->get_all_lines();

my $counter = 1;

print "<TABLE BORDER='1'>";
foreach my $d (@$lines) {
    print "<TR>";
    print "<TD>$counter</TD>";
    foreach my $f (@$fields) {
        print "<TD>" . encode($obj->{html_encoding}, $d->{$f}) . "</TD>";
    }
    print "</TR>";
    $counter++;
}
print "</TABLE>";

print "</BODY></HTML>";
