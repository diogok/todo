$(function(){

    $("form").submit(function(){ return false; });

    var items = [];

    function ins(item) {
        items[item._id] = item;
        var date = new Date(item.timestamp * 1000);
        var dateStr = date.getMonth()+"/"+date.getDay()+" "+date.getHours()+":"+date.getMinutes();
        var html = "<li rel='"+item._id+"'>";
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
        var item = {content: content, timestamp: new Date().getTime()/1000, status: "todo" };
        post(item, function(r) {
            var data = JSON.parse(r);
            item._rev = data.rev;
            item._id  = data.id;
            ins(item);
        });
    });

    $("#todo button.done").live("click",function(bt){
        var line = $( $(bt.currentTarget).parent()[0] );
        var id = line.attr("rel");
        var item = items[id];
        item.status = "done";
        item.done_timestamp = new Date().getTime()/1000;
        post(item,function(){
            delete items[id];
            $(line).remove();
        });
    });

    function changes(since,process) {
        $.ajax({
            url: "../../_changes?feed=longpoll&since="+ since,
            success: function(r) {
                var data = JSON.parse(r);
                if(process) {
                    $.get("../../"+ data.results[0].id,function(r) {
                            var data = JSON.parse(r);
                            if(data.status == "done") {
                                if(typeof items[data._id] != "undefined" && items[data._id] != null) {
                                    $("li[rel='"+ data._id +"']").remove();
                                    delete items[data._id];
                                }
                            } else {
                                if(typeof items[data._id] == "undefined" || items[data._id] == null) {
                                    ins(data);
                                }
                            }
                        });
                }
                changes(data.last_seq,true);
            }
        });
    }

    $.get("_view/ordered",function(resp) {
        var data = JSON.parse(resp);
        for(var i =0;i<data.rows.length;i++) {
           if(data.rows[i].value.status == "todo") {
               ins(data.rows[i].value);
           }
        }
        changes(0,false);
    });
});
