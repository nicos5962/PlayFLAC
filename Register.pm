package Plugins::PlayFLAC::Register;

# Registers the PlayFLAC tag handler. Kept free of any web/UI dependency so it
# can be used by both the server plugin and the scanner importer.

use strict;
use warnings;

use Slim::Formats;
use Slim::Utils::Log;

use constant HANDLER => 'Plugins::PlayFLAC::Formats::FLAC';

my $log = logger('plugin.playflac');

sub registerFormatHandler {
    my ($class, $tagClasses) = @_;

    Slim::Formats->init();

    $tagClasses ||= \%Slim::Formats::tagClasses;

    return 0 unless ref($tagClasses) eq 'HASH';

    my $current = $tagClasses->{flc};
    return 1 if defined($current) && $current eq HANDLER;

    $tagClasses->{flc} = HANDLER;

    main::DEBUGLOG && $log->is_debug && $log->debug('PlayFLAC: registered FLAC tag handler');

    return 1;
}

1;
