@ignore
Feature:

  Scenario:
    * def minutesWait = function(waitInMinutes){ karate.log("Starting a " + waitInMinutes + " minute waiting period."); java.lang.Thread.sleep(waitInMinutes*60*1000) }

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