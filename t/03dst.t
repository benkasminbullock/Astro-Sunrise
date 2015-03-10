#!/usr/bin/perl -w
# -*- perl -*-
#
#     Test script for Astro::Sunrise
#     Author: Slaven Rezic
#     Copyright (C) 2015 Slaven Rezic, Ron Hill and Jean Forget
#
#     This program is distributed under the same terms as Perl 5.16.3:
#     GNU Public License version 1 or later and Perl Artistic License
#
#     You can find the text of the licenses in the F<LICENSE> file or at
#     L<http://www.perlfoundation.org/artistic_license_1_0>
#     and L<http://www.gnu.org/licenses/gpl-1.0.html>.
#
#     Here is the summary of GPL:
#
#     This program is free software; you can redistribute it and/or modify
#     it under the terms of the GNU General Public License as published by
#     the Free Software Foundation; either version 1, or (at your option)
#     any later version.
#
#     This program is distributed in the hope that it will be useful,
#     but WITHOUT ANY WARRANTY; without even the implied warranty of
#     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#     GNU General Public License for more details.
#
#     You should have received a copy of the GNU General Public License
#     along with this program; if not, write to the Free Software Foundation,
#     Inc., <http://www.fsf.org/>.
#

use strict;
use warnings;
use Test::More;

BEGIN {
  eval "use DateTime;";
  if ($@) {
    plan skip_all => "DateTime needed";
    exit;
  }
}

if (!eval q{ require Time::Fake; 1;}) {
    print "1..0 # skip no Time::Fake module\n";
    exit;
}

my @tests = (
	     [1288545834, 'sun_rise', '07:00'],
	     [1288545834, 'sun_set',  '16:39'],

	     [1269738800, 'sun_rise', '06:50'],
	     [1269738800, 'sun_set',  '19:32'],
	    );

plan tests => scalar @tests;

{
  local $ENV{TZ} = 'Europe/Berlin';

  for my $test (@tests) {
    my($epoch, $func, $expected) = @$test;
    my @cmd = ($^X, "-Mblib",
                    "-MTime::Fake=$epoch",
                    "-MAstro::Sunrise",
                    "-e", "print $func(13.5,52.5)");
    open my $fh, "-|", @cmd or die $!;
    local $/;
    my $res = <$fh>;
    close $fh or die "Failure while running @cmd: $!";
    is $res, $expected, "Check for $func at $epoch";
  }
}

__END__
