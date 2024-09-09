data_list <- list(
  n = 100,
  y = rbinom(100, 1, 0.3)
)

library(cmdstanr)

file <- file.path("test_cmdstanr", "bernoulli.stan")
mod  <- cmdstan_model(file)
fit  <- mod$sample(
  dat = data_list,
  chains = 4,
  parallel_chains = 4,
  refresh = 100
)

fit$summary()