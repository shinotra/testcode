#######################################
# POST/GET 処理クラス
# 
# @package Params
# @copyright 2016 Shinohara,Tohru
# 
#######################################
package Params;

use utf8;
use Data::Dumper;
use Encode qw/encode decode/;

#######################################
# new
# コンストラクタ
# @return bless self
#######################################
sub new {
    my $this = shift;
    my $parameter = $this->fetch_param();
    
    # uncheck referer or session ??

    my $param = {
        param => $parameter,
    };
    return bless $param,$this;
}

#######################################
# fetch_param
# HTML変数から必要なパラメータを取り出す
# @return hashref : 取り出したパラメータのハッシュリファレンス
#######################################
sub fetch_param {
    my $this = shift;
    if($ENV{'REQUEST_METHOD'} eq "GET"){
        $buffer = $ENV{'QUERY_STRING'} . '&';
        @pairs = split(/&/,$buffer);
    }elsif ($ENV{'REQUEST_METHOD'} eq "POST"){
        $length = $ENV{'CONTENT_LENGTH'};
        read(STDIN, $buffer, $length);
        @pairs = split(/&/,$buffer);
    }
    foreach $pair (@pairs){
        ($name,$value) = split(/=/, $pair);
        $value =~ tr/+/ /;
        $value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack("C", hex($1))/eg;
        $param_value{$name} = $value;
    }
    return \%param_value
}

#######################################
# get_param
# パラメータを取り出す
# @return hashref : パラメータのハッシュリファレンス
#######################################
sub get_param {
    my $this = shift;
    return $this->{param};
}


1;
__END__