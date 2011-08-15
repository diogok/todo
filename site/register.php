<?php
include 'RestClient.class.php';
include 'config.php';

$user = $_POST["username"];
$pass = $_POST["password"];
$salt = "todoist";

if(strlen($user) < 1 or strlen($pass) < 1 or !preg_match("/^[a-zA-Z0-9_]+$/",$user)) {
    header("location: index.html#invalid");
} else {
    $u = new StdClass;
    $u->name = $user;
    $u->type = "user";
    $u->roles = array("todoist");
    $u->salt = $salt ;
    $u->password_sha = sha1($pass.$salt);
    $u->_id = "org.couchdb.user:".$user;
    $c = RestClient::post($couch_host."/_users",json_encode($u),$couch_user,$couch_pass,"application/json");
    if($c->getResponseCode() == '201') {
        header("location: index.html#login");
    } else {
        header("location: index.html#invalid");
    }
}



?>
