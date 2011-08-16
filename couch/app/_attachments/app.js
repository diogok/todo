$(function(){

    $("form").submit(function(){ return false; });

    function ins(item) {
        var date = new Date(item.timestamp);
        var dateStr = date.getMonth()+"/"+date.getDay()+" "+date.getHours()+":"+date.getMinutes();
        var html = "<li>";
        html += "<span class='date'>"+dateStr+"</span> ";
        html += "<span class='content'>"+item.content+"</span> ";
        html += "<button class='done'>Done</button> ";
        html += "</li>";
        $("#todo").append(html);
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
