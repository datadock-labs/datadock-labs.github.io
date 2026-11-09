#!/usr/bin/env bash
# Adds the Firefox store link to index.html once the add-on is public on AMO.
# Prints "changed" when it edited the file. Usage: scripts/firefox-link.sh [amo-slug]
set -euo pipefail
slug="${1:-tidy-screenshot}"
file="index.html"
grep -q '<!--FF-->' "$file" || { echo "already linked"; exit 0; }
code=$(curl -s -o /dev/null -w '%{http_code}' "https://addons.mozilla.org/api/v5/addons/addon/${slug}/")
echo "AMO status for ${slug}: ${code}"
[ "$code" = "200" ] || exit 0
sed -i \
  -e 's#Free for Chrome and Microsoft Edge\. Firefox version coming soon\.#Free for Chrome, Microsoft Edge and Firefox.#' \
  -e 's#<!--FF-->#<a href="https://addons.mozilla.org/firefox/addon/tidy-screenshot/">Add to Firefox</a>#' \
  "$file"
echo "changed"
