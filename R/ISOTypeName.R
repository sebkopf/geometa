#' ISOTypeName
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords ISO typename
#' @return Object of \code{\link{R6Class}} for modelling an ISOTypeName
#' @format \code{\link{R6Class}} object.
#'
#' @field aName
#'
#' @section Methods:
#' \describe{
#'  \item{\code{new(xml)}}{
#'    This method is used to instantiate an ISOTypeName
#'  }
#'  \item{\code{setName(aName)}}{
#'    Sets the aName
#'  }
#' }
#' 
#' @author Emmanuel Blondel <emmanuel.blondel1@@gmail.com>
#'
ISOTypeName <- R6Class("ISOTypeName",
   inherit = ISOMetadataElement,
   private = list(
     xmlElement = "TypeName",
     xmlNamespacePrefix = "GCO"
   ),
   public = list(
     
     #+ aName: character
     aName = NULL,
     
     initialize = function(xml = NULL){
       super$initialize(
         xml = xml,
         element = private$xmlElement,
         namespace = getISOMetadataNamespace(private$xmlNamespacePrefix)
       )
     },
     
     #setName
     setName = function(aName){
       self$aName <- aName
     }
   )         
)