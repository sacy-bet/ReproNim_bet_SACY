#!/bin/bash

python get_data.py
bash fsl_bet.sh
python stats.py