@startMockserver
  Feature:

    Background:
      * call read('this:../hooks/scriptDependencies.feature')

    Scenario:
      * call read(commonScenarios + '@startMockServer')