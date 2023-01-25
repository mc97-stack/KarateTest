Feature: Pokemon data

  @getRandomPokemon
  Scenario: random pokemon
    * def random = function(max){ return Math.floor(Math.random() * max) + 1 }
    * def pokeJson =
    """
    {
      "pokemonDex": {
        "1": "Bulbasaur",
        "2": "Ditto",
        "3": "Charizard",
        "4": "Zubat",
        "5": "Weedle",
        "6": "Kakuna",
        "7": "Pidgeot",
        "8": "Spearow",
        "9": "Caterpie"
      }
    }
    """

    * def result = pokeJson.pokemonDex["2"]
    * def size = pokeJson.length
    * print size
    * print result