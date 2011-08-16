$(function(){
        var user = null;
        var register_url = "http://diogok.net/todo/register/register.php";
        var couch_host   = "http://todoist.iriscouch.com";

        function login(user,pass) {
            $.ajax({
                    url: couch_host+"/_session",
                    data: "name="+user+"&password="+pass,
                    type: "POST",
                    success: function(r) {
                        location.href=couch_host+"/"+user+"_todo/_design/app/index.html";
                    },
                    error: function(xhr,r) {
                        alert("Invalid login, please try again.");
                    }
                });
        }

        $("form").submit(function(){
                return false;
            });

        $("#login").click(function(){
                var user = $("#username").val();
                var pass = $("#password").val();
                login(user,pass);
            });
        $("#register").click(function(){
                var user = $("#username").val();
                var pass = $("#password").val();
                $.get(register_url+"?callback=?&username="+user+"&password="+pass, function(r) {
                        if(r.ok) {
                            login(user,pass);
                        } else {
                            alert("Unable to register "+ user +", please try another name");
                        }
                    },"text/plain");
            });
});
