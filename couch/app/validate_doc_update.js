function (newDoc,oldDoc,userCtx) {
    var fields= ["status","_rev","_id","content","timestamp","_revisions","done_timestamp"];
    for(var i  in newDoc) {
        var ok = false;
        for(var f in fields) {
            if(i == fields[f]) {
                ok = true;
            }
        }
        if(!ok) {
            throw({forbidden: "Invalid fields."});
        }
    }
    if(!newDoc["status"] || !newDoc["content"] || !newDoc["timestamp"]) {
        throw({forbidden: "Invalid fields."});
    }
    if(oldDoc) {
        if(newDoc.content != oldDoc.content || newDoc.timestamp != oldDoc.timestamp) {
            throw({forbidden: "Invalid update."});
        }
    }
}
