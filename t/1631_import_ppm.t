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
system('convert rose: test.ppm');
system('convert rose: test.png');
my $old = `identify -format '%m %G %g %z-bit %r' test.png`;

my $slist = Gscan2pdf::Document->new;

# dir for temporary files
my $dir = File::Temp->newdir;
$slist->set_dir($dir);

$slist->import_files(
    paths             => ['test.ppm'],
    finished_callback => sub {
        is(
`identify -format '%m %G %g %z-bit %r' $slist->{data}[0][2]{filename}`,
            $old,
            'PPM imported correctly'
        );
        is( dirname("$slist->{data}[0][2]{filename}"),
            "$dir", 'using session directory' );
        Gtk2->main_quit;
    }
);
Gtk2->main;

#########################

unlink 'test.ppm', 'test.png', <$dir/*>;
rmdir $dir;
Gscan2pdf::Document->quit();
