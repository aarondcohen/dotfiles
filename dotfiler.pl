#!/usr/bin/env perl

use strict;
use warnings;

use Dotfiler ();
use FindBin ();
use Getopt::Long ();

my $backup_dir = "$FindBin::Bin/backup";
my $install_dir = $ENV{HOME};
my $is_backup = 1;
my $is_install = 1;
my $source_dir = "$FindBin::Bin/src";
my $verbose = 1;

Getopt::Long::GetOptions(
	'backup!' => \$is_backup,
	'backup-directory=s' => \$backup_dir,
	'install!' => \$is_install,
	'install-directory=s' => \$install_dir,
	'restore-directory=s' => \$source_dir,
	'verbose!' => \$verbose,
);

my $dotfiler = Dotfiler->new(
	backup_directory => $backup_dir,
	dot_symbol => '+DOT+',
	install_directory => $install_dir,
	is_debug => $verbose,
);
$dotfiler->backup($source_dir) if $is_backup;
$dotfiler->install($source_dir) if $is_install;
