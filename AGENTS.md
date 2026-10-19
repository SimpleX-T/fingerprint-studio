# Fingerprint Studio contributor guide

Treat the plugin as a read-only trust surface. UI changes must preserve the no-`sudo`, no-driver-write, no-template-access, no-network boundary. Troubleshooting behavior belongs in `skills/fingerprint-studio/SKILL.md`; keep the JSON schema from `scripts/probe.sh --json` backward-compatible.

Run before committing:

```bash
bash tests/plugin-contract.sh
```
