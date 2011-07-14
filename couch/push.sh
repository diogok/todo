#!/bin/bash
DEV="localhost:5984"
PRO="manifesto.couchone.com"
USER="admin"

if [ $3 != "nopass"]; then
    echo "Password:"
    read -s PASS
fi

[[ "$PASS" == "" ]] && echo "No Auth" || AUTH="${USER}:${PASS}@"

DEV="http://${AUTH}${DEV}/$2"
PRO="http://${AUTH}${PRO}/$2"

[[ "$1" == "pro" ]] && URL=$PRO || URL=$DEV

echo "Using $URL"

iter() {
    echo -n "{"
    for file in $(ls $1)
    do
        echo -n \"${file/.js/}\":
        if [ -d $1/$file ]; then
            echo -n $(iter $1/$file)
        else
            CONTENT=$(cat $1/$file)
            echo -n \"${CONTENT//\"/\\\"}\"
        fi
        echo -n ","
    done
    echo -n "}"
}

for dir in $(ls) 
do
    if [ -d $dir ]; then
        REV=$(curl "$URL/_design/$dir" | egrep -o -e '"_rev":"[^"]+"')
        REV=${REV/'"_rev":'/}
        REV=${REV//\"/}
        [[ "$REV" != "" ]] && echo $REV > $dir/_rev

        JSON=$(iter $dir)
        JSON=${JSON//,\}/\}}
        echo $JSON > $dir.json

        curl -X POST -d @${dir}.json -H "Content-Type: application/json" $URL

        rm $dir.json
        [[ -e $dir/_rev ]] && rm $dir/_rev
    fi
done

echo "Done"
