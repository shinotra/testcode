package Params;

use utf8;
use Data::Dumper;
use Encode qw/encode decode/;


sub new {
    my $this = shift;
    my $parameter = $this->get_param();
    
    # uncheck referer or session ??

    my $param = {
        param => $parameter,
    };
    return bless $param,$this;
}

sub get_param {
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


1;
__END__