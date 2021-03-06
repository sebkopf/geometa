% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/GMLConventionalUnit.R
\docType{class}
\name{GMLConventionalUnit}
\alias{GMLConventionalUnit}
\title{GMLConventionalUnit}
\format{\code{\link{R6Class}} object.}
\usage{
GMLConventionalUnit
}
\value{
Object of \code{\link{R6Class}} for modelling an GML derived unit
}
\description{
GMLConventionalUnit
}
\section{Fields}{

\describe{
\item{\code{conversionToPreferredUnit}}{}

\item{\code{roughConversionToPreferredUnit}}{}

\item{\code{derivationUnitTerm}}{}
}}
\section{Methods}{

\describe{
 \item{\code{new(xml, defaults, id)}}{
   This method is used to instantiate a GML Base Unit
 }
 \item{\code{addDerivationUnitTerm(uom, exponent)}}{
   Adds a derivation unit term, made of a uom reference, and an exponent which
   can be negative/positive but not equal to zero.
 }
 \item{\code{delDerivationUnitTerm(uom, exponent)}}{
   Deletes a derivation unit term
 }
 \item{\code{setConversionToPreferredUnit(uom, factor, rough)}}{
   Sets the conversion to preferred unit. \code{rough} is \code{FALSE} by default
 }
}
}
\examples{
gml <- GMLConventionalUnit$new()
   gml$setDescriptionReference("someref")
   gml$setIdentifier("identifier", "codespace")
   gml$addName("name1", "codespace")
   gml$addName("name2", "codespace")
   gml$setQuantityTypeReference("someref")
   gml$setCatalogSymbol("symbol")
   gml$addDerivationUnitTerm("uomId", 2L)
   gml$setConversionToPreferredUnit("uomId", 2L)
}
\author{
Emmanuel Blondel <emmanuel.blondel1@gmail.com>
}
\references{
ISO 19136:2007 Geographic Information -- Geographic Markup Language.
  http://www.iso.org/iso/iso_catalogue/catalogue_tc/catalogue_detail.htm?csnumber=32554

  OGC Geography Markup Language. http://www.opengeospatial.org/standards/gml
}
\keyword{GML}
\keyword{ISO}
\keyword{conventional}
\keyword{definition}
\keyword{unit}

