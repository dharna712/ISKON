# ISKON App — Running Context

Living context file, updated as decisions get made. See
[OLD_APP_ANALYSIS.md](OLD_APP_ANALYSIS.md) for the deep-dive on the
reference app, and [NEW_APP_REQUIREMENTS.md](NEW_APP_REQUIREMENTS.md) for
the brief as given.

## Status: decisions locked, starting Flutter scaffold

- **2026-09-22** — Reverse-engineered the reference APK
  (`shloka-saathi.apk`). Extracted its full content model to
  `reference-data/old-app-shlokas.json` (37 verses, EN + IAST only, no
  Hindi). Wrote up findings in `OLD_APP_ANALYSIS.md`.
- **2026-09-22** — Tech stack: **Flutter**, prioritizing a lightweight
  build, matching the old app's UX flow (listen → understand → quiz →
  recite).
- **2026-09-22** — Content scope for v1: **Bhagavad Gītā + Īśopaniṣad
  only**. No other Upanishads, no Bhakti-rasāmṛta-sindhu / Nectar of
  Instruction, even though the reference app had a few of those verses.
  Rationale: Īśopaniṣad is short (18 verses), pure verse form (fits the
  recite/quiz mechanic), and is the one Śrīla Prabhupāda personally
  translated in full — natural fit for this app's tradition.
- **2026-09-22** — Audio stays **Sanskrit recitation only** (matches old
  app exactly — verse audio, not translated audio). Translation/word-
  meaning section becomes language-switchable: English + Hindi for now,
  extensible later. Hindi content will be translated as part of this
  build, not sourced externally.
- **2026-09-22** — Repo history reset: the first commit on
  `dharna712/ISKON` had an AI co-author line and was authored under the
  wrong GitHub identity. Repo was deleted and recreated (same name/URL),
  and this file's history restarts clean from here — author identity is
  `dharna712` / `dharna628@gmail.com` only, no AI mentions anywhere in
  commits, code, or docs (same policy as the ChainBreach project).

## People

- Sole contributor: Dharna (`dharna712` on GitHub).

## Open questions / still to decide

1. Data model finalization: `translation: {en, hi}` per verse, each word
   `{sa, en, hi}` instead of the old app's flat `en`-only strings.
2. New audio needed: Gītā has 27/700 verses recorded in the reference app,
   Īśopaniṣad 2/18 — need to confirm how much of the remaining verse
   coverage is in scope for v1 vs. later.
3. Flutter project scaffolding pending — SDK install in progress on this
   machine.
