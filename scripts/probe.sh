#!/usr/bin/env bash
# Read-only local probe. It intentionally does not call sudo, contact a
# network service, read enrolled templates, or inspect biometric data.
set -u

lsusb 2>/dev/null || true
printf '%s\n' '--SERVICE--'
printf 'PYTHON3_VALIDITY=%s\n' "$(systemctl is-active python3-validity.service 2>/dev/null || true)"
printf 'OPEN_FPRINTD=%s\n' "$(systemctl is-active open-fprintd.service 2>/dev/null || true)"
