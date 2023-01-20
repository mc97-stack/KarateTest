Feature: stateful mock server

  Background:
    * callonce read('this:./helpers/dependencyLoader.feature')
    * configure cors = true

    * def generateAuthToken =
    """
      function() {
        let token = uuid();
        while(authorisedTokens.includes(token) && authorisedTokens.length > 0)
        {
          token = uuid();
        }
        return token;
      }
    """

    * def removeStaleToken =
    """
      function(contentToRemove)
      {
        let removeTokenAtIndex = 0;
        removeTokenAtIndex = authorisedTokens.indexOf(contentToRemove);
        if(removeTokenAtIndex >= 0)
        {
          authorisedTokens.splice(removeTokenAtIndex, 1);
        }
        return authorisedTokens;
      }
    """

    * def responseHeaders = read('this:./data/headerTemplate.json')

  Scenario: pathMatches('/v1/mgmt') && methodIs('post')
    * def responseStatus = 200

    # Building the response for the management endpoint
    * def response = {}
    * set response.status = 'Server is online.'
    * set response.stats.activeUsers = (authorisedTokens).length
    * set response.stats.archiveSize = (requestStore).length

  Scenario: pathMatches('/v1/auth') && methodIs('get')
    * def generatedToken = generateAuthToken()
    * eval authorisedTokens.push(generatedToken)

    * def responseStatus = 201
    * def responseHeaders = { 'Content-Type': 'application/json' }
    * def response =
    """
      {
        "token": #(generatedToken)
      }
    """
    * print authorisedTokens

  Scenario: pathMatches('/v1/archive') && methodIs('post')

    * def tokenPresent = !(karate.match("requestHeaders.auth-token == '#notpresent'").pass)
    * if (tokenPresent) karate.set('isAuthorised', authorisedTokens.includes(karate.jsonPath(requestHeaders, '$.auth-token')[0]))
    * if (tokenPresent) karate.set('authorisedTokens', removeStaleToken(karate.jsonPath(requestHeaders, '$.auth-token')[0]))

    * if (!tokenPresent) karate.set(karate.call('this:./helpers/payloadValidator.feature@notAuthorisedResponse'))
    * if (tokenPresent && !isAuthorised) karate.set(karate.call('this:./helpers/payloadValidator.feature@notAuthorisedResponse'))

    * if (tokenPresent && isAuthorised) karate.set('requestStore', requestStore)
    * if (tokenPresent && isAuthorised) karate.set(karate.call('this:./helpers/responseBuilder.feature@buildArchiveResponse'))
    * def response = karate.get('response')


  Scenario: pathMatches('/v1/pokemon') && methodIs('put')

    * def tokenPresent = !(karate.match("requestHeaders.auth-token == '#notpresent'").pass)
    * if (tokenPresent) karate.set('isAuthorised', authorisedTokens.includes(karate.jsonPath(requestHeaders, '$.auth-token')[0]))
    * if (!tokenPresent) karate.set(karate.call('this:./helpers/payloadValidator.feature@notAuthorisedResponse'))
    * if (tokenPresent && isAuthorised) karate.set('authorisedTokens', removeStaleToken(karate.jsonPath(requestHeaders, '$.auth-token')[0]))
    * if (!tokenPresent) karate.abort()
    * print authorisedTokens

    * if (tokenPresent && !isAuthorised) karate.set(karate.call('this:./helpers/payloadValidator.feature@notAuthorisedResponse'))
    * if (tokenPresent && !isAuthorised) karate.abort()

    * karate.set('isValidRequest', karate.match("request == karate.jsonPath(schemas, '$.request')"))
    * if (!isValidRequest.pass) karate.set(karate.call('this:./helpers/payloadValidator.feature@invalidRequestPayload'))
    * if (!isValidRequest.pass) karate.abort()

    * def payloadPresent = request != null
    * if (!payloadPresent) karate.set(karate.call('this:./helpers/payloadValidator.feature@payloadNotPresent'))
    * if (!payloadPresent) karate.abort()

    * def req = (payloadPresent)? JSON.stringify(request) : ''
    * call read('this:./helpers/payloadValidator.feature@isSupportedPokemon') { req: #(req) }
    * if (payloadPresent) karate.set('isSupported', output)
    * if (!isSupported.pass) karate.set(karate.call('this:./helpers/payloadValidator.feature@payloadUnsupported'))
    * if (!isSupported.pass) karate.abort()

    * def storage = {}
    * set storage.data.headers = requestHeaders
    * set storage.data.payload = request
    * set storage.info.endpoint = requestUri
    * set storage.info.received = getIsoDateTime()

    * def validationOutcome = isAuthorised && isValidRequest.pass && isSupported.pass
    * if (validationOutcome) requestStore.push(storage)
    * if (validationOutcome) karate.set('req', request)
    * if (validationOutcome) karate.set(karate.call('this:./helpers/responseBuilder.feature@responseFromObject'))

    * if (tokenPresent && validationOutcome) karate.set('responseStatus', 200)
    * set response.header.requestDateTime = storage.info.received

  Scenario:
    # catch-all
    * def responseStatus = 404
    * def response = <html><body>Not Found</body></html>