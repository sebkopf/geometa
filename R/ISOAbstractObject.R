#' ISOAbstractObject
#'
#' @docType class
#' @importFrom utils packageDescription
#' @importFrom R6 R6Class
#' @export
#' @keywords ISO metadata element
#' @return Object of \code{\link{R6Class}} for modelling an ISO Metadata Element
#' @format \code{\link{R6Class}} object.
#'
#' @section Static Methods:
#' \describe{
#'  \item{\code{getISOClassByNode(node)}}{
#'    Inherit the ISO class matching an XML document or node
#'  }
#'  \item{\code{compare(metadataElement1, metadataElement2)}}{
#'    Compares two metadata elements objects. Returns TRUE if they are equal,
#'    FALSE otherwise. The comparison of object is done by comparing the XML 
#'    representation of the objects (since no R6 object comparison method seems 
#'    to exist)
#'  }
#' }
#'
#' @section Abstract Methods:
#' \describe{
#'  \item{\code{new(xml, element, namespace, defaults, attrs)}}{
#'    This method is used to instantiate an ISOAbstractObject
#'  }
#'  \item{\code{INFO(text)}}{
#'    Logger to report information. Used internally
#'  }
#'  \item{\code{WARN(text)}}{
#'    Logger to report warnings. Used internally
#'  }
#'  \item{\code{ERROR(text)}}{
#'    Logger to report errors. Used internally
#'  }
#'  \item{\code{print()}}{
#'    Provides a custom print output (as tree) of the current class
#'  }
#'  \item{\code{decode(xml)}}{
#'    Decodes a ISOMetadata* R6 object from XML representation
#'  }
#'  \item{\code{encode(addNS, validate, strict)}}{
#'    Encodes a ISOMetadata* R6 object to XML representation. By default, namespace
#'    definition will be added to XML root (\code{addNS = TRUE}), and validation
#'    of object will be performed (\code{validate = TRUE}) prior to its XML encoding.
#'    The argument \code{strict} allows to stop the encoding in case object is not
#'    valid, with a default value set to \code{FALSE}.
#'  }
#'  \item{\code{validate(xml, strict)}}{
#'    Validates the encoded XML against ISO 19139 XML schemas. If \code{strict} is
#'    \code{TRUE}, a error will be raised. Default is \code{FALSE}. 
#'  }
#'  \item{\code{getNamespaceDefinition(recursive)}}{
#'    Gets the namespace definition of the current ISO* class. By default, only
#'    the namespace definition of the current element is retrieved (\code{recursive = FALSE}).
#'  }
#'  \item{\code{getClassName()}}{
#'    Gets the class name
#'  }
#'  \item{\code{getClass()}}{
#'    Gets the class
#'  }
#'  \item{\code{wrapBaseElement(field, fieldObj)}}{
#'    Wraps a base element type
#'  }
#'  \item{\code{contains(field, metadataElement)}}{
#'    Indicates of the present class object contains an metadata element object
#'    for a particular list-based field.
#'  }
#'  \item{\code{addListElement(field, metadataElement)}}{
#'    Adds a metadata element to a list-based field. Returns TRUE if the element
#'    has been added, FALSE otherwise. In case an element is already added, the 
#'    element will not be added and this method will return FALSE.
#'  }
#'  \item{\code{delListElement(field, metadataElement)}}{
#'    Deletes a metadata element from a list-based field. Returns TRUE if the element
#'    has been deleted, FALSE otherwise. In case an element is abstent, this method 
#'    will return FALSE.
#'  }
#'  \item{\code{setAttr(attrKey, attrValue)}}{
#'    Set an attribute
#'  }
#'  \item{\code{setId(id, addNS)}}{
#'    Set an id. By default \code{addNS} is \code{FALSE} (no namespace prefix added).
#'  }
#'  \item{\code{setHref(href)}}{
#'    Sets an href reference
#'  }
#'  \item{\code{setCodeList(codeList)}}{
#'    Sets a codeList
#'  }
#'  \item{\code{setCodeListValue(codeListValue)}}{
#'    Sets a codeList value
#'  }
#'  \item{\code{setCodeSpace(codeSpace)}}{
#'    Set a codeSpace
#'  }
#'  \item{\code{setValue(value)}}{
#'    Set a value
#'  }
#'  \item{\code{isDocument()}}{
#'    Indicates if the object is a metadata document, typically an object of class
#'    \code{ISOMetadata} or \code{ISOFeatureCatalogue}
#'  }
#'  \item{\code{isFieldInheritedFrom(field)}}{
#'    Gives the parent from which the field is inherited, otherwise return \code{NULL}.
#'  }
#' }
#' 
#' @note Abstract ISO Metadata class used internally by geometa
#' 
#' @author Emmanuel Blondel <emmanuel.blondel1@@gmail.com>
#'
ISOAbstractObject <- R6Class("ISOAbstractObject",
  private = list(
    xmlElement = "AbstractObject",
    xmlNamespacePrefix = "GCO",
    encoding = options("encoding"),
    document = FALSE,
    system_fields = c("wrap", 
                      "element", "namespace", "defaults", "attrs",
                      "codelistId", "measureType"),
    logger = function(type, text){
      cat(sprintf("[geometa][%s] %s \n", type, text))
    },
    xmlHeader = function(compliant){
      txt <- "<?xml version='1.0'?>"
      geometa <- packageDescription("geometa")
      title <- paste0("\tISO 19139 XML generated by 'geometa' R package - Version ", geometa$Version)
      isCompliant <- ifelse(is.na(compliant),"NOT TESTED", ifelse(compliant, "YES", "NO"))
      compliance <- paste0("\tISO 19139 XML compliance: ", isCompliant)
      createdOn <- paste0("\tCreation date/time: ", format(Sys.time(), "%Y-%m-%dT%H:%M:%S"))
      author <- paste0("\tContact: ", geometa$Author)
      infoPage <- paste0("\tURL: ", geometa$URL)
      bugReport <- paste0("\tBugReports: ", geometa$BugReports)
      txt <- paste(txt, "<!-- ", sep="\n")
      txt <- paste(txt, createdOn, sep="\n")
      txt <- paste(txt, title, sep="\n")
      txt <- paste(txt, compliance, sep="\n")
      txt <- paste(txt, "-->", sep="\n")
      txt <- paste(txt, "<!-- ", sep="\n")
      txt <- paste(txt, "\tgeometa R package information", sep="\n")
      txt <- paste(txt, author, sep="\n")
      txt <- paste(txt, infoPage, sep="\n")
      txt <- paste(txt, bugReport, sep="\n")
      txt <- paste(txt, "-->", sep="\n")
      return(txt)
    },
    toComplexTypes = function(value){
      newvalue <- value
      if(regexpr(pattern = "(\\d{4})-(\\d{2})-(\\d{2})T(\\d{2}):(\\d{2}):(\\d{2})", value)>0){
        newvalue <- as.POSIXct(strptime(value, "%Y-%m-%dT%H:%M:%S"), tz = "GMT")
      }else if(regexpr(pattern = "(\\d{4})-(\\d{2})-(\\d{2})", value)>0){
        newvalue <- as.Date(value) 
      }
      return(newvalue)
    },
    fromComplexTypes = function(value){
      if(suppressWarnings(all(class(value)==c("POSIXct","POSIXt")))){
        value <- format(value,"%Y-%m-%dT%H:%M:%S")
      }else if(class(value)[1] == "Date"){
        value <- format(value,"%Y-%m-%d")
      }
      return(value)
    }
  ),
  public = list(
    
    #logger
    INFO = function(text){private$logger("INFO", text)},
    WARN = function(text){private$logger("WARN", text)},
    ERROR = function(text){private$logger("ERROR", text)},
    
    
    #fields
    #---------------------------------------------------------------------------
    wrap = TRUE,
    element = NA,
    namespace = NA,
    defaults = list(),
    attrs = list(),
    value = NULL,
    initialize = function(xml = NULL, element = NULL, namespace = NULL,
                          attrs = list(), defaults = list(),
                          wrap = TRUE){
      if(!is.null(element)){ private$xmlElement <- element }
      if(!is.null(namespace)){ private$xmlNamespacePrefix <- toupper(namespace)}
      self$element = private$xmlElement
      self$namespace = getISOMetadataNamespace(private$xmlNamespacePrefix)
      self$attrs = attrs
      self$defaults = defaults
      self$wrap = wrap
      if(!is.null(xml)){
        self$decode(xml)
      }
    },
    
    #Main methods
    #---------------------------------------------------------------------------
    
    #print
    print = function(..., depth = 1){
      #list of fields to encode as XML
      fields <- rev(names(self))
      
      #fields
      fields <- fields[!sapply(fields, function(x){
        (class(self[[x]]) %in% c("environment", "function")) ||
        (x %in% private$system_fields)
      })]
      
      cat(sprintf("<%s>", self$getClassName()))
      if(is(self, "ISOCodeListValue")){
        clVal <- self$attrs$codeListValue
        clDes <- self$codelistId$entries[self$codelistId$entries$value == clVal,"description"]
        cat(paste0(": ", clVal, " {",clDes,"}"))
      }
      
      for(field in fields){
        fieldObj <- self[[field]]
        
        #default values management
        if(is.null(fieldObj) || (is.list(fieldObj) & length(fieldObj)==0)){
          if(field %in% names(self$defaults)){
            fieldObj <- self$defaults[[field]]
          }
        }
        
        #user values management
        shift <- "...."
        if(!is.null(fieldObj)){
          if(is(fieldObj, "ISOAbstractObject")){
            cat(paste0("\n", paste(rep(shift, depth), collapse=""),"|-- ", field, " "))
            fieldObj$print(depth = depth+1)
          }else if(is(fieldObj, "list")){
            for(item in fieldObj){
              if(is(item, "ISOAbstractObject")){
                cat(paste0("\n", paste(rep(shift, depth), collapse=""),"|-- ", field, " "))
                item$print(depth = depth+1)
                if(is(item, "ISOCodeListValue")){
                  clVal <- item$attrs$codeListValue
                  clDes <- item$codelistId$entries[item$codelistId$entries$value == clVal,"description"]
                  cat(paste0(": ", clVal, " {",clDes,"}"))
                }
              }else{
                cat(paste0("\n", paste(rep(shift, depth), collapse=""),"|-- ", field, ": ", item))
              }
            }
          }else{
            cat(paste0("\n",paste(rep(shift, depth), collapse=""),"|-- ", field, ": ", fieldObj))
          }
        }
      }
      invisible(self)
    },
    
    #decode
    decode = function(xml){
      
      #remove comments if any (in case of document)
      if(is(xml, "XMLInternalDocument")){
        children <- xmlChildren(xml, encoding = private$encoding)
        xml <- children[names(children) != "comment"][[1]]
      }
      for(child in xmlChildren(xml, encoding = private$encoding)){
        fieldName <- xmlName(child)
        childElement <- child
        nsPrefix <- ""
        fNames <- unlist(strsplit(fieldName, ":"))
        if(length(fNames)>1){
         fieldName <- fNames[2]
        }
        
        if(!(fieldName %in% names(self)) & fieldName != "text") next
        
        fieldClass <- NULL
        if(!is(child, "XMLInternalTextNode")){
          fieldClass <- ISOAbstractObject$getISOClassByNode(child)
          nsPrefix <- names(xmlNamespace(child))
          if(is.null(fieldClass)){
            children <- xmlChildren(child, encoding = private$encoding)
            if(length(children)>0){
              childroot <- children[[1]]
              if(!is(childroot, "XMLInternalTextNode")){
                child <- childroot
                fieldClass <- ISOAbstractObject$getISOClassByNode(childroot)
              }
            }
          }
        }
        
        #coercing
        fieldValue <- xmlValue(child, recursive = FALSE)
        if(length(fieldValue)>0){
          fieldValue <- private$toComplexTypes(fieldValue)
        }
        
        if(!is.null(fieldClass)){
          if(regexpr("^ISOBase.+", fieldClass$classname)>0){
            
            fieldValue <- switch(fieldClass$classname,
                                 "ISOBaseBoolean" = as.logical(fieldValue),
                                 "ISOBaseInteger" = as.integer(fieldValue),
                                 "ISOBaseReal" = as.numeric(fieldValue),
                                 "ISOBaseDecimal" = {
                                   fieldValue <- as.numeric(fieldValue)
                                   class(fieldValue) <- "decimal"
                                   fieldValue
                                 },
                                 fieldValue
            )
          }else{
            fieldValue <- fieldClass$new(xml = child)
            fieldValue$attrs <- as.list(xmlAttrs(child, TRUE, FALSE))
          }
          if(is(self[[fieldName]], "list")){
            self[[fieldName]] <- c(self[[fieldName]], fieldValue)
          }else{
            self[[fieldName]] <- fieldValue
          }
        }else{
          if(nsPrefix == "gml"){
            gmlElem <- GMLElement$new(element = fieldName)
            gmlElem$decode(xml = childElement)
            if(is(self[[fieldName]], "list")){
              self[[fieldName]] <- c(self[[fieldName]], gmlElem)
            }else{
              self[[fieldName]] <- gmlElem
            }
          }else{
            value <- xmlValue(child)
            if(value=="") value <- NA
            if(fieldName == "text") fieldName <- "value"
            self[[fieldName]] <- value
          }
        }
        
      }
      
      #inherit attributes if any
      self$attrs <- as.list(xmlAttrs(xml, TRUE, FALSE))
    },
    
    #encode
    encode = function(addNS = TRUE, validate = TRUE, strict = FALSE){

      #list of fields to encode as XML
      fields <- rev(names(self))
      
      #root XML
      rootXML <- NULL
      rootXMLAttrs <- list()
      if("attrs" %in% fields){
        rootXMLAttrs <- self[["attrs"]]
      }
      
      #fields
      fields <- fields[!sapply(fields, function(x){
        (class(self[[x]]) %in% c("environment", "function")) ||
        (x %in% private$system_fields)
      })]
      
      if(self$isDocument()){
        rootNamespaces <- sapply(ISOMetadataNamespace$all(), function(x){x$getDefinition()})
        rootXML <- xmlOutputDOM(
          tag = self$element,
          nameSpace = self$namespace$id,
          nsURI = rootNamespaces
        )
      }else{
        if(addNS){
          nsdefs <- self$getNamespaceDefinition(recursive = TRUE)
          rootXML <- xmlOutputDOM(
            tag = self$element,
            nameSpace = self$namespace$id,
            nsURI = nsdefs
          )
        }else{
          rootXML <- xmlOutputDOM(
            tag = self$element,
            nameSpace = self$namespace$id
          )
        }
      }
      
      for(field in fields){
        fieldObj <- self[[field]]
        
        #default values management
        if(is.null(fieldObj) || (is.list(fieldObj) & length(fieldObj)==0)){
          if(field %in% names(self$defaults)){
            fieldObj <- self$defaults[[field]]
          }
        }
        
        #user values management
        ns <- self$namespace$getDefinition()
        if(field != "value"){
          klass <- self$isFieldInheritedFrom(field)
          if(!is.null(klass)){
            ns <- ISOMetadataNamespace[[klass$private_fields$xmlNamespacePrefix]]$getDefinition()
          }
        }
        namespaceId <- names(ns)
        if(!is.null(fieldObj)){
          if(is(fieldObj, "ISOAbstractObject")){
            if(self$wrap){
              wrapperNode <- xmlOutputDOM(
                tag = field,
                nameSpace = namespaceId
              )
              wrapperNode$addNode(fieldObj$encode(addNS = FALSE, validate = FALSE))
              rootXML$addNode(wrapperNode$value())
            }else{
              rootXML$addNode(fieldObj$encode(addNS = FALSE, validate = FALSE))
            }
          }else if(is(fieldObj, "list")){
            for(item in fieldObj){
              nodeValue <- NULL
              if(is(item, "ISOAbstractObject")){
                nodeValue <- item
              }else{
                nodeValue <- self$wrapBaseElement(field, item)
              }
              if(nodeValue$wrap){
                wrapperNode <- xmlOutputDOM(
                  tag = field,
                  nameSpace = namespaceId
                )
                wrapperNode$addNode(nodeValue$encode(addNS = FALSE, validate = FALSE))
                rootXML$addNode(wrapperNode$value())
              }else{
                rootXML$addNode(nodeValue$encode(addNS = FALSE, validate = FALSE))
              }
            }
          }else{
            if(is.na(fieldObj)){
              emptyNode <- xmlOutputDOM(tag = field,nameSpace = namespaceId)
              rootXML$addNode(emptyNode$value())
            }else{
              if(field == "value"){
                fieldObj <- private$fromComplexTypes(fieldObj)
                rootXML$addNode(xmlTextNode(fieldObj))
              }else{
                dataObj <- self$wrapBaseElement(field, fieldObj)
                if(!is.null(dataObj)){
                  if(dataObj$wrap){
                    #general case of gco wrapper element
                    wrapperNode <- xmlOutputDOM(
                      tag = field,
                      nameSpace = namespaceId
                    )
                    wrapperNode$addNode(dataObj$encode(addNS = FALSE, validate = FALSE))
                    rootXML$addNode(wrapperNode$value())
                  }else{
                    rootXML$addNode(dataObj$encode(addNS = FALSE, validate = FALSE))
                  }
                }
              }
            }
          }
        }
      }
      out <- rootXML$value()
      out <- as(out, "XMLInternalNode")
      if(length(rootXMLAttrs)>0){
        suppressWarnings(xmlAttrs(out) <- rootXMLAttrs)
      }
      
      #validation vs. ISO 19139 XML schemas
      compliant <- NA
      if(validate){
        compliant <- self$validate(xml = out, strict = strict)
      }
      
      #add header
      if(self$isDocument()){
        outbuf <- xmlOutputBuffer("", header = private$xmlHeader(compliant))
        outbuf$add(as(out, "character"))
        out <- xmlParse(outbuf$value())
      }
      
      return(out)
    },
    
    #validate
    validate = function(xml = NULL, strict = FALSE){
      
      #xml
      schemaNamespaceId <- NULL
      if(is.null(xml)){
        schemaNamespaceId <- self$namespace$id
        xml <- self$encode(addNS = TRUE, validate = FALSE, strict = strict)
      }else{
        #remove comments if any
        content <- as(xml, "character")
        content <- gsub("<!--.*?-->", "", content)
        xml <- xmlParse(content, encoding = private$encoding)
        schemaNamespaceId <- names(xmlNamespace(xmlRoot(xml)))
      }
      
      #proceed with schema xml schema validation
      xsd <- getISOSchemasFor(schemaNamespaceId)
      if(is(xml, "XMLInternalNode")) xml <- xmlDoc(xml)
      report <- xmlSchemaValidate(xsd, xml)
      
      #check validity on self
      isValid <- report$status == 0
      if(!isValid){
        loggerType <- ifelse(strict, "ERROR", "WARN")
        for(error in report$errors){
          errorMsg <- paste0(substr(error$msg, 1, nchar(error$msg)-2), " at line ", error$line, ".")
          self[[loggerType]](errorMsg)
        }
        msg <- sprintf("Object '%s' is INVALID according to ISO 19139 XML schemas!", self$getClassName())
        if(strict){
          self$ERROR(msg)
          stop(msg)
        }else{
          self$WARN(msg)
        }
      }else{
        self$INFO(sprintf("Object '%s' is VALID according to ISO 19139 XML schemas!", self$getClassName()))
      }
      return(isValid)
    },
    
    #Util & internal methods
    #---------------------------------------------------------------------------
    
    #getNamespaceDefinition
    getNamespaceDefinition = function(recursive = FALSE){
      nsdefs <- NULL
      
      if(recursive){
        #list of fields
        fields <- rev(names(self))
        fields <- fields[!sapply(fields, function(x){
          (class(self[[x]]) %in% c("environment", "function")) ||
            (x %in% private$system_fields)
        })]
        
        selfNsdef <- self$getNamespaceDefinition()
        nsdefs <- list()
        if(length(fields)>0){
          invisible(lapply(fields, function(x){
            xObj <- self[[x]]
            if(is.null(xObj) || (is.list(xObj) & length(xObj) == 0)){
              if(x %in% names(self$defaults)){
                xObj <- self$defaults[[x]]
              }
            }
            hasContent <- !is.null(xObj)
            if(is(xObj, "ISOAbstractObject")){
              hasContent <- any(hasContent, length(xObj$attrs)>0)
            }
            if(hasContent){
              
              #add parent namespaces if any parent field
              if(x != "value"){
                klass <- self$isFieldInheritedFrom(x)
                if(!is.null(klass)){
                  ns <- ISOMetadataNamespace[[klass$private_fields$xmlNamespacePrefix]]$getDefinition()
                  if(!(ns %in% nsdefs)){
                    nsdefs <<- c(nsdefs, ns)
                  }
                }
              }
              
              #add namespaces
              nsdef <- NULL
              if(is(xObj, "ISOAbstractObject")){
                nsdef <- xObj$getNamespaceDefinition(recursive = recursive)
              }else if(is(xObj, "list")){
                nsdef <- list()
                invisible(lapply(xObj, function(xObj.item){
                  nsdef.item <- NULL
                  if(is(xObj.item, "ISOAbstractObject")){
                    nsdef.item <- xObj.item$getNamespaceDefinition(recursive = recursive)
                  }else{
                    nsdef.item <- ISOMetadataNamespace$GCO$getDefinition() 
                  }
                  for(item in names(nsdef.item)){
                    nsd <- nsdef.item[[item]]
                    if(!(nsd %in% nsdef)){
                      nsdef.new <- c(nsdef, nsd)
                      names(nsdef.new) <- c(names(nsdef), item)
                      nsdef <<- nsdef.new
                    }
                  }
                }))
              }else{
                if(names(selfNsdef) != "gml"){
                  nsdef <- ISOMetadataNamespace$GCO$getDefinition()
                }
              }
              for(item in names(nsdef)){
                nsdef.item <- nsdef[[item]]
                if(!(nsdef.item %in% nsdefs)){
                  nsdefs.new <- c(nsdefs, nsdef.item)
                  names(nsdefs.new) <- c(names(nsdefs), item)
                  nsdefs <<- nsdefs.new
                }
              }
            }
          }))
        }
        if(!(selfNsdef[[1]] %in% nsdefs)) nsdefs <- c(selfNsdef, nsdefs)
        nsdefs <- nsdefs[!sapply(nsdefs, is.null)]
      }else{
        nsdefs <- self$namespace$getDefinition()
      }
      
      invisible(lapply(names(self$attrs), function(attr){
        str <- unlist(strsplit(attr,":", fixed=T))
        if(length(str)>1){
          nsprefix <- str[1]
          namespace <- ISOMetadataNamespace[[toupper(nsprefix)]]
          if(!is.null(namespace)){
            ns <- namespace$getDefinition()
            if(!(ns %in% nsdefs)) nsdefs <<- c(nsdefs, ns)
          }
        }
      }))
      
      return(nsdefs)
    },
    
    #getClassName
    getClassName = function(){
      return(class(self)[1])
    },
    
    #getClass
    getClass = function(){
      class <- eval(parse(text=self$getClassName()))
      return(class)
    },
    
    #wrapBaseElement
    wrapBaseElement = function(field, fieldObj){
      dataType <- class(fieldObj)
      
      #specific coercing
      if(all(dataType == c("POSIXct","POSIXt"))) dataType <- "datetime"
      
      #wrapping
      dataObj <- switch(tolower(dataType),
                        "character" = ISOBaseCharacterString$new(value = iconv(fieldObj, to  = "UTF-8//IGNORE")),
                        "numeric"   = ISOBaseReal$new(value = fieldObj),
                        "decimal"   = ISOBaseDecimal$new(value = fieldObj), #Requires specific class call
                        "integer"   = ISOBaseInteger$new(value = fieldObj),
                        "unlimitedinteger" = ISOUnlimitedInteger$new(value = fieldObj),
                        "logical"   = ISOBaseBoolean$new(value = fieldObj),
                        "datetime"  = ISOBaseDateTime$new(value = fieldObj),
                        "date"      = ISOBaseDate$new(value = fieldObj),
                        NULL
      )
      return(dataObj)
    },
    
    #contains
    contains = function(field, metadataElement){
      out = FALSE
      if(length(self[[field]]) == 0){
        out = FALSE
      }else{
        out = any(sapply(self[[field]], function(x){
          ISOAbstractObject$compare(x, metadataElement)
        }))
      }
      return(out)
    },
    
    #addListElement
    addListElement = function(field, metadataElement){
      startNb <- length(self[[field]])
      if(!self$contains(field, metadataElement)){
        self[[field]] = c(self[[field]], metadataElement)
      }
      endNb = length(self[[field]])
      return(endNb == startNb+1)
    },
    
    #delListElement
    delListElement = function(field, metadataElement){
      startNb <- length(self[[field]])
      if(self$contains(field, metadataElement)){
        self[[field]] = self[[field]][!sapply(self[[field]], ISOAbstractObject$compare, metadataElement)]
      }
      endNb = length(self[[field]])
      return(endNb == startNb-1)
    },
    
    #setAttr
    setAttr = function(attrKey, attrValue){
      self$attrs[[attrKey]] <- attrValue
    },
    
    #setId
    setId = function(id, addNS = FALSE){
      attrKey <- "id"
      if(addNS) attrKey <- paste(tolower(private$xmlNamespacePrefix), attrKey, sep=":")
      self$attrs[[attrKey]] <- id
    },
    
    #setHref
    setHref = function(href){
      self$attrs[["xlink:href"]] <- href
    },
    
    #setCodeList
    setCodeList = function(codeList){
      self$attrs[["codeList"]] <- codeList
    },
    
    #setCodeListValue
    setCodeListValue = function(codeListValue){
      self$attrs[["codeListValue"]] <- codeListValue
    },
    
    #setCodeSpace
    setCodeSpace = function(codeSpace){
      self$attrs[["codeSpace"]] <- codeSpace
    },
    
    #setValue
    setValue = function(value){
      self$value <- value
    },
    
    #isDocument
    isDocument = function(){
      return(private$document)
    },
    
    #isFieldInheritedFrom
    isFieldInheritedFrom = function(field){
      parentClass <- NULL
      inherited <- !(field %in% names(self$getClass()$public_fields))
      if(inherited){
        classes <- class(self)
        classes <- classes[c(-1,-length(classes))]
        for(i in 1:length(classes)){
          cl <- eval(parse(text=classes[i]))
          if(field %in% names(cl$public_fields)){
            parentClass <- cl
            break
          }
        }
      }
      return(parentClass)
    }
  )                              
)

