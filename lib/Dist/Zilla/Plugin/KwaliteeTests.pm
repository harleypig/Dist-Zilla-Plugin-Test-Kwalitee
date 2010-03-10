use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::KwaliteeTests;
# ABSTRACT: release tests for kwalitee
use Moose;
use Test::Kwalitee ();
extends 'Dist::Zilla::Plugin::InlineFiles';

__PACKAGE__->meta->make_immutable;
no Moose;
1;

=pod

=head1 SYNOPSIS

In C<dist.ini>:

    [KwaliteeTests]

=head1 DESCRIPTION

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following files

  xt/release/kwalitee.t - a standard Test::Kwalitee test

=cut

__DATA__
___[ xt/release/kwalitee.t ]___
#!perl

use Test::More;

eval "use Test::Kwalitee";
plan skip_all => "Test::Kwalitee required for testing kwalitee"
  if $@;

