customMatchers = {
  
  // matcher function input params req'd by Jasmine
  // must return an object with 'compare' fn property
  toMatchDomIds: function(util, customEqualityTesters) {
    return {
      
      //actual custom matcher function definition supported by Jasmine
      // must be a "compare" fn property returned by matcher function
      compare: function(actual, expected) {
        var result = {};
        // extract project ids from jQ objs
        actualIds = $.map($("tr"), function(item) {
          return $(item).attr("id") 
        });

        // CREATE RESULTE OBJECT 
        // { pass: bool , message: string}

        // result.pass assignment:
        // test each id against the expected id
        result.pass = util.equals(actualIds, expected, customEqualityTesters);

        // result.message assignmetn:
        if (result.pass) {
          result.message = "Expected " + actual + " not to have DOM Ids" + expected + ". Instead it had " + actualIds
        } else {
          result.message = "Expected " + actual + " to have DOM Ids " +
          expected + ". Instead it had " + actualIds 
        }

        return result; 
      }

    }
  }
}