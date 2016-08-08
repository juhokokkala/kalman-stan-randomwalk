@ECHO OFF
REM Copyright (c) 2016 Juho Kokkala
REM This file is licensed under the MIT License.

REM Generate data
PYTHON generatedata.py

REM Run the samplers
RANDOMWALK_NAIVE  sample num_samples=100000 random seed=1 init=0 data file=randomwalk.data output file=output_naive.csv
RANDOMWALK_KALMAN sample num_samples=100000 random seed=1 init=0 data file=randomwalk.data output file=output_kalman.csv

REM Summarize results 
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_naive.csv > summary_naive.txt
\STAN\CMDSTAN-2.11.0\BIN\STANSUMMARY output_kalman.csv > summary_kalman.txt
