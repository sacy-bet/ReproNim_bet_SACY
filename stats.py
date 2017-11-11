import csv
import os
from subprocess import call
import scipy.stats as stats

males_all=[]
with open('Data/Set1/Male_volumes.txt') as males_data:
    males_individual = [line.strip() for line in males_data.read().split(' ')]
    for i in range(0,len(males_individual)):
        if i % 2 != 0:
            #print(males_individual[i])
            males_all.append(float(males_individual[i]))
        else:
            continue

females_all=[]
with open('Data/Set2/Female_volumes.txt') as females_data:
    females_individual = [line.strip() for line in females_data.read().split(' ')]
    for i in range(0,len(females_individual)):
        if i % 2 != 0:
            #print(females_individual[i])
            females_all.append(float(females_individual[i]))
        else:
            continue
            
            
t_stat, p_val = stats.ttest_ind(males_all, females_all, equal_var=False)
print('t_stat: ',t_stat,'pval: ',p_val)