@smokeTest
Feature:

  Background:
    * call read('this:../../common/hooks/scriptDependencies.feature')
    * def mockserverPort = 8080
    Given url 'http://localhost:' + mockserverPort
#    * def token = response.token
    * def tokenResponse = call read('classpath:helpers/authenticationToken.feature')
    * def token = tokenResponse.authToken


    * def tokenResponses = call read('classpath:helpers/multiAuthToken.feature')
    * def token1 = tokenResponses.authToken1
    * def token2 = tokenResponses.authToken2
    * def token3 = tokenResponses.authToken3


    * def pokemon1 = "ditto"
    * def pokemon2 = "charizard"
    * def pokemon3 = "zubat"




  @mgmt
  Scenario: Calling the management endpoint returns the status of the server
    * call read(mockserver + '@getServerStatus')

  @pokemon
  Scenario Outline: <id>: Calling the pokemon endpoint returns a HTTP 200 response to the test script
    * call read(commonScenarios + '@buildPayload') { pokemonName: 'ditto', infoRequest: '<detailRequest>'}

    * call read(mockserver + '@getPokeInfo') { expectedStatus: 200, payload: #(inputData) }

    Examples:
      | id | detailRequest |
      | 1  | types         |
      | 2  | abilities     |

  @happyPathTypes
  Scenario: Happy Path Generate token and request pokemon type/s

    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon3)","details": "types"}}
    When method PUT
    Then status 200
    And match response.payload.originalRequest.name == pokemon3
    And match response.payload.originalRequest.dataRequested == 'types'
    And def pokemonName = response.payload.originalRequest.name
    And def pokemonTypes = response.payload.filteredResponse
    Then print 'The type/s for ' + pokemonName + pokemonTypes



  @happyPathAbilities
  Scenario: Happy Path Generate token and request pokemon abilities AC 1.1

    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon1)","details": "abilities"}}
    When method PUT
    Then status 200
    And match response.payload.originalRequest.name == pokemon1
    And match response.payload.originalRequest.dataRequested == 'abilities'
    And def pokemonName = response.payload.originalRequest.name
    And def pokemonAbilities = response.payload.filteredResponse
    Then print 'The abilities for ' + pokemonName + ' are ' + pokemonAbilities

  @invalidToken
  Scenario:  Invalid Request sent to pokemon endpoint
    * def token = 7
    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon1)","details": "abilities"}}
    When method PUT
    Then status 403
    Then print 'Invalid request made'


  @knownBug
  Scenario: Multiple valid requests made to pokemon endpoint, stored in archives error due to token bug
    Given header auth-token = token
    * print token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon1)","details": "types"}}
    When method PUT
    Then status 200

    Given header auth-token = token1
    * print token1
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon2)","details": "types"}}
    When method PUT
    Then status 403

    Given header auth-token = token2
    * print token2
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon3)","details": "types"}}
    When method PUT
    Then status 403

    Given header auth-token = token3
    * print token3
    Given path '/v1/archive'
    When method POST
    Then status 403

  @validMgmt
  Scenario: Valid request sent to Management end point and amount of users / archive size printed
    Given url 'http://localhost:' + mockserverPort + '/v1/mgmt'
    When method POST
    Then status 200
    And def activePeople = response.stats.activeUsers
    And def currentArchiveSize = response.stats.archiveSize
    Then print 'The amount of active users are ' + activePeople + ' and the current archive is of size ' + currentArchiveSize

  @pokeApiAssert
  Scenario: Ability match with PokeAPI for ditto
    * def pokemon = 'ditto'
    Given url 'https://pokeapi.co/api/v2/pokemon/' + pokemon
    When method GET
    Then status 200
    And match response.abilities[*].ability.name contains ['limber','imposter']

  @evalTesting
  Scenario: Eval
#    * def pokemon = 'ditto'
    Given url 'https://pokeapi.co/api/v2/pokemon/' + pokemon1
    When method GET
    Then status 200
    And match response.abilities[*].ability.name == "#array"
    And match each response.abilities[*].ability.name == "#string"
    And match response.abilities[*].ability.name contains ['limber','imposter']
#    And match response.abilities[*].ability.name contains 'limber'
#    * def rtnAbil = $response.abilities[?(@.abilities=='abilities')]
#    * def pokAbility = $rtnAbil..ability
#    * def Collections = Java.type('java.util.Collections')
#    * eval Collections.sort(pokAbility)
#    * print pokAbility

  @happyPathArchive
  Scenario:  Stored in Archives

    Given header auth-token = token
    Given path '/v1/archive'
    When method POST
    Then status 201
    Then print 'Now stored on the archive'

  @schemaInfoAlignment
  Scenario: Compare pokeApi and localApi

    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "ABC123DEF456GH78"},"payload": {"name": "#(pokemon1)","details": "abilities"}}
    When method PUT
    Then status 200
    And match response.payload.originalRequest.name == pokemon1
    And match response.payload.originalRequest.name == pokemon1
    And match response.payload.originalRequest.dataRequested == 'abilities'
    And def pokemonName = response.payload.originalRequest.name
    And def pokemonAbilities = response.payload.filteredResponse

    Given url 'https://pokeapi.co/api/v2/pokemon/' + pokemon1
    When method GET
    Then status 200
    And match response.abilities[*].ability.name contains ['limber','imposter']
    And match pokemonAbilities contains response.abilities[0].ability.name
    And match pokemonAbilities contains response.abilities[1].ability.name




  @invalidPayload
  Scenario Outline: Happy Path with invalid payload (requestRef as integer)

    Given header auth-token = token
    Given path '/v1/pokemon'
    And request {"header": {"requestReference": "<requestReference> + 1"},"payload": {"name": "<name>","details": "<details>"}}
    When method PUT
    Then status 400
    And match response == <errorResponse>

    Examples:
      | requestReference | name  | details | errorResponse
      | 7                | zubat | types   | {"message":"The provided payload is invalid."} |


#    And match response.payload.originalRequest.name == pokemon3
#    And match response.payload.originalRequest.dataRequested == 'types'
#    And def pokemonName = response.payload.originalRequest.name
#    And def pokemonTypes = response.payload.filteredResponse
#    Then print 'The type/s for ' + pokemonName + pokemonTypes



  @managementStatus
  Scenario: Valid request sent to management endpoint
    Given path '/v1/mgmt'
    When method POST
    Then status 200













