use strict;
use warnings;

use Dist::Zilla::Tester;
use Path::Class;
use Test::More;
use Capture::Tiny qw( capture );

# FILENAME: test-kwalitee.t
# CREATED: 29/08/11 15:36:11 by Kent Fredric (kentnl) <kentfredric@gmail.com>
# ABSTRACT: Test the Test::Kwalitee plugin works

my $tzil = Dist::Zilla::Tester->from_config( { dist_root => dir(qw( t test-kwalitee )), } );

my $tempdir       = $tzil->tempdir;
my $sourcedir     = $tempdir->subdir('source');
my $builddir      = $tempdir->subdir('build');
my $expected_file = $builddir->subdir('xt')->subdir('release')->file('kwalitee.t');

chdir $sourcedir;

$tzil->build;
END { # Remove (empty) dir created by building the dists
    require File::Path;
    my $tmp = $tempdir->parent;
    chdir $tmp->parent;
    File::Path::remove_tree($tmp, { keep_root => 0 });
}

ok( -e $expected_file, 'test created' );
chdir $builddir;

my ( $result, $output, $error, $errflags );
{
  local $@;
  local $!;
  local $?;
  ( $output, $error ) = capture {
    $result = system( $^X, $expected_file );
  };
  $errflags = { '@' => $@, '!' => $!, '?' => $? };
}
my $success = 1;
# ABOUT: This test =================
#
# What this test is doing is running dzil on the bundled sub-distribution
# in t/test-kwalitee
#
# That distribution is KNOWNINGLY and INTENTIONALLY broken.
#
# This test simply greps for useful substrings emitted by that test,
# to indicate the tests were running.
#
# Note: when you see diag output below, you're seeing output from a
# **CHILD** test run, inside dzil.
#
isnt( $result, 0, 'Test ran , and failed, as intended' ) or do { $success = 0 };
like( $output, qr/ok.*no_symlinks/m,   'Test dist lacked symlinks' )   or do { $success = 0 };

if ( not $success ) {
  diag explain {
    'stdout' => $output,
    'stderr' => $error,
    'result' => $result,
    'flags'  => $errflags,
  };
}
done_testing;
