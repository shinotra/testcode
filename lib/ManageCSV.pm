#######################################
# csv 処理クラス
# 
# @package ManageCSV
# @copyright 2016 Shinohara,Tohru
# 
#######################################
package ManageCSV;

use utf8;
use Data::Dumper;
use Time::Local;
use Encode qw/encode decode/;

#######################################
# new
# コンストラクタ
# @return bless self
#######################################
sub new {
    my $this = shift;

    my $config = {
        # 参照するCSVデータのpath
        datapath          => '../data/sampledata_euc.dat',
        # CSVデータのテキストエンコーディング
        csv_encoding      => 'euc-jp',
        # HTMLページのテキストエンコーディング
        html_encoding     => 'UTF-8',
        # CSVデータの行区切り文字
        line_splitter     => "\n",
        # CSVデータの列区切り文字
        field_splitter    => "\t",
        # 1行目が項目行であった場合は1を指定
        ignore_first_line => 0,
        # 検索用の行まるごとデータの項目名
        raw_line_name     => '%%__raw__%%',
        # 内部処理用の項目名
        field_keys        => "expire\ttitle\tuser\tposted\tphone\tsubject\twhat",
        # 表示用の項目名
        field_titles      => {  
                                expire  => '掲載期限',
                                title   => 'タイトル',
                                user    => '氏名',
                                posted  => '投稿日時',
                                phone   => '電話',
                                subject => '記事',
                                what    => 'その他',
                              },
        # 表示用の項目形式や幅等を指定する
        field_type        => {  
                                expire  => 'text:40',
                                title   => 'text:80',
                                user    => 'text:30',
                                posted  => 'static',
                                phone   => 'text:40',
                                subject => 'textarea:80:10',
                                what    => 'text:80',
                              },
        # 有効期限として扱うカラムの項目名
        expire_date_field => 'expire',
        # 投稿日として扱うカラムの項目名
        post_datetime_field => 'posted',
        # CSVデータの配列
        csv_data          => undef,
    };
    return bless $config,$this;
}

#######################################
# set_datapath
# CSVデータのpathをセットする
# @param string $path : path string
#######################################
sub set_datapath {
    my $this = shift;
    my $path = shift;
    $this->{datapath} = $path;
}

