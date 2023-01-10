# KarateTest
This repository contains a mock service that decorates the API endpoint available under (https://pokeapi.co). The API interface for this mock server is as follows:

| Endpoint      | Method | Description                                                                                 |
|---------------|--------|---------------------------------------------------------------------------------------------|
| `/v1/mgmt`    | POST   | Returns the current status of the server.                                                   |
| `/v1/auth`    | GET    | Returns a one-time authentication token for accessing business functionality.               |
| `/v1/pokemon` | PUT    | Retrieves data about a pokemon provided in the payload.                                     |
| `/v1/archive` | POST   | Retrieves all requests made to the `/v1/pokemon` endpoint within the active server session. |

This repository also contains system and smoke test suites for validating the mock server.

## API Endpoints Requiring Authentication
- `/v1/pokemon`
- `/v1/archive`

## `/v1/pokemon` (v1.0)
This endpoint currently supports the following options under the path `$.payload.details` in the request payload:

| Option    | Description                                                                       |
|-----------|:----------------------------------------------------------------------------------|
| types     | Retrieves the type information about the pokemon provided under `$.payload.name`. |
| abilities | Retrieves available abilities about the pokemon provided under `$.payload.name`.  |
