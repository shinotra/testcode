#!/usr/local/bin/perl

use lib qw{./lib};
use Data::Dumper;
use utf8;
use Encode qw/encode decode/;
use ManageCSV;

print "Content-type: text/html \n\n";
print "<?xml version=\"1.0\" encoding=\"UTF-8\">";
print "<HTML>";
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
print "<BODY>";

my $obj = new ManageCSV();

#$obj->set_datapath('C:\develop\HTDOCS\testcode\data\sampledatas.csv');
$obj->set_datapath('C:\xampp\htdocs\perl\csv\data\sampledatas_euc.dat');
$obj->read_CSV;

my $field_keys = $obj->get_fields();

print "<h1>全件表示</h1>";
my $lines  = $obj->get_all_lines();
my $counter = 0;

#print Dumper $lines;

print "<TABLE BORDER='1'>";
foreach my $d (@$lines) {
    print "<TR>";
    foreach my $f (@$field_keys) {
        print "<TD>";
        if($f eq 'title') {
            print "<a href=\"edit.cgi?id=" . $d->{id} . "&mode=edit\">";
            print encode($obj->{html_encoding}, $d->{$f});
            print "</a>";
        } else {
            print encode($obj->{html_encoding}, $d->{$f});
        }
        print "</TD>";
    }
    print "</TR>";
    $counter++;
}
print "</TABLE>";

print "<h1>期限内を表示</h1>";
my $lines  = $obj->get_unexpired_lines();
my $counter = 0;

print "<TABLE BORDER='1'>";
foreach my $d (@$lines) {
    print "<TR>";
    foreach my $f (@$field_keys) {
        print "<TD>";
        if($f eq 'title') {
            print "<a href=\"view.cgi?id=" . $d->{id} . "\">";
            print encode($obj->{html_encoding}, $d->{$f});
            print "</a>";
        } else {
            print encode($obj->{html_encoding}, $d->{$f});
        }
        print "</TD>";
    }
    print "</TR>";
    $counter++;
}
print "</TABLE>";



print "</BODY></HTML>";
