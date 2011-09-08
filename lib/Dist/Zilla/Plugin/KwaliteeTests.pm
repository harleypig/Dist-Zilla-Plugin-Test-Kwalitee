use 5.008;
use strict;
use warnings;

package Dist::Zilla::Plugin::KwaliteeTests;
# ABSTRACT: (DEPRECATED) Release tests for kwalitee
use Moose;
extends 'Dist::Zilla::Plugin::Test::Kwalitee';

=begin :prelude

=for test_synopsis
1;
__END__

=end :prelude

=head1 SYNOPSIS

In C<dist.ini>:

    [Test::Kwalitee]
    skiptest=use_strict ; Don't test for strictness.

=head1 DESCRIPTION

Please use L<Dist::Zilla::Plugin::Test::Kwalitee> instead.

This is an extension of L<Dist::Zilla::Plugin::InlineFiles>, providing the
following file:

  xt/release/kwalitee.t - a standard Test::Kwalitee test

=cut

before register_component => sub {
    warn '!!! [KwaliteeTests] is deprecated, and will be removed in a future release. Please use [Test::Kwalitee] instead.';
};

__PACKAGE__->meta->make_immutable;
no Moose;
1;
