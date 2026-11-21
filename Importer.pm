package Plugins::PlayFLAC::Importer;

use strict;
use warnings;

use Plugins::PlayFLAC::Register;

sub initPlugin {
    my $class = shift;

    Plugins::PlayFLAC::Register->registerFormatHandler();
    return 1;
}

sub startScan {
    my $class = shift;
    return;
}

1;
