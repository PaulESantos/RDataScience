#' ---
#' title: "Community Network Analysis"
#' author: "Naia Morueta-Holme"
#' ---
#' 
#' 
#' 
#' <div>
#' <object data="3_2_assets/network_slides1.pdf" type="application/pdf" width="100%" height="650px"> 
#'   <p>It appears you don't have a PDF plugin for this browser.
#'    No biggie... you can <a href="3_2_assets/network_slides1.pdf">click here to
#'   download the PDF file.</a></p>  
#'  </object>
#'  </div>
#'  
#'  <p><a href="3_2_assets/network_slides1.pdf">Download the PDF of the presentation</a></p>  
#'  
#' 
#' [<i class="fa fa-file-code-o fa-3x" aria-hidden="true"></i> The R Script associated with this page is available here](`r output`).  Download this file and open it (or copy-paste into a new script) with RStudio so you can follow along.  
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

