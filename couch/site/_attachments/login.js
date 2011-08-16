$(function(){
        var user = null;
        $("form").submit(function(){
                return false;
            });
        $("#login").click(function(){
                var user = $("#username").val();
                var pass = $("#password").val();
                $.post(couch_host+"/_session?callback=?","name="+user+"&password="+pass,function(r){
                });
            });
        $("#register").click(function(){
            });
});
