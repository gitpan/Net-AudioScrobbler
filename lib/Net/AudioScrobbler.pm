package Net::AudioScrobbler;

use Digest::MD5 qw/md5_hex/; 
use LWP::UserAgent;
use Data::Dumper;
use Encode;

our $VERSION	= '0.01';
our $ID			= 'tst';

my $ua = LWP::UserAgent->new;

sub new {
	my ($class,%options) = @_;
	
	$self = \%options;
	die "Need user and pass to use Scrobbler" 
		unless $self->{user} and $self->{pass};

	$self->{pass} = md5_hex($self->{pass});
	$self->{lasthandshake} = 0;
	$self->{interval} = 0;

	bless $self,$class;
}

sub _handshake {
	die unless caller eq __PACKAGE__;
	print "Handshaking...";
	$self->{lasthandshake} = time;
	my $pass = md5_hex($self->{pass} . $self->{lasthandshake});

	my $url = 'http://post.audioscrobbler.com/?hs=true&p=1.1&'.
		"c=$ID&v=$VERSION&u=".$self->{user}.
		"&t=".$self->{lasthandshake}."&a=".$pass;

	my $req = HTTP::Request->new( GET => $url );
	my $res = $ua->request($req);

	if ($res->is_success) {
		my @response = split "\n",$res->content;
		print Dumper(@response);
		if ($response[0] =~ /^UP(?:DATE|TODATE)/) {
			$self->{md5challenge} = @response[1];
			$self->{submiturl} = @response[2];
			$self->{interval} = @response[3];
			print "done\n";
			return 1;
		}
		else {
			print $response[0];
			return 0;
		}
	}
	else {
		print $res->status_line;
		return 0;
	}
}

sub submit {
	print Dumper(@_);
	my ($self,%options) = @_;
	$song = \%options;

	return 0 unless _handshake();
	
	my $user	= encode_utf8($self->{user});
	my $md5 	= encode_utf8(md5_hex($self->{pass} . $self->{md5challenge}));
	my $artist 	= encode_utf8($song->{artist});
	my $track 	= encode_utf8($song->{track});
	my $album	= encode_utf8($song->{album});
	my $length	= encode_utf8($song->{length});
	my $time	= encode_utf8($song->{time});
	my $mbid 	= encode_utf8($song->{mbid});

	print $user;

	my %content = (
		"u"		=> $user,
		"s"		=> $md5,
		"a[0]"	=> $artist,
		"t[0]"	=> $track,
		"b[0]"	=> $album,
		"m[1]"	=> $mbid,
		"l[0]"	=> $length,
		"i[0]"	=> $time,
	);
				  
	print $content;
	my $resp = $ua->post($self->{submiturl},\%content);

	if ($resp->is_success) {
		print $resp->content;
	}
	else {
		print $resp->status_line;
	}
}

1;
