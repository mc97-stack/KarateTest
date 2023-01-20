
 Feature: Create an Authentication token

   @getAuthToken
   Scenario: Create Token
     * def mockserverPort = 8080
     Given url 'http://localhost:' + mockserverPort
     Given path '/v1/auth'
     When method GET
     Then status 201
     * def authToken = response.token
