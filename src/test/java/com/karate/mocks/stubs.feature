Feature: stateful mock server

  Background:
    * call read('this:./helpers/dependencyLoader.feature')
    * configure cors = true

    * def authorisedTokens = []
    * def requestStore = []
    * def response = {}

    * def removeStaleToken =
    """
      function(contentToRemove)
      {
        authorisedTokens.splice(authorisedTokens.indexOf('contentToRemove'), 1);
        return authorisedTokens;
      }
    """

    * def responseHeaders = read('this:./data/headerTemplate.json')

  Scenario: pathMatches('/mgmt') && methodIs('post')
    * def responseStatus = 200

    # Building the response for the management endpoint
    * set response.status = 'Server is online.'
    * set response.stats.ActiveUsers = (authorisedTokens).length
    * set response.stats.ArchiveSize = (requestStore).length

  Scenario: pathMatches('/v1/auth') && methodIs('get')
    * def generateAuthToken =
    """
      function() {
        let token = uuid();
        while(!authorisedTokens.includes(token) && authorisedTokens.length > 0)
        {
          token = uuid();
        }
        return token;
      }
    """
    * def generatedToken = generateAuthToken()
    * eval authorisedTokens.push(generatedToken)

    * def responseStatus = 200
    * def responseHeaders = { 'Content-Type': 'application/json' }
    * def response =
    """
      {
        "token": #(generatedToken)
      }
    """

  Scenario: pathMatches('/v1/archive') && methodIs('get')

    * def isAuthorised = authorisedTokens.includes(karate.jsonPath(requestHeaders, '$.auth-token')[0])
    * if (!isAuthorised) karate.set(karate.call('this:./helpers/payloadValidator.feature@notAuthorisedResponse'))
    * if (!isAuthorised) karate.abort()

    * def responseStatus = 200
    * def responseHeaders = ''
    * set response.message-store = requestStore
    * set response.timeProcessed = getIsoDateTime()

    * def authorisedTokens = removeStaleToken(karate.jsonPath(requestHeaders, '$.auth-token')[0])

  Scenario: pathMatches('/v1/pokemon') && methodIs('put')

    * def isAuthorised = authorisedTokens.includes(karate.jsonPath(requestHeaders, '$.auth-token')[0])
    * if (!isAuthorised) karate.set(karate.call('this:./helpers/payloadValidator.feature@notAuthorisedResponse'))
    * if (!isAuthorised) karate.abort()

    * def isValidRequest = karate.match("request == karate.jsonPath(schemas, '$.request')")
    * if (!isValidRequest.pass) karate.set(karate.call('this:./helpers/payloadValidator.feature@invalidRequestPayload'))
    * if (!isValidRequest.pass) karate.abort()

    * call read('this:./helpers/payloadValidator.feature@isSupportedPokemon') { req: #(request) }
    * def isSupported = output
    * if (!isSupported.pass) karate.set(karate.call('this:./helpers/payloadValidator.feature@payloadUnsupported'))
    * if (!isSupported.pass) karate.abort()

    * def storage = {}
    * set storage.data.headers = requestHeaders
    * set storage.data.payload = request
    * set storage.info.endpoint = requestUri
    * set storage.info.received = getIsoDateTime()
    * eval requestStore.push(storage)

    * call read('this:./helpers/responseBuilder.feature@responseFromObject') { req: #(request) }

    * def responseStatus = 200
    * set response.header.requestDateTime = storage.info.received

    * def authorisedTokens = removeStaleToken(karate.jsonPath(requestHeaders, '$.auth-token')[0])

  Scenario:
    # catch-all
    * def responseStatus = 404
    * def response = <html><body>Not Found</body></html>