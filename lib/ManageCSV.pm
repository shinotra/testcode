package ManageCSV;

use Data::Dumper;
use Encode;

sub new {
    my $this = shift;

    # constants
    my $datapath = '/home/myname/test.csv';
    my $csv_encoding = 'shift-jis';
    my $html_encoding = 'UTF-8';

    my $config = {
        datapath => $datapath,
        csv_encoding => $csv_encoding,
        html_encoding => $html_encoding,
        csv_data => undef,
    };
    return bless $config,$this;
}

sub read_CSV {
    my $this = shift;
}

sub write_CSV {
    my $this = shift;

}

sub set_field {
    my $this = shift;

}

sub insert_line {
    my $this = shift;

}

sub insert_lines {
    my $this = shift;

}

sub search {
    my $this = shift;

}

sub search_by_key {
    my $this = shift;

}



sub replace_line {
    my $this = shift;

}

sub delete_line {
    my $this = shift;

}

sub delete_lines {
    my $this = shift;

}

sub sort_lines {
    my $this = shift;

}

1;
__END__