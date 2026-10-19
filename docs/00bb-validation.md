# `06cb:00bb / 0x969` claim: validation protocol

## Decision

The reported `06cb:00bb / 0x969 / 57K0 FM-3439-004` provisioning path is **not supported** and must remain fail-closed. Its report describes erase, reset, repartition, pairing, and firmware-upload operations. A successful outcome narrative, especially one produced with an AI-generated wrapper, is not enough evidence to authorize those writes on another device.

## Phase 1 — evidence intake (safe; no device writes)

The reporter supplies all of the following before anyone reviews a change:

1. The wrapper source and the smallest proposed source diff in a public, versioned repository.
2. `clean-slate-probe.py` JSON from before reset, after the reporter's zero-partition reboot, and after their final successful boot.
3. SHA-256 and public provenance for the firmware extension. Proprietary firmware itself must not be committed or attached.
4. Sanitized USB command/response evidence showing the claimed post-reboot gate and TLS-session reset. Remove pairing keys, private keys, certificates, usernames, and templates.
5. A description of the flash backup layout and how recovery was verified on the same reporter-owned device.

At this stage, reviewers only inspect artifacts, write an offline parser/test fixture, and compare the identity to existing evidence. Nobody runs the wrapper or a reset command.

## Phase 2 — narrow implementation review

If Phase 1 evidence is coherent, split the work into independently reviewable patches:

1. Read-only identity recognition for exactly `06cb:00bb / 0x969 / FM-3439-004`.
2. The `Cancel()` / next-operation regression, with a minimal reproducer unrelated to provisioning.
3. Any reset/partition code, identity-gated at ROM, real sensor type, and model name—not VID:PID alone.

The implementation must reject every identity not observed in the evidence bundle. It must not add a generic `0x969` path or change current safe behavior for `00ab`, `00b7`, or `00cb`.

## Phase 3 — hardware validation

Only the original reporter uses a reviewed, pinned commit. They must capture fresh read-only probes before and after, preserve a recovery plan, and report the complete result. A second physical `00bb / 0x969` device must independently reproduce the path before it can be advertised or placed in a normal package flow.

## Merge bar

Merge requires reproducible artifacts, passing regression tests, two-device confirmation, a non-destructive install path, and maintainer review. Until then the user-facing guidance is simple: **do not force payloads or run third-party reset wrappers on `0x969` hardware.**
