// Every X seconds, run a function that checks the server for new content
// get the new content
// inject into the DOM - redraw
$(function(){
  // setInterval(function(){
  //   console.log("hello, it's been 1000 miliseconds")
  // }, 1000);
    Refresh = {
      init: function(page){
        setInterval(function(page){
          $.getScript('/'+page)
        }, 1000)
        console.log("Running getScript: "+page);
      }
    }

});