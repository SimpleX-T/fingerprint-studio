# Agent integration

Fingerprint Studio includes an agent skill so Omarchy's selected agent can diagnose a reported state before proposing a repair. The skill starts with a versioned, read-only JSON probe and has explicit boundaries against firmware, reset, PAM, and telemetry actions.

After installing the plugin, expose the skill to Omarchy-compatible agent harnesses:

```bash
mkdir -p ~/.agents/skills
ln -s ~/.config/omarchy/plugins/io.github.simplex-t.fingerprint-studio/skills/fingerprint-studio \
  ~/.agents/skills/fingerprint-studio
```

Most Omarchy-supported agent harnesses discover `~/.agents/skills`; users with a harness-specific skill directory can symlink the same directory there. The link means plugin updates also update the troubleshooting instructions.

To diagnose, the user can ask their agent: **“Diagnose Fingerprint Studio.”** The expected first command is:

```bash
bash ~/.config/omarchy/plugins/io.github.simplex-t.fingerprint-studio/scripts/probe.sh --json
```

The probe never uses elevated privileges, reads biometric templates, or contacts the network.