ISOAbstractObject$getISOClassByNode = function(node){
  outClass <- NULL
  if(!is(node, "XMLInternalDocument")) node <- xmlDoc(node)
  nodeElement <- xmlRoot(node)
  nodeElementName <- xmlName(nodeElement)
  nodeElementNames <- unlist(strsplit(nodeElementName, ":"))
  if(length(nodeElementNames)>1){
    nodeElementName <- nodeElementNames[2]
  }
  list_of_classes <- rev(ls("package:geometa"))
  list_of_classes <- list_of_classes[regexpr("^ISO.+", list_of_classes)>0 | regexpr("^GML.+", list_of_classes)>0]
  for(classname in list_of_classes){
    class <- eval(parse(text=classname))
    if(length(class$private_fields)>0
       && !is.null(class$private_fields$xmlElement)
       && !is.null(class$private_fields$xmlNamespacePrefix)){

      if(nodeElementName %in% class$private_fields$xmlElement){
        outClass <- class
        break
      }
    }
  }
  return(outClass)
}

ISOAbstractObject$compare = function(metadataElement1, metadataElement2){
  text1 <- NULL
  if(is(metadataElement1, "ISOAbstractObject")){
    xml1 <-metadataElement1$encode(addNS = TRUE, validate = FALSE)
    if(metadataElement1$isDocument()){
      content1 <- as(xml1, "character")
      content1 <- gsub("<!--.*?-->", "", content1)
      xml1 <- xmlParse(content1) 
    }else{
      xml1 <- XML::xmlDoc(xml1)
    }
    text1 <- as(xml1, "character")
  }else{
    text1 <- as.character(metadataElement1)
  }
  text2 <- NULL
  if(is(metadataElement2, "ISOAbstractObject")){
    xml2 <- metadataElement2$encode(addNS = TRUE, validate = FALSE)
    if(metadataElement2$isDocument()){
      content2 <- as(xml2, "character")
      content2 <- gsub("<!--.*?-->", "", content2)
      xml2 <- xmlParse(content2) 
    }else{
      xml2 <- XML::xmlDoc(xml2)
    }
    text2 <- as(xml2, "character")
  }else{
    text2 <- as.character(metadataElement2)
  }
  return(text1 == text2)
}

#ISO 19139 schemas fetcher / getter
#===============================================================================
#fetchISOSchemaFor
fetchISOSchemasFor <- function(namespace){
  schemaPath <- "extdata/schemas"
  xsd <- tryCatch(
    XML::xmlParse(
      system.file(paste(schemaPath, namespace, sep="/"), paste0(namespace,".xsd"),
                  package = "geometa", mustWork = TRUE),
      isSchema = TRUE, xinclude = TRUE,
      error = function (msg, code, domain, line, col, level, filename, class = "XMLError"){}
    )
  )
  return(xsd)
}

#fetchISOSchemas
fetchISOSchemas <- function(){
  packageStartupMessage("Loading ISO 19139 XML schemas...")
  namespaces <- c("gmd", "gfc")
  schemas <- lapply(namespaces, fetchISOSchemasFor)
  names(schemas) <- namespaces
  .geometa.iso$schemas <- schemas
}

#getISOSchemas
getISOSchemasFor <- function(namespace){
  if(!(namespace %in% c("gmd","gfc"))) namespace <- "gmd"
  return(.geometa.iso$schemas[[namespace]])
}
