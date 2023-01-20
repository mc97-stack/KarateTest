@ignore
Feature:

  Background:
    # Building the unique server reference
    * def requestCounter = 1
    * def getServerReference =
    """
      function() {
        let output = '';
        output += getIsoDateTime().split('T')[0].replaceAll('-', '').substring(2);
        output += 'TS2';
        let temp = requestCounter.toString();
        while(temp.length < 8)
        {
          temp = '0' + temp;
        }
        output += temp
        return output;
      }
    """

  @buildArchiveResponse
  Scenario:
    * def responseStatus = 201
    * def responseHeaders = ''

    * def response = {}
    * set response.message-store = requestStore
    * set response.timeProcessed = getIsoDateTime()

    * karate.set('response', response)

  @responseFromObject
  Scenario:
    * def externalApi = call read('this:./pokeApiClient.feature@makeRequest') { requestedName: #(req.payload.name)}
    * def extResponse = externalApi.response

    * def response = {}
    * def response = read('this:../data/responseTemplate.json')

    # Mapping transferred fields
    * set response.header.references.originalRequest = req.header.requestReference
    * set response.payload.originalRequest.name = req.payload.name
    * set response.payload.originalRequest.dataRequested = req.payload.details

    # Creating system-generated fields
    * set response.header.references.server = getServerReference()

    # Building out the requested details to form response
    * def customJsonPath = '$.' + req.payload.details
    * def customJsonPath = customJsonPath + ((req.payload.details === 'types')? '..type.name': '')
    * def customJsonPath = customJsonPath + ((req.payload.details === 'abilities')? '..ability.name': '')

    * set response.payload.filteredResponse = karate.jsonPath(extResponse, customJsonPath)

        # Request fulfilled
    * set response.header.fulfilmentDateTime = getIsoDateTime()

    * eval ++requestCounter