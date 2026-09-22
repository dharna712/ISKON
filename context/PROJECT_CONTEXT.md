# ISKON App — Running Context

Living context file, updated as decisions get made. See
[OLD_APP_ANALYSIS.md](OLD_APP_ANALYSIS.md) for the deep-dive on the
reference app, and [NEW_APP_REQUIREMENTS.md](NEW_APP_REQUIREMENTS.md) for
the brief as given.

## Status: v1 core loop built and verified working

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
  meaning section is language-switchable: English + Hindi. All 29 verses
  in scope (27 BG + 2 Īśopaniṣad) were translated to Hindi as part of this
  build — see `app/assets/data/verses.json`.
- **2026-09-22** — Repo history reset: the first commit on
  `dharna712/ISKON` had an AI co-author line and was authored under the
  wrong GitHub identity. Repo was deleted and recreated (same name/URL),
  and this file's history restarts clean from here — author identity is
  `dharna712` / `dharna628@gmail.com` only, no AI mentions anywhere in
  commits, code, or docs (same policy as the ChainBreach project).
- **2026-09-22** — Flutter app scaffolded at `app/` and the full core loop
  built: Home (verse list grouped by book, starred/mastered state) →
  Listen (audio player, loop counter) → Understand (word-by-word glossary
  + full translation, EN/हिं toggle) → Quiz (meaning-match + fill-blank,
  auto-generated from the word list, same mechanic as the old app) →
  Recite (whole-verse repeat ×3 with tanpura drone toggle) → Done (score,
  session time, marks verse mastered). Verified end-to-end in a browser
  build (Flutter web) — full flow, language toggle, and progress
  persistence all confirmed working.

## Known simplifications vs. the reference app (follow-ups, not blockers)

1. **Recite screen** repeats the *whole verse* 3 times rather than the old
   app's per-line segmented call-and-response — the reference app's
   line-by-line timing data isn't available outside its bundled JS, so
   this was simplified. Revisit if finer-grained recitation guidance is
   wanted later.
2. **Fonts**: uses `google_fonts` (Noto Sans + Noto Sans Devanagari) for
   correct Sanskrit diacritic (ṁ, ṭ, ś…) and Hindi Devanagari rendering.
   This fetches fonts at runtime by default, same online-dependency the
   old app had (`@import` from Google Fonts). Worth bundling the font
   files as static assets later for full offline support on first launch.
3. **Android SDK**: licenses accepted and toolchain verified on this
   machine. Windows Developer Mode (needed only for Windows desktop
   builds, not Android/web) was *not* enabled — that's a system-level
   toggle, left for whoever owns this machine to turn on if a Windows
   desktop build is ever wanted.
4. Verse audio for verses beyond the 27 BG / 2 Īśopaniṣad already
   recorded in the reference app is still needed for fuller coverage —
   same gap noted in `OLD_APP_ANALYSIS.md`.

## People

- Sole contributor: Dharna (`dharna712` on GitHub).

## Running the app

```
cd app
flutter pub get
flutter run              # pick a connected device/emulator
```

Flutter SDK lives at `C:\src\flutter` on this machine (added to user
PATH). Android SDK licenses are accepted. For a quick browser check
without a device: `flutter build web` then serve `app/build/web/`.
