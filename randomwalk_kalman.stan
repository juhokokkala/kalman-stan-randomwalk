/* 
 * Linear-Gaussian Random walk + Jitter model, Kalman filter version
 * -----------------------------------------------------------------
 * Copyright: Juho Kokkala
 * Date: 08 August 2016
 * License: MIT
 */

data {
    //Data
    int<lower=1> T;   //Time-series length
    vector[T] y; //Measurements
    vector<lower=0>[T] sigma_y; //Measurement std:s  

    //Initial distribution of x
    real m0; 
    real<lower=0> P0; 
}

parameters {
    real<lower=0> sigma_z; //Standard deviation of jitter
    real<lower=0> sqrtQ; //Standard deviation of random walk
}



transformed parameters {
    vector[T] m; //filtered mean x_t|y_1:t
    vector[T] P; //filtered var x_t|y_1:t
    vector[T] R; //measurement variance,  y_t|x_t
    vector[T] S; //measurement variance, y_t|y_1:t-1
    vector[T] m_pred; //predicted mean x_t|y_1:t-1
    vector[T] P_pred; //predicted var x_t|y_1:t-1
    real K;  //Kalman gain, depends on t but not stored

    //Filtering 
    R = sigma_y .* sigma_y + sigma_z*sigma_z;
 
    m_pred[1] = m0;
    P_pred[1] = P0;

    for (t in 1:T) {
        //Prediction step
        if (t>1) {
            m_pred[t] = m[t-1];
            P_pred[t] = P[t-1] + sqrtQ*sqrtQ;
        }

        //Update step
        S[t] = P_pred[t] + R[t];
        K = P_pred[t]/S[t];
        m[t] = m_pred[t] + K*(y[t] - m_pred[t]);   //The measurement is just noise added to signal, so mu==m_pred
        P[t] = P_pred[t] - K*S[t]*K;
    }    
}

model {
    //Parameter priors
    sigma_z ~ student_t(2, 0, 1);
    sqrtQ ~ student_t(2,0,1);

    //Likelihood p(y|parameters)
    for (t in 1:T) {
        y[t] ~ normal(m_pred[t], sqrt(S[t])); //Should vectorize this but I didn't get how to do a vectorized sqrt :(
    }
}

generated quantities {
    vector[T] x; //The random-walking signal
    vector[T] z; //x + jitter

    //Sampling x
    x[T] = normal_rng(m[T], sqrt(P[T]));
    for (i in 1:T-1) {
        int t;
        real varx;
        real meanx;
        t = T-i;
        varx = 1 / (1/P[t] + 1/(sqrtQ*sqrtQ));
        meanx = (m[t]/P[t] + x[t+1]/(sqrtQ*sqrtQ))*varx;
        x[t] = normal_rng(meanx,sqrt(varx));
    }
    
    //Sampling z
    for (t in 1:T) {
        real meanz;
        real varz;
        varz = 1/ (1/(sigma_z*sigma_z) + 1/(sigma_y[t]*sigma_y[t]));
        meanz = varz * (x[t]/(sigma_z*sigma_z) + y[t]/(sigma_y[t]*sigma_y[t]));
        z[t] = normal_rng(meanz,sqrt(varz));
    }
}