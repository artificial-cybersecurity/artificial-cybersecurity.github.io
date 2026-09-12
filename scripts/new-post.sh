#!/usr/bin/env bash
# Create a new post skeleton in _posts/ and print its path.
#
#   ./scripts/new-post.sh "Attacking a RAG pipeline" ai security
#
set -euo pipefail

if [ $# -lt 1 ]; then
  echo "usage: $0 \"Post title\" [tag ...]" >&2
  exit 1
fi

title="$1"; shift
slug=$(printf '%s' "$title" \
  | tr '[:upper:]' '[:lower:]' \
  | sed -E 's/[^a-z0-9]+/-/g; s/^-+|-+$//g')
date_stamp=$(date +%Y-%m-%d)
file="_posts/${date_stamp}-${slug}.md"

if [ -e "$file" ]; then
  echo "refusing to overwrite existing $file" >&2
  exit 1
fi

tags="[$(printf '%s, ' "$@" | sed 's/, $//')]"
[ "$#" -eq 0 ] && tags="[]"

cat > "$file" <<POST
---
title: "${title}"
description: ""
date: $(date '+%Y-%m-%d %H:%M:%S %z')
tags: ${tags}
---

Opening paragraph — this becomes the excerpt on the home page.

<!--more-->

## Section
POST

echo "$file"
