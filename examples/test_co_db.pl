#!/usr/bin/perl

use strict;
use warnings;
our $VERSION = sprintf("%d.%02d", q$Revision: 1.4 $ =~ /(\d+)\.(\d+)/);

use VCS::Rcs::Parser;

opendir DIR, "RCS";

my $i;
my $vtext;

my $line;
my $rev;
my $revs;
my $i;

my $test_dir =  "test_dir/";

-x $test_dir && die "Oooooops! there is the dir!";

-x $test_dir || mkdir $test_dir || die "no dir create";


while (my $file = readdir(DIR)) {

    next unless $file=~/\w/;
    next if $file=~/CVS/;

    warn "opening file:$file\n";



    open FH, "RCS/$file";
    $vtext = do {local $/; <FH>};
    close FH;

    warn "parsing file:$file\n";

    my $rcs = VCS::Rcs::Parser->new(\$vtext);

    warn "getting revisions of file:$file\n";

    $revs = $rcs->revs(index=>'rev');

    for $rev (sort keys %$revs) {

	warn "++++++++\nReading date:".$revs->{$rev}."  rev: $rev\n";

        my $text =  $rcs->co(rev=>$rev);
        open RFH, ">", $test_dir.$file.".".$rev 
            || 
	    die $test_dir.$file.".".$rev." no open";
 
        print RFH $text;        

        close RFH;
    }
}


