% Generated by roxygen2 (4.1.1): do not edit by hand
% Please edit documentation in R/ISOContact.R
\docType{class}
\name{ISOContact}
\alias{ISOContact}
\title{ISOContact}
\format{\code{\link{R6Class}} object.}
\usage{
ISOContact
}
\value{
Object of \code{\link{R6Class}} for modelling an ISO Contact
}
\description{
ISOContact
}
\section{Fields}{

\describe{
\item{\code{phone}}{}

\item{\code{address}}{}

\item{\code{onlineResource}}{}
}}
\section{Methods}{

\describe{
 \item{\code{new(xml)}}{
   This method is used to instantiate an ISOContact
 }
 \item{\code{setPhone(phone)}}{
   Sets the phone contact
 }
 \item{\code{setAddress(address)}}{
   Sets the address contact
 }
 \item{\code{setOnlineResource(onlineResource)}}{
   Sets the online resource
 }
}
}
\examples{
md <- ISOContact$new()
 phone <- ISOTelephone$new()
 phone$setVoice("myphonenumber")
 phone$setFacsimile("myfacsimile")
 md$setPhone(phone)
 address <- ISOAddress$new()
 address$setDeliveryPoint("theaddress")
 address$setCity("thecity")
 address$setPostalCode("111")
 address$setCountry("France")
 address$setEmail("someone@theorg.org")
 md$setAddress(address)
 res <- ISOOnlineResource$new()
 res$setLinkage("http://www.somewhereovertheweb.org")
 res$setName("somename")
 md$setOnlineResource(res)
 xml <- md$encode()
}
\author{
Emmanuel Blondel <emmanuel.blondel1@gmail.com>
}
\references{
ISO 19115:2003 - Geographic information -- Metadata
}
\keyword{ISO}
\keyword{contact}

