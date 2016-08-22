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

# 必要なオブジェクトをコンストラクトする
my $cnf = new ConfigLocal();
my $obj = new ManageCSV();

# CSVデータを書き出す
$obj->set_datapath($cnf->{datapath});
$obj->download_csv("test.csv");

print "</BODY></HTML>";
