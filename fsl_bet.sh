#!/bin/bash

for ds in *.nii
do
  fslreorient2std 202_HH_anat.nii 202_HH_anat_ro

  bet 202_HH_anat_ro.nii.gz 202_HH_anat_brain -m -R
 
  fslstats 202_HH_anat_brain_mask.nii.gz -V
done
