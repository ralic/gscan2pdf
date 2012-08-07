# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Gscan2pdf.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use warnings;
use strict;
use Test::More tests => 3;

BEGIN {
 use_ok('Gscan2pdf');
 use_ok('Gscan2pdf::Document');
 use Gtk2 -init;    # Could just call init separately
}

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($WARN);
our $logger = Log::Log4perl::get_logger;
Gscan2pdf::Document->setup($logger);

# Create test image
system('convert rose: test.pdf');
system('convert rose: test.png');

my $slist = Gscan2pdf::Document->new;
$slist->get_file_info(
 path              => 'test.pdf',
 finished_callback => sub {
  my ($info) = @_;
  $slist->import_file(
   info              => $info,
   first             => 1,
   last              => 1,
   finished_callback => sub {
    system("cp $slist->{data}[0][2]{filename} test2.png");
    Gtk2->main_quit;
   }
  );
 }
);
Gtk2->main;

is( -s 'test.png', -s 'test2.png', 'PDF imported correctly' );

#########################

unlink 'test.pdf', 'test.png', 'test2.png';
Gscan2pdf::Document->quit();
