#!/bin/bash

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

BUFFER=$(git branch -a | grep -v '*' | peco)
checkout ${BUFFER}
