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
isnt( $result, 0, 'Test ran , and failed, as intended' ) or do { $success = 0 };
like( $output, qr/ok.*extractable/m,   'Test dist was extractable' )   or do { $success = 0 };
like( $output, qr/ok.*no_symlinks/m,   'Test dist lacked symlinks' )   or do { $success = 0 };
like( $output, qr/ok.*proper_libs/m,   'Test dist has proper libs' )   or do { $success = 0 };
like( $output, qr/ok.*no_pod_errors/m, 'Test dist has no pod errors' ) or do { $success = 0 };

if ( not $success ) {
  diag explain {
    'stdout' => $output,
    'stderr' => $error,
    'result' => $result,
    'flags'  => $errflags,
  };
}
done_testing;

