% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ISOKeywordType.R
\docType{class}
\name{ISOKeywordType}
\alias{ISOKeywordType}
\title{ISOKeywordType}
\format{\code{\link{R6Class}} object.}
\usage{
ISOKeywordType
}
\value{
Object of \code{\link{R6Class}} for modelling an ISO KeywordType
}
\description{
ISOKeywordType
}
\section{Fields}{

\describe{
\item{\code{value}}{}
}}
\section{Methods}{

\describe{
 \item{\code{new(xml,value)}}{
   This method is used to instantiate an ISOKeywordType
 }
}
}
\examples{
#possible values
  values <- ISOKeywordType$values(labels = TRUE)

  #place keywordType
  place <- ISOKeywordType$new(value = "place")
}
\author{
Emmanuel Blondel <emmanuel.blondel1@gmail.com>
}
\references{
ISO 19115:2003 - Geographic information -- Metadata
}
\keyword{ISO}
\keyword{keywordtype}

