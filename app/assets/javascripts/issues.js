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
})