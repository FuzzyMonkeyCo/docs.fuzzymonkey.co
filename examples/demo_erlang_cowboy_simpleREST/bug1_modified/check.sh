#!/bin/bash -eu

set -o errtrace
set -o pipefail

MONKEY=${MONKEY:-monkey}
VVV=${VVV:-}
STAR=${STAR:-}
TIMEOUT=${TIMEOUT:-30s}
SEED=${SEED:-}
branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

# Test like CI but sequentially

declare -a STARs Vs Ts
declare -i i=0

STARs[$i]=fuzzymonkey.star
Vs[$i]=0
Ts[$i]=6
((i+=1)) # Funny Bash thing: ((i++)) returns 1 only when i=0

STARs[$i]=fuzzymonkey__start_reset_stop_docker.star
Vs[$i]=0
Ts[$i]=6
((i+=1))

STARs[$i]=fuzzymonkey__start_reset_stop.star
Vs[$i]=0
Ts[$i]=6
((i+=1))

STARs[$i]=fuzzymonkey__start_reset_stop_json.star
Vs[$i]=0
Ts[$i]=6
((i+=1))

STARs[$i]=fuzzymonkey__start_reset_stop_failing_script.star
Vs[$i]=0
Ts[$i]=7
((i+=1))

STARs[$i]=fuzzymonkey__env.star
Vs[$i]=0
Ts[$i]=6
((i+=1))

STARs[$i]=fuzzymonkey__doc_typo.star
Vs[$i]=2
Ts[$i]=2
((i+=1))

STARs[$i]=fuzzymonkey__doc_typo_json.star
Vs[$i]=2
Ts[$i]=2
((i+=1))


info() {
    printf '\e[1;3m%s\e[0m\n\n\n' "$*"
}
error() {
    echo "( SEED=$($MONKEY -f "$STAR" pastseed) )"
    printf '\e[1;3m%s ...failed\e[0m\n' "$*"
}

info "$MONKEY" --version
$MONKEY --version
rebar3 clean --all
rebar3 as prod release

check() {
    info "$MONKEY" "$VVV" -f "$STAR" fmt
    set +e
    # shellcheck disable=SC2086  # for $VVV
    $MONKEY $VVV -f "$STAR" fmt; code=$?
    set -e
    if  [[ $code -ne 0 ]]; then
        error "$branch" "$STAR" "F=0 (got $code)"
        return 1
    fi

    info "$MONKEY" "$VVV" -f "$STAR" lint
    set +e
    # shellcheck disable=SC2086  # for $VVV
    $MONKEY $VVV -f "$STAR" lint; code=$?
    set -e
    if  [[ $code -ne $V ]]; then
        error "$branch" "$STAR" "V=$V (got $code)" T="$T"
        return 1
    fi

    timeout=$TIMEOUT
    if [[ $T -ne 0 ]]; then
        timeout=30m
    fi
    intensity=999 # TODO: drop --intensity

    if [[ -z "$SEED" ]]; then
        info "$MONKEY" "$VVV" -f "$STAR" fuzz --intensity=$intensity --time-budget-overall=$timeout --no-shrinking
        set +e
        # shellcheck disable=SC2086  # for $VVV
        $MONKEY $VVV -f "$STAR" fuzz --intensity=$intensity --time-budget-overall=$timeout --no-shrinking; code=$?
        set -e
        if  [[ $code -ne $T ]]; then
            error "$branch" "$STAR" V="$V" "T=$T (got $code)"
            return 1
        fi

        if [[ $V -eq 0 ]]; then
            info "$MONKEY" -f "$STAR" pastseed
            seedfile=$(mktemp)
            set +e
            $MONKEY -f "$STAR" pastseed >"$seedfile" 2>&1; code=$?
            set -e
            SEED=$(cat "$seedfile")
            rm "$seedfile"
            if [[ $code -ne 0 ]] || [[ -z "$SEED" ]]; then
                error "$branch" "$STAR" V="$V" "S=0 (got $code)"
                echo "$seedfile"
                echo "$SEED"
                return 1
            fi
        fi
    else
        info "Given SEED=$SEED"
    fi

    info "$MONKEY" "$VVV" -f "$STAR" fuzz --intensity=$intensity --time-budget-overall=$timeout --seed="$SEED"
    set +e
    # shellcheck disable=SC2086  # for $VVV
    $MONKEY $VVV -f "$STAR" fuzz --intensity=$intensity --time-budget-overall=$timeout --seed="$SEED"; code=$?
    set -e
    if  [[ $code -ne $T ]]; then
        error "$branch" "$STAR" V="$V" "T=$T (got $code)"
        return 1
    fi

    info "$branch" "$STAR" V="$V" T="$T" ...passed
    return 0
}

cleanup() {
    if [[ -n "$failed" ]]; then
        if [[ -n "${CI:-}" ]]; then
            $MONKEY -f "$STAR" logs | tail -n999
            echo '---'
            $MONKEY -f "$STAR" logs | head
        fi
    fi

    if curl --output /dev/null --silent --fail --head http://localhost:6773/api/1/items; then
        info Some instance is still running on localhost!
        return 1
    fi
    if curl --output /dev/null --silent --fail --head http://my_image:6773/api/1/items; then
        info Container my_image is still running!
        return 1
    fi
}

errors=0
for i in "${!STARs[@]}"; do
    V=${Vs[$i]}
    T=${Ts[$i]}

    [[ -n "$STAR" ]] && [[ $STAR != "${STARs[$i]}" ]] && continue

    info "$branch" "$STAR" V="$V" T="$T"
    STAR=${STARs[$i]} V=$V T=$T check || { ((errors+=1)); failed=t; }
    STAR=${STARs[$i]} V=$V T=$T failed=${failed:-} cleanup

    [[ -n "$STAR" ]] && [[ $STAR = "${STARs[$i]}" ]] && break
done
exit "$errors"
