// Every X seconds, run a function that checks the server for new content
// get the new content
// inject into the DOM - redraw
$(function(){
  // setInterval(function(){
  //   console.log("hello, it's been 1000 miliseconds")
  // }, 1000);
    BigBoard = {
      init: function(){
        setInterval(function(){
          $.getScript('/big_board')
        }, 1000);
      }
    }

});
