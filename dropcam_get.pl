#!/usr/bin/perl

# Just grabbing shots into time files
use POSIX qw(strftime);

$folder1 = "./cam1/";
$folder2 = "./cam2/";
$folder3 = "./cam3/";
$darkfile1 = "./cam1/darkref.jpg";
$darkfile2 = "./cam2/darkref.jpg";
$darkfile3 = "./cam3/darkref.jpg";

$dropcam_key1 = "<insert dropcam uuid>";
$dropcam_key2 = "<insert dropcam uuid>";
$dropcam_key3 = "<insert dropcam uuid>";

$url1 = "https://nexusapi.dropcam.com/get_image?width=800&uuid=$dropcam_key1";
$url2 = "https://nexusapi.dropcam.com/get_image?width=800&uuid=$dropcam_key2";
$url3 = "https://nexusapi.dropcam.com/get_image?width=800&uuid=$dropcam_key3";

while(1) {
	$time = strftime "%Y_%m_%d_%H-%M-%S.jpg",localtime;
	$out1 = "$folder1$time";
	$out2 = "$folder2$time";
	$out3 = "$folder3$time";
	`wget -q -O $out1 "$url1"`;
	`wget -q -O $out2 "$url2"`;
	`wget -q -O $out3 "$url3"`;
	$diff1 = `compare -metric RMSE $out1 $darkfile1 /dev/null 2>&1`;
	$diff2 = `compare -metric RMSE $out2 $darkfile2 /dev/null 2>&1`;
	$diff3 = `compare -metric RMSE $out3 $darkfile3 /dev/null 2>&1`;
	chomp($diff1);
	chomp($diff2);
	chomp($diff3);
	# 28178.5 (0.429977)
	$diff1 =~s/[0-9.]+ \(([0-9.]+)\)/\1/;
	$diff2 =~s/[0-9.]+ \(([0-9.]+)\)/\1/;
	$diff3 =~s/[0-9.]+ \(([0-9.]+)\)/\1/;
	if ($diff1 < 0.1) {
		# delete last out1 file
		unlink $out1;
	}
	if ($diff2 < 0.1) {
		# delete last out1 file
		unlink $out2;
	}
	if ($diff3 < 0.1) {
		# delete last out1 file
		unlink $out3;
	}
	sleep 60;
}
