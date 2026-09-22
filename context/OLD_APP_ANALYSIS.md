# Old App Analysis — "Shloka Saathi"

Source: `shloka-saathi.apk` (provided by Harsh, not in this repo's git history — the
GitHub repo was empty when cloned). Reverse-engineered by unzipping the APK
(it is a thin native wrapper: two near-empty `classes.dex` files, ~1KB each,
just spin up a WebView). All real logic lives in a single bundled file:
`assets/index.html` (~105KB, one HTML file with inline `<style>` and
`<script>` — no Cordova/Capacitor JS bridge, no external network calls,
100% client-side, state kept in `localStorage`).

## Tech shape

- **Wrapper**: native Android shell, WebView pointed at
  `file:///android_asset/index.html`. No plugin bridge detected.
- **Frontend**: vanilla HTML/CSS/JS, single file, single-page app with
  `.screen` divs toggled via `showScreen(id)`. No framework, no build step.
- **Fonts**: Google Fonts (`Baloo 2` for headings, `Noto Sans` for body).
- **Audio**: local `<audio>` elements pointing at bundled `.m4a`/`.mp3`
  files in `assets/audio/` (~12MB total, per-verse narration files named
  like `2.7_final.m4a`, plus a `Tanpura.mp3` drone loop and an
  `APP INTRO.mp3` walkthrough).
- **Images**: just one — `assets/images/prabhupada.jpg` (hero avatar).
- **Persistence**: `localStorage` only — starred verses (`starred_<id>`),
  section open/closed state, presumably progress/mastery (`card.mastered`
  class referenced in CSS). No backend, no accounts, no sync.

## Content model

Single flat array `SHLOKAS` (see `reference-data/old-app-shlokas.json` for
the full extracted content — 37 entries, English-only). Each entry:

```json
{
  "id": "bg-2-7",
  "name": "BG 2.7",
  "sub": "kārpaṇya-doṣopahata-svabhāvaḥ",
  "badge": "गी",
  "lines": ["kārpaṇya-doṣopahata-svabhāvaḥ", "..."],
  "words": [{"sa": "kārpaṇya-doṣa", "en": "the fault/weakness of miserliness"}, "..."],
  "translation": "My very nature is overcome by the weakness of pity...",
  "audioUrl": "audio/2.7_final.m4a"
}
```

Content is grouped into 4 categories by `id`/`name` prefix (see `renderHome()`):

| Prefix | Book | Count in old app |
|---|---|---|
| `bg-` | Bhagavad-gītā | 27 |
| `brs-` | Bhakti-rasāmṛta-sindhu | 4 |
| `noi-` | Nectar of Instruction (Upadeśāmṛta) | 4 |
| `iso-` | Īśopaniṣad | 2 |

**Everything is IAST-transliterated Sanskrit + English only — no Hindi
anywhere.** That's the headline gap vs. what Harsh wants for the new app.

## User flow (per shloka, "Step X of 4")

1. **Listen** (`s-listen`) — plays the verse audio over a looping tanpura
   drone, seek bar, loop counter (`LISTEN_TARGET = 5` loops encouraged)
   before unlocking "Next".
2. **Understand / Read** (`s-read`) — full verse text, word-by-word
   Sanskrit→English glossary cards, then the full translation in a
   highlighted box. Verse can be starred here.
3. **Quiz** (`s-quiz`) — auto-generated from the word list:
   - `N_MEANING = 5` "what does X mean" multiple-choice questions (3
     options: correct + 2 random distractors from other words in the verse)
   - `N_BLANK = 3` fill-in-the-blank questions (tap the missing word in the
     verse)
   - Progress dots, can be skipped via "Skip Quiz".
4. **Recite** (`s-recite`) — guided call-and-response: app plays a line,
   segments the verse into steps (`RECITE_STEPS`), user repeats each
   segment 3 rounds ("I Chanted This Round ✓"), tanpura toggle available.
5. **Done** (`s-done`) — score (`X / 8 correct`), session time
   (`SESSION_SECONDS = 600` i.e. a 10-minute budget, shown as a countdown
   timer in the topbar throughout), congratulatory message.

Home screen (`s-home`) lists all verses grouped by book (collapsible
sections), an intro audio-guide card, and a "Pick a shloka" list where
starred/mastered verses sort to the top and get a green "mastered" style.

## What's reusable for the new app

- The **pedagogical flow** (listen → understand → quiz → recite) is solid
  and worth keeping as the core loop.
- The **word-by-word breakdown + full translation** content structure
  extends naturally to add a Hindi field per word/translation.
- The **quiz generation logic** (meaning-match + fill-blank, auto-derived
  from the word list) can be reused almost as-is once Hindi strings exist.
- Audio narration files for **BG verses already recorded** — 27 of them.
  Īśopaniṣad has only 2 of its 18 verses recorded in the old app, so new
  Upanishad audio will be needed for full coverage.

## What's missing for the new app (per Harsh's brief)

- **Hindi translations** — verse meaning, word meanings, and UI copy all
  need a Hindi counterpart (data model needs a `hi` field alongside `en`
  everywhere, not a UI-only translation layer).
- **Upaniṣads beyond Īśopaniṣad** — brief says "Upanishads" generally;
  needs scoping (which Upanishads, starting with Īśa is a reasonable seed
  since it's already partially there).
- **Bhakti-rasāmṛta-sindhu / Nectar of Instruction content is out of
  scope** for the new app per Harsh's brief (only Gītā + Upaniṣads) — the
  old app's BRS/NOI verses are kept in the reference JSON for completeness
  but won't carry over.
- No accounts/backend in the old app — fine to keep local-only again unless
  new app wants cross-device sync.
