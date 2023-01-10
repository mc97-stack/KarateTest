@ignore
Feature:

  Scenario:
    * def schema = {}
    * set schema.management = read('this:./management.json')
    * set schema.authorisation = read('this:./authorisation.json')