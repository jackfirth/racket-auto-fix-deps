#!/bin/bash

set -e

(raco pkg show $1 | grep clone) || (raco pkg remove $1 && raco pkg install --no-setup --clone $1)
cd $1
hub fork || echo "fork already exists"
hub checkout -b auto-fix-deps || hub checkout auto-fix-deps
hub reset --hard origin/master
raco setup --fix-pkg-deps || echo "fixed"
hub add info.rkt
hub commit -m "Fix dependencies."
hub push -f $GITHUB_USER auto-fix-deps
hub pull-request -m "Fix dependencies."
raco pkg remove $1
