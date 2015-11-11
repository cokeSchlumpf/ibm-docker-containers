#!/bin/bash

jq -n "{ project: \"${PWD##*/}\", buildDate: \"`date`\", buildOn: \"`whoami`@`hostname`\", version: \"`git rev-parse --verify HEAD`\" }" > version.json
scp 
