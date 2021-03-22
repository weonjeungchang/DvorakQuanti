options(scipen = 100)

# # 메모리 청소
rm(list = ls())
gc()

library(PortfolioAnalytics)
library(ROI)
library(Rglpk)


# returns
load("/home/WJJang/shiny/WJJang/indexes.rda")
R <- indexes
rm(indexes)
# R <- rmvnorm (n=100, mean = rep(0,k), sigma=diag(k))
# a K x N pick matrix
P = diag(ncol(R)) # matrix( c(0,0,0,0,0,0, -1,0,0,0,1,1, 0,0,-1,0,0,1),3,6)
# Omega = matrix(c(0.000801,0,0, 0,0.009546,0, 0,0,0.00084),3,3)


# ==============================================================================
# black.litterman
# Compute the Black Litterman estimate of moments for the posterior normal.
# ==============================================================================
# BlackLittermanFormula = function( Mu, Sigma, P, v, Omega) {
#   BLMu    = Mu + Sigma %*% t( P ) %*% ( solve( P %*% Sigma %*% t( P ) + Omega ) %*% ( v - P %*% Mu ) );
#   BLSigma =  Sigma -  Sigma %*% t( P ) %*% ( solve( P %*% Sigma %*% t( P ) + Omega ) %*% ( P %*% Sigma ) );
#   
#   return( list( BLMu = BLMu , BLSigma = BLSigma ) );
# }
#
# black.litterman <- function(R, P, Mu=NULL, Sigma=NULL, Views=NULL) {
# 
#   # Compute the sample estimate if mu is null
#   if(is.null(Mu)) {
#     Mu <- colMeans(R)
#   }
#   if(length(Mu) != NCOL(R)) stop("length of Mu must equal number of columns of R")
# 
#   # Compute the sample estimate if sigma is null
#   if(is.null(Sigma)) {
#     Sigma <- cov(R)
#   }
#   if(!all(dim(Sigma) == NCOL(R))) stop("dimensions of Sigma must equal number of columns of R")
# 
#   # Compute the Omega matrix and views value
#   Omega = tcrossprod(P %*% Sigma, P)
#   
#   if(is.null(Views)) {
#     Views = as.numeric(sqrt( diag( Omega ) ))
#   }
#   
#   B = BlackLittermanFormula( Mu, Sigma, P, Views, Omega )
#   
#   return(B)
# }

df_black.litterman <- black.litterman(R, P, Mu = NULL, Sigma = NULL, Views = NULL)
print("posterior expected values : ")
df_expected <- as.data.frame(cbind(colMeans(R), df_black.litterman$BLMu))
colnames(df_expected) <- c('prior_expected_values', 'posterior_expected_values')
df_expected

print("posterior covariance matrix : ")
df_black.litterman$BLSigma


# ==============================================================================
# meanvar.efficient.frontier
# Generate the efficient frontier for a mean-variance portfolio
# ==============================================================================
pspec <- portfolio.spec(assets=colnames(R))
# pspec <- portfolio.spec(assets=ncol(R),
#                         category_labels=colnames(R),
#                         weight_seq=generatesequence())

# ------------------------------------------------------------------------------
# ** constraint
# https://bookdown.org/sstoeckl/Tidy_Portfoliomanagement_in_R/s-4portfolios.html#sss_4constr
# ------------------------------------------------------------------------------
### 4.2.2.1 Sum of Weights Constraint : maximum/minimum sum of portfolio weights
## 하단 2line 같은 의미
pspec <- add.constraint(portfolio=pspec, type="full_investment")
# pspec <- add.constraint(portfolio=pspec, type="weight_sum", min_sum=1, max_sum=1)
## 하단 3line 같은 의미
# pspec <- add.constraint(portfolio=pspec, type="dollar_neutral")
# pspec <- add.constraint(portfolio=pspec, type="active")
# pspec <- add.constraint(portfolio=pspec, type="weight_sum", min_sum=0, max_sum=0)

