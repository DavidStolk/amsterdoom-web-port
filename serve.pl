#!/usr/bin/perl
# serve.pl - a small web server for this folder, reachable only from this computer
# (127.0.0.1), that opens Amsterdoom in the default browser. It uses nothing but Perl's own
# modules, which macOS and Linux include. Started by "Start Amsterdoom.command" (Mac) and
# start-amsterdoom.sh (Linux); stop it with Ctrl+C or by closing its window.
use strict;
use warnings;
use IO::Socket::INET;
use File::Basename qw(dirname);
use Cwd qw(abs_path);

my $root = abs_path(dirname(__FILE__));
my %types = (
	html => 'text/html; charset=utf-8', js => 'text/javascript', wasm => 'application/wasm',
	css => 'text/css', json => 'application/json', md => 'text/plain; charset=utf-8',
	txt => 'text/plain; charset=utf-8', png => 'image/png', ico => 'image/x-icon',
);

# the first free port from 8123
my ($server, $port);
for my $p (8123 .. 8199) {
	$server = IO::Socket::INET->new(LocalAddr => '127.0.0.1', LocalPort => $p, Proto => 'tcp', Listen => 16);
	if ($server) { $port = $p; last; }
}
die "No free port between 8123 and 8199\n" unless $server;
my $url = "http://127.0.0.1:$port/";
print "Amsterdoom: $url  (close this window or press Ctrl+C to stop)\n";

# open the browser (in the background, so the server is already listening)
my $opener = $^O eq 'darwin' ? 'open' : 'xdg-open';
if (fork() == 0) {
	exec($opener, $url) or exit 0;
}

$SIG{CHLD} = 'IGNORE'; # no zombies from the request handlers
$SIG{PIPE} = 'IGNORE'; # the browser may close a connection early

sub reply {
	my ($c, $status, $type, $body, $head) = @_;
	print $c "HTTP/1.1 $status\r\nContent-Type: $type\r\nContent-Length: " . length($body) .
	         "\r\nCache-Control: no-cache\r\nConnection: close\r\n\r\n";
	print $c $body unless $head;
}

# one process per connection: a browser may open a connection and send nothing on it yet
while (1) {
	my $c = $server->accept or next;
	my $pid = fork();
	if (!defined $pid || $pid) { close $c; next; }
	close $server;
	binmode $c;
	# a connection that sends no (complete) request within 30 seconds is closed
	alarm 30;
	my $line = <$c>;
	exit 0 unless defined $line;
	while (my $h = <$c>) { last if $h =~ /^\r?\n$/; }
	alarm 0;
	my ($method, $path) = $line =~ m{^(GET|HEAD) (\S+)};
	if (!$method) { reply($c, '405 Method Not Allowed', 'text/plain', "405\n"); exit 0; }
	$path =~ s/[?#].*//;
	$path =~ s/%([0-9A-Fa-f]{2})/chr(hex($1))/ge;
	$path = '/index.html' if $path eq '/';
	my $file = $root . $path;
	# nothing outside the folder, no hidden files (.git)
	if ($path =~ m{(^|/)\.} || !-f $file || !open(my $fh, '<:raw', $file)) {
		reply($c, '404 Not Found', 'text/plain', "404 Not Found\n", $method eq 'HEAD');
	} else {
		local $/;
		my $body = <$fh>;
		close $fh;
		my ($ext) = $file =~ /\.([^.\/]+)$/;
		reply($c, '200 OK', $types{lc($ext // '')} // 'application/octet-stream', $body, $method eq 'HEAD');
	}
	close $c;
	exit 0;
}
