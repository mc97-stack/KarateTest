 Feature: Create an Authentication token

   @getMultipleAuth
   Scenario: Multiple Tokens
     * def mockserverPort = 8080
     Given url 'http://localhost:' + mockserverPort
     Given path '/v1/auth'
     When method GET
     Then status 201
     * def authToken1 = response.token
     * print authToken1



     Given url 'http://localhost:' + mockserverPort
     Given path '/v1/auth'
     When method GET
     Then status 201
     * def authToken2 = response.token
     * print authToken2



     Given url 'http://localhost:' + mockserverPort
     Given path '/v1/auth'
     When method GET
     Then status 201
     * def authToken3 = response.token
     * print authToken3

