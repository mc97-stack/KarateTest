@smokeTest
Feature:

  Background:
    * call read('this:../../common/hooks/scriptDependencies.feature')

  @mgmt
  Scenario: Calling the management endpoint returns the status of the server
    * call read(mockserver + '@getServerStatus')

  @pokemon
  Scenario Outline: <id>: Calling the pokemon endpoint returns a HTTP 200 response to the test script
    * call read(commonScenarios + '@buildPayload') { pokemonName: 'ditto', infoRequest: '<detailRequest>'}

    * call read(mockserver + '@getPokeInfo') { expectedStatus: 200, payload: #(inputData) }

    Examples:
      | id | detailRequest |
      | 1  | types         |
      | 2  | abilities     |
