Feature:

  Background:
    * call read('this:../../common/hooks/scriptDependencies.feature')
    * def mockserverPort = 8080
    * def pokemon3 = "zubat"
    Given url 'http://localhost:' + mockserverPort




  @4.1mgmtComparison
  Scenario: mgmt
    * def activeUsers = []
    * def archiveSub = []
    * def result1 = call read('smokeTests1.feature@1.1forTypes')
    * karate.appendTo(archiveSub, "resultCount1")
    * def result2 = call read('smokeTests1.feature@1.1forAbilities')
    * karate.appendTo(archiveSub, "resultCount2")
    * def result3 = call read('smokeTests1.feature@1.2invalidAuth')
    * karate.appendTo(activeUsers, "resultCount3")
    * def result4 = call read('smokeTests1.feature@1.3invalidSchema')
    * def result5 = call read('smokeTests1.feature@1.4validRequestIncorrectly')
    * karate.appendTo(activeUsers, "resultCount5")
    * print karate.pretty(activeUsers) + 'These are the active users'
    * print activeUsers.length
    * print karate.pretty(archiveSub) + 'These are the archived'
    * print archiveSub.length
    Given path '/v1/mgmt'
    When method POST
    Then status 200
    And match response.stats.activeUsers == activeUsers.length
    And match response.stats.archiveSize == archiveSub.length
#    * def result3 = call read('@smokeTest1.feature@1.2invalidAuth') When you run this the management breaks - bug

  @4.1bug1
  Scenario: mgmt bug that has an infinite loop
    * def activeUsers = []
    * def archiveSub = []
    * def result1 = call read('smokeTests1.feature@1.1forTypes')
    * def result2 = call read('smokeTests1.feature@1.1forAbilities')
    * def result3 = call read('@smokeTest1.feature@1.2invalidAuth')






#    Then status 200
#    And match response.payload.originalRequest.name == pokemon2
#    And match response.payload.originalRequest.dataRequested == 'abilities'
#    And match response.payload.filteredResponse contains ['limber','imposter']

#   @4.1bug3
#   Scenario: Bug continuation
#     * def result = call read('smokeTest4.feature@4.1bug2')
#     Given path '/v1/mgmt'
#     When method POST
#     Then status 200
#     And match response.stats.activeUsers == 0
#     And match response.stats.archiveSize == archiveSub.length
#