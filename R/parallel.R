# Check if the default cluster is set. If it has, return `parLapply` using
# the default cluster instead of `lapply`. Then check if option `mc.cores` 
# has been set. If it has, return `mclapply` instead of `lapply`. But in 
# no circumstances use `mclapply` on Windows.

using_parallel <- function() {
  cores_set <- !is.null(getOption("mc.cores"))
  windows <- .Platform$OS.type == "windows"
  cores_set && !windows
}

using_cluster <- function() {
  def_clust_set <- !is.null(getDefaultCluster())
  windows <- .Platform$OS.type == "windows"
  def_clust_set && !windows
}

get_apply_function <- function() {
 if (using_cluster())
   return(function(...) {parLapply(getDefaultCluster(), ...)})
 else if (using_parallel())
   return(parallel::mclapply)
 else
   return(lapply)
}
