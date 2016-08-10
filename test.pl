#!/usr/local/bin/perl

use lib qw{./lib};
use Data::Dumper;
use utf8;
use Encode;
use ManageCSV;

my $obj = new ManageCSV();

$obj->set_datapath('data/sampledatas_euc.dat');
$obj->read_CSV;

$obj->get_unxpired_lines();

#print Dumper $obj;
exit;

$obj->set_data(2,'user','C');
#print Dumper $obj;
$obj->set_data(2,'date','1999/11/12');
#print Dumper $obj;

$obj->set_datapath('data/sampledata2.csv');
$obj->write_CSV;


#print Dumper $obj;