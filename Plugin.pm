package Plugins::PlayFLAC::Plugin;

use strict;
use warnings;

use base qw(Slim::Plugin::Base);

use Slim::Utils::Log;
use Plugins::PlayFLAC::Register;

my $log = Slim::Utils::Log->addLogCategory({
    category     => 'plugin.playflac',
    defaultLevel => 'INFO',
    description  => 'PLUGIN_PLAYFLAC',
});

sub initPlugin {
    my $class = shift;

    my $version = $class->_pluginDataFor('version') || 'unknown';
    $log->info("Initializing PlayFLAC plugin $version");

    Plugins::PlayFLAC::Register->registerFormatHandler();

    $class->SUPER::initPlugin(@_);
}

sub getDisplayName { 'PLUGIN_PLAYFLAC' }

1;
