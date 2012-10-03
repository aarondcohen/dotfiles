package Dotfiler;

use strict;

use File::Basename ();
use File::Compare ();
use File::Copy ();
use File::Find ();
use File::Path ();

sub new {
	my ($class, %args) = @_;
	$class = ref $class || $class;

	bless my $this = {}, $class;

	$this->$_($args{$_}) for qw{
		backup_directory
		dot_symbol
		install_directory
		is_debug
	};

	return $this;
}

sub backup_directory {
	my $this = shift;
	$this->{_backup_directory} = $this->_normalize_directory(@_) if @_;
	return $this->{_backup_directory};
}

sub dot_symbol {
	my $this = shift;
	if (@_) {
		$this->{_dot_symbol} = $_[0];
		$this->{_dot_symbol} = '' unless defined $this->{_dot_symbol};
	}
	return $this->{_dot_symbol};
}

sub install_directory {
	my $this = shift;
	$this->{_install_directory} = $this->_normalize_directory(@_) if @_;
	return $this->{_install_directory};
}

sub is_debug {
	my $this = shift;
	$this->{_is_debug} = !! $_[0] if @_;
	return $this->{_is_debug};
}



sub backup {
	my $this = shift;
	my ($source_directory) = @_;

	$source_directory = $this->_normalize_directory($source_directory);

	die "Source directory [$source_directory] could not be found for backup" unless -d $source_directory;
	die "Backup requires both an installation and backup directory" unless $this->backup_directory && $this->install_directory;

	my @source_files;
	File::Find::find(+{ wanted => sub { push @source_files, $_ if -f }, no_chdir => 1 }, $source_directory);

	for my $source_file (@source_files) {
		my $relative_file = $source_file;
		substr $relative_file, 0, length $source_directory, '';

		my $destination_file = $this->install_directory . $this->to_dot($relative_file);

		$this->_debug("Examining file [$source_file] for backup");

		#Only backup files if we know where to back them up to
		#and a differing file would be overwritten
		if (-e $destination_file && File::Compare::compare($source_file, $destination_file)) {
			eval { $this->_copy_file($destination_file, $this->versioned_backup_directory . $this->from_dot($relative_file)); 1 }
				|| die "Failed during backup: $@";
		}
	}

	return 1;
}

sub install {
	my $this = shift;
	my ($source_directory) = @_;

	$source_directory = $this->_normalize_directory($source_directory);

	die "Source directory [$source_directory] could not be found for install" unless -d $source_directory;
	die "Install requires an installation directory" unless $this->install_directory;

	my @source_files;
	File::Find::find(+{ wanted => sub { push @source_files, $_ if -f }, no_chdir => 1 }, $source_directory);

	for my $source_file (@source_files) {
		my $relative_file = $source_file;
		substr $relative_file, 0, length $source_directory, '';

		$this->_debug("Examining file [$source_file] for installation");

		eval { $this->_copy_file($source_file, $this->install_directory . $this->to_dot($relative_file)); 1 }
			|| die "Failed during installation: $@";
	}

	return 1;
}

sub from_dot {
	my $this = shift;
	my ($file_path) = @_;

	return $file_path if $this->dot_symbol eq '';

	my $dot_symbol = $this->dot_symbol;
	$file_path =~ s#(?:^|/)\.#$dot_symbol#g;

	return $file_path;
}

sub to_dot {
	my $this = shift;
	my ($file_path) = @_;

	return $file_path if $this->dot_symbol eq '';

	my $dot_symbol = quotemeta $this->dot_symbol;
	$file_path =~ s#(?:^|/)$dot_symbol#.#g;

	return $file_path;
}

sub versioned_backup_directory {
	my $this = shift;

	return $this->{_versioned_backup_directory} if $this->{_versioned_backup_directory};

	#Get today's date in YYYYMMDD format
	my ($day, $month, $year) = (localtime)[3,4,5];
	my $today = sprintf "%d%02d%02d", $year+1900, $month+1, $day;

	#Determine the most recent versioned backup
	my ($latest_version) = sort { $b cmp $a } $this->_list_directory($this->backup_directory);

	#Determine the next backup version: today's date + the next version created today
	my $next_version = sprintf("%s.%03d",
		$today,
		! defined $latest_version || $today gt $latest_version
			? 0
			: do { $latest_version =~ /\.(\d+)$/; ($1 || 0) + 1 }
	);

	#Get the full versioned backup path
	my $versioned_backup_directory = $this->backup_directory . $next_version . '/';

	$this->_debug("Creating versioned backup directory [$versioned_backup_directory]");
	do {
		my $errors_ref;
		File::Path::make_path($versioned_backup_directory, { error => \$errors_ref });
		local $" = '; ';
		die "Failed to create versioned backup directory [$versioned_backup_directory] - @$errors_ref" if @$errors_ref;
	};

	return $this->{_versioned_backup_directory} = $versioned_backup_directory;
}

#Helper functions

sub _copy_file {
	my $this = shift;

	my ($source, $destination) = @_;

	my $destination_path = File::Basename::dirname($destination);

	$this->_debug("Creating destination path [$destination_path]");
	do {
		my $errors_ref;
		File::Path::make_path($destination_path, { error => \$errors_ref });
		local $" = '; ';
		die "Failed to create destination path [$destination_path] - @$errors_ref" if @$errors_ref;
	};

	$this->_debug("Copying from [$source] to [$destination]");
	File::Copy::copy($source, $destination)
		|| die "Failed to copy file from [$source] to [$destination] - $!";

	return 1;
}

#Print debugging messages when enabled
sub _debug {
	my $this = shift;
	my ($message) = @_;

	local $\="\n";
	print STDERR $message if $this->is_debug;
}

#Implement system's ls in code
sub _list_directory {
	my $this = shift;

	my ($directory) = @_;

	$this->_debug("Listing files in directory [$directory]");
	opendir(my $dh, $directory) || die "Failed to open directory [$directory] - $!";
	my @files = grep { $_ !~ /^\.\.?$/ } readdir($dh);
	closedir $dh;

	return @files;
}

#Add a single slash to the end of a directory
sub _normalize_directory {
	my $this = shift;
	my ($directory) = @_;

	return unless defined $directory;

	$directory =~ s|/*$|/|;

	return $directory;
}


1;
