$(function(){

    $("form").submit(function(){ return false; });

    function ins(item) {
        $("#todo").append("<li>"+item.content+"</li>");
    }

    $("#add").click(function(){
        var content = $("#input").val();
        var item = {content: content, timestamp: new Date().getTime(), status: "todo" };
        $.ajax({
            url: "../../",
            data: JSON.stringify(item),
            type:"POST",
            contentType: "application/json",
            success: function(r) {
                item._rev = r.rev;
                item._id  = r.id;
                ins(item);
            }
        });
    });

    $.get("_view/ordered",function(resp) {
        var data = JSON.parse(resp);
        for(var i =0;i<data.rows.length;i++) {
           ins(data.rows[i].value);
        }
    });
});
