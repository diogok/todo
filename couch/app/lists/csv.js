function(head,req) {
    var row;
    while(row = getRow()) {
        var item = row.value;
        send(item._id+';'+item.timestamp+';'+item.content+';'+item.status+';'+item.done_timestamp+';'+ item._rev +"\\n");
    }
}

