#!/usr/bin/env perl
use strict;
use warnings;
use IO::Socket;

my ($host, $port) = ("192.168.100.251", 9999);
my $s = IO::Socket::INET->new(
  PeerAddr => $host,
  PeerPort => $port,
  #LocalPort => 10001,
  Proto => "udp",
  Type => SOCK_DGRAM,
  #Broadcast => 1
  );

for (my $k = 1; $k < 16; ++$k) {
  my $str = "a" x $k;
  for (my $i = 0; $i < 1; ++$i) {
    my $r = $s->send($str, 0);
    print "send done $str\n";
  }
  my $rstr = "";
  my $r = $s->recv($rstr, 65536, 0);
  print "recv done $rstr\n";
  print "length=" . length($rstr) . "\n";
}
