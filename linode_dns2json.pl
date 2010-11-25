#!/usr/bin/env perl

use strict;
use warnings;
use feature qw( say );

use Config::Pit;
use WebService::Linode::DNS;
use JSON;

my $config = pit_get( "linode.com", require => { apikey => "your api key" } );

my $data = {};

my $api = new WebService::Linode::DNS( apikey => $config->{apikey} );
for my $domain ( @{ $api->domainList } ) {
    my $name = $domain->{domain};
    $data->{$name} = $domain;
    $data->{$name}->{hosts} = [];
    for my $entry ( @{ $api->domainResourceList( domain => $name ) } ) {
        push @{ $data->{$name}->{hosts} }, $entry;
    }
}

say encode_json($data);
