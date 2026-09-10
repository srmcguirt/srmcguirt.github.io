#!/usr/bin/env bash
# Publish both surfaces from this repo:
#   1. srmcguirt.dev   -> Cloudflare Worker `wireforge` (npx wrangler deploy)
#   2. GitHub profile  -> srmcguirt/srmcguirt README.md (gh api, same content as profile/README.md)
# Requires: `npx wrangler login` and `gh auth login` done once on this machine.
# Usage: scripts/publish.sh [site|profile|all]   (default: all)
set -euo pipefail
cd "$(dirname "$0")/.."
target="${1:-all}"
PROFILE_REPO="srmcguirt/srmcguirt"

if [ "$target" = "site" ] || [ "$target" = "all" ]; then
  scripts/check-links.sh public/index.html
  npx --yes wrangler deploy
  echo "Site deployed -> https://srmcguirt.dev"
fi

if [ "$target" = "profile" ] || [ "$target" = "all" ]; then
  scripts/check-links.sh profile/README.md
  sha=$(gh api "repos/$PROFILE_REPO/contents/README.md" --jq .sha 2>/dev/null || true)
  remote=$(gh api "repos/$PROFILE_REPO/contents/README.md" -H 'Accept: application/vnd.github.raw' 2>/dev/null || true)
  if [ "$remote" = "$(cat profile/README.md)" ]; then
    echo "Profile README already up to date."
  else
    gh api -X PUT "repos/$PROFILE_REPO/contents/README.md" \
      -f message="Sync profile README from srmcguirt.github.io" \
      -f content="$(base64 < profile/README.md | tr -d '\n')" \
      ${sha:+-f sha="$sha"} --silent
    echo "Profile README pushed -> https://github.com/$PROFILE_REPO"
  fi
fi
