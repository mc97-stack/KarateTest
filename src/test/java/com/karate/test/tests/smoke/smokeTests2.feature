@smokeTest2
Feature:

  Background:
    * call read('this:../../common/hooks/scriptDependencies.feature')
    * def mockserverPort = 8080
    * def token = call read(mockserver + '@getOneTimeToken')
    * def authToken = karate.jsonPath(token, '$.response.token')
    * def pokemon3 = "zubat"
#    * def count = 6
#    * configure afterScenario =
#    """
#    function(){
#      count++
#      karate.log('Count is ' + count);
#
#      return count;
#
#    }
#    """
    Given url 'http://localhost:' + mockserverPort





  @2.1multipleRequestsValid
  Scenario: Multiple
    * def result1 = call read('smokeTests1.feature@1.1forTypes')
    * def result2 = call read('smokeTests1.feature@1.1forAbilities')
    * def token = call read(mockserver + '@getOneTimeToken')
    * def authToken = karate.jsonPath(token, '$.response.token')
    Given header auth-token = authToken
    Given path '/v1/archive'
    When method POST
    Then status 201
    Then match response.message-store contains "#array"
    And print response

  @2.2invalidRequestNoHeader
  Scenario: Incorrectly with no header
    * def result1 = call read('smokeTests1.feature@1.1forTypes')
    * def result2 = call read('smokeTests1.feature@1.1forAbilities')
    * def token = call read(mockserver + '@getOneTimeToken')
    * def authToken = karate.jsonPath(token, '$.response.token')
    Given path '/v1/archive'
    When method POST
    Then status 403
    And match response.message contains 'present a valid token'
    Then print 'Unrecognised token used so access is not authorised, 403 error forbidden'

  @2.3validRequestInvalidTokenArchive
  Scenario: Incorrect token
    * def result1 = call read('smokeTests1.feature@1.1forTypes')
    * def result2 = call read('smokeTests1.feature@1.1forAbilities')
    * def token = call read(mockserver + '@getOneTimeToken')
    * def authToken = karate.jsonPath(token, '$.response.token')
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
#    And match response.stats.activeUsers == '2'
#    * if (responseStatus == 200) karate.appendTo(archiveSub, "count")

#    * print authUsers.length
#    * print karate.pretty(authUsers)
#    * print archiveSub.length
#    * print karate.pretty(archiveSub)


#  @authDummy
#  Scenario: Add auth count
#  @trial
#  Scenario: trial
#    * def authTor = call read('smokeTests2.feature@4.1mgmtComparison'){authUsers}
#    * print authUsers

