options(scipen = 100)

# # 메모리 청소
rm(list = ls())
gc()

library(BL_post_distr)
library(mvtnorm)


# a data sample with num rows and (k+1) columns for k assets;
# returns
load("/home/WJJang/shiny/WJJang/indexes.rda")
R <- indexes
rm(indexes)
k   <- ncol(R)
num <- 100
dat <- cbind(as.matrix(R[1:nrow(R),]),
             matrix(1/nrow(R),nrow(R),1))
# dat <- cbind(rmvnorm (n=100, mean = rep(0,k), sigma=diag(k)),
#              matrix(1/num,num,1))
w_m <- rep(1/k,k) # market portfolio. a vector of length k
cColNames <- c(colnames(R), 'PosteriorExpectedReturns')

# ==============================================================================
# BL_post_distr
# Computes the Black-Litterman posterior distribution.
# ==============================================================================

returns_freq <- 12           # Frequency of data in time series dat
SR           <- 1            # Sharpe ratio
Pe           <- diag(k)      # we assume that views are "absolute views"
qe           <- rep(0.05, k) # user's opinions on future returns (views)
tau          <- 0.02         # Confidence parameter in the Black-Litterman model
df_BL_post_distr <- BL_post_distr(dat,
                                  returns_freq,
                                  prior_type = NULL,
                                  w_m,
                                  SR,
                                  Pe,
                                  qe,
                                  tau,
                                  risk = "MAD",
                                  alpha = 0,
                                  views_distr = observ_normal,
                                  views_cov_matrix_type = "diag",
                                  cov_matrix = cov(dat[,1:6]))
nrow(df_BL_post_distr$post_distr)
head(dat)
colnames(df_BL_post_distr$post_distr) <- cColNames
head(df_BL_post_distr$post_distr)


# ==============================================================================
# equilibrium_mean
# Solves the inverse optimization to mean-risk standard optimization problem to find equilibrium returns.
# The function is invoked by BL_post_distr and arguments are supplemented by BL_post_distr.
# ==============================================================================

RM = 0.05 # market expected return.
df_equilibrium_mean <- equilibrium_mean(dat,
                                        w_m,
                                        RM,
                                        risk = "CVAR",
                                        alpha = 0.95)
df_equilibrium_mean


# ==============================================================================
# observ_normal
# Example of distribution of views – normal distribution
# ==============================================================================

df_observ_normal <- observ_normal(x = matrix(c(rep(0.5,k),rep(0.2,k)),k,2),
                                  q = matrix(0,k,1),
                                  covmat = diag(k))
df_observ_normal


# ==============================================================================
# observ_powerexp
# Example of distribution of views – power exponential distribution
# ==============================================================================

df_observ_powerexp <- observ_powerexp(x = matrix(c(rep(0.5,k),rep(0.2,k)),k,2),
                                      q = matrix(0,k,1),
                                      covmat = diag(k),
                                      beta = 0.6)
df_observ_powerexp


# ==============================================================================
# observ_ts
# Example of distribution of views – Student t-distribution
# ==============================================================================

df_observ_ts <- observ_ts(x = matrix(c(rep(0.5,k),rep(0.2,k)),k,2),
                          q = matrix(0,k,1),
                          covmat = diag(k),
                          df=5)
df_observ_ts


