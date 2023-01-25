@smokeTest1
Feature:

  Background:
    * call read('this:../../common/hooks/scriptDependencies.feature')
    * def mockserverPort = 8080
#    * def token = call read(mockserver + '@getOneTimeToken')
#    * def authToken = karate.jsonPath(token, '$.response.token')
#    * def tokenResponse = call read('classpath:helpers/authenticationToken.feature')
#    * def token = tokenResponse.authToken

    * def pokemon3 = "zubat"
    * def pokemon2 = "ditto"
    * def authUsers = 0
    Given url 'http://localhost:' + mockserverPort


  @mgmt
  Scenario: Calling the management endpoint returns the status of the server
    * call read(mockserver + '@getServerStatus')


  @1.1forTypes
  Scenario: Happy path for types
    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon3)","details": "types"}}
    When method PUT
    Then status 200
    And match response.payload.originalRequest.name == pokemon3
    And match response.payload.originalRequest.dataRequested == 'types'
    And match response.payload.filteredResponse contains ['poison','flying']
    * def response1 = response.payload.filteredResponse

    Given url 'https://pokeapi.co/api/v2/pokemon/' + pokemon3
    When method GET
    Then status 200
    And match response.types[*].type.name contains ['poison','flying']
    And match response.types[*].type.name contains response1


  @1.1forAbilities
  Scenario: Happy path for abilities
    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon2)","details": "abilities"}}
    When method PUT
    Then status 200
    And match response.payload.originalRequest.name == pokemon2
    And match response.payload.originalRequest.dataRequested == 'abilities'
    And match response.payload.filteredResponse contains ['limber','imposter']

    Given url 'https://pokeapi.co/api/v2/pokemon/' + pokemon2
    When method GET
    Then status 200
    And match response.abilities[*].ability.name contains ['limber','imposter']

  @1.1allHappyPaths
    Scenario Outline: Happy path for types and abilities
    * def tokenResponse = call read('classpath:helpers/authenticationToken.feature')
    * def token = tokenResponse.authToken
    * print token + 'this is token 1'
    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "<requestReference>"},"payload": {"name": "<name>","details": "<details>"}}
    When method PUT
    Then status 200
    And match response.payload.filteredResponse contains deep <Response>
#    * karate.repeat(2,

#    Given url 'https://pokeapi.co/api/v2/pokemon/' + pokemon2
#    When method GET
#    Then status 200
#    And match response.abilities[*].ability.name contains <Response>

    * def tokenResponse = call read('classpath:helpers/authenticationToken.feature')
    * def token2 = tokenResponse.authToken
    * print token2 + 'this is token 2'
    Given header auth-token = token2
    Given path '/v1/archive'
    When method POST
    Then status 201
    * print response


    Examples:
      | requestReference | name        | details   | Response            |
      | 6                | #(pokemon2) | abilities | 'limber','imposter' |
      | 7                | #(pokemon3) | types     | 'poison','flying'   |


  @1.2invalidAuth
  Scenario: Valid request but invalid auth token
    Given header auth-token = token + "1"
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon3)","details": "abilities"}}
    When method PUT
    Then status 403
    And match response.message contains 'present a valid token'
    Then print 'Unrecognised token used so access is not authorised, 403 error forbidden'

  @1.3invalidSchema
  Scenario Outline: Valid request with invalid schema
    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "<requestReference>"},"payload": {"name": "<name>","details": "<details>"}}
    When method PUT
    Then status 400
    And match response == <errorResponse>

    Examples:
      | requestReference     | name  | details | errorResponse                                  |
      | requestReference + 1 | zubat | types   | {"message":"The provided payload is invalid."} |




  @1.3invalidSchemaAll
  Scenario Outline: Valid request with invalid schema
    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "<requestReference>"},"payload": {"name": "<name>","details": "<details>"}}
    When method PUT
    Then status 400
    And match response == <errorResponse>

    Examples:
      | requestReference     | name   | details   | errorResponse                                                                                                  |  |  |  |
      | requestReference + 1 | zubat  | types     | {"message":"The provided payload is invalid."}                                                                 |  |  |  |
      | 7                    | namess | types     | {"message":"The requested pokemon name was not recognised."} && {"message":"The provided payload is invalid."} |  |  |  |
      | 7                    | zubat  | typos     | {"message":"The provided payload is invalid."}                                                                 |  |  |  |
      | requestReference + 1 | zubat  | abilities | {"message":"The provided payload is invalid."}                                                                 |  |  |  |
      | 7                    | namess | abilities | {"message":"The requested pokemon name was not recognised."} && {"message":"The provided payload is invalid."} |  |  |  |
      | 7                    | zubat  | abilitos  | {"message":"The provided payload is invalid."}                                                                 |  |  |  |
      | 7                    | zubat  |           | {"message":"The provided payload is invalid."}                                                                 |  |  |  |
      | 7                    |        | abilities | {"message":"The requested pokemon name was not recognised."} && {"message":"The provided payload is invalid."} |  |  |  |
      |                      | zubat  | abilities | {"message":"The provided payload is invalid."}                                                                 |  |  |  |


  @1.4validRequestIncorrectly
  Scenario: Valid request diff API method POST
    Given header auth-token = token
    * print token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon3)","details": "abilities"}}
    When method POST
    Then status 404
    And match response contains 'Not Found'










