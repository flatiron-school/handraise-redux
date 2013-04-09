$(document).ready(function(){
  // define value variables
  var emailInput = $('#login_email');
  var passwordInput = $('#login_password');
  var emailDefault = "type email";
  var passwordDefault = "type password";


  // clear field & remove class "example_text" when in focus
  emailInput.focus(function(){
    emailInput.addClass('black_font');
    if (emailInput.val() == emailDefault) {
      emailInput.val('');
    } else {
      emailInput.select();
    }
  }); // end .focus

  emailInput.blur(function(){
    if (emailInput.val() == '') {
      emailInput.val(emailDefault);
      emailInput.removeClass('black_font');
    }
  }); // end .blur


  passwordInput.focus(function(){
    passwordInput.addClass('black_font');
    if (passwordInput.val() == passwordDefault) {
      passwordInput.val('');
    } else {
      passwordInput.select();
    }
  }); // end .focus

  passwordInput.blur(function(){
    if (passwordInput.val() == '') {
      passwordInput.val(passwordDefault);
      passwordInput.removeClass('black_font');
    } 
  }); // end .blur

  // add default txt & add class "example_text" when nil values on blur
}); // end document ready
