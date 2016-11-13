#!usr/bin/env perl

use strict;
use warnings;

our $VERSION='0.1211';

my $target='KSP_Data/mainData';
my $backup='KSP_Data/mainData-ksp-fullscreenfix-backup';
my $kspversions;
{
	my $v1_0_x=+{
		addr=>0x109c,
		check_addr=>0x101c,
		check_string=>"\x05\x00\x00\x00Squad\x00\x00\x00\x14\x00\x00\x00Kerbal Space Program",
	};
	my $v1_1_x=+{
		addr=>0x4044,
		check_addr=>0x3fb8,
		check_string=>"\x05\x00\x00\x00Squad\x00\x00\x00\x14\x00\x00\x00Kerbal Space Program",
	};
	my $v1_1_2=+{
		addr=>0x3f24,
		check_addr=>0x3e98,
		check_string=>"\x05\x00\x00\x00Squad\x00\x00\x00\x14\x00\x00\x00Kerbal Space Program",
	};
	my $v1_2=+{
		addr=>0x10e0,
		check_addr=>0x1024,
		check_string=>"\x05\x00\x00\x00Squad\x00\x00\x00\x14\x00\x00\x00Kerbal Space Program",
		target=>'globalgamemanagers',
	};
	$kspversions=+{
		830=>+{version=>'1.0.0',%$v1_0_x},
		840=>+{version=>'1.0.1',%$v1_0_x},
		842=>+{version=>'1.0.2',%$v1_0_x},
		861=>+{version=>'1.0.4',%$v1_0_x},
		1024=>+{version=>'1.0.5',%$v1_0_x},
		1028=>+{version=>'1.0.5',%$v1_0_x},
		1183=>+{version=>'1.1.0 prerelease 1183',%$v1_1_x},
		1230=>+{version=>'1.1.0',%$v1_1_x},
		1250=>+{version=>'1.1.1',%$v1_1_x},
		1260=>+{version=>'1.1.2',%$v1_1_2},
		1289=>+{version=>'1.1.3',%$v1_1_2},
		1586=>+{version=>'1.2',%$v1_2},
		1604=>+{version=>'1.2.1',%$v1_2},
		705=>+{
			version=>'0.90.0',
			addr=>0x1098,
			check_addr=>0x1018,
			check_string=>"\x05\x00\x00\x00Squad\x00\x00\x00\x14\x00\x00\x00Kerbal Space Program",
		}
	};
}

print "$/This is KSP exclusive fullscreen fix $VERSION$/$/";

$@='';
eval {
	main();
};
if (length($@)) {
	print "$/Error: $@$/$/Press Enter to close window$/";
} else {
	print "$/I'm done. Press Enter to close window$/";
}
<STDIN>;

sub main {
	my $build=kspversion();
	unless (defined $build) {
		print "ERROR: start this in a KSP Installation folder (where KSP.exe is)$/";
		return;
	}
	my $conf=$kspversions->{$build};
	if (defined $conf->{'target'}) {
		$target="KSP_Data/$conf->{target}";
		$backup="KSP_Data/$conf->{target}-ksp-fullscreenfix-backup";
	}
	if ($build>=1183) {
		s/^KSP_Data/KSP_x64_Data/ for ($target,$backup);
	}
	die "build $build: unknown build" unless defined $conf;
	print "Detected KSP version: $conf->{version}$/";
	my $fixed=check($conf);
	unless (defined $fixed) {
		print "$target to be patched has unexpected content, aborting.$/";
		return;
	}
	if ($fixed) {
		print "$target is already patched to exclusive fullscreen mode.$/";
		return;
	} else {print "$target seems to be unpatched yet.$/"}
	print "$/Shall we really patch KSP to use exclusive fullscreen mode?$/";
	print "Enter to do it, CTRL-C to abort$/";
	<STDIN>;
	print "Patching $target...$/";
	patch($conf);
	print "PATCHED$/";
}

sub check {
	my $conf=shift;
	open my $fh,'<',$target or die "$target: $!";
	binmode $fh;
	sysseek $fh,$conf->{check_addr},0 or die "$target: $!";
	my $buf;
	my $red=sysread $fh,$buf,length($conf->{check_string}) or die "$target: $!";
	die "$target: read failed" unless $red==length($conf->{check_string});
	return undef unless $buf eq $conf->{check_string};
	
	sysseek $fh,$conf->{addr},0 or die "$target: $!";
	$buf='';
	$red=sysread $fh,$buf,4 or die "$target: $!";
	die "$target: read failed" unless $red==4;
	return undef unless $buf eq "\x00\x00\x00\x00" || $buf eq "\x01\x00\x00\x00";
	$buf=substr($buf,0,1);
	return 1 if $buf eq "\x00";
	return 0;
}

sub patch {
	my $conf=shift;
	if (-e $backup) {
		print "backup fle $backup already exists, not making a backup$/";
	} else {
		print "Creating backup $backup$/";
		copy($target,$backup) or die "Backing up to $backup failed: $!";
	}
	open my $fh,'+<',$target or die "$target: $!";
	binmode $fh;
	
	sysseek $fh,$conf->{addr},0 or die "$target: $!";
	my $buf="\x00";
	my $wrote=syswrite $fh,$buf,1 or die "$target: $!";
	die "$target: write failed" unless $wrote==1;
	close $fh or die "$target: $!";
}


# get KSP version
sub kspversion {
	my $fn='buildID.txt';
	if (-e $fn) {
		open my $fh,'<',$fn or die "$fn: $!";
		my $line=<$fh>;
		chomp $line;
		die "$fn: $line: could not parse build id" unless $line=~/^build id \= (\d+)$/;
		return 0+$1;
	}
	return undef;
}

sub copy {
	my ($sfn,$ofn)=@_;
	open my $fh,'<',$sfn or die "copying $sfn: $!";
	binmode $fh;
	open my $ofh,'>',$ofn or die "copying to $ofn: $!";
	binmode $ofh;
	my $buf;
	while (1) {
		$buf='';
		my $read=sysread($fh,$buf,4096);
		die "copying $sfn: $!" unless defined $read;
		last if $read==0;
		my $wrote=syswrite($ofh,$buf);
		die "copying to $ofn: $!" unless defined $wrote;
		die "copying to $ofn: partial write" unless $wrote==$read;
	}
	close($fh);
	close($ofh) or die "copying to $ofn: $!";
}