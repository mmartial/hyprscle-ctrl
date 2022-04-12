#!/usr/bin/env perl

use strict;

my $in  = &slurp(shift @ARGV);
my $out = &slurp(shift @ARGV);

#print "[$in]";
my ($lp) = ($in =~ m%^(listen_port\:.+)$%m);
my ($ad) = ($in =~ m%^(address\:.+)$%m);
my ($pr) = ($in =~ m%^(peers\:.+)%ms);
#print "[$id][$lp][$ad][$pr]\n";

$out =~ s%^(\s*)(listen_port\:.+)$%$1$lp%m;
$out =~ s%^(\s*)(address\:.+)$%$1$ad%m;
$out =~ s%^(\s*)(peers\:.+)%$1$pr%ms;

print "$out";

exit(0);

sub slurp {
    my $fn = shift @_;
    my $txt;
    open(my $fh, '<', $fn) or die("Problem opening file ($fn)");
    {
        local $/;
        $txt = <$fh>;
    }
    close($fh);
    return($txt);
}