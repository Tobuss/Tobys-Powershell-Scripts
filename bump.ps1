# Takes you to a runescape post and straight to the comment section for easy bumping.

$username = "Username"
$Password = "Password"


$ie = New-Object -com InternetExplorer.Application
$ie.visible=$true
$ie.navigate("Link obtained by going to forum post and clicking login. This link is for the login page") 
while($ie.ReadyState -ne 4) {start-sleep -m 100}
$ie.document.getElementById('login-username').value= "$username" 
$ie.document.getElementById("login-password").value = "$Password" 
$ie.document.getElementById("rs-login-submit").Click(2)
Sleep 5
#$ie.document.getElementById("reply-box__area").Value = "Bump"
Sleep 5
$ie.document.getElementsByClassName("btn").Click(2);
