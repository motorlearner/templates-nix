data {
   int<lower=0> n;
   array[n] real y;
}
parameters {
    real mu;
    real<lower=0> sigma;
}
model {
    mu ~ normal(0, 10);
    sigma ~ exponential(1);
    y ~ normal(mu, sigma);
}
