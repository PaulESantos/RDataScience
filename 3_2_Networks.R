#' ---
#' title: "Network_tutorial"
#' author: "Naia Morueta-Holme"
#' ---
#' 
#' 
#' # Setup
## ----message=F, warning=F------------------------------------------------
library(netassoc)


#' 
#' ## Generate some random 'observed' data
## ------------------------------------------------------------------------
set.seed(1)

# Number of m species
nsp <- 10
# Number of n sites
nsi <- 50

# Observed m x n community matrix (abundance or presence/absence)
m_obs <- floor(matrix(rpois(nsp*nsi,lambda=5),ncol=nsi,nrow=nsp))

# "Force" some species associations to the observed community matrix
m_obs[1,1:(nsi/2)] <- rpois(n=nsi/2,lambda=20)
m_obs[2,1:(nsi/2)] <- rpois(n=nsi/2,lambda=20)

#' 
#' ## What is the null expectation?
## ------------------------------------------------------------------------
# Null expected m x n community matrix (abundance or presence/absence)
m_nul <- floor(matrix(rpois(nsp*nsi,lambda=5),ncol=nsi,nrow=nsp))

#' Note that here we are simply resampling the observed data preserving row and column sums, which is NOT recommended. Instead, we should use our expected null model of community assembly.
#' 
#' 
#' ## Infer the species association network
## ------------------------------------------------------------------------
# What species co-occurrence patterns are more or less likely than expected under the null model?
n <- make_netassoc_network(m_obs, m_nul,
  method="partial_correlation",
  args=list(method="shrinkage"), # for alternative estimators see ?partial_correlation
  p.method='fdr', 
  numnulls=100, 
  plot=TRUE,
  alpha=0.05)

## ------------------------------------------------------------------------
n$network_all

