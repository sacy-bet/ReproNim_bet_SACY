#!/bin/bash


for i in {0..1}
do fslreorient2std Data/Set1/$i"_anat" Data/Set1/$i"_anat_ro"; bet Data/Set1/$i"_anat_ro" Data/Set1/$i"_anat_brain" -m
fslstats Data/Set1/$i"_anat_brain_mask" -V >> Data/Set1/Male_volumes.txt
done

for i in {0..1}

do fslreorient2std Data/Set2/$i"_anat" Data/Set2/$i"_anat_ro"; bet Data/Set2/$i"_anat_ro" Data/Set2/$i"_anat_brain" -m
fslstats Data/Set2/$i"_anat_brain_mask" -V >> Data/Set2/Female_volumes.txt
done