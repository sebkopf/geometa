% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ISOMaintenanceFrequency.R
\docType{class}
\name{ISOMaintenanceFrequency}
\alias{ISOMaintenanceFrequency}
\title{ISOMaintenanceFrequency}
\format{\code{\link{R6Class}} object.}
\usage{
ISOMaintenanceFrequency
}
\value{
Object of \code{\link{R6Class}} for modelling an ISO MaintenanceFrequency
}
\description{
ISOMaintenanceFrequency
}
\section{Fields}{

\describe{
\item{\code{value}}{}
}}
\section{Methods}{

\describe{
 \item{\code{new(xml,value)}}{
   This method is used to instantiate an ISOMaintenanceFrequency
 }
}
}
\examples{
#possible values
  values <- ISOMaintenanceFrequency$values(labels = TRUE)

  #daily frequency
  daily <- ISOMaintenanceFrequency$new(value = "daily")
}
\author{
Emmanuel Blondel <emmanuel.blondel1@gmail.com>
}
\references{
ISO 19115:2003 - Geographic information -- Metadata
}
\keyword{ISO}
\keyword{hierarchyLevel}

