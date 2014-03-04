#!/usr/bin/perl

# Just grabbing shots into time files
use POSIX qw(strftime);

$camera_list = `cat cams.txt`;
$referenceFileName = "darkref.jpg";
@cameras = split("\n",$camera_list);
@keys = ();
@folders = ();
foreach $camera (@cameras) {
	#print "Got line $camera\n";
	$camera =~/^(.*?):([0-9a-fA-F]+)/;
	$folder = $1;
	$key = $2;
	#print "Got pieces ($1) & ($2)\n";
	if (($folder ne "") && ($key ne "")) {
		#print "Added to list\n";
		push(@folders,$folder);
		push(@keys,$key); 
	}
}
$length = @keys;
#print "Found $length items\n";

while(1) {
	#print "Starting Loop\n";	
	for($i = 0; $i<$length;$i++) {
		#print "Working on item $i\n";
		$key = $keys[$i];
		$folder = $folders[$i];
		$url = "https://nexusapi.dropcam.com/get_image?width=800&uuid=$key";
		$darkfile = "$folder$referenceFileName";
		$time = strftime "%Y_%m_%d_%H-%M-%S.jpg",localtime;
		$out = "$folder$time";
		#print "Item $i: key=$key,folder=$folder,url=$url,darkfile=$darkfile,out=$out\n";
		`wget -q -O $out "$url"`;
		$diff = `compare -metric RMSE $out $darkfile /dev/null 2>&1`;
		chomp($diff);
	    # 28178.5 (0.429977)
		$diff =~s/[0-9.]+ \(([0-9.]+)\)/\1/;
		if (($diff != "") && ($diff < 0.1)) {
			# delete last out file
			unlink $out;
		}
	}
	sleep 60;
}
