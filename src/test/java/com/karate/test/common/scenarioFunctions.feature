@ignore
Feature:

  @buildPayload
  Scenario: Scenario functions for generating a valid payload for the 'v1/pokemon' API endpoint
    * def inputData = read('this:./data/request.json')
    * set inputData.header.requestReference = generateUniqueRef(16)
    * set inputData.payload.name = pokemonName
    * set inputData.payload.details = infoRequest