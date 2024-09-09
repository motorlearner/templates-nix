data {
  int<lower=0> n;
  array[n] int<lower=0,upper=1> y;
}
parameters {
  real<lower=0,upper=1> theta;
}
model {
  theta ~ beta(2,2);
  y ~ bernoulli(theta);
}
