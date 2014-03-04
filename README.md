dropcam_timelapse
=================

This is a setup to automatically grab images from a set of drop cams and see if their the same as a "boring" reference and it automaticlly deletes the boring pictures.

====
Requirements: 
- Perl
- ImageMagick (specifically the compare program needs to be in the path)

====
Setup:
- Edit cams.txt
Format is <path>:<cam uuid>

Run:
./dropcam_get.pl
or
perl dropcam_gel.pl

====
Merge images from multiple cameras into a single combined image set.

Setup:
- Edit folders.txt
Format is <folder_path> on each line

Run:
./generate_combined.pl
or
perl generate_combined.pl

