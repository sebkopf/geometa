#' ISOHierarchyLevel
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords ISO Restriction
#' @return Object of \code{\link{R6Class}} for modelling an ISO Restriction
#' @format \code{\link{R6Class}} object.
#'
#' @field value
#'
#' @section Methods:
#' \describe{
#'  \item{\code{new(xml,value)}}{
#'    This method is used to instantiate an ISORestriction
#'  }
#' }
#' 
#' @examples 
#'   #possible values
#'   values <- ISORestriction$values(labels = TRUE)
#'   
#'   #copyright restriction
#'   cr <- ISORestriction$new(value = "copyright")
#'   
#' @references 
#'   ISO 19115:2003 - Geographic information -- Metadata
#' 
#' @author Emmanuel Blondel <emmanuel.blondel1@@gmail.com>
#'
ISORestriction <- R6Class("ISORestriction",
   inherit = ISOCodeListValue,
   private = list(
     xmlElement = "MD_RestrictionCode",
     xmlNamespacePrefix = "GMD"
   ),
   public = list(
     initialize = function(xml = NULL, value){
       super$initialize(xml = xml, id = private$xmlElement, value = value, setValue = FALSE)
     }
   )                        
)

ISORestriction$values <- function(labels = FALSE){
  return(ISOCodeListValue$values(ISORestriction, labels))
}