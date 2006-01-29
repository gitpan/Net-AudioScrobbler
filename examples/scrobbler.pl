#!/usr/bin/perl

use Net::AudioScrobbler;

my $scrobbler = Net::AudioScrobbler->new(user => 'user',pass => 'pass');

$scrobbler->submit(
	artist	=> "Ween",
	album	=> "Chocolate & Cheese",
	track	=> "Take Me Away",
	mbid	=> '',
	length	=> "300",
	time	=> time - 245,);
