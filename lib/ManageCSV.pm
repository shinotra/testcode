package ManageCSV;

use utf8;
use Data::Dumper;
use Encode qw/encode decode/;


sub new {
    my $this = shift;

    # constants
    my $datapath = '../data/sampledata.csv';
    my $csv_encoding = 'Shift_JIS';
    my $html_encoding = 'UTF-8';
    my $line_splitter = "\n";
    my $ignore_first_line = 1;
    my $raw_line_name = '%%__raw__%%';
    my $fields = 'id,date,user,information';

    my $config = {
        datapath => $datapath,
        csv_encoding => $csv_encoding,
        html_encoding => $html_encoding,
        line_splitter => $line_splitter,
        ignore_first_line => $ignore_first_line,
        raw_line_name => $raw_line_name,
        fields => $fields,
        csv_data => undef,
    };
    return bless $config,$this;
}

sub set_datapath {
    my $this = shift;
    my $path = shift;
    $this->{datapath} = $path;
}

sub read_CSV {
    my $this = shift;
    my @csv_data = ();
    my $counter = 0;
    
    open(IN, $this->{datapath});
    while(<IN>) {
        if(($this->{ignore_first_line} == 1) && ($counter++ == 0)) {
            next;
        }
        chomp;
        $data = decode($this->{csv_encoding}, $_);
        my @linefields = split(/,/, $data);
        my $pos = 0;
        my $line = ();
        my @fields = split(/,/, $this->{fields});
        foreach my $f (@fields) {
            $line->{$f} = $linefields[$pos++];
        }
        $line->{$this->{raw_line_name}} = $data;
        push @csv_data, $line;
    }
    $this->{csv_data} = \@csv_data;
    close(IN);
}

sub write_CSV {
    my $this = shift;
    my $csv_data = $this->{csv_data};
    open(OUT, '>' . $this->{datapath});
    
    if($this->{ignore_first_line} == 1) {
        print OUT $this->{fields} . $this->{line_splitter};
    }
    
    foreach my $line (@$csv_data) {
        $line = $this->refresh_rawline($line);
        $output = encode($this->{csv_encoding}, $line->{$this->{raw_line_name}});
        print OUT $output . $this->{line_splitter};
    }
    close(OUT);
}

sub refresh_rawline {
    my $this = shift;
    my $line_data = shift;

    my @fields = split(/,/, $this->{fields});
    my @buff = ();
    foreach my $field (@fields) {
        push @buff, $line_data->{$field};
    }
    $line_data->{$this->{raw_line_name}} = join(',', @buff);
    return $line_data;
}

sub get_fields {
    my $this = shift;
    my @fields = split(/,/, $this->{fields});
    return \@fields;
}

sub get_all_lines {
    my $this = shift;
    my $csv_data = $this->{csv_data};
    return $csv_data;
}

sub get_line {
    my $this = shift;

}


sub insert_line {
    my $this = shift;

}

sub insert_lines {
    my $this = shift;

}

sub search_by_line {
    my $this = shift;

}

sub search_by_field {
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

sub set_data {
    my $this = shift;
    my $line_number = shift;
    my $field = shift;
    my $data = shift;   # undecoded
    
    my $csv_data = $this->{csv_data};
    my $line_counter = 1;
    foreach my $l (@$csv_data) {
        if($line_number == $line_counter++) {
            $l->{$field} = $data;
            $this->refresh_rawline($l);
        }
    }

}

1;
__END__