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

    * set response.payload.additionalInformation.info.pokedexNumber = karate.jsonPath(extResponse, '$.id')
    * set response.payload.additionalInformation.info.weight = karate.jsonPath(extResponse, '$.weight')
    * set response.payload.additionalInformation.info.base_experience = karate.jsonPath(extResponse, '$.base_experience')
    * set response.payload.additionalInformation.stats.hp = karate.jsonPath(extResponse, "$.stats[?(@.stat.name == 'hp')].base_stat")[0]
    * set response.payload.additionalInformation.stats.atk = karate.jsonPath(extResponse, "$.stats[?(@.stat.name == 'attack')].base_stat")[0]
    * set response.payload.additionalInformation.stats.def = karate.jsonPath(extResponse, "$.stats[?(@.stat.name == 'defense')].base_stat")[0]
    * set response.payload.additionalInformation.stats.spAtk = karate.jsonPath(extResponse, "$.stats[?(@.stat.name == 'special-attack')].base_stat")[0]
    * set response.payload.additionalInformation.stats.spDef = karate.jsonPath(extResponse, "$.stats[?(@.stat.name == 'special-defense')].base_stat")[0]
    * set response.payload.additionalInformation.stats.speed = karate.jsonPath(extResponse, "$.stats[?(@.stat.name == 'speed')].base_stat")[0]

    # Request fulfilled
    * set response.header.fulfilmentDateTime = getIsoDateTime()

    * eval ++requestCounter