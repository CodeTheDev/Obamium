#!/usr/bin/env bash

# scripts/upstreamCommit.sh <oldPaperRef> <oldPufferfishRef>

# param: oldPaperRef - the previous paperRef commit used in gradle.properties
# param: oldPufferfishRef - the previous Pufferfish commit.

(

set -e
PS1="$"

paper=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/PaperMC/Paper/compare/$1...HEAD | jq -r '.commits[] | "PaperMC/Paper@\(.sha[:7]) \(.commit.message | split("\r\n")[0] | split("\n")[0])"')
pufferfish=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/pufferfish-gg/Pufferfish/compare/$2...HEAD | jq -r '.commits[] | "pufferfish-gg/Pufferfish@\(.sha[:7]) \(.commit.message | split("\r\n")[0] | split("\n")[0])"')

updated=""
logsuffix=""

if [ -n "$paper" ]; then
    logsuffix="$logsuffix\n\nPaper Changes:\n$paper"
    updated="Paper"
fi
if [ -n "$pufferfish" ]; then
    logsuffix="$logsuffix\n\nPufferfish Changes:\n$pufferfish"
    if [ -z "$updated" ]; then updated="Pufferfish"; else updated="$updated/Pufferfish"; fi
fi

disclaimer="Upstream has released updates that appear to apply and compile correctly."
log="${UP_LOG_PREFIX}Updated Upstream ($updated)\n\n${disclaimer}${logsuffix}"

echo -e "$log" | git commit -F -

) || exit 1
