#!/bin/bash

#put nsname here


for i in $(kubectl get pods --all-namespaces | awk 'NR>1 {print $2}'); do echo "----------------Checking $i---------------"; kubectl logs $i | grep $nsname | grep err; done >> hb1.log

#can grep timestamp
cat hb1.log |grep -i priority | jq '. |select(.PRIORITY=="err")' >> hb2.log







#get uniq error
cat hb2.log |jq -s '. |group_by(.PRIORITY) | map({MESSAGE: map(.MESSAGE) | unique})' | jq '.[] |.MESSAGE' | jq .[]  >> hb3.log

cut -d '"' -f2 hb3.log >> hb4.log

#get the whole uniqu logs
while read line; do grep -A 10 "$line" hb2.log |  head -10; done < hb4.log
