% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ISOStatus.R
\docType{class}
\name{ISOStatus}
\alias{ISOStatus}
\title{ISOStatus}
\format{\code{\link{R6Class}} object.}
\usage{
ISOStatus
}
\value{
Object of \code{\link{R6Class}} for modelling an ISO progress status
}
\description{
ISOStatus
}
\section{Fields}{

\describe{
\item{\code{value}}{}
}}
\section{Methods}{

\describe{
 \item{\code{new(xml,value)}}{
   This method is used to instantiate an ISOStatus
 }
}
}
\examples{
#possible values
  values <- ISOStatus$values(labels = TRUE)

  #pending status
  pending <- ISOStatus$new(value = "pending")
}
\author{
Emmanuel Blondel <emmanuel.blondel1@gmail.com>
}
\references{
ISO 19115:2003 - Geographic information -- Metadata
}
\keyword{ISO}
\keyword{status}

