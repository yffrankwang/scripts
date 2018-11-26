#!/bin/bash

BRANCH=$(git rev-parse --abbrev-ref HEAD)
REMOTE=$(git config --get branch.${BRANCH}.remote)
if [ -z ${REMOTE} ]; then
    echo "no remote"
    exit -1
fi
git fetch
if [ $? != 0 ]; then
    echo "fetch failed"
    exit -1
fi
git reset --hard ${REMOTE}/${BRANCH}
if [ $? != 0 ]; then
    echo "reset failed"
    exit -1
fi
