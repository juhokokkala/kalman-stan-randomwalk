################################################################################
# Copyright (C) 2016 Juho Kokkala
#
# This file is licensed under the MIT License.
################################################################################
"""Script for simulating the data and writing it into the Stan R format"""

import numpy as np

##Parameters
m0 = 0
P0 = 1
sqrtQ = 0.1
sigma_z = 0.5;
T = 100

##Simulate sigma_y, x, z, y
np.random.seed(1)

sigma_y = np.random.choice(3,size=T) + 0.5 #unif from {0.5,1.5,2.5}

x = np.zeros(T)
x[0] = np.random.normal(m0,np.sqrt(P0));
for i in range(1,T):
    x[i] = np.random.normal(x[i-1], sqrtQ);
    
z = np.random.normal(x,sigma_z);
y = np.random.normal(z,sigma_y);
    
##Write data into Stan format
file = open("randomwalk.data","w")
file.write("T<-"+str(T)+"\n")
file.write("m0<-"+str(m0)+"\n")
file.write("P0<-"+str(P0)+"\n")
file.write("y<-c(")
for i in range(T-1):
    file.write(str(y[i])+",")
file.write(str(y[-1])+")\n")
file.write("sigma_y<-c(")
for i in range(T-1):
    file.write(str(sigma_y[i])+",")
file.write(str(sigma_y[-1])+")\n")
file.close()