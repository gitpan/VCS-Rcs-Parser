#!/usr/bin/perl

use strict;
use warnings;
our $VERSION = sprintf("%d.%02d", q$Revision: 1.3 $ =~ /(\d+)\.(\d+)/);

use VCS::Rcs::Parser;

opendir DIR, "RCS";

my $i;
my $vtext;

my $line;
my $rev;
my $revs;
my $i;


while (my $file = readdir(DIR)) {

    next unless $file=~/\w/;

    warn "opening file:$file\n";



    open FH, "RCS/$file";
    $vtext = do {local $/; <FH>};
    close FH;

    warn "parsing file:$file\n";

    my $rcs = VCS::Rcs::Parser->new(\$vtext);

    warn "getting revisions of file:$file\n";

    $revs = $rcs->revs(index=>'date');

    for $rev (sort keys %$revs) {

	warn "++++++++\nReading date:".$revs->{$rev}."  rev: $rev\n";

        my $text =  $rcs->co(rev=>$rev);

        while ( $text =~ /\G([^\n]*(?:\n|\z))/gcs ) {

	    $line = $1;

            if ($line =~ m/^allocated:/ ) 
                  {
                      print $line;
                  }

	}


    }
}


