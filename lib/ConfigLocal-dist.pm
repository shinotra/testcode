package ConfigLocal;

use utf8;
use Data::Dumper;

sub new {
    my $this = shift;

    my $param = {
        datapath => 'C:\develop\HTDOCS\testcode\data\sampledatas_euc.dat',
    };
    return bless $param,$this;
}

1;
__END__