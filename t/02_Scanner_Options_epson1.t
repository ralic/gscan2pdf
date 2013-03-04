use warnings;
use strict;
use Test::More tests => 3;
use Sane 0.05;    # For enums
BEGIN { use_ok('Gscan2pdf::Scanner::Options') }

#########################

my $filename = 'scanners/epson1';
my $output   = do { local ( @ARGV, $/ ) = $filename; <> };
my $options  = Gscan2pdf::Scanner::Options->new_from_data($output);
my @that     = (
 {
  'index' => 0,
 },
 {
  index             => 1,
  title             => 'Scan Mode',
  'cap'             => 0,
  'max_values'      => 0,
  'name'            => '',
  'unit'            => SANE_UNIT_NONE,
  'desc'            => '',
  type              => SANE_TYPE_GROUP,
  'constraint_type' => SANE_CONSTRAINT_NONE
 },
 {
  name   => 'mode',
  title  => 'Mode',
  index  => 2,
  'desc' => 'Selects the scan mode (e.g., lineart, monochrome, or color).',
  'val'  => 'Binary',
  'constraint'    => [ 'Binary', 'Gray', 'Color' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name  => 'depth',
  title => 'Depth',
  index => 3,
  'desc' =>
'Number of bits per sample, typical values are 1 for "line-art" and 8 for multibit scans.',
  'constraint'    => [ '8', '16' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_WORD_LIST,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name         => 'halftoning',
  title        => 'Halftoning',
  index        => 4,
  'desc'       => 'Selects the halftone.',
  'val'        => 'Halftone A (Hard Tone)',
  'constraint' => [
   'None',
   'Halftone A (Hard Tone)',
   'Halftone B (Soft Tone)',
   'Halftone C (Net Screen)',
   'Dither A (4x4 Bayer)',
   'Dither B (4x4 Spiral)',
   'Dither C (4x4 Net Screen)',
   'Dither D (8x4 Net Screen)',
   'Text Enhanced Technology',
   'Download pattern A',
   'Download pattern B'
  ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name            => 'dropout',
  title           => 'Dropout',
  index           => 5,
  'desc'          => 'Selects the dropout.',
  'val'           => 'None',
  'constraint'    => [ 'None', 'Red', 'Green', 'Blue' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name       => 'brightness',
  title      => 'Brightness',
  index      => 6,
  'desc'     => 'Selects the brightness.',
  'val'      => '0',
  constraint => {
   'min' => -4,
   'max' => 3,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name       => 'sharpness',
  title      => 'Sharpness',
  index      => 7,
  'desc'     => '',
  'val'      => '0',
  constraint => {
   'min' => -2,
   'max' => 2,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name  => 'gamma-correction',
  title => 'Gamma correction',
  index => 8,
  'desc' =>
'Selects the gamma correction value from a list of pre-defined devices or the user defined table, which can be downloaded to the scanner',
  'val'        => 'Default',
  'constraint' => [
   'Default',
   'User defined',
   'High density printing',
   'Low density printing',
   'High contrast printing'
  ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name   => 'color-correction',
  title  => 'Color correction',
  index  => 9,
  'desc' => 'Sets the color correction table for the selected output device.',
  'val'  => 'CRT monitors',
  'constraint' => [
   'No Correction',
   'User defined',
   'Impact-dot printers',
   'Thermal printers',
   'Ink-jet printers',
   'CRT monitors'
  ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name         => 'resolution',
  title        => 'Resolution',
  index        => 10,
  'desc'       => 'Sets the resolution of the scanned image.',
  'val'        => '50',
  'constraint' => [
   '50',  '60',  '72',  '75',  '80',   '90',   '100',  '120',
   '133', '144', '150', '160', '175',  '180',  '200',  '216',
   '240', '266', '300', '320', '350',  '360',  '400',  '480',
   '600', '720', '800', '900', '1200', '1600', '1800', '2400',
   '3200'
  ],
  'unit'          => SANE_UNIT_DPI,
  constraint_type => SANE_CONSTRAINT_WORD_LIST,
  type            => SANE_TYPE_INT,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name       => 'threshold',
  title      => 'Threshold',
  index      => 11,
  'desc'     => 'Select minimum-brightness to get a white point',
  constraint => {
   'min' => 0,
   'max' => 255,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  index             => 12,
  title             => 'Advanced',
  'cap'             => 0,
  'max_values'      => 0,
  'name'            => '',
  'unit'            => SANE_UNIT_NONE,
  'desc'            => '',
  type              => SANE_TYPE_GROUP,
  'constraint_type' => SANE_CONSTRAINT_NONE
 },
 {
  name              => 'mirror',
  title             => 'Mirror',
  index             => 13,
  'desc'            => 'Mirror the image.',
  'val'             => SANE_FALSE,
  'unit'            => SANE_UNIT_NONE,
  'type'            => SANE_TYPE_BOOL,
  'constraint_type' => SANE_CONSTRAINT_NONE,
  'cap'             => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'      => 1,
 },
 {
  name              => 'speed',
  title             => 'Speed',
  index             => 14,
  'desc'            => 'Determines the speed at which the scan proceeds.',
  'val'             => SANE_FALSE,
  'unit'            => SANE_UNIT_NONE,
  'type'            => SANE_TYPE_BOOL,
  'constraint_type' => SANE_CONSTRAINT_NONE,
  'cap'             => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'      => 1,
 },
 {
  name              => 'auto-area-segmentation',
  title             => 'Auto area segmentation',
  index             => 15,
  'desc'            => '',
  'val'             => SANE_TRUE,
  'unit'            => SANE_UNIT_NONE,
  'type'            => SANE_TYPE_BOOL,
  'constraint_type' => SANE_CONSTRAINT_NONE,
  'cap'             => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'      => 1,
 },
 {
  name              => 'short-resolution',
  title             => 'Short resolution',
  index             => 16,
  'desc'            => 'Display short resolution list',
  'val'             => SANE_FALSE,
  'unit'            => SANE_UNIT_NONE,
  'type'            => SANE_TYPE_BOOL,
  'constraint_type' => SANE_CONSTRAINT_NONE,
  'cap'             => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'      => 1,
 },
 {
  name       => 'zoom',
  title      => 'Zoom',
  index      => 17,
  'desc'     => 'Defines the zoom factor the scanner will use',
  constraint => {
   'min' => 50,
   'max' => 200,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'red-gamma-table',
  title      => 'Red gamma table',
  index      => 18,
  'desc'     => 'Gamma-correction table for the red band.',
  constraint => {
   'min' => 0,
   'max' => 255,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 255,
 },
 {
  name       => 'green-gamma-table',
  title      => 'Green gamma table',
  index      => 19,
  'desc'     => 'Gamma-correction table for the green band.',
  constraint => {
   'min' => 0,
   'max' => 255,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 255,
 },
 {
  name       => 'blue-gamma-table',
  title      => 'Blue gamma table',
  index      => 20,
  'desc'     => 'Gamma-correction table for the blue band.',
  constraint => {
   'min' => 0,
   'max' => 255,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 255,
 },
 {
  name  => 'wait-for-button',
  title => 'Wait for button',
  index => 21,
  'desc' =>
'After sending the scan command, wait until the button on the scanner is pressed to actually start the scan process.',
  'val'             => SANE_FALSE,
  'unit'            => SANE_UNIT_NONE,
  'type'            => SANE_TYPE_BOOL,
  'constraint_type' => SANE_CONSTRAINT_NONE,
  'cap'             => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'      => 1,
 },
 {
  index             => 22,
  title             => 'Color correction coefficients',
  'cap'             => 0,
  'max_values'      => 0,
  'name'            => '',
  'unit'            => SANE_UNIT_NONE,
  'desc'            => '',
  type              => SANE_TYPE_GROUP,
  'constraint_type' => SANE_CONSTRAINT_NONE
 },
 {
  name       => 'cct-1',
  title      => 'CCT 1',
  index      => 23,
  'desc'     => 'Controls green level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'cct-2',
  title      => 'CCT 2',
  index      => 24,
  'desc'     => 'Adds to red based on green level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'cct-3',
  title      => 'CCT 3',
  index      => 25,
  'desc'     => 'Adds to blue based on green level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'cct-4',
  title      => 'CCT 4',
  index      => 26,
  'desc'     => 'Adds to green based on red level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'cct-5',
  title      => 'CCT 5',
  index      => 27,
  'desc'     => 'Controls red level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'cct-6',
  title      => 'CCT 6',
  index      => 28,
  'desc'     => 'Adds to blue based on red level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'cct-7',
  title      => 'CCT 7',
  index      => 29,
  'desc'     => 'Adds to green based on blue level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'cct-8',
  title      => 'CCT 8',
  index      => 30,
  'desc'     => 'Adds to red based on blue level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name       => 'cct-9',
  title      => 'CCT 9',
  index      => 31,
  'desc'     => 'Controls blue level',
  constraint => {
   'min' => -127,
   'max' => 127,
  },
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  index             => 32,
  title             => 'Preview',
  'cap'             => 0,
  'max_values'      => 0,
  'name'            => '',
  'unit'            => SANE_UNIT_NONE,
  'desc'            => '',
  type              => SANE_TYPE_GROUP,
  'constraint_type' => SANE_CONSTRAINT_NONE
 },
 {
  name              => 'preview',
  title             => 'Preview',
  index             => 33,
  'desc'            => 'Request a preview-quality scan.',
  'val'             => SANE_FALSE,
  'unit'            => SANE_UNIT_NONE,
  'type'            => SANE_TYPE_BOOL,
  'constraint_type' => SANE_CONSTRAINT_NONE,
  'cap'             => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'      => 1,
 },
 {
  name              => 'preview-speed',
  title             => 'Preview speed',
  index             => 34,
  'desc'            => '',
  'val'             => SANE_FALSE,
  'unit'            => SANE_UNIT_NONE,
  'type'            => SANE_TYPE_BOOL,
  'constraint_type' => SANE_CONSTRAINT_NONE,
  'cap'             => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'      => 1,
 },
 {
  index             => 35,
  title             => 'Geometry',
  'cap'             => 0,
  'max_values'      => 0,
  'name'            => '',
  'unit'            => SANE_UNIT_NONE,
  'desc'            => '',
  type              => SANE_TYPE_GROUP,
  'constraint_type' => SANE_CONSTRAINT_NONE
 },
 {
  name       => 'l',
  title      => 'Top-left x',
  index      => 36,
  'desc'     => 'Top-left x position of scan area.',
  'val'      => 0,
  constraint => {
   'min' => 0,
   'max' => 215.9,
  },
  'unit'          => SANE_UNIT_MM,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_FIXED,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name       => 't',
  title      => 'Top-left y',
  index      => 37,
  'desc'     => 'Top-left y position of scan area.',
  'val'      => 0,
  constraint => {
   'min' => 0,
   'max' => 297.18,
  },
  'unit'          => SANE_UNIT_MM,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_FIXED,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name       => 'x',
  title      => 'Width',
  index      => 38,
  'desc'     => 'Width of scan-area.',
  'val'      => 215.9,
  constraint => {
   'min' => 0,
   'max' => 215.9,
  },
  'unit'          => SANE_UNIT_MM,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_FIXED,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name       => 'y',
  title      => 'Height',
  index      => 39,
  'desc'     => 'Height of scan-area.',
  'val'      => 297.18,
  constraint => {
   'min' => 0,
   'max' => 297.18,
  },
  'unit'          => SANE_UNIT_MM,
  constraint_type => SANE_CONSTRAINT_RANGE,
  type            => SANE_TYPE_FIXED,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name   => 'quick-format',
  title  => 'Quick format',
  index  => 40,
  'desc' => '',
  'val'  => 'Max',
  'constraint' =>
    [ 'CD', 'A5 portrait', 'A5 landscape', 'Letter', 'A4', 'Max' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  index             => 41,
  title             => 'Optional equipment',
  'cap'             => 0,
  'max_values'      => 0,
  'name'            => '',
  'unit'            => SANE_UNIT_NONE,
  'desc'            => '',
  type              => SANE_TYPE_GROUP,
  'constraint_type' => SANE_CONSTRAINT_NONE
 },
 {
  name            => 'source',
  title           => 'Source',
  index           => 42,
  'desc'          => 'Selects the scan source (such as a document-feeder).',
  'val'           => 'Flatbed',
  'constraint'    => [ 'Flatbed', 'Transparency Unit' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name              => 'auto-eject',
  title             => 'Auto eject',
  index             => 43,
  'desc'            => 'Eject document after scanning',
  'unit'            => SANE_UNIT_NONE,
  'type'            => SANE_TYPE_BOOL,
  'constraint_type' => SANE_CONSTRAINT_NONE,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name            => 'film-type',
  title           => 'Film type',
  index           => 44,
  'desc'          => '',
  'constraint'    => [ 'Positive Film', 'Negative Film' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name  => 'focus-position',
  title => 'Focus position',
  index => 45,
  'desc' =>
    'Sets the focus position to either the glass or 2.5mm above the glass',
  'val'           => 'Focus on glass',
  'constraint'    => [ 'Focus on glass', 'Focus 2.5mm above glass' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap'           => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT,
  'max_values'    => 1,
 },
 {
  name            => 'bay',
  title           => 'Bay',
  index           => 46,
  'desc'          => 'Select bay to scan',
  'constraint'    => [ ' 1 ', ' 2 ', ' 3 ', ' 4 ', ' 5 ', ' 6 ' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_WORD_LIST,
  type            => SANE_TYPE_INT,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
 {
  name            => 'eject',
  title           => 'Eject',
  index           => 47,
  'desc'          => 'Eject the sheet in the ADF',
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_NONE,
  type            => SANE_TYPE_BUTTON,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 0,
 },
 {
  name            => 'adf_mode',
  title           => 'ADF mode',
  index           => 48,
  'desc'          => 'Selects the ADF mode (simplex/duplex)',
  'constraint'    => [ 'Simplex', 'Duplex' ],
  'unit'          => SANE_UNIT_NONE,
  constraint_type => SANE_CONSTRAINT_STRING_LIST,
  type            => SANE_TYPE_STRING,
  'cap' => SANE_CAP_SOFT_DETECT + SANE_CAP_SOFT_SELECT + SANE_CAP_INACTIVE,
  'max_values' => 1,
 },
);
is_deeply( $options->{array}, \@that, 'epson1' );
is( Gscan2pdf::Scanner::Options->device, 'epson:libusb:005:007',
 'device name' );
