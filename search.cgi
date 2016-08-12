#!/usr/local/bin/perl

use lib qw{./lib};
use Data::Dumper;
use utf8;
use Encode qw/encode decode/;
use ManageCSV;
use ConfigLocal;
use Params;

print "Content-type: text/html \n\n";
print "<?xml version=\"1.0\" encoding=\"UTF-8\">";
print "<HTML>";
print "<meta name=\"format-detection\" content=\"telephone=no\">";
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
print "<BODY>";

my $cnf = new ConfigLocal();
my $obj = new ManageCSV();
my $cgi = new Params();
my $param = $cgi->get_param();

$obj->set_datapath($cnf->{datapath});
$obj->read_CSV;

my $field_keys = $obj->get_fields();
my $criteria   = $param->{criteria};


print "<h1>検索</h1>";

print "<FORM action=\"search.cgi\" method=\"post\" name=\"hogehoge\">";
print "検索文字列 : ";
print "<input type=\"text\" name=\"criteria\" value=\"$criteria\" size=\"80\">";
print "<BR>";
print "<input type=\"button\" value=\"キャンセル\" onClick=\"location.href = 'sample.cgi'\">";
print "<input type=\"submit\" value=\"検索実行\">";
print "</FORM>";

# 一旦、utf8からPerlの内部文字コードにdecodeする。
$criteria = decode($obj->{html_encoding}, $criteria);
my $lines  = $obj->search_by_line($criteria);

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
}
print "</TABLE>";

print "</BODY></HTML>";
