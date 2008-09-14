\name{StartupUtilities}
%
\alias{startupmsg}
%
%Utilities
\alias{infoShow}
\alias{NEWS}
\alias{readVersionInformation}
\alias{readURLInformation}
\alias{pointertoNEWS}
%
%S3 class & accessors
\alias{StartupMessage}
\alias{startupPackage}
\alias{startupType}
%
%message generator
\alias{startupMessage}
%
%message wrapper
\alias{suppressStartupMessages}
\alias{onlytypeStartupMessages}

\title{Utilities for start-up messages}
\description{
several utilities to produce start-up messages
}
\usage{
readVersionInformation(pkg, library=NULL)
readURLInformation(pkg, library=NULL)
pointertoNEWS(pkg, library=NULL) 

infoShow(pkg, filename, library=NULL)
NEWS(pkg, library=NULL)

StartupMessage(message, call = NULL, pkg="", 
               type="version") 
startupPackage(startupmessage) 
startupType(startupmessage) 

startupMessage(..., domain = NULL, pkg = "", 
               type="version")

suppressStartupMessages(expr)
onlytypeStartupMessages(expr,atypes="version")
}
\arguments{
  \item{pkg}{a character string with the name of a single package}
  \item{library}{a character vector with path names of R libraries, or \code{NULL}.
                 The default value of \code{NULL} corresponds to all libraries
                 currently known.  If the default is used, the loaded packages
                 are searched before the libraries}
  
  \item{filename}{name of the file which is to be displayed by \code{infoShow} (with relative path within the package main folder)}
  \item{message}{a character string -- the message part of an S3-object of class \code{StartupMessage}}
  \item{call}{a call expression -- the call part of an S3-object of class \code{StartupMessage}}
  \item{type}{character -- the type part of an S3-object of class \code{StartupMessage}; currently, 
              type should be in \code{c("version","notabene","information")}.}
  \item{startupmessage}{the \code{StartupMessage} object whose slot \code{package} is to be inspected}
  \item{domain}{see \code{gettext}. If \code{NA}, messages will not be translated.}
  \item{atypes}{a vector of characters -- the types of \code{StartupMessage}-objects which \code{onlytypeStartupMessages}
                lets pass through}
  \item{expr}{expression to evaluate.}
  \item{...}{character vectors (which are pasted together with no separator)}
  }

\details{
\code{readVersionInformation} and \code{readURLInformation} read the \file{DESCRIPTION} file of the package.
\code{readVersionInformation} returns a list with elements \code{ver} and \code{title} for the version and title 
to be found in the \file{DESCRIPTION} file; if there is a \code{URL} entry it is returned by \code{readURLInformation}
else \code{readURLInformation} returns \code{NULL}.

If there is a \file{NEWS} in the package main folder, \code{pointertoNEWS} returns a string with an expression how
to retrieve this file from within R, else \code{pointertoNEWS}  returns \code{NULL}.

\code{infoShow} displays the file \code{filename} in the package main folder using \code{file.show} -- if it exists;
\code{NEWS} in particular displays the \file{NEWS} file; takes up an idea by Andy Liaw.

A new sub-condition \code{StartupMessage} to \code{message} is introduced, 
with a constructor with the same name. 

In addition to the slots of \code{message}, it also has slots \code{package} (for the package they are for)
and \code{type} (currently in  \code{c("version","notabene","information")}).
These slot may be accessed by \code{startupPackage} and \code{startupType}, respectively.

\code{startupMessage} issues a start-up message which also is represented as a condition.
 While the start-up message is being processed, the following restarts are available:
\itemize{\item \code{muffleMessage()} to suppress the \code{StartupMessage}, 
\item \code{onlytypeMessage(c0,atypes)} to filter out types not mentioned in \code{atypes} of \code{StartupMessages}-argument \code{c0},
\item \code{custom(c,f)} to apply the user-defined function \code{f} to \code{StartupMessages}-argument \code{c0} instead of the usual procedure
} 
     
The user may suppress the start-up messages produced by these utilities as follows:

\itemize{\item \code{suppressStartupMessages(expr)} 
                      suppresses all messages issued by \code{startupMessage} in the expression \code{expr} within the parentheses%          
         \item \code{suppressPackageStartupMessages(expr)}: 
                     from package version 0.5 on, is the same as \code{suppressStartupMessages} for our start-up banners, but more 
                     generally suppresses all messages of S3-class \code{packageStartupMessage} (from \pkg{base} package)%
         \item \code{onlyversionStartupMessages(expr, atypes="version")} 
                    only shows messages issued by \code{startupMessage} in the expression \code{expr} within the parentheses, if
                     there slot \code{type} is contained in the \code{atypes} argument
         \item by the \code{custom} restart (see example by Seth Falcon) 
                    }%
}
\section{Acknowledgement}{Thanks to Seth Falcon for his helpful comments.}

\author{Peter Ruckdeschel \email{Peter.Ruckdeschel@itwm.fraunhofer.de}}
\examples{
## a set of test messages
several.messages<-function() {
startupMessage("this is a type 'version' startup message", pkg="PKG")
startupMessage("this is a type 'information' startup message", 
                pkg="PKG", type="information")
message("this is an ordinary message")}

## issuing of messages with different wrappers
several.messages()
suppressStartupMessages(several.messages())
suppressMessages(several.messages())
onlytypeStartupMessages(several.messages(),atypes=c("version","notabene"))

##Example by Seth Falcon:
## Here is a test function
doit <- function() {
    several.messages()
    return(123)
}

## Here is an example message handler.  Here, you could write messages
## to a file, send them as email to your friends or enemies, etc.
## For the example, we'll just prepend 'MSG:'
msgLogger <- function(m) {
             types<-paste("(", startupType(m),"):", sep="")
             cat(paste("MSG: ",types, conditionMessage(m)), "\n")
             }

## Finally, call the doit function and customize how messages are
## handled.
withCallingHandlers(doit(),
                    StartupMessage=function(m) {
                        invokeRestart("custom", m, msgLogger)
                    })
### reading information file utilities
readVersionInformation("stats")
readURLInformation("stats")
## for packages with URL file see e.g. dse1
pointertoNEWS("stats") ## no NEWS file;
NEWS("stats") ## no NEWS file; 
## for packages with NEWS file see e.g. randomForest, distr
}
\seealso{\code{\link{buildStartupMessage}} for some illustration;
         for the ideas taken up in this package, see mails "[Rd] Wishlist: 'quietly' argument for .onAttach() / .First.lib()  "
         on r-devel by Brian Ripley,  
         \url{https://stat.ethz.ch/pipermail/r-devel/2006-April/037281.html},
         by Andy Liaw, 
         \url{https://stat.ethz.ch/pipermail/r-devel/2006-April/037286.html},
         by Seth Falcon,
         \url{https://stat.ethz.ch/pipermail/r-devel/2006-April/037317.html},
         and again by Seth Falcon,
         \url{https://stat.ethz.ch/pipermail/r-devel/2006-April/037367.html},
         and by the author,  
         \url{https://stat.ethz.ch/pipermail/r-devel/2006-April/037382.html}}

\keyword{utilities}
\concept{startup}
\concept{S3 message class}
\concept{message}
\concept{startup message}
\concept{info file}
\concept{NEWS}
\concept{pointer to news}


