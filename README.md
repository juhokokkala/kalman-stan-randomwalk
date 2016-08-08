## Kalman filter style recursion to marginalize state variables to speed up Stan inference

A demonstration of how a certain Stan (http://mc-stan.org) model can be made faster by marginalizing a conditionally linear-Gaussian part using a Kalman filter within Stan. A detailed description/documentation will soon appear in my blog. 

I expect the meaning of the files here to be rather clear after reading the blog post, so no extensive documentation here.

The .stan files are the versions of the Stan model. summary*.txt contains the outputs of the stansummary tool of CmdStan with my precomputed results.  

## Replication Instructions

See runall.bat for the exact parameters used in calling the samplers. This runall.bat is an MS-DOS/Windows batch file for running the experiment (tested with Windows 10, for ancient DOS versions the @ in the beginning must perhaps be removed). 

runall.bat has the following prerequisites:
- CmdStan 2.11.0 needs to be installed at \stan\cmdstan-2.11.0\
- The .stan files need to be compiled so that the current directory contains randomwalk_naive.exe and randomwalk_kalman.exe

## License information

Copyright (c) Juho Kokkala 2016. All files in this repository are licensed under the MIT License. See the file LICENSE or http://opensource.org/licenses/MIT. 