#######################################
# read_CSV
# CSVデータのデータをメモリにロードする
#######################################
sub read_CSV {
    my $this = shift;
    
    my @csv_data = ();
    my $counter = 0;
    my $splitter = $this->{field_splitter};
    my @field_keys = split(/$splitter/, $this->{field_keys});

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

#######################################
# write_CSV
# メモリ中のデータをCSVファイルに書き出す
#######################################
sub write_CSV {
    my $this = shift;
    
    my $csv_data = $this->{csv_data};
    open(OUT, '>' . $this->{datapath});
    
    if($this->{ignore_first_line} == 1) {
        my $fields = $this->{field_keys};
        print OUT $fields . $this->{line_splitter};
    }
    foreach my $line (@$csv_data) {
        $output = encode($this->{csv_encoding}, $line->{$this->{raw_line_name}});
        print OUT $output . $this->{line_splitter};
    }
    close(OUT);
}

#######################################
# refresh_rawline
# メモリ中の各カラムのデータで、検索用の
# データを更新する
# @param $line_number int : line number
#######################################
sub refresh_rawline {
    my $this = shift;
    my $line_number = shift;
    
    my $splitter = $this->{field_splitter};
    my $field_keys = $this->get_fields();
    my $csv_data = $this->{csv_data};

    my @buff = ();
    foreach my $field (@$field_keys) {
        my $str = $$csv_data[$line_number]->{$field};
        if(!defined($str)) {
            $str = '';
        }
        push @buff, $str;
    }
    $$csv_data[$line_number]->{$this->{raw_line_name}} = join($this->{field_splitter}, @buff);
}

#######################################
# get_fields
# 内部処理用の項目名を得る
#######################################
sub get_fields {
    my $this = shift;
    
    my $splitter = $this->{field_splitter};
    my @field_keys = split(/$splitter/, $this->{field_keys});
    return \@field_keys;
}

#######################################
# get_field_title
# 表示用の項目名を得る
# @param string $key : 内部処理用の項目名
# @return string : 表示用の項目名
#######################################
sub get_field_title {
    my $this = shift;
    my $key  = shift;
    
    my $field_titles = $this->{field_titles};
    return $field_titles->{$key};
}

#######################################
# get_field_type
# 内部処理用の項目名を指定して、項目の表示形式を得る
# @param string $key : 内部処理用の項目名
# @return hash : type as 形式, width as 表示幅, height as 表示高さ
#######################################
sub get_field_type {
    my $this = shift;
    my $key  = shift;
    
    my $field_type = $this->{field_type};
    my ($type, $width, $height) = split(/:/, $field_type->{$key});
    my $field_type_def = {
        type   => $type,
        width  => $width,
        height => $height,
    };
    return $field_type_def;
}

#######################################
# get_all_lines
# メモリ中のデータ全件を得る
# @return arrayref : データ配列のリファレンス
#######################################
sub get_all_lines {
    my $this = shift;
    
    my $csv_data = $this->{csv_data};
    return $csv_data;
}

#######################################
# get_unexpired_lines
# 1カラム目(expire)が今日以降のデータを得る
# @return arrayref : データ配列のリファレンス
#######################################
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

#######################################
# search_by_line
# 文字列を指定して含むデータを得る
# @param $criteria string : 検索条件文字列
# @return arrayref : データ配列のリファレンス
#######################################
sub search_by_line {
    my $this = shift;
    my $criteria = shift;
    
    if(!defined($criteria) || $criteria eq '') {
        return $this->get_all_lines();
    }
    
    my $csv_data = $this->{csv_data};
    my @lines = ();
    foreach my $d (@$csv_data) {
        if(index($d->{$this->{raw_line_name}}, $criteria) > 0) {
            push (@lines, $d);
        }
    }
    return \@lines;
}

#######################################
# get_line_by_id
# 行IDを指定して、単一行のデータを得る
# @param $id int : 行ID
# @return hashref : データハッシュのリファレンス
#######################################
sub get_line_by_id {
    my $this = shift;
    my $id   = shift;

    my $csv_data = $this->{csv_data};
    return $$csv_data[$id];
}

#######################################
# insert_line
# 1行を指定行の上に挿入する
# @param $data hashref : 挿入する行データ
# @param $line_number int : 挿入行
#######################################
sub insert_line { # insert line upward
    my $this = shift;
    my $data = shift;
    my $line_number  = shift;
    
    my $csv_data = $this->{csv_data};
    $data->{$this->{raw_line_name}} = '';
    
    my @array = ();
    push (@array, $data);
    splice (@$csv_data, $line_number, 0, @array);
    $this->refresh_rawline($line_number);

}

#######################################
# append_line
# データの末尾に1行を追加する
# @param $data hashref : 挿入する行データ
# @param $line_number int : 挿入行
#######################################
sub append_line {
    my $this = shift;
    my $data = shift;
    $data->{$this->{raw_line_name}} = '';
    my $csv_data = $this->{csv_data};
    push(@$csv_data, $data);

    my $line_number = @$csv_data;
    $line_number--;
    $this->refresh_rawline($line_number);
}

#######################################
# delete_line
# 行IDを指定して該当行を削除する
# @param $line_number int : 削除行
# @return
#######################################
sub delete_line {
    my $this = shift;
    my $line_number = shift;

    my $csv_data = $this->{csv_data};
    splice(@$csv_data, $line_number, 1);
}

#######################################
# set_data
# 行とカラム名を指定して、データを更新する
# @param $line_number int : 更新する行
# @param $field string : 更新するカラム
# @param $data string : 上書きするデータ
#######################################
sub set_data {
    my $this = shift;
    my $line_number = shift;
    my $field = shift;
    my $data = shift;
    
    my $csv_data = $this->{csv_data};
    $$csv_data[$line_number]->{$field} = $data;
    $this->refresh_rawline($line_number);
}

1;
__END__