# What the first Omarchy plugin competition rewarded

**Decision:** Fingerprint Studio should make fingerprint authentication feel *native and quietly reassuring*, not like a driver-management screen. The winning pattern is a delightful, immediately understandable bar capability with a serious implementation behind it.

## Results

Omarchy Core named four projects in its [official results](https://omarchy.org/news/2026/08/the-first-plugin-competition-winners/):

| Place | Project | What it does | Why it landed |
| --- | --- | --- | --- |
| 1st — $2,500 | [Radio Atlas](https://github.com/AksharP5/omarchy-radio-atlas) by Akshar Patel | Turns the bar into a rotatable world radio browser; users choose a country or station and play it through Omarchy media controls. | A memorable visual interaction serves a familiar task. It remains fast with session caches, progressive loading, history, keyboard controls, and graceful stream failure recovery. |
| 2nd — $1,000 | [Omagotchi](https://github.com/SLcode777/omagotchi) by SLcode777 | A theme-tinted 1-bit pet hatches in the bar, grows with active shell time, and later roams and climbs windows. | It gives the desktop personality without becoming a toy UI: clear needs, meaningful progression, direct manipulation, sound only at significant moments, and a proper state model. |
| 3rd — $500 | [AirPods](https://github.com/thisisgm/omarchy-pods) by GM | Shows per-part battery and model-appropriate controls for AirPods from the bar. | It restores a concrete, beloved hardware experience Linux users miss. The panel exposes only controls the connected hardware actually supports. |
| Honorable mention | [GitHub](https://github.com/robzolkos/omarchy-github) by Rob Zolkos | A keyboard-first inbox for notifications, reviews, pull requests, issues, repositories, and Actions. | It brings work requiring attention to an ambient surface, ranks it by urgency, and makes bounded, reversible actions safe. |

## Lessons to adopt

### 1. The bar state is the whole pitch

Each winner answers a one-second question at a glance: *what is playing?*, *how is my pet?*, *are my AirPods ready?*, *does GitHub need me?* Fingerprint Studio should therefore use a small, calm state language:

- **Ready** — fingerprint reader available; no persistent attention demand.
- **Needs setup** — a supported reader is found but no enrollment is usable.
- **Needs attention** — service unavailable, hardware disconnected, or a recoverable post-resume issue.
- **Working** — a short-lived enrollment, verification, or repair state.

Do not show an always-visible green “security” badge, raw USB IDs, or a permanent “healthy” count. Details belong in the panel.

### 2. Design from real capability, never an assumed device

AirPods publishes state from a daemon and builds its panel from capability keys; unavailable features disappear rather than becoming broken controls. Its README explicitly excludes controls owned by Omarchy's Audio and Bluetooth panels. [Source](https://github.com/thisisgm/omarchy-pods)

Fingerprint Studio should do the same:

- detect reader identity, driver availability, service state, enrolled-print availability, and wake/resume health independently;
- render only safe actions for the detected state;
- link to the native Omarchy/system flow where it already owns a task;
- say *why* an action is unavailable and what changes after it succeeds.

### 3. Interaction has to work with both mouse and keyboard

Radio Atlas, AirPods, and GitHub all document complete keyboard operation; GitHub makes `j`/`k`, arrows, `Enter`, `/`, `r`, and `Escape` first-class. [GitHub controls](https://github.com/robzolkos/omarchy-github#controls)  Fingerprint Studio needs predictable focus order, arrow navigation, Enter/Space activation, `r` refresh, and Escape close. The one urgent action should be preselected, not hidden behind menus.

### 4. Trust is part of the product, especially for hardware

The strongest entries make boundaries concrete:

- Radio Atlas documents its data source, persistent data, bounded proxy, logs, and tests. [Source](https://github.com/AksharP5/omarchy-radio-atlas)
- Omagotchi documents every command, fixed argument lists, no elevation, capped state reads, and no credentials. [Source](https://github.com/SLcode777/omagotchi#what-it-executes-exactly)
- GitHub delegates tokens to `gh`, confirms destructive bulk changes, bounds concurrency, and declares rate-limit/error states. [Source](https://github.com/robzolkos/omarchy-github)

Fingerprint Studio must likewise show the exact privileged command before it runs, explain its effect, require a deliberate confirmation, write diagnostic logs to a documented path, and never collect fingerprints or send hardware data off-device. "Repair" must be a reversible service action where possible—not an opaque firmware write.

### 5. Separate the live system from the UI

AirPods is the best architectural precedent: its daemon owns Bluetooth and writes a status file only when state changes; the panel watches that file and does not poll or touch Bluetooth directly. [Architecture](https://github.com/thisisgm/omarchy-pods#how-it-works)

Fingerprint Studio should have the same split:

```text
system services / fingerprint driver
        │  read-only health probe + explicit action helper
        ▼
user service publishes a versioned, bounded status file
        ▼
Quickshell bar widget renders state and requests named actions
```

The widget should not parse journal logs, access USB directly, or own long-running recovery logic. A separate user service can react to resume and publish a concise health result; system-level remediation still needs the user's explicit privilege grant.

## Marketplace and engineering bar

Adopt these concrete standards before submission:

1. A root `manifest.json`, polished `preview.png`, SPDX-compatible license, concise README, install/remove instructions, and an honest supported-hardware matrix. The winners all carry the core plugin artifacts; the marketplace itself indexes repositories with a manifest. [Registry description](https://omahub.dev/)
2. A tiny, testable model layer outside QML. AirPods tests parser/formatting behavior without QML; Radio Atlas runs its test suite plus `qmllint`; GitHub validates the plugin and exercises its helpers. [AirPods tests](https://github.com/thisisgm/omarchy-pods#tests) · [Radio Atlas development](https://github.com/AksharP5/omarchy-radio-atlas#development) · [GitHub local development](https://github.com/robzolkos/omarchy-github#local-development)
3. Versioned, size-capped local state; corrupted or unknown state must fail safely into an explainable status, never an optimistic "ready" state.
4. No root installer hook. Omarchy plugins are third-party code; privileged work belongs behind an explicit terminal/Polkit prompt and documented fixed commands.
5. Hardware-safe uninstall: disable the Fingerprint Studio user service and remove only its own state. Never remove `fprintd`, driver packages, enrolled templates, or firmware as an uninstall side effect.

## The competition-ready product statement

> **Fingerprint Studio brings a calm, Mac-like fingerprint experience to Omarchy:** a bar indicator that knows whether your reader is ready, a focused panel to enroll or repair it, and a post-resume health guard that surfaces trouble before your next unlock.

The creative hook is **Touch ID-level confidence on Linux**. The proof is not a feature list; it is a single beautiful bar state, a frictionless first enrollment, and a clear recovery path when the system wakes up.
