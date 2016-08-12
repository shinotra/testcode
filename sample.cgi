#!/usr/local/bin/perl

# モジュールの読み込み先を指定する
use lib qw{./lib};

# 標準モジュールのうち最低限必要なものを指定する
use Data::Dumper;
use utf8;
use Encode qw/encode decode/;

# 作成したモジュールを指定する
use ManageCSV;
use ConfigLocal;

print "Content-type: text/html \n\n";   # Perl CGIはこの行が必要
print "<?xml version=\"1.0\" encoding=\"UTF-8\">";
print "<HTML>";
print "<meta name=\"format-detection\" content=\"telephone=no\">";
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
print "<BODY>";

# 必要なオブジェクトをコンストラクトする
my $cnf = new ConfigLocal();
my $obj = new ManageCSV();

# CSVデータを読み込む
$obj->set_datapath($cnf->{datapath});
$obj->read_CSV;

# 以降はManageCSVのコメントを参考に
my $field_keys = $obj->get_fields();

print "<h1>全件表示</h1>";
my $lines  = $obj->get_all_lines();

print "<TABLE BORDER='1'>";
foreach my $d (@$lines) {
    print "<TR>";
    foreach my $f (@$field_keys) {
        print "<TD>";
        if($f eq 'title') {
            print "<a href=\"edit.cgi?id=" . $d->{id} . "&mode=edit\">";
            # HTMLに書き出すときはPerlの内部エンコーディングからutf8に変換する
            print encode($obj->{html_encoding}, $d->{$f});
            print "</a>";
        } else {
            # HTMLに書き出すときはPerlの内部エンコーディングからutf8に変換する
            print encode($obj->{html_encoding}, $d->{$f});
        }
        print "</TD>";
    }
    print "</TR>";
}
print "</TABLE>";
print "<A HREF=\"search.cgi\">検索サンプル</a><br>";

print "<h1>期限内を表示</h1>";
my $lines  = $obj->get_unexpired_lines();

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
}
print "</TABLE>";
print "</BODY></HTML>";
