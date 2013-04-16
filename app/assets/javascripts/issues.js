// # Place all the behaviors and hooks related to the matching controller here.
// # All this logic will automatically be available in application.js.
// # You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(function(){ 
  $('.edit_button a').hover(function(){
    $(this).tooltip('show')
  });
  $('.resolve_button a').hover(function(){
    $(this).tooltip('show')
  });
  $('.delete_button a').hover(function(){
    $(this).tooltip('show')
  });  
  $('.more_help_button a').hover(function(){
    $(this).tooltip('show')
  });

  $.fn.extend({
    limiter: function(limit, elem){
      console.log(this);
      $(this).on("keyup focus", function() {
        setCount(this, elem);
      });
      function setCount(src, elem) {
        var chars = src.value.length;
        var desc = "Your description is too short. Please give us more details of your issue. Help us, help you!";
        var first = $('.length_notice:first');
        if(chars == 0){
          first.text("Your description is too short. Please give us more details of your issue. Help us, help you!");
          first.css("color", "red");
        } else if((chars >= 1) && (chars < limit * 0.25)){
          first.text("That's it? We need more information.");
          first.css("color", "red");
        } else if((chars >= limit * 0.25) && (chars < limit * 0.75)){
          first.text("Still not quite cutting it.");
          first.css("color", "orange");
        } else if((chars >= limit * 0.75) && (chars < limit)){
          first.text("You're almost there!");
          first.css("color", "purple");
        }
        if (chars > limit) {
            // src.value = src.value.substr(0, limit);
            // chars = limit;
            $('.length_notice').hide();
        } else {
          $('.length_notice').show();
        }
        elem.html( limit - chars );
      }
      setCount($(this)[0], elem);
    }
  })

// (function($){
//   $.fn.extend({
//     limiter: function(limit, elem) {
//       $(this).on("keyup focus", function() {
//         setCount(this, elem);
//       });
//       function setCount(src, elem) {
//         var chars = src.value.length;
//         if (chars > limit) {
//             src.value = src.value.substr(0, limit);
//             chars = limit;
//         }
//         elem.html( limit - chars );
//       }
//       setCount($(this)[0], elem);
//     }
//   });
// });

  var elem = $("#chars");
  // var desc = "Your description is too short. Please give us more details of your issue. Help us, help you!";

  $("#issue_content").limiter(80, elem);
  // $("#issue_content").on("keyup focus", function(){
  //   $("#issue_content").append('<p>' + desc + '</p>');
  // })
});