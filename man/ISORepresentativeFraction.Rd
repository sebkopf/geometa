% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ISORepresentativeFraction.R
\docType{class}
\name{ISORepresentativeFraction}
\alias{ISORepresentativeFraction}
\title{ISORepresentativeFraction}
\format{\code{\link{R6Class}} object.}
\usage{
ISORepresentativeFraction
}
\value{
Object of \code{\link{R6Class}} for modelling an ISO RepresentativeFraction
}
\description{
ISORepresentativeFraction
}
\section{Fields}{

\describe{
\item{\code{denominator}}{}
}}
\section{Methods}{

\describe{
 \item{\code{new(xml, denominator)}}{
   This method is used to instantiate an ISORepresentativeFraction
 }
 \item{\code{setDenominator(denominator)}}{
   Sets the denominator
 }
}
}
\examples{
fr <- ISORepresentativeFraction$new(denominator = 1L)
  xml1 <- fr$encode()
  fr$setDenominator(2L)
  xml2 <- fr$encode()
}
\author{
Emmanuel Blondel <emmanuel.blondel1@gmail.com>
}
\references{
ISO 19115:2003 - Geographic information -- Metadata
}
\keyword{ISO}
\keyword{fraction}
\keyword{representative}

