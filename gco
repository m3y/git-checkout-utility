#!/bin/bash

function checkout() {
    branch=`echo $1 | sed -e 's/remotes\/origin\///g'`
    git branch | grep ${branch} > /dev/null 2>&1 \
        && ARG="${branch}" \
        || ARG="-b ${branch} origin/${branch}"
    git checkout ${ARG}
}

BUFFER=$(git branch -a | grep -v '*' | peco)
checkout ${BUFFER}
