@ignore
Feature:

  @makeRequest
  Scenario:
    * url 'https://pokeapi.co/'
    * path 'api', 'v2', 'pokemon', requestedName.toLowerCase()

    * method GET
    * status 200

    * match responseHeaders contains schemas.external.apiHeaders
    * match response == schemas.external.pokeInfo

    * if ( karate.jsonPath(responseHeaders, '$.Content-Type')[0].includes('text/plain;') ) karate.set('additionalValidation', karate.match("karate.jsonPath(responseHeaders, '$.Content-Length') == '#array'"))
    * if ( karate.jsonPath(responseHeaders, '$.Content-Type')[0].includes('text/plain;') && !additionalValidation.pass) karate.fail()