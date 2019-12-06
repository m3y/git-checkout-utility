#!/bin/bash

function cln() {
    git branch | grep -v master | while read B; do
        branch=remotes/origin/`echo ${B} | sed -e 's/remotes\/origin\///g'`
        if [ `git branch -a | grep ${branch}` ]; then
            git branch -D ${B}
        else
            echo "[Notice] It is a local branch only [${B}]"
        fi
    done
}

function checkout() {
    branch=`echo $1 | sed -e 's/remotes\/origin\///g'`
    [ "${branch}" = "" ] \
        && echo "Target branch should not be empty." && exit 1

    [ "`git symbolic-ref --short HEAD`" = "${branch}" ] \
        && echo "Already on target branch." && exit 0

    git branch | grep ${branch} > /dev/null 2>&1 \
        && ARG="${branch}" \
        || ARG="-b ${branch} origin/${branch}"
    git checkout ${ARG}
}

function create() {
    branch=remotes/origin/`echo ${1} | sed -e 's/remotes\/origin\///g'`
    if [ "`git branch -a | grep ${branch}`" ]; then
        checkout $1
    else
        git checkout -b $1
    fi
}

if [ "$1" = "clean" ]; then
    cln
    exit 0
elif [ "$1" = "pull" ]; then
    git pull --prune
elif [ "$1" = "-b" ]; then
    if [ "x$2" = "x" ]; then
        exit 1
    fi
    create $2
elif [ "$1" != "" ]; then
    checkout $1
else
    BUFFER=$(git branch -a | grep -v '*' | peco)
    checkout ${BUFFER}
    exit 0
fi