### 4.2.2.2 Box Constraint : upper and lower bounds on the asset weights
# pspec <- add.constraint(portfolio=pspec, type="box",
#                         min=0,
#                         max=0.4)
# pspec <- add.constraint(portfolio=pspec, type="box",
#                         min=c(0.05, 0, rep(0.05,8)),
#                         max=c(0.4, 0.3, rep(0.4,8)))
pspec <- add.constraint(portfolio=pspec, type="long_only")  # positive weights per asset. These are set automatically

### 4.2.2.3 Group Constraints

### 4.2.2.4 Position Limit Constraint

### 4.2.2.5 Diversification Constraint

### 4.2.2.6 Turnover Constraint
# pspec <- add.constraint(portfolio=pspec, type="turnover", turnover_target=0.2)

### 4.2.2.7 Target Return Constraint
# pspec <- add.constraint(portfolio=pspec, type="return", return_target=0.007)

### 4.2.2.8 Factor Exposure Constraint

### 4.2.2.9 Transaction Cost Constraint

### 4.2.2.10 Leverage Exposure Constraint

### 4.2.2.11 Checking and en-/disabling constraints

# ------------------------------------------------------------------------------
# ** Objectives
# https://bookdown.org/sstoeckl/Tidy_Portfoliomanagement_in_R/s-4portfolios.html#sss_4portObj
# ------------------------------------------------------------------------------
### 4.2.3.1 Portfolio Risk Objective
pspec <- add.objective(portfolio=pspec, type='risk', name='var')

### 4.2.3.2 Portfolio Return Objective
pspec <- add.objective(portfolio=pspec, type='return', name='mean')

### 4.2.3.3 Portfolio Risk Budget Objective
# pspec <- add.objective(portfolio=pspec, type="risk_budget", name="var", max_prisk=0.3)


#' @param R xts object of asset returns
#' @param portfolio object of class 'portfolio' specifying the constraints and objectives, see \code{\link{portfolio.spec}}.
#' @param type type of efficient frontier, see Details. c('mean-var', 'mean-etl', 'random', 'DEoptim')
#' @param n.portfolios number of portfolios to calculate along the efficient frontier
#' @param risk_aversion vector of risk_aversion values to construct the efficient frontier.
#' \code{n.portfolios} is ignored if \code{risk_aversion} is specified and the number of points along the efficient frontier will be equal to the length of \code{risk_aversion}.
#' @param match.col column to match when extracting the efficient frontier from an objected created by \code{\link{optimize.portfolio}}. for type="DEoptim" or type="random".
#' @param search_size passed to \code{\link{optimize.portfolio}} for type="DEoptim" or type="random".
df_efficient_frontier <- create.EfficientFrontier(R,
                                                  portfolio     = pspec,
                                                  type          ='mean-var', # 'mean-var':QP solver, 'mean-ETL':LP solver
                                                  n.portfolios  = 100,
                                                  risk_aversion = NULL,
                                                  match.col     = NULL,
                                                  search_size   = NULL)
df_efficient_frontier$call      # call
df_efficient_frontier$frontier  # frontier
df_efficient_frontier$R         # "xts" "zoo"
# df_efficient_frontier$portfolio # "portfolio.spec" "portfolio"  
df_efficient_frontier$portfolio$assets
df_efficient_frontier$portfolio$constraints
df_efficient_frontier$portfolio$objectives

plot(df_efficient_frontier$frontier[,2], df_efficient_frontier$frontier[,1],
     xlab = 'Risk',ylab = 'Returns',
     type = 'l',
     lty = 1,
     lwd = 3,
     main = 'Mean Variance Optimizer',col = 'blue')

ggplot2(data = df_efficient_frontier, aes(x = StdDev, y = mean))

# lines(sigmaP,
#       Rvals,"l",
#       lty = 1,
#       lwd=3,
#       col = 'red')
# legend('topleft', c("Simple variance method","BL Method"), pch = 17,  col = c('red','blue'), text.col = c('red','blue'), cex = .6)


