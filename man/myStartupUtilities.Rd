\name{myStartupUtilities}
\alias{mystartupMessage}
\alias{mySMHandler}
\alias{buildStartupMessage}

\title{Example functions to utilities for start-up messages}
\description{
Illustration of package 'startupmsg'}
\usage{
mySMHandler(c)
mystartupMessage(..., domain = NULL, pkg = "", type="version", 
                 SMHandler=mySMHandler, endline = FALSE)

buildStartupMessage(..., pkg, library=NULL, domain=NULL, 
                    packageHelp=FALSE, MANUAL = NULL, VIGNETTE = NULL,
                    SMHandler=mySMHandler)
}
\arguments{
  \item{c}{an object of class \code{StartupMessage}}
  \item{pkg}{a character string with the name of a single package}
  \item{library}{a character vector with path names of R libraries, or \code{NULL}.
                 The default value of \code{NULL} corresponds to all libraries
                 currently known.  If the default is used, the loaded packages
                 are searched before the libraries}
  \item{domain}{see \code{gettext}. If \code{NA}, messages will not be translated.}
  \item{type}{character -- the type part of an S3-object of class \code{StartupMessage}; currently, 
              type should be in \code{c("version","notabene","information")}.}
  \item{SMHandler}{function to handle the output of an object of class \code{StartupMessage}, defaults to \code{mySMHandler};
                    btw: \code{SMHandler} stands for /S/tartup/M/essage/Handler/}
  \item{endline}{logical: shall there be an empty line (TRUE) or a line with linestarter in the end?}
  \item{packageHelp}{logical: is there help available as \code{?}\var{<pkg-name>} ?}
  \item{MANUAL}{character or \code{NULL} if \code{!is.null(MANUAL)}  the name of a manual distributed together with the 
                package (with relative path within the library) or an URL}
  \item{VIGNETTE}{character or \code{NULL} if \code{!is.null(VIGNETTE)}  an indication of one or more vignettes available
  to this package}
  \item{...}{character vectors (which are pasted together with no separator)}
  }

\details{
\code{mystartupMessage} redirects the output of \code{startupMessage} to have a particular output function
\code{SMHandler} issue the message; to see how such a function may be defined, have a look at code of
the default function \code{mySMHandler}:
\preformatted{
mySMHandler <- function(c) {
    pkg <- startupPackage(c) # get the package slot of c
    #prefix a starter for each new line of the message:
    linestarterN <- paste(":",pkg,"> ", sep ="")                              
    linestarterN <- paste("\n",linestarter, sep ="")
    linestarterE <- paste(linestarterN,"$",sep="")
    writeLines(paste(linestarter, sub(linestarterE,"\n", 
               gsub("\n",linestarterN,conditionMessage(c))),
                    sep=""),stderr())}
}

Just like for \code{startupMessage}, for \code{mystartupMessage}, too, restarts 
\code{muffleMessage()}, \code{onlytypeMessage(c0,atypes)}, \code{custom(c,f)}
are available (confer \code{\link{startupmsg}}).
     
To generate a complete start-up message, we provide \code{buildStartupMessage}: this function automatically generates 
\itemize{\item a start-up message of condition \code{StartupMessage} with type \code{"version"} as to the version information.
\item additional messages of class \code{StartupMessage} and of type \code{"notabene"} according to the \dots argument
\item a message of class \code{StartupMessage} and of type \code{"information"} mentioning\cr
\itemize{\item \code{?"}\var{<pkg-name>}\code{"} -- according to argument \code{packageHelp},  
         \item \code{NEWS("}\var{<pkg-name>}\code{")}, if there is a \file{NEWS} file,   
         \item \code{URL}, if there is a \code{URL} mentioned in the \file{DESCRIPTION} file,   
         \item if there is a  \code{MANUAL} argument, the file / the URL to this manual 
         \item if there is a  \code{VIGNETTE} argument, \code{VIGNETTE} is printed out indicating a vignette location
        }
}

The user may suppress the start-up messages produced by \code{buildStartupMessages} in two ways:
Either by \code{suppressStartupMessages(expr)} and \code{onlyversionStartupMessages(expr, atypes="version")}
as for \code{startupmessage} (confer \code{\link{startupmsg}}), or -- as proposed by Brian Ripley -- by \code{options};
let us describe the latter possibility here: 
\itemize{\item \code{options("StartupBanner"="off")} switches off all start-up messages%
          \item if option \code{"StartupBanner"} is not defined (default) or setting    
                    \code{options("StartupBanner"=NULL)} or  \code{options("StartupBanner"="complete")} 
                    the complete start-up banner is displayed 
          \item for any other value of option \code{"StartupBanner"} (i.e., not in \code{c(NULL,"off","complete")})
                    only the version information is displayed 
                    }%
}

\author{Peter Ruckdeschel \email{peter.ruckdeschel@uni-oldenburg.de}}
\examples{
## a set of test messages

msg <- "Note that you may set global options by options() --- cf. ?\"options\"."

## issuing of messages controlled by options()
buildStartupMessage(pkg="stats", msg) 
suppressStartupMessages(buildStartupMessage(pkg="stats", msg) )
suppressMessages(buildStartupMessage(pkg="stats", msg))
onlytypeStartupMessages(buildStartupMessage(pkg="stats", msg),
          atypes="version")

getOption("StartupBanner")
buildStartupMessage(pkg="stats", msg)

options("StartupBanner"="off");getOption("StartupBanner")
buildStartupMessage(pkg="stats", msg)

options("StartupBanner"="complete");getOption("StartupBanner")
buildStartupMessage(pkg="stats", msg)

options("StartupBanner"="something else");getOption("StartupBanner")
buildStartupMessage(pkg="stats", msg)

options("StartupBanner"=NULL);getOption("StartupBanner")
buildStartupMessage(pkg="stats", msg)


MNH <- "https://www.r-project.org/"
buildStartupMessage(pkg="stats", msg, packageHelp=TRUE, MANUAL=MNH)
## not quite a manual, but to illustrate the principle:
## "demo/nlm.R" as a "manual": to be system-independent the 
## first call is to be preferred 
buildStartupMessage(pkg="stats", msg, packageHelp=TRUE, MANUAL=c("demo","nlm.R"))
###  works, too, (i.e. is equivalent) under Linux and Windows (at least):
buildStartupMessage(pkg="stats", msg, packageHelp=TRUE, MANUAL="demo/nlm.R")

}

\seealso{Mail "[Rd] Wishlist: 'quietly' argument for .onAttach() / .First.lib()  "
          on r-devel by Brian Ripley, 
         \url{https://stat.ethz.ch/pipermail/r-devel/2006-April/037281.html}}
\keyword{utilities}
\concept{startup}
\concept{S3 message class}
\concept{message}
\concept{startup message}
\concept{constructor}
\concept{generating function}

