#!/usr/bin/env bash
# Fail if any outbound http(s) link in the site or the profile README is dead.
# Usage: scripts/check-links.sh [file ...]   (defaults to both published sources)
set -euo pipefail
cd "$(dirname "$0")/.."
files=("$@"); [ ${#files[@]} -eq 0 ] && files=(public/index.html profile/README.md)

links=$(grep -ohE 'https?://[^"'"'"' )<>]+' "${files[@]}" | sed 's/[.,;]$//' | grep -v 'www.w3.org/' | sort -u)
fail=0
while IFS= read -r url; do
  [ -z "$url" ] && continue
  code=$(curl -s -o /dev/null -w '%{http_code}' -L --max-time 20 -A 'Mozilla/5.0 (link-check)' "$url" || echo 000)
  case "$code" in
    2*|3*) printf '  ok   %s  %s\n' "$code" "$url" ;;
    403)   printf '  warn %s  %s (bot-blocked, verify by hand)\n' "$code" "$url" ;;
    *)     printf '  DEAD %s  %s\n' "$code" "$url"; fail=1 ;;
  esac
done <<< "$links"
if [ "$fail" -eq 0 ]; then echo "All links OK."; else echo "Dead links found."; exit 1; fi
