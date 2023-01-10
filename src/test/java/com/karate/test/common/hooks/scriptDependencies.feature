@ignore
Feature:

  Scenario:
    * def commonFiles = 'classpath:com/karate/test/common/'
    * def commonScenarios = commonFiles + 'scenarioFunctions.feature'
    * def mockserver = commonFiles + 'mockserver.feature'

    * call read('this:../schemas/responseSchemas.feature')
    * call read('this:../commonFunctions.feature')