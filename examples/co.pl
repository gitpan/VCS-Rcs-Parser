#!/usr/local/bin/perl
#
#   ./co.pl -r1.1 file_to_co
#
use VCS::Rcs::Parser;

$r = shift || die "usage: co.pl -rx.x file_to_co \n\n";
$r=~s/\-r//;

$f = shift || die "usage: co.pl -rx.x file_to_co \n\n";

warn "RCS/$f,v  -->  $f\n";
open FH,'<',"RCS/$f,v" || die "No revision file for $f\n\n";
$text = do {local $/; <FH>};close FH;

warn "revision $r\n";
my $rcs = VCS::Rcs::Parser->new(\$text,revs=>[$r]);
my $fo = $rcs->co(rev=>$r);
die "Nothing for $r\n\n" unless defined($fo);

open FH,'>',$f || die "$!\n";
print FH $fo;close FH;

warn "done\n";
