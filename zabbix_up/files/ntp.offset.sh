#!/bin/bash

#/usr/sbin/ntpq -pn | /usr/bin/awk 'BEGIN { offset=1000 } $1 ~ /\*/ { offset=$9 } END { print offset }'
ntpdate -q 10.116.12.10 | grep sec | sed 's/.*offset //' | sed 's/ sec//g'
