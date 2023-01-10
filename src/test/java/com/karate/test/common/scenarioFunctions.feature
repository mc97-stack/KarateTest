@ignore
Feature:

  Background:
    * def mockserverPort = 8080

  @startMockServer
  Scenario:
    * def serverConfiguration =
    """
      {
        mock: 'classpath:com/karate/mocks/stubs.feature',
        port: #(mockserverPort)
      }
    """
    * def server = karate.start(serverConfiguration)
    # Mock server will be deployed to http://localhost:8080/

  @getServerStatus
  Scenario:

    * url 'http://localhost:' + mockserverPort + '/v1/mgmt'
    * method POST
    * status 200

    * match response == schema.management

  @getOneTimeToken
  Scenario:
    * url 'http://localhost:' + mockserverPort + '/v1/auth'
    * method GET
    * status 201

    * match response == schema.authorisation

  @getPokeInfo
  Scenario:
    * if (karate.get('payload') == null) karate.fail('A payload must be provided to use this scenario function.')

    * def token = call read('this:./scenarioFunctions.feature@getOneTimeToken')
    * def authToken = karate.jsonPath(token, '$.response.token')

    * url 'http://localhost:' + mockserverPort + '/v1/pokemon'

    * def header = read('this:./data/header.json')
    * set header.auth-token = authToken
    * headers header

    * request payload

    * method PUT
    * match responseStatus == expectedStatus


