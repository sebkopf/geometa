% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ISODateType.R
\docType{class}
\name{ISODateType}
\alias{ISODateType}
\title{ISODateType}
\format{\code{\link{R6Class}} object.}
\usage{
ISODateType
}
\value{
Object of \code{\link{R6Class}} for modelling an ISO DateType
}
\description{
ISODateType
}
\section{Fields}{

\describe{
\item{\code{value}}{}
}}
\section{Methods}{

\describe{
 \item{\code{new(xml,value)}}{
   This method is used to instantiate an ISODateType
 }
}
}
\examples{
#possible values
  values <- ISODateType$values(labels = TRUE)

  #creation datetype
  creation <- ISODateType$new(value = "creation")
}
\author{
Emmanuel Blondel <emmanuel.blondel1@gmail.com>
}
\references{
ISO 19115:2003 - Geographic information -- Metadata
}
\keyword{ISO}
\keyword{datetype}

