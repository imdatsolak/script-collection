#!/usr/bin/perl
use Getopt::Long qw(GetOptions);

GetOptions('r=s' => \$restart, 'd' => \$debug, 'f' => \$forceLink);
if (defined($restart)) {
	$autoid = 1;
}

opendir($mh, ".");
@files = readdir($mh);
closedir($mh);

foreach $entry (@files) {
	if ($entry !~ /DS_Store/) {
		chomp($entry);
		if (!defined($restart)) {
		$episode = $entry;
		$episode =~ s/.*([0-9][0-9]).*$/\1/g;
		} else {
			$episode = $autoid;
			$autoid++;
		}
		$ext = $entry;
		$ext =~ s/.*(....)$/\1/g;
		$ext =~ s/\.//g;
		$outfile = sprintf("%02d NAME.%s", $episode, $ext);
		print "rename(\"$entry\", \"$outfile\");\n";
		rename("$entry", "$outfile");
	}	
}

