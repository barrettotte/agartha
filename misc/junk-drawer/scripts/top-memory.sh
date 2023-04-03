#!/bin/bash

ps --no-headers -eo pid,comm,pmem,rss --sort=-rss | head -n 10 | awk '{print $1,$2,$3,$4/1024/1024 "GB"}'
