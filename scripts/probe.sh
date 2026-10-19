#!/usr/bin/env bash
# Read-only local probe. It intentionally does not call sudo, contact a
# network service, read enrolled templates, or inspect biometric data.
set -u

mode="${1:-text}"
if [[ "$mode" != "text" && "$mode" != "--json" ]]; then
  printf 'Usage: %s [--json]\n' "${0##*/}" >&2
  exit 64
fi

usb="$(lsusb 2>/dev/null || true)"
reader=""
if grep -qi '06cb:00b7' <<<"$usb"; then
  reader="06cb:00b7"
elif grep -qi '138a:00ab' <<<"$usb"; then
  reader="138a:00ab"
fi

validity="$(systemctl is-active python3-validity.service 2>/dev/null || true)"
fprintd="$(systemctl is-active open-fprintd.service 2>/dev/null || true)"

if [[ -z "$reader" ]]; then
  status="unsupported"
elif [[ "$validity" == "active" && "$fprintd" == "active" ]]; then
  status="ready"
else
  status="attention"
fi

if [[ "$mode" == "--json" ]]; then
  printf '{"schema_version":1,"reader":"%s","python3_validity":"%s","open_fprintd":"%s","status":"%s"}\n' \
    "$reader" "$validity" "$fprintd" "$status"
  exit 0
fi

printf '%s\n' "$usb"
printf '%s\n' '--SERVICE--'
printf 'PYTHON3_VALIDITY=%s\n' "$validity"
printf 'OPEN_FPRINTD=%s\n' "$fprintd"
