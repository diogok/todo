<?php

include 'RestClient.class.php';
include 'config.php';

if(strlen($user) < 1 or strlen($pass) < 1 or !preg_match("/^[a-zA-Z0-9_]+$/",$user)) {
    echo 'nok';
} else if($_POST["action"] == "Register") {
    $u = new StdClass;
    $u->name = $user;
    $u->type = "user";
    $u->roles = array("todoist");
    $u->salt = $salt ;
    $u->password_sha = sha1($pass.$salt);
    $u->_id = "org.couchdb.user:".$user;
    $c = RestClient::post($couch_host."/_users",json_encode($u),$couch_user,$couch_pass,"application/json");
    if($c->getResponseCode() == '201') {
        $rep = '{"source":"todo_master","target":"'.$user.'_todo","create_target":true,"continuous": true}';
        RestClient::post($couch_host."/_replicate",$rep,$couch_user,$couch_pass,"application/json");
        $sec = '{"admins":{"names":["admin","'.$user.'"],"roles":[]},"readers":{"names":["admin","'.$user.'"],"roles":[]}}';
        RestClient::put($couch_host."/".$user."_todo/_security",$sec,$couch_user,$couch_pass,"application/json");
        echo 'ok';
    } else {
        echo 'nok';
    }
}

echo 'nok';

?>
