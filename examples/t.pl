#!/usr/local/bin/perl

use VCS::Rcs::Parser;

$text = do {local $/; <>};

my $rcs = VCS::Rcs::Parser->new(\$text);

#print $rcs->co(rev => '1.1');

$d = $rcs->revs(index => date);

for (sort keys(%$d)) {
    print $_, " ", $d->{$_}, "\n";
}

