package ManageCSV;

use utf8;
use Data::Dumper;
use Time::Local;
use Encode qw/encode decode/;


sub new {
    my $this = shift;

    my $config = {
        datapath          => '../data/sampledata_euc.dat',
        csv_encoding      => 'euc-jp',
        html_encoding     => 'UTF-8',
        line_splitter     => "\n",
        field_splitter    => "\t",
        ignore_first_line => 0,
        raw_line_name     => '%%__raw__%%',
        field_keys        => "expire\ttitle\tuser\tposted\tphone\tsubject\twhat",
        field_titles      => {  
                                expire  => '掲載期限',
                                title   => 'タイトル',
                                user    => '氏名',
                                posted  => '投稿日時',
                                phone   => '電話',
                                subject => '記事',
                                what    => 'その他',
                              },
        field_type        => {  
                                expire  => 'text:40',
                                title   => 'text:80',
                                user    => 'text:30',
                                posted  => 'text:40',
                                phone   => 'text:40',
                                subject => 'textarea:80:10',
                                what    => 'text:80',
                              },        expire_date_field => 'expire',
        csv_data          => undef,
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
    my $splitter = $this->{field_splitter};
    my @field_keys = split(/$splitter/, $this->{field_keys});

#    print  Dumper @field_keys;

    open(IN, $this->{datapath});
    while(<IN>) {
        if(($this->{ignore_first_line} == 1) && ($counter == 0)) {
            $counter++;
            next;
        }
        chomp;
        $data = decode($this->{csv_encoding}, $_);
        my @linefields = split(/$splitter/, $data);
        my $pos = 0;
        my $line = ();
        foreach my $f (@field_keys) {
            $line->{$f} = $linefields[$pos++];
        }
        $line->{$this->{raw_line_name}} = $data;
        $line->{id} = $counter++;
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
        my $fields = $this->{field_keys};
        print OUT $fields . $this->{line_splitter};
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
    my $splitter = $this->{field_splitter};
    my @field_keys = split(/$splitter/, $this->{field_keys});

    my @buff = ();
    foreach my $field (@field_keys) {
        push @buff, $line_data->{$field};
    }
    $line_data->{$this->{raw_line_name}} = join($this->{field_splitter}, @buff);
    return $line_data;
}

sub get_fields {
    my $this = shift;
    my $splitter = $this->{field_splitter};
    my @field_keys = split(/$splitter/, $this->{field_keys});
    return \@field_keys;
}

sub get_field_title {
    my $this = shift;
    my $key  = shift;
    my $field_titles = $this->{field_titles};
    return $field_titles->{$key};
}

sub get_field_type {
    my $this = shift;
    my $key  = shift;
    my $field_type = $this->{field_type};
#print Dumper $field_type;

    my ($type, $width, $height) = split(/:/, $field_type->{$key});
    my $field_type_def = {
        type   => $type,
        width  => $width,
        height => $height,
    };
    return $field_type_def;
}

sub get_all_lines {
    my $this = shift;
    my $csv_data = $this->{csv_data};
    return $csv_data;
}

sub get_unexpired_lines {
    my $this = shift;
    my $csv_data = $this->{csv_data};

    my $now = time();
    my @lines = ();

    foreach my $d (@$csv_data) {
        my $expiration = $d->{$this->{expire_date_field}};
        my ($year, $month, $date) = split (/\//, $expiration);
        $yaer  = $year - 1900;
        $month = $month - 1;
        my $expire = timelocal (59,59,23,$date,$month,$yaer);
        if($expire >= $now) {
            push (@lines, $d);
        }
    }

    return \@lines;
}

sub get_line_by_id {
    my $this = shift;
    my $id   = shift;

    my $csv_data = $this->{csv_data};
    return @$csv_data[$id];
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