use warnings;
use strict;
use Test::More tests => 1;

BEGIN {
    use Gscan2pdf::Document;
    use Gtk2 -init;    # Could just call init separately
}

#########################

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($WARN);
my $logger = Log::Log4perl::get_logger;
Gscan2pdf::Document->setup($logger);

# Create test image
system('convert rose: test.pnm');

my $slist = Gscan2pdf::Document->new;

# dir for temporary files
my $dir = File::Temp->newdir;
$slist->set_dir($dir);

$slist->import_files(
    paths             => ['test.pnm'],
    finished_callback => sub {
        $slist->{data}[0][2]{hocr} = 'The quick brown fox';
        $slist->save_djvu(
            path              => 'test.djvu',
            list_of_pages     => [ $slist->{data}[0][2] ],
            finished_callback => sub { Gtk2->main_quit }
        );
    }
);
Gtk2->main;

like( `djvutxt test.djvu`, qr/The quick brown fox/, 'DjVu with expected text' );

#########################

unlink 'test.pnm', 'test.djvu';
Gscan2pdf::Document->quit();
