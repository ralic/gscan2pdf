# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Gscan2pdf.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use warnings;
use strict;
use Test::More tests => 2;

BEGIN {
 use Gscan2pdf::Document;
 use Gscan2pdf::Unpaper;
 use Gtk2 -init;    # Could just call init separately

 #  use File::Copy;
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

SKIP: {
 skip 'unpaper not installed', 2
   unless ( system("which unpaper > /dev/null 2> /dev/null") == 0 );
 my $unpaper =
   Gscan2pdf::Unpaper->new( { 'output-pages' => 2, layout => 'double' } );

 use Log::Log4perl qw(:easy);
 Log::Log4perl->easy_init($WARN);
 Gscan2pdf::Document->setup(Log::Log4perl::get_logger);

 # Create test image
 system(
'convert +matte -depth 1 -border 2x2 -bordercolor black -pointsize 12 -density 300 label:"The quick brown fox" 1.pnm'
 );
 system(
'convert +matte -depth 1 -border 2x2 -bordercolor black -pointsize 12 -density 300 label:"The slower lazy dog" 2.pnm'
 );
 system('convert -size 100x100 xc:black black.pnm');
 system('convert 1.pnm black.pnm 2.pnm +append test.pnm');

 my $slist = Gscan2pdf::Document->new;
 $slist->get_file_info(
  path              => 'test.pnm',
  finished_callback => sub {
   my ($info) = @_;
   $slist->import_file(
    info              => $info,
    first             => 1,
    last              => 1,
    finished_callback => sub {
     $slist->unpaper(
      page              => $slist->{data}[0][2],
      options           => $unpaper->get_cmdline,
      finished_callback => sub {
       system(
"cp $slist->{data}[0][2]{filename} lh.pnm;cp $slist->{data}[1][2]{filename} rh.pnm;"
       );

#    copy( $slist->{data}[0][2]{filename}, 'lh.pnm' ) if (defined $slist->{data}[0][2]{filename}); FIXME: why does copy() not work when cp does?
#    copy( $slist->{data}[1][2]{filename}, 'rh.pnm' ) if (defined $slist->{data}[1][2]{filename});
       Gtk2->main_quit;
      }
     );
    }
   );
  }
 );
 Gtk2->main;

 is( system('identify lh.pnm'), 0, 'valid PNM created for LH' );
 is( system('identify rh.pnm'), 0, 'valid PNM created for RH' );

 unlink 'test.pnm', '1.pnm', '2.pnm', 'black.pnm', 'lh.pnm', 'rh.pnm';
 Gscan2pdf::Document->quit();
}
