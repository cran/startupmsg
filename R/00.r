# .onLoad<-function(lib,pkg){require(methods)}

.onLoad<-function(lib,pkg) {options("StartupBanner" = "no-version", "StartupShowHint_sessionInfo" = TRUE)}
.onAttach <- function(library, pkg)
{
#  if (is.null(library)) 
#            library <- .libPaths()

#  if(any(file.exists(file.path(library,"startupmsg"))))
buildStartupMessage(pkg="startupmsg", library=library, packageHelp=TRUE)
  invisible()
} 
