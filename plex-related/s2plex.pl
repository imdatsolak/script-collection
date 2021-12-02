#!/usr/bin/perl
use Getopt::Long qw(GetOptions);

$SRCDIR="/Volumes/shared/Movies/TV Shows";
$DSTDIR="/Volumes/shared/Movies/TVFlat";

GetOptions('s=s' => \$oneShow, 'd' => \$debug, 'f' => \$forceLink);

chdir($SRCDIR);

if (defined($oneShow) && $oneShow ne "") {
	push(@shows, $oneShow);
} elsif(defined($forceLink)) {
	print "You can only force re-link for one show at a time...\n";
	print "Please use 's' option to specify which show\n";
	exit(1);
}  else {
	opendir($mh, $SRCDIR);
	@shows = readdir($mh);
	closedir($mh);
}

foreach $show (sort @shows) {
	if ($show ne "." && $show ne ".." && $show !~ /DS_Store/) {
        &Debug("$show");
		if (-d $SRCDIR . "/" . $show) {
			chdir($DSTDIR);
			if (! -d $show) {
				mkdir($show);
			}
			chdir($SRCDIR . "/" . $show);
			opendir($mh, $SRCDIR . "/" . $show);
			@seasons = sort readdir($mh);
			closedir($mh);
			for $season (@seasons) {
				if ($season ne "." && $season ne ".." && $season !~ /DS_Store/) {
					&Debug("   $season");
					chdir($DSTDIR . "/" . $show);
					if (! -d $season) {
						mkdir($season);
					}
					chdir($SRCDIR . "/" . $show . "/" . $season);
					opendir($mh, $SRCDIR . "/" . $show . "/" . $season);
					@episodes = sort readdir($mh);
					closedir($mh);
					$seasonNr = $season;
					$seasonNr =~ s/^Season //g;
					if (length($seasonNr) <= 2) {
						$seasonNr = sprintf("%02d", $seasonNr);
						for $episode (@episodes) {
							if ($episode ne "." && $episode ne ".." && $episode !~ /DS_Store/) {
								chdir($DSTDIR . "/" . $show . "/" . $season);
								$episodeNr = $episode;
								$episodeNr =~ s/([^ ]*) .*/\1/g;
								if (length($episodeNr) <= 3) {
									$episodeNr = sprintf("%03d", $episodeNr);
									$ext = $episode;
									$ext =~ s/.*(....)$/\1/g;
									$ext =~ s/\.//g;
									$source = $SRCDIR . "/" . $show . "/" . $season . "/" . $episode;
									$destination = $DSTDIR . "/" . $show . "/" . $season . "/" . $show . ".S" . $seasonNr . "E" . $episodeNr . "." . $ext;
									if ((-f $destination) && (defined($forceLink))) {
										&Debug("      ✗ $episode --> $destination");
										unlink($destination);
										symlink($source, $destination);
									}
									if (! -f $destination) {
                                        &Debug("      ⦿ $episode ⤔  $destination");
										symlink($source, $destination);
									} else {
                                        &Debug("      ✓ $episode");
                                    }
								} else {
                                    &Debug("      ⁉︎ $episode");
                                }
                            }
						}
					}
				}
			}
		} else {
			&Debug("Show '$show' doesn't exist!");
		}
	}
}

sub Debug {
	my ($txt) = @_;
	if (defined($debug)) {
		print $txt . "\n";
	}
}

sub Debugn {
	my ($txt) = @_;
	if (defined($debug)) {
		print $txt;
	}
}

sub DebugNewLine {
	if (defined($debug)) {
		print "\n";
	}
}
