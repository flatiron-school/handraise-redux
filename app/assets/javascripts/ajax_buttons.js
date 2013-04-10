function recount() {
  var i = [0,0,0,0];
  $(".issues_assigned div.issue .queue_position").each(function()
  {
    $(this).html(i[0]+1)
    i[0]++;
  });

  $(".issues_instructor_urgent div.issue .queue_position").each(function()
  {
    $(this).html(i[1]+1)
    i[1]++;
  })

  $(".issues_instructor_normal div.issue .queue_position").each(function()
  {
    $(this).html(i[2]+1)
    i[2]++;
  });

  $(".issues_fellow_student div.issue .queue_position").each(function()
  {
    $(this).html(i[3]+1)
    i[3]++;
  });
}

$(function() {
  recount();
})