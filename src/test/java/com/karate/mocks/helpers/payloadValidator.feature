@ignore
Feature:

  @notAuthorisedResponse
  Scenario:
    * def responseStatus = 403
    * def responseHeaders = ''
    * def responseHeaders = { 'Content-Type': 'application/json' }
    * def response =
    """
      {
        "message": "Access is not authorised. Please present a valid token."
      }
    """

  @invalidRequestPayload
  Scenario:
    * def responseStatus = 400
    * def responseHeaders = ''
    * def responseHeaders = { 'Content-Type': 'application/json' }
    * def response =
    """
      {
        "message": "The provided payload is invalid."
      }
    """

  @isSupportedPokemon
  Scenario:
    * json req = req
    * def supportPokemon = read('this:../data/external/sunMoonPokemon.json')

    * def nameRequested = (req.payload.name).toLowerCase()
    * def nameRequested = nameRequested.substring(0, 1).toUpperCase() + nameRequested.substring(1)
#    * print nameRequested

    * def conditionalMatch = supportPokemon.includes(nameRequested)
    * def output = {}
    * set output.pass = conditionalMatch
    * set output.message = (!conditionalMatch)? 'The requested pokemon is not supported.' : ''
#    * print output

  @payloadUnsupported
  Scenario:
    * def responseStatus = 400
    * def responseHeaders = ''
    * def responseHeaders = { 'Content-Type': 'application/json' }
    * def response =
    """
      {
        "message": "The requested pokemon name was not recognised."
      }
    """