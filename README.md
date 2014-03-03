dropcam_timelapse
=================

This is a setup to automatically grab images from a set of drop cams and see if their the same as a "boring" reference and it automaticlly deletes the boring pictures.

====
Requirements: 
- Perl
- ImageMagick (specifically the compare program needs to be in the path)

====
To use: edit dropcam_get.pl to set the drop cams UUID values to the uuids you want to capture.  Dropcam must be made public for this to work.
Change:
$dropcam_key1 = "<insert dropcam uuid>";
To:
$dropcam_key1 = "001122334455abcdef01012";
