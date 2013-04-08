$(document).ready(function(){

  // DOM selector
  var password = $('#user_password'),
    passwordConf = $('#user_password_confirmation'),
    passwordInputs = $('#user_password, #user_password_confirmation'),
    passwordMatchError = $('#password_match_error');
  
  $('span').hide(); // Initially hide error message spans


  // Password confirmation validation on Keyup and Blur
  passwordInputs.keyup(function(){
    passwordConfVal = passwordConf.val();
    passwordVal = password.val();
    passwordMatchError.show(); 
    if(passwordVal===''||passwordConfVal==='') {
      passwordMatchError.hide();
    }
    else if(passwordVal === passwordConfVal){
      passwordMatchError.show();
      passwordMatchError.text("Password entries match").removeClass('red').addClass('green');
    }       
    else {
      passwordMatchError.show();
      passwordMatchError.text("Confirmation password does not match password").addClass('red');
      passwordMatchError.show();
    }
  }); 

}); // end document ready
