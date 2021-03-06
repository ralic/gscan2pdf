use warnings;
use strict;
use File::Basename;    # Split filename into dir, file, ext
use Test::More tests => 3;

BEGIN {
    use_ok('Gscan2pdf::Document');
    use Gtk2 -init;    # Could just call init separately
}

#########################

use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($WARN);
my $logger = Log::Log4perl::get_logger;
Gscan2pdf::Document->setup($logger);

# Create test image
system('convert xc:black black.pnm');

my $slist = Gscan2pdf::Document->new;

# dir for temporary files
my $dir = File::Temp->newdir;
$slist->set_dir($dir);

$slist->import_files(
    paths             => ['black.pnm'],
    finished_callback => sub {
        $slist->analyse(
            page              => $slist->{data}[0][2],
            finished_callback => sub {
                is( $slist->{data}[0][2]{mean}, 0, 'Found dark page' );
                is( dirname("$slist->{data}[0][2]{filename}"),
                    "$dir", 'using session directory' );
                Gtk2->main_quit;
            }
        );
    }
);
Gtk2->main;

#########################

unlink 'black.pnm', <$dir/*>;
rmdir $dir;
Gscan2pdf::Document->quit();
