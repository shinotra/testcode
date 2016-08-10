#!/usr/local/bin/perl

use lib qw{./lib};
use Data::Dumper;
use utf8;
use Encode qw/encode decode/;
use ManageCSV;
use Params;

print "Content-type: text/html \n\n";
print "<?xml version=\"1.0\" encoding=\"UTF-8\">";
print "<HTML>";
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
print "<BODY>";

my $cgi = new Params();
my $id = %$cgi->{param}->{id};

my $obj = new ManageCSV();
#$obj->set_datapath('C:\develop\HTDOCS\testcode\data\sampledatas.csv');
$obj->set_datapath('C:\xampp\htdocs\perl\csv\data\sampledatas_euc.dat');
$obj->read_CSV;
my $field_keys = $obj->get_fields();
my $line = $obj->get_line_by_id($id);

print "<h1>１件表示</h1>";

print "<TABLE BORDER='1'>";
foreach my $f (@$field_keys) {
    print "<TR>";
    my $colname = encode($obj->{html_encoding}, $obj->get_field_title($f));
    print "<TD>" . $colname . "</TD>";
    my $coldata = encode($obj->{html_encoding}, $line->{$f});
    $coldata =~ s/&k/<br>/g;
    print "<TD>" . $coldata . "</TD>";
    print "</TR>";
}
print "</TABLE>";

print "<a href=\"sample.cgi\">一覧に戻る</a>";


print "</BODY></HTML>";
