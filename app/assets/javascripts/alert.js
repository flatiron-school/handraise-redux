$(document).ready(function(){
  $('#modalToggle').click(function(){
    console.log("Hello from assigned Modal");
    $('#alert').html('<audio src="assets/Air_Horn_SoundBible.ogg" type="audio/ogg" autoplay="autoplay" />');
  }); // close .click
}); // close document.ready