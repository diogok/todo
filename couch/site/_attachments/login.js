$(function(){
        var user = null;
        $("form").submit(function(){
                return false;
            });
        $("#login").click(function(){
                var user = $("#username").val();
                var pass = $("#password").val();
                $.ajax({
                        url: couch_host+"/_session",
                        data: "name="+user+"&password="+pass,
                        type:"POST",
                        success: function(r) {
                        },
                        error: function(xhr,r) {
                            alert("Invalid login, please try again.");
                        }
                    });
            });
        $("#register").click(function(){
            });
});
