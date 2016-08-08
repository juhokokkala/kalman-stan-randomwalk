/* 
 * Linear-Gaussian Random walk + Jitter model, Naive version
 * ---------------------------------------------------------
 * Copyright: Juho Kokkala
 * Date: 08 August 2016
 * License: MIT
 */

data {
    int<lower=1> T;   //Time-series length
    vector[T] y; //Measurements
    vector<lower=0>[T] sigma_y; //Measurement std:s  

    //Fixed parameters (initial distribution of x)
    real m0; 
    real<lower=0> P0; 
}

parameters {
    vector[T] x; //The random-walking signal
    vector[T] z; //Denoised measurement, i.e., signal plus jitter
    real<lower=0> sigma_z; //Standard deviation of the jitter
    real<lower=0> sqrtQ; //Standard deviation of random walk
}


model {
    sigma_z ~ student_t(2, 0, 1);
    sqrtQ ~ student_t(2,0,1);
    
    x[1] ~ normal(m0,sqrt(P0));
    for (t in 2:T) {
        x[t] ~ normal(x[t-1], sqrtQ);
    }
    
    z ~ normal(x,sigma_z);
    y ~ normal(z,sigma_y);
}
