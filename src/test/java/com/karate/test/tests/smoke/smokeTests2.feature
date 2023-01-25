@smokeTest2
Feature:

  Background:
    * call read('this:../../common/hooks/scriptDependencies.feature')
    * def mockserverPort = 8080
    Given url 'http://localhost:' + mockserverPort



  @2.1multipleRequestsValid
  Scenario: Multiple
    * def result1 = call read('smokeTests1.feature@1.1forTypes')
    * def result2 = call read('smokeTests1.feature@1.1forAbilities')
    * def tokenResponse = call read('classpath:helpers/authenticationToken.feature')
    * def token = tokenResponse.authToken
    Given header auth-token = token
    Given path '/v1/archive'
    When method POST
    Then status 201
    Then match response.message-store contains "#array"
    And print response

  @2.2invalidRequestNoHeader
  Scenario: Incorrectly with no header
    * def result1 = call read('smokeTests1.feature@1.1forTypes')
    * def result2 = call read('smokeTests1.feature@1.1forAbilities')
    * def tokenResponse = call read('classpath:helpers/authenticationToken.feature')
    * def token = tokenResponse.authToken
    Given path '/v1/archive'
    When method POST
    Then status 403
    And match response.message contains 'present a valid token'
    Then print 'Unrecognised token used so access is not authorised, 403 error forbidden'

  @2.3validRequestInvalidTokenArchive
  Scenario: Incorrect token
    * def result1 = call read('smokeTests1.feature@1.1forTypes')
    * def result2 = call read('smokeTests1.feature@1.1forAbilities')
    Given header auth-token = "null"
    Given path '/v1/archive'
    When method POST
    Then status 403
    And match response.message contains 'present a valid token'
    Then print 'Unrecognised token used so access is not authorised, 403 error forbidden'

  @4.1mgmtComparison
  Scenario: mgmt
    * def authUsers = []
    * def archiveSub = []
    * def result1 = call read('smokeTests1.feature@1.1forAbilities') karate.appendTo(authUsers, "authCount") && karate.appendTo(archiveSub, "pokeArchiveCount") && karate.appendTo(authUsers, "authCount")

    Given path '/v1/mgmt'
    When method POST
    Then status 200

