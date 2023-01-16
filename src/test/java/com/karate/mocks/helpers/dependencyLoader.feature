@ignore
Feature:

  Background:

    * def schemas = {}

    * set schemas.request = read('this:../data/requestSchema.json')
    * set schemas.external.apiHeaders = read('this:../data/externalSchemas/responseHeaders.json')
    * set schemas.external.pokeInfo = read('this:../data/externalSchemas/pokeInfo.json')

  Scenario:
    * def uuid = function(){ return java.util.UUID.randomUUID().toString() }

    * def getIsoDateTime = function() { return new Date().toISOString(); }

    * def authorisedTokens = []
    * def requestStore = []
