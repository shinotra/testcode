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
my $mode = %$cgi->{param}->{mode};
my $obj = new ManageCSV();
#$obj->set_datapath('C:\develop\HTDOCS\testcode\data\sampledatas.csv');
$obj->set_datapath('C:\xampp\htdocs\perl\csv\data\sampledatas_euc.dat');

if ($mode eq 'edit') {
    $obj->read_CSV;
    my $field_keys = $obj->get_fields();
    my $line = $obj->get_line_by_id($id);
    
    print "<h1>１件編集</h1>";
    print "<form action=\"edit.cgi\" method=\"post\" name=\"hogehoge\">";
    print "<TABLE BORDER='1'>";
    foreach my $f (@$field_keys) {
        print "<TR>";
        my $colname = encode($obj->{html_encoding}, $obj->get_field_title($f));
        print "<TD>" . $colname . "</TD>";
        my $field_type = $obj->get_field_type($f);
#print Dumper $field_type;
        my $coldata = encode($obj->{html_encoding}, $line->{$f});
        $coldata =~ s/&k/\n/g;
        if($field_type->{type} eq 'text') {
            print "<TD><input type=\"text\" name=\"$f\" value=\"$coldata\" size=\"" . $field_type->{width} . "\"></TD>";
        } elsif ($field_type->{type} eq 'textarea') {
            print "<TD><textarea name=\"$f\" cols=\"" . $field_type->{width} . "\" rows=\"" . $field_type->{height} . "\">" . $coldata . "</textarea></TD>";
        }
        print "</TR>";
    }
    print "</TABLE>";
    print "<input type=\"hidden\" name=\"id\" value=\"$id\">";
    print "<input type=\"button\" value=\"キャンセル\" onClick=\"location.href = 'sample.cgi'\">";
    print "<input type=\"submit\" value=\"更新\">";
    print "</FORM>";
} elsif ($mode eq 'update') {

} elsif ($mode eq 'insert') {

} elsif ($mode eq 'delete') {

}







print "</BODY></HTML>";
