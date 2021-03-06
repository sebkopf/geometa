#' ISODateType
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords ISO datetype
#' @return Object of \code{\link{R6Class}} for modelling an ISO DateType
#' @format \code{\link{R6Class}} object.
#'
#' @field value
#'
#' @section Methods:
#' \describe{
#'  \item{\code{new(xml,value)}}{
#'    This method is used to instantiate an ISODateType
#'  }
#' }
#' 
#' @examples 
#'   #possible values
#'   values <- ISODateType$values(labels = TRUE)
#'   
#'   #creation datetype
#'   creation <- ISODateType$new(value = "creation")
#'   
#' @references 
#'   ISO 19115:2003 - Geographic information -- Metadata 
#' 
#' @author Emmanuel Blondel <emmanuel.blondel1@@gmail.com>
#'
ISODateType <- R6Class("ISODateType",
   inherit = ISOCodeListValue,
   private = list(
     xmlElement = "CI_DateTypeCode",
     xmlNamespacePrefix = "GMD"
   ),
   public = list(
     initialize = function(xml = NULL, value){
       super$initialize(xml = xml, id = "CI_DateTypeCode", value = value, setValue = FALSE)
     }
   )                        
)

ISODateType$values <- function(labels = FALSE){
  return(ISOCodeListValue$values(ISODateType, labels))
}