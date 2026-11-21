package Plugins::PlayFLAC::Formats::FLAC;

# Core already handles FLAC tags and embedded cuesheets. This class only adds
# an external album id (from Discogs) so that different releases of the same
# album / artist are not merged into one album.

use strict;
use warnings;
use base qw(Slim::Formats::FLAC);

# Tags holding the Discogs release id, in order of preference.
my @extIdTags = qw(DISCOGS_RELEASE_ID DISCOGS_ID DISCOGSID DISCOGS_RELEASEID);

sub _getStandardTag {
    my ($class, $s) = @_;

    my $tags = $class->SUPER::_getStandardTag($s);

    $class->_setExtId($tags, $s->{tags});

    return $tags;
}

# The cuesheet tracks get their metadata from several sources, not all of
# which carry the file level tags: set the album id on every track.
sub _getSubFileTags {
    my ($class, $s, $tracks) = @_;

    my $items = $class->SUPER::_getSubFileTags($s, $tracks);

    my $extId = $class->_findExtId($s->{tags});

    if (defined $extId) {
        for my $track (values %$tracks) {
            $track->{ALBUM_EXTID} = $extId unless $track->{ALBUM_EXTID};
        }
    }

    return $items;
}

sub _setExtId {
    my ($class, $tags, $source) = @_;

    return if $tags->{ALBUM_EXTID};

    my $extId = $class->_findExtId($source || $tags);

    $tags->{ALBUM_EXTID} = $extId if defined $extId;
}

sub _findExtId {
    my ($class, $tags) = @_;

    return unless ref $tags eq 'HASH';

    my %byName = map { uc($_) => $tags->{$_} } keys %$tags;

    for my $name (@extIdTags) {
        my $value = $byName{$name};
        $value = $value->[0] if ref $value eq 'ARRAY';

        next unless defined $value;

        $value =~ s/^\s+|\s+$//g;

        return $value if length $value;
    }

    return;
}

1;
