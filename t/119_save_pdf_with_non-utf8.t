# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Gscan2pdf.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use warnings;
use strict;
use Test::More tests => 1;

BEGIN {
 use Gscan2pdf;
 use Gscan2pdf::Document;
 use Gtk2 -init;    # Could just call init separately
 use PDF::API2;
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

# Thumbnail dimensions
our $widtht  = 100;
our $heightt = 100;

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($WARN);
our $logger = Log::Log4perl::get_logger;
Gscan2pdf->setup($logger);

# Create test image
system('convert rose: test.pnm');

my $slist = Gscan2pdf::Document->new;
$slist->get_file_info(
 'test.pnm',
 undef, undef, undef,
 sub {
  my ($info) = @_;
  $slist->import_file(
   $info, 1, 1, undef, undef, undef,
   sub {
    $slist->{data}[0][2]{hocr} = Gscan2pdf::slurp('t/non-utf8.html');
    $slist->save_pdf( 'test.pdf', [ $slist->{data}[0][2] ],
     undef, undef, undef, undef, undef, sub { Gtk2->main_quit } );
   }
  );
 }
);
Gtk2->main;

ok( 1, 'PDF with expected text' );

#########################

unlink 'test.pnm', 'test.pdf';
Gscan2pdf->quit();