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
print "<meta http-equiv=\"Content-Type\" content=\"text/html; charset=UTF-8\" />";
print "<BODY>";

my $cgi = new Params();
my $param = $cgi->get_param();
my $id = $param->{id};
my $mode = $param->{mode};
my $obj = new ManageCSV();
my $cnf = new ConfigLocal();
my $field_keys = $obj->get_fields();
$obj->set_datapath($cnf->{datapath});
$obj->read_CSV;

if ($mode eq 'edit') {
    my $line = $obj->get_line_by_id($id);
    
    print "<h1>１件編集</h1>";
    print "<FORM action=\"edit.cgi\" method=\"post\" name=\"hogehoge\">";
    print "<TABLE BORDER='1'>";
    foreach my $f (@$field_keys) {
        print "<TR>";
        my $colname = encode($obj->{html_encoding}, $obj->get_field_title($f));
        print "<TD>" . $colname . "</TD>";
        my $field_type = $obj->get_field_type($f);
        my $coldata = encode($obj->{html_encoding}, $line->{$f});
        $coldata =~ s/&k/\n/g;
        if($field_type->{type} eq 'text') {
            print "<TD><input type=\"text\" name=\"$f\" value=\"$coldata\" size=\"" . $field_type->{width} . "\"></TD>";
        } elsif ($field_type->{type} eq 'textarea') {
            print "<TD><textarea name=\"$f\" cols=\"" . $field_type->{width} . "\" rows=\"" . $field_type->{height} . "\">" . $coldata . "</textarea></TD>";
        } elsif ($field_type->{type} eq 'static') {
            print "<TD>" . $coldata . "</TD>";
        }
        print "</TR>";
    }
    print "</TABLE>";
    print "<input type=\"hidden\" name=\"id\" value=\"$id\">";
    print "<input type=\"radio\" name=\"mode\" value=\"update\" checked>更新";
    print "<input type=\"radio\" name=\"mode\" value=\"insert\">挿入";
    print "<input type=\"radio\" name=\"mode\" value=\"append\">追加";
    print "<input type=\"radio\" name=\"mode\" value=\"delete\">削除";
    print "<BR>";
    print "<input type=\"button\" value=\"キャンセル\" onClick=\"location.href = 'sample.cgi'\">";
    print "<input type=\"submit\" value=\"更新\">";
    print "</FORM>";
    
} elsif ($mode eq 'update') {
    foreach my $f (@$field_keys) {
        if(!defined($param->{$f})) {
            next;
        }
        my $coldata = $param->{$f};
        my $field_type = $obj->get_field_type($f);
        if ($field_type->{type} eq 'textarea') {
                $coldata =~ s/\n/&k/g;
                $coldata =~ s/\r//g;
        }
        $obj->set_data($id, $f, decode($obj->{html_encoding}, $coldata));
    }
    $obj->write_CSV;
    print "<FORM action=\"sample.cgi\" method=\"post\" name=\"hogehoge\">";
    print "<input type=\"hidden\" name=\"id\" value=\"$id\">";
    print "<input type=\"hidden\" name=\"mode\" value=\"edit\">";
    print "<input type=\"submit\" value=\"続ける\">";
    print "</FORM>";
    
} elsif ($mode eq 'insert') {
    my $data = ();
    foreach my $f (@$field_keys) {
        if(!defined($param->{$f})) {
            next;
        }
        my $coldata = $param->{$f};
        my $field_type = $obj->get_field_type($f);
        if ($field_type->{type} eq 'textarea') {
                $coldata =~ s/\n/&k/g;
                $coldata =~ s/\r//g;
        }
        $data->{$f} = decode($obj->{html_encoding}, $coldata);
        
    }
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
    $year += 1900;
    $mon += 1;
    my $timestring = sprintf ("%04d/%02d/%02d %02d:%02d:%02d", $year, $mon, $mday, $hour, $min, $sec);
    $data->{$obj->{post_datetime_field}} = $timestring;
    $obj->insert_line($data, $id);
    $obj->write_CSV;
    print "<FORM action=\"sample.cgi\" method=\"post\" name=\"hogehoge\">";
    print "<input type=\"submit\" value=\"続ける\">";
    print "</FORM>";

} elsif ($mode eq 'append') {
    my $data = ();
    foreach my $f (@$field_keys) {
        if(!defined($param->{$f})) {
            next;
        }
        my $coldata = $param->{$f};
        my $field_type = $obj->get_field_type($f);
        if ($field_type->{type} eq 'textarea') {
                $coldata =~ s/\n/&k/g;
                $coldata =~ s/\r//g;
        }
        $data->{$f} = decode($obj->{html_encoding}, $coldata);
        
    }
    my ($sec, $min, $hour, $mday, $mon, $year, $wday, $yday, $isdst) = localtime(time);
    $year += 1900;
    $mon += 1;
    my $timestring = sprintf ("%04d/%02d/%02d %02d:%02d:%02d", $year, $mon, $mday, $hour, $min, $sec);
    $data->{$obj->{post_datetime_field}} = $timestring;

    $obj->append_line($data);
    $obj->write_CSV;
    print "<FORM action=\"sample.cgi\" method=\"post\" name=\"hogehoge\">";
    print "<input type=\"submit\" value=\"続ける\">";
    print "</FORM>";

} elsif ($mode eq 'delete') {
    $obj->delete_line($id);
    $obj->write_CSV;
    print "<FORM action=\"sample.cgi\" method=\"post\" name=\"hogehoge\">";
    print "<input type=\"submit\" value=\"続ける\">";
    print "</FORM>";
}







print "</BODY></HTML>";
