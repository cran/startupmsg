pkgname <- "startupmsg"
source(file.path(R.home("share"), "R", "examples-header.R"))
options(warn = 1)
options(pager = "console")
library('startupmsg')

assign(".oldSearch", search(), pos = 'CheckExEnv')
cleanEx()
nameEx("StartupUtilities")
### * StartupUtilities

flush(stderr()); flush(stdout())

### Name: StartupUtilities
### Title: Utilities for start-up messages
### Aliases: startupmsg infoShow TOBEDONE NEWS readVersionInformation
###   readURLInformation pointertoNEWS StartupMessage startupPackage
###   startupType startupEndline startupMessage suppressStartupMessages
###   onlytypeStartupMessages
### Keywords: utilities

### ** Examples

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



cleanEx()
nameEx("myStartupUtilities")
### * myStartupUtilities

flush(stderr()); flush(stdout())

### Name: myStartupUtilities
### Title: Example functions to utilities for start-up messages
### Aliases: mystartupMessage mySMHandler buildStartupMessage
### Keywords: utilities

### ** Examples

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


MNH <- "http://www.r-project.org/"
buildStartupMessage(pkg="stats", msg, packageHelp=TRUE, MANUAL=MNH)
## not quite a manual, but to illustrate the principle:
## "demo/nlm.R" as a "manual": to be system-independent the 
## first call is to be preferred 
buildStartupMessage(pkg="stats", msg, packageHelp=TRUE, MANUAL=c("demo","nlm.R"))
###  works, too, (i.e. is equivalent) under Linux and Windows (at least):
buildStartupMessage(pkg="stats", msg, packageHelp=TRUE, MANUAL="demo/nlm.R")




### * <FOOTER>
###
cat("Time elapsed: ", proc.time() - get("ptime", pos = 'CheckExEnv'),"\n")
grDevices::dev.off()
###
### Local variables: ***
### mode: outline-minor ***
### outline-regexp: "\\(> \\)?### [*]+" ***
### End: ***
quit('no')
