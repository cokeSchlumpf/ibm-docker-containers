#!/bin/bash

/sbin/service sshd start
su -c "/opt/wlp/bin/server run" wlp
