#
# Copyright (c) 2001 by RIPE-NCC.  All rights reserved.
#
# This program is free software; you can redistribute it and/or
# modify it under the same terms as Perl itself.
#
# You should have received a copy of the Perl license along with
# Perl; see the file README in Perl distribution.
#
# You should have received a copy of the GNU General Public License
# along with Perl; see the file Copying.  If not, write to
# the Free Software Foundation, 675 Mass Ave, Cambridge, MA 02139, USA.
#
# You should have received a copy of the Artistic License
# along with Perl; see the file Artistic.
#
#                            NO WARRANTY
#
# BECAUSE THE PROGRAM IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
# FOR THE PROGRAM, TO THE EXTENT PERMITTED BY APPLICABLE LAW.  EXCEPT WHEN
# OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
# PROVIDE THE PROGRAM "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER EXPRESSED
# OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.  THE ENTIRE RISK AS
# TO THE QUALITY AND PERFORMANCE OF THE PROGRAM IS WITH YOU.  SHOULD THE
# PROGRAM PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL NECESSARY SERVICING,
# REPAIR OR CORRECTION.
#
# IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
# WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
# REDISTRIBUTE THE PROGRAM AS PERMITTED ABOVE, BE LIABLE TO YOU FOR DAMAGES,
# INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES ARISING
# OUT OF THE USE OR INABILITY TO USE THE PROGRAM (INCLUDING BUT NOT LIMITED
# TO LOSS OF DATA OR DATA BEING RENDERED INACCURATE OR LOSSES SUSTAINED BY
# YOU OR THIRD PARTIES OR A FAILURE OF THE PROGRAM TO OPERATE WITH ANY OTHER
# PROGRAMS), EVEN IF SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGES.
#
#                     END OF TERMS AND CONDITIONS
#
#
package VCS::Rcs::Parser;

require 5.6.0;
use strict;
use warnings;
use Carp;

use VCS::Rcs::YappRcsParser;
use VCS::Rcs::Deltatext;

our $VERSION = '0.04';

my $dt;

sub new {
    my $this  = shift;
    my $rtext = shift;
    my %param = @_;

    my $revs  = delete $param{revs};
    my $dates = delete $param{dates};

    croak "Unexpected Parameter(s):",(join ',', keys %param) if %param;

    (ref($rtext) eq 'SCALAR') or croak "Scalar Ref. to Text is missing!";

    if($revs){ (ref($revs) eq 'ARRAY') or croak "revs must be arrayref!"};

    if($dates){ (ref($dates) eq 'ARRAY') or croak "dates must be arrayref!"};


    my $class = ref($this) || $this;
    my $self = {};
    bless $self ,$class;


    my $rcs = new VCS::Rcs::YappRcsParser;
    $dt = $rcs->Run($rtext, $revs, $dates);  # VCS::Rcs::Deltatext

    for my $rev ($dt->revs) {
        my $rdate = $dt->date($rev);
	next unless (defined $rdate);
        $rdate = '19'.$rdate if (length($rdate) ==  17);
        $self->{__date_index__}{$rdate} = $rev;
        $self->{__rev_index__}{$rev} = $rdate;
    }

    $self
}


sub co {
    my $self = shift;
    my %param = @_;

    my $rev  = delete $param{rev};
    my $date = delete $param{date};

    croak "Unexpected Parameter(s):",(join ',', keys %param) if %param;
 
    return $dt->rev($rev) if (defined $rev);

    my @alldates  = sort keys %{$self->{__date_index__}};


    my($a,$date_proper);

    for $a (@alldates) {
	$date_proper=$a if ($a lt $date);
    }

    $dt->rev($self->{__date_index__}{$date_proper})
}


sub revs {
    my $self = shift;
    my %param = @_;

    my $index = delete $param{index};

    croak "Unexpected Parameter(s):",(join ',', keys %param) if %param;

    $index eq 'date' and return ($self->{__date_index__});

    $index eq 'rev' and return ($self->{__rev_index__});

    croak "Unexpected value(s):",(join ',', values %param);
}


1;


__END__


=head1 NAME

VCS::Rcs::Parser - Perl extension for RCSfile Parsing

=head1 SYNOPSIS

  use VCS::Rcs::Parser;

  # Read a *,v file into $text
  $text = do {local $/; <>};

  my $rcs = VCS::Rcs::Parser->new(\$text);

  print $rcs->co(rev => '1.1');


=head1 DESCRIPTION

Reads a ',v' RCS revisions file and checks out every revision into core.
There will be more documentation soon.

=head1 AUTHOR

Ziya Suzen, ziya@ripe.net

=head1 SEE ALSO

perl(1).

=cut
