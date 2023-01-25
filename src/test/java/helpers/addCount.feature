
Feature:

  Background:
    * def mockserverPort = 8080
    * url 'http://localhost:' + mockserverPort


  Scenario: Authentication
    Given path '/v1/auth'
    When method GET
    Then status 201
    * def authCount = response.length
    * print authCount



