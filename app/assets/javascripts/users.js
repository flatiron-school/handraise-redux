$(document).ready(function(){

  // DOM selector
  var pw = $('#user_password'),
    pwc = $('#user_password_confirmation'),
    pwInputs = $('#user_password, #user_password_confirmation'),
    pwMatchError = $('#password_match_error'),
    name = $('#user_name'),
    nameReq = $('#name_required'),
    email = $('#user_email'),
    emailReq = $('#email_required'),
    pwReq = $('#password_required'),
    pwcReq = $('#password_conf_required');
  
  $(pwMatchError).hide(); // Initially hide error message spans

  // Remove *required spans as fields are filled in
  name.keyup(function(){
    nameVal = name.val();
    nameReq.show();
    if(nameVal.length > 2) {
      nameReq.hide();
    }
    else {
      nameReq.show();
    }
  });  

  email.keyup(function(){
    emailVal = email.val();
    emailReq.show();
    if(emailVal.length > 2) {
      emailReq.hide();
    }
    else {
      emailReq.show();
    }
  });  

  pw.keyup(function(){
    pwVal = pw.val();
    pwReq.show();
    if(pwVal.length > 2) {
      pwReq.hide();
    }
    else {
      pwReq.show();
    }
  });  

  pwc.keyup(function(){
    pwcVal = pwc.val();
    pwcReq.show();
    if(pwcVal.length > 2) {
      pwcReq.hide();
    }
    else {
      pwcReq.show();
    }
  });

  

  // Password confirmation validation on Keyup
  pwInputs.keyup(function(){
    pwcVal = pwc.val();
    pwVal = pw.val();
    pwMatchError.show();
    if(pwVal===''||pwcVal==='') {
      pwMatchError.hide();
    }
    else if(pwVal === pwcVal){
      pwMatchError.show();
      pwMatchError.text("Password entries match").removeClass('red').addClass('green');
    }       
    else {
      pwMatchError.show();
      pwMatchError.text("Confirmation password does not match password").addClass('red');
      pwMatchError.show();
    }
  }); 

}); // end document ready
