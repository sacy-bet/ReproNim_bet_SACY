#!/bin/bash

echo "PROCESSING MALE SUBJECTS" > Male_volumes.txt
for i in {0..14}
do echo "PROCESSING SUBJECT " $i >> Male_volumes.txt
fslreorient2std $i"_anat" $i"_anat_ro"; bet $i"_anat_ro" $i"_anat_brain" -m
fslstats $i"_anat_brain_mask" -V >> Male_volumes.txt
done

echo "PROCESSING FEMALE SUBJECTS" > Female_volumes.txt
for i in {0..14}
do echo "PROCESSING SUBJECT " $i >> Female_volumes.txt
fslreorient2std $i"_anat" $i"_anat_ro"; bet $i"_anat_ro" $i"_anat_brain" -m
fslstats $i"_anat_brain_mask" -V >> Female_volumes.txt
done