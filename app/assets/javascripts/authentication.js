$('#auth').click(function(){
  $.get('/sessions/new_github', function(data, status){
    $('body').append(data);
    $('#my_modal').modal('toggle');
  });
  return false;
});