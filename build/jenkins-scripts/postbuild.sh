#!/bin/bash

jq -n "{ project: \"${PWD##*/}\", buildDate: \"`date`\", buildOn: \"`whoami`@`hostname`\", version: \"`git rev-parse --verify HEAD`\" }" > version.json
ssh -i ~/.ssh/id_rsa -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no wlp@wlp
