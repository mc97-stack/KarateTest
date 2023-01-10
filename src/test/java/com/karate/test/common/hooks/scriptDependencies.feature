@ignore
Feature:

  Scenario:
    * def commonScenarios = 'classpath:com/karate/test/common/scenarioFunctions.feature'

    * call read('this:../schemas/responseSchemas.feature')
    * call read('this:../commonFunctions.feature')