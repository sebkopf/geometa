#' ISOGeoreferenceable
#'
#' @docType class
#' @importFrom R6 R6Class
#' @export
#' @keywords ISO grid spatial representation georeferenceable
#' @return Object of \code{\link{R6Class}} for modelling an ISO Georeferenceable
#' @format \code{\link{R6Class}} object.
#'
#' @field controlPointAvailability
#' @field orientationParameterAvailability
#' @field orientationParameterDescription
#' @field georeferencedParameters
#' @field parameterCitation
#'
#' @section Inherited Methods:
#' \describe{
#'  \item{\code{setNumberOfDimensions}}{
#'    Sets the number of dimensions (value of class \code{integer})
#'  }
#'  \item{\code{addDimension(dimension)}}{
#'    Adds a dimension. Object of class \code{ISODimension}
#'  }
#'  \item{\code{delDimension(dimension)}}{
#'    Deletes a dimension;
#'  }
#'  \item{\code{setCellGeometry(cellGeometry)}}{
#'    Sets the cell geometry. Object of class \code{ISOCellGeometry} or any value
#'    from \code{ISOCellGeometry$values()}
#'  }
#'  \item{\code{setTransformationParameterAvailability(availability)}}{
#'    Sets the transformation parameter availability
#'  }
#' }
#'
#' @section Methods:
#' \describe{
#'  \item{\code{new(xml)}}{
#'    This method is used to instantiate an ISOGeoreferenceable
#'  }
#'  \item{\code{setControlPointAvailability(availability)}}{
#'    Sets the control point availability. TRUE/FALSE
#'  }
#'  \item{\code{setOrientationParameterAvailability(availability)}}{
#'    Sets the orientation parameter availability. TRUE/FALSE
#'  }
#'  \item{\code{setOrientationParameterDescription(description)}}{
#'    Sets the orientation parameter description
#'  }
#'  \item{\code{setGeoreferencedParameters(record)}}{
#'    Sets the georeferenced parameter (object of class \code{ISORecord})
#'  }
#'  \item{\code{addParameterCitation(citation)}}{
#'    Adds a parameter citation
#'  }
#'  \item{\code{delParameterCitation(citation)}}{
#'    Deletes a parameter citation
#'  }
#' }
#' 
#' @examples 
#'   md <- ISOGeoreferenceable$new()
#'   
#'   #inherited methods from ISOGridSpatialRepresentation
#'   md$setNumberOfDimensions(1)
#'   dim1 <- ISODimension$new()
#'   dim1$setName("row")
#'   dim1$setSize(100)
#'   dim1$setResolution(ISOMeasure$new(value=1,uom="m"))
#'   md$addDimension(dim1)
#'   md$setCellGeometry("area")
#'   
#'   #parameters
#'   md$setControlPointAvailability(TRUE)
#'   md$setOrientationParameterAvailability(TRUE)
#'   md$setOrientationParameterDescription("description")
#'   md$setGeoreferencedParameters("record")
#'   ct <- ISOCitation$new()
#'   ct$setTitle("citation")
#'   md$addParameterCitation(ct)
#'   
#'   xml <- md$encode()
#' 
#' @references 
#'   ISO 19115:2003 - Geographic information -- Metadata
#' 
#' @author Emmanuel Blondel <emmanuel.blondel1@@gmail.com>
#'
ISOGeoreferenceable <- R6Class("ISOGeoreferenceable",
    inherit = ISOGridSpatialRepresentation,
    private = list(
      xmlElement = "MD_Georeferenceable",
      xmlNamespacePrefix = "GMD"
    ),
    public = list(
      
      #+ controlPointAvailability: logical
      controlPointAvailability = NULL,
      #+ orientationParameterAvailability : logical
      orientationParameterAvailability = NULL,
      #+ orientationParameterDescription [0..1] : character
      orientationParameterDescription = NULL,
      #+ georeferencedParameters : ISORecord
      georeferencedParameters = NULL,
      #+ parameterCitation [0..*] : ISOCitation
      parameterCitation = NULL,
      
      initialize = function(xml = NULL){
        super$initialize(xml = xml)
      },
      
      #setControlPointAvailability
      setControlPointAvailability = function(availability){
        self$controlPointAvailability = as.logical(availability)
      },
      
      #setOrientationParameterAvailability
      setOrientationParameterAvailability = function(availability){
        self$orientationParameterAvailability = as.logical(availability)
      },
      
      #setOrientationParameterDescription
      setOrientationParameterDescription = function(description){
        self$orientationParameterDescription = as.character(description)
      },
      
      #setGeoreferencedParameters
      setGeoreferencedParameters = function(record){
        if(!is(record, "ISORecord")){
          record <- ISORecord$new(value = as(record,"character"))
        }
        self$georeferencedParameters = record
      },
      
      #addParameterCitation
      addParameterCitation = function(citation){
        if(!is(citation, "ISOCitation")){
          stop("Argument should be an object of class 'ISOCitation'")
        }
        return(self$addListElement("parameterCitation", citation))
      },
      
      #delParameterCitation
      delParameterCitation = function(citation){
        if(!is(citation, "ISOCitation")){
          stop("Argument should be an object of class 'ISOCitation'")
        }
        return(self$delListElement("parameterCitation", citation))
      }
      
    )                        
)