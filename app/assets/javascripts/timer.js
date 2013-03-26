// set minutes --> needs to be updated based on waiting room timing threshold
var mins = 2;
 
// calculate the seconds (don't change this! unless time progresses at a different speed for you...)
var secs = mins * 60;
function countdown() {
setTimeout('Decrement()',1000);
}
function Decrement() {
if (document.getElementById) {
minutes = document.getElementById("minutes");
seconds = document.getElementById("seconds");
// if less than a minute remaining
if (seconds < 59) {
seconds.value = secs;
} else {
minutes.value = getminutes();
seconds.value = getseconds();
}
secs--;
setTimeout('Decrement()',1000);
}
}
function getminutes() {
// minutes is seconds divided by 60, rounded down
mins = Math.floor(secs / 60);
return mins;
}
function getseconds() {
// take mins remaining (as seconds) away from total seconds remaining
return secs-Math.round(mins *60);
}

countdown();