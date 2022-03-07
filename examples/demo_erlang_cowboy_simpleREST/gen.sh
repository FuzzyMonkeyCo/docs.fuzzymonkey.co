#!/bin/bash -eu

set -o pipefail

for bug in bugfree bug1_modified bug2_invalid bug3_crashes; do
    if [[ "$bug" != bugfree ]]; then
        shopt -s dotglob
        rm -rf "$bug"/*
        shopt -u dotglob

        cp -prT bugfree "$bug"

        git apply "$bug".patch
    fi

    sed s/responses:/response:/ <bugfree/priv/openapi3v1.yml >"$bug"/priv/openapi3v1_typo.yml
    sed 's/"responses":/"response":/' <bugfree/priv/openapi3v1.json >"$bug"/priv/openapi3v1_typo.json
done
