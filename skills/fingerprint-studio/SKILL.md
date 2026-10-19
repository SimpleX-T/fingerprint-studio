---
name: fingerprint-studio
description: Safely diagnose Fingerprint Studio and supported Synaptics/Validity fingerprint hardware on Omarchy. Use when the bar widget reports attention, a reader disappears, enrollment or verification stops, or a user asks for fingerprint troubleshooting.
---

# Fingerprint Studio troubleshooting

Start with the plugin's read-only report:

```bash
bash ~/.config/omarchy/plugins/io.github.simplex-t.fingerprint-studio/scripts/probe.sh --json
```

Interpret it before suggesting any repair:

- `ready`: both services are active and a supported reader is present. Ask whether the failure is enrollment, verification, PAM, lock screen, or post-resume; do not restart services pre-emptively.
- `attention`: a supported reader is present but one or both services are inactive. Show the user the exact non-destructive evidence first (`systemctl status python3-validity.service open-fprintd.service --no-pager`). Explain any next action and obtain explicit permission before a privileged command.
- `unsupported`: do not try payloads, resets, firmware upload, or generic USB fixes. Capture only the user-approved `lsusb` identity and point them to the support matrix.

## Hard safety boundaries

Never, without a separate explicit user request and a reviewed recovery plan:

- run `factory-reset.py`, a reset wrapper, or any flash erase/partition command;
- run `validity-sensors-firmware`, upload a firmware extension, or force a blob;
- remove `fprintd`, alter PAM, or change authentication policy;
- upload full logs, USB captures, certificates, pairing material, templates, or biometric data.

For `06cb:00bb / 0x969`, stop after the read-only probe. That identity is intentionally unsupported while its destructive provisioning claim is being validated. Follow the repository's `docs/00bb-validation.md`; never ask a user to test the claimed wrapper.

## Safe evidence collection

With the user's consent, collect the smallest relevant output:

```bash
systemctl status python3-validity.service open-fprintd.service --no-pager
```

For a post-resume failure, record whether a reboot restores behavior. Separate “reader absent”, “service inactive”, and “service active but no match”; they have different owners and should not receive the same fix.

## Escalation

Make no external report automatically. If the user wants to report upstream, first redact names, enrolled-template material, certificates, pairing keys, and full USB traces. Then draft the report and wait for their approval before posting.
