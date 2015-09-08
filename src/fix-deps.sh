#!/bin/bash

set -e

git config --global user.email "$GITHUB_USER_EMAIL"
git config --global user.name "$GITHUB_USER_NAME"

raco pkg install --deps search-auto --no-setup --clone $1
cd $1
/src/hub fork || echo "fork already exists"
/src/hub checkout -b auto-fix-deps || /src/hub checkout auto-fix-deps
/src/hub reset --hard origin/master
raco setup --fix-pkg-deps || echo "fixed"
/src/hub add info.rkt
/src/hub commit -m "Fix dependencies."
/src/hub push -f $GITHUB_USER auto-fix-deps
/src/hub pull-request -m "Fix dependencies."
raco pkg remove $1
