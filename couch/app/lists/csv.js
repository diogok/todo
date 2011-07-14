function(head,req) {
    var row;
    while(row = getRow()) {
        var item = row.value;
        send(item._id+';'+item.timestamp+';'+item.content+';'+item.status+"\\n");
    }
}

