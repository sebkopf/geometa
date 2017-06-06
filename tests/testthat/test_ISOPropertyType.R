# test_ISOPropertyType.R
# Author: Emmanuel Blondel <emmanuel.blondel1@gmail.com>
#
# Description: Unit tests for ISOPropertyType.R
#=======================
require(geometa, quietly = TRUE)
require(testthat)

context("ISOPropertyType")

test_that("encoding",{
  
  #encoding
  md <- ISOPropertyType$new()
  md$setMemberName("name")
  md$setDefinition("definition")
  md$setCardinality(lower=1,upper=1)
  expect_is(md, "ISOPropertyType")
  xml <- md$encode()
  expect_is(xml, "XMLInternalNode")
  
  #decoding
  md2 <- ISOPropertyType$new(xml = xml)
  xml2 <- md2$encode()
  
  expect_true(ISOMetadataElement$compare(md, md2))
  
})