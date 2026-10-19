#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

jq -e '
  .schemaVersion == 1
  and (.id | test("^io\\.github\\.[a-z0-9-]+\\.[a-z0-9-]+$"))
  and (.kinds | index("bar-widget"))
  and ((.kinds | index("service")) | not)
  and (.entryPoints.barWidget | type == "string")
' "$root/manifest.json" >/dev/null

while IFS= read -r entry; do
  test -f "$root/$entry"
done < <(jq -r '.entryPoints[]' "$root/manifest.json")

if find "$root" -type l -print -quit | grep -q .; then
  echo "Plugin packages must not contain symlinks." >&2
  exit 1
fi

if rg -n '(^|[^[:alnum:]_])sudo[[:space:]]|curl[[:space:]].*\|[[:space:]]*(ba)?sh|wget[[:space:]].*\|[[:space:]]*(ba)?sh|systemctl[[:space:]]+(restart|start|stop|enable|disable)' "$root" --glob '!docs/**'; then
  echo "Fingerprint Studio must not contain hidden privileged or download-to-shell actions." >&2
  exit 1
fi

echo "Plugin contract passed."
