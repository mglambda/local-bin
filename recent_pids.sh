#!/bin/bash
# lists the last couple programs invoked sorted with most recent first
ps -eo pid,ppid,comm,cmd,etimes --sort=etimes | head -n 15
