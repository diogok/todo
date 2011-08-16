$(function(){

    $("form").submit(function(){ return false; });

    var items = [];

    function ins(item) {
        items[item._id] = item;
        var date = new Date(item.timestamp);
        var dateStr = date.getMonth()+"/"+date.getDay()+" "+date.getHours()+":"+date.getMinutes();
        var html = "<li id='"+item._id+"'>";
        html += "<span class='date'>"+dateStr+"</span> ";
        html += "<span class='content'>"+item.content+"</span> ";
        html += "<button class='done'>Done</button> ";
        html += "</li>";
        $("#todo").append(html);
    }

    function post(item,s) {
        $.ajax({
            url: "../../",
            data: JSON.stringify(item),
            type:"POST",
            contentType: "application/json",
            success: s
        });
    }

    $("#add").click(function(){
        var content = $("#input").val();
        if(content.length < 1) return;
        var item = {content: content, timestamp: new Date().getTime(), status: "todo" };
        post(item, function(r) {
            item._rev = r.rev;
            item._id  = r.id;
            ins(item);
        });
    });

    $("#todo button.done").live("click",function(bt){
        var line = $(bt.currentTarget).parent()[0];
        var id = line.id;
        var item = items[id];
        item.status = "done";
        item.done_timestamp = new Date().getTime();
        post(item,function(){
            delete items[id];
            $(line).remove();
        });
    });

    $.get("_view/ordered",function(resp) {
        var data = JSON.parse(resp);
        for(var i =0;i<data.rows.length;i++) {
           if(data.rows[i].value.status == "todo") {
               ins(data.rows[i].value);
           }
        }
    });
});
