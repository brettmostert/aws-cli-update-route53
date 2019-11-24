#!/bin/bash
cd /d/workspaces/local-infrastructure/
# GET IP
if IP=$(dig +short myip.opendns.com @resolver1.opendns.com); then
    echo "Success: IP retrieved :" $IP
    IP_RETRIEVED=1
else
    echo "Failure: Unable to retrieve IP."
    exit
fi

# Update template with IP
sed 's/${IP}/'$IP'/g' ./local-aws-dns-template.json > ./local-aws-dns.json

# Update AWS Route53
~/.local/bin/aws route53 change-resource-record-sets --profile brettmostert-route53 --cli-connect-timeout 5 --cli-read-timeout 5 --hosted-zone-id Z22HKC0WYLGLW2 --change-batch file://local-aws-dns.json