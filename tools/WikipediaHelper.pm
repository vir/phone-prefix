package WikipediaHelper;
use LWP::UserAgent;
#use Encode;

sub new
{
	my $class = shift;
	my($site) = @_;
	$site = 'en' unless $site && $site =~ /^[a-z]{2}$/;

	my $ua = LWP::UserAgent->new;
	$ua->timeout(10);
	$ua->env_proxy;
#	$ua->cookie_jar( {} );

	my $self = bless {
		site => $site,
		ua => $ua,
		debug => $ENV{DEBUG},
	}, $class;
	return $self;
}

sub debug
{
	my $self = shift;
	return unless $self->{debug};
	if(@_ > 1) {
		printf(@_);
	} else {
		print $_[0];
	}
}

sub export_article
{
	my $self = shift;
	my(@pages) = @_;
#	foreach(@pages) {
#		$_ = Encode::encode_utf8($_);
##		$_ =~ s#([^a-zA-Z0-9_-])#sprintf("%%%02X", ord($1))#sge;
#	}
	my $uri = 'http://'.$self->{site}.'.wikipedia.org/w/index.php?title=Special:Export';
#	$self->debug("GET URI: $uri");
#	$self->{ua}->get($uri);
	$uri .= '&action=submit';
#	$self->debug("POST URI: $uri");
	$self->debug("Pages: ".join("\n", @pages));
	my $resp = $self->{ua}->post($uri, {
		catname => '',
		pages => join("\n", @pages),
		curonly => 1,
		templates => 0,
		wpDownload => 0,
		submit => 'Export',
	});

	if ($resp->is_success) {
		return $resp->decoded_content;
	} else {
		die $resp->status_line;
	}
}

sub fetch_article_text
{
	my $self = shift;
	my $t = $self->export_article(@_);
	$t =~ s#^.*?<text [^>]+>##s;
	$t =~ s#</text>.*?$##s;
	return $t;
}

1;

