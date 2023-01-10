@ignore
Feature:

  Scenario:
    * def generateUniqueRef =
    """
      function(length)
      {
        if(length < 0)
        {
          length = 12;
        }
        let charMask = '', output = '';
        charMask = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";

        while(output.length != length)
        {
          output += charMask.charAt(Math.floor(Math.random()*charMask.length));
        }
        return output;
      }
    """