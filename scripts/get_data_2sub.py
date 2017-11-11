import csv
import os
from subprocess import call

with open('Male_2subj_url.txt') as url_males:
    males_data = [line.strip() for line in url_males.readlines()]

for subject in range(0,len(males_data)):
    call('curl {0} > Set1/{1}_anat.nii'.format(males_data[subject], subject), shell=True)
    
    
    
with open('Female_2subj_url.txt') as url_females:
    females_data = [line.strip() for line in url_females.readlines()]

for subject in range(0,len(females_data)):
    call('curl {0} > Set2/{1}_anat.nii'.format(females_data[subject], subject), shell=True)

"""curl https://s3.amazonaws.com/sfn-17/202_HH_anat.nii > 202_HH_anat.nii
fslreorient2std 202_HH_anat.nii 202_HH_anat_ro
bet 202_HH_anat_ro.nii.gz 202_HH_anat_brain -m -R
fslstats 202_HH_anat_brain_mask.nii.gz -V"""