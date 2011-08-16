#!/bin/bash
DEV="localhost:5984"
PRO="todoist.iriscouch.com"
USER="admin"

if [ "$3" != "nopass" ]; then
    echo "Password:"
    read -s PASS
fi

[[ "$PASS" == "" ]] && echo "No Auth" || AUTH="${USER}:${PASS}@"

DEV="http://${AUTH}${DEV}/$2"
PRO="http://${AUTH}${PRO}/$2"

[[ "$1" == "pro" ]] && URL=$PRO || URL=$DEV

echo "Using $URL"

iterAtt() {
    for file in $(ls $1/_attachments)
    do
        FILEPATH="$1/_attachments/$file"

        REV=$(curl -s "$URL/_design/$dir" | egrep -o -e '"_rev":"[^"]+"')
        REV=${REV/'"_rev":'/}
        REV=${REV//\"/}

        TYPE=$(file -ib $1/_attachments/$file)

        if [ "${file:(-3)}" == ".js" ]; then
            TYPE="text/javascript"
        elif [ "${file:(-4)}" == ".css" ]; then
            TYPE="text/css"
        fi

        DOCURL="$URL/_design/$1/$file?rev=$REV"
        curl -X PUT -d @${FILEPATH} -H "Content-Type: ${TYPE}" ${DOCURL}
    done
}

iter() {
    echo -n "{"
    for file in $(ls $1)
    do
        if [ "$file" == "_attachments" ]; then
            echo -n
        else
            echo -n \"${file/.js/}\":
            if [ -d $1/$file ]; then
                echo -n $(iter $1/$file)
            else
                CONTENT=$(cat $1/$file)
                echo -n \"${CONTENT//\"/\\\"}\"
            fi
            echo -n ","
        fi
    done
    echo -n "}"
}

for dir in $(ls) 
do
    if [ -d $dir ]; then
        REV=$(curl -s "$URL/_design/$dir" | egrep -o -e '"_rev":"[^"]+"')
        REV=${REV/'"_rev":'/}
        REV=${REV//\"/}
        [[ "$REV" != "" ]] && echo $REV > $dir/_rev

        JSON=$(iter $dir)
        JSON=${JSON//,\}/\}}
        echo $JSON > $dir.json

        curl -X POST -d @${dir}.json -H "Content-Type: application/json" $URL 

        rm $dir.json
        [[ -e $dir/_rev ]] && rm $dir/_rev

        if [ -d $dir/_attachments ]; then
            iterAtt $dir
        fi
    elif [ "${dir:(-5)}" == ".json" ]; then
        NAME=${dir/.json/}
        REV=$(curl -s "$URL/$NAME" | egrep -o -e '"_rev":"[^"]+"')
        CONTENT=$(cat $dir)
        if [ "$REV" != "" ]; then
            JSON="${CONTENT:0:-1},$REV,\"_id\":\"$NAME\"}"
        else
            JSON="${CONTENT:0:-1},\"_id\":\"$NAME\"}"
        fi
        curl -X POST -d "${JSON}" -H "Content-Type: application/json" "$URL"
    fi
done

echo "Done"
