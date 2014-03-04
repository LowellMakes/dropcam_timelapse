#!/usr/bin/perl

# This is used to take n paths containing same named files (time_stamps)
# And generate montage of them with ImageMagick to later be able to generate
# a time lapse video of all images syncronized together.
use File::Spec;

### BEING Config
$outputFolder = "/p/lowellMakes/combined/";
$geometry = "+2+2";

### END CONFIG
$folderList = `cat folders.txt`;
@folders = split("\n",$folderList);

#print "FolderList = $folderList\n";
$count = @folders;
$tile = "";

if ($count == 0) {
    print "Error: Couldn't read the folder list";
    exit();
}
if ($count == 3) {   
    $tile = " -tile 2x2";
}

@files = glob "$folders[0]/2014_03_03_19*.jpg";
$totalFiles = @files;
print "Found $totalFiles files\n";
foreach $file (@files) {
    # First make sure we're getting just the file name
    ($volume,$dir,$file) = File::Spec->splitpath($file);
    # Next confirm it exists in all the folders
    $cont= 1;
    $image_list = "";
    #print "Checking $file existance in all folders\n";
    for($i=0;$i < $count;$i++) {
        unless (-e "$folders[$i]/$file") {
            $cont = 0;
            #print "-> $folders[$i]/$file DOES NOT EXIST!\n";
        }
        $image_list .= "$folders[$i]/$file ";
    }
    if ($cont == 0) {
        #print "**Found non-match file = $file\n";
        next;
    }
    `montage $image_list$tile -geometry $geometry $outputFolder$file`;
    #print "Test Cmd: \nmontage $image_list$tile -geometry $geometry $outputFolder$file\n\n";
}
#mencoder -nosound -noskip -oac copy -ovc copy -o output.avi -mf fps=15 'mf://@files.txt' # Very fast but does not create index so if you want to edit with a non linear editor do not choose this.
#mencoder -idx -nosound -noskip -ovc lavc -lavcopts vcodec=mjpeg -o output.avi -mf fps=15 'mf://@files.txt' # Fast, it will create index, but it will re-compress the JPG files so some loss of quality will occur (insignificant, so you can safely bet on this) 
#mencoder -idx -nosound -noskip -ovc lavc -lavcopts vcodec=ljpeg -o output.avi -mf fps=15 'mf://@files.txt' # Slow, it will create index, it will re-compress the JPG file but with the highest quality options to provide lossless results (the final file will be larger than the total of the original files, but if you are a quality freak, then go for this one)