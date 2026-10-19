# Fingerprint Studio

Fingerprint Studio is a calm, privacy-respecting control surface for supported Synaptics and Validity readers on Omarchy.

It is deliberately **not** a driver installer or repair tool. The plugin only reads local USB and service state; it never invokes `sudo`, restarts a service, uploads firmware, or accesses enrolled biometric templates.

## Current capabilities

- Detects `06cb:00b7` and `138a:00ab` readers locally.
- Shows a compact bar status and a focused, keyboard-dismissible health panel.
- Checks that both `python3-validity` and `open-fprintd` are active every 30 seconds.
- Links to the upstream investigation and diagnostics; it does not upload hardware data.

## Agent troubleshooting

The plugin ships a portable agent skill and a versioned JSON probe. Install the skill once after adding the plugin, then any Omarchy-compatible agent can start from a safe diagnosis rather than guessing:

```bash
mkdir -p ~/.agents/skills
ln -s ~/.config/omarchy/plugins/io.github.simplex-t.fingerprint-studio/skills/fingerprint-studio \
  ~/.agents/skills/fingerprint-studio
```

See [agent integration](docs/agent-integration.md) for its safety boundaries and supported agent-harness locations.

## Install

```bash
omarchy plugin add https://github.com/SimpleX-T/fingerprint-studio.git --enable
```

The plugin is installed disabled by default unless `--enable` is supplied, so its source can be reviewed first. Remove it with:

```bash
omarchy plugin remove io.github.simplex-t.fingerprint-studio
```

## Develop locally

```bash
omarchy plugin validate .
omarchy plugin add "$PWD" --enable
```

## Verify before installing

```bash
./tests/plugin-contract.sh
omarchy plugin validate .
```

## Dependencies

- Omarchy Quattro / Quickshell
- `lsusb` and `systemctl`
- `python3-validity` and `open-fprintd` for the ready state

## Safety and privacy

All state is read locally. No biometric data is read, stored, transmitted, or logged by this plugin. The underlying fingerprint driver owns its encrypted sensor templates.

## Hardware scope

The first release recognizes `06cb:00b7` and `138a:00ab` for health reporting only. It does not provision unsupported or zero-partition hardware. The separate [`00bb / 0x969` validation protocol](docs/00bb-validation.md) explains the evidence required before any destructive path can be considered.

## License

MIT. See [LICENSE](LICENSE).
