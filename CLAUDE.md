# FutureLab — Project Guide

## What is this?

FutureLab is a gamified, single-page English learning platform for 8th-grade students at Boston Flex. Students learn future tenses and conditionals through animated lessons, adaptive practice, flashcards, writing exercises, and a final exam — all synced to Supabase.

## Repository Structure

```
index.html                          ← Canonical student app (all-in-one HTML)
teacher.html                        ← Teacher dashboard (real-time analytics)
Future_and_conditionals/
  index.html                        ← Synced copy of root index.html
  teacher.html                      ← Synced copy of root teacher.html
archive/
  futurelab.html                    ← Legacy v1 (no XP/badges/Supabase — DO NOT USE)
  template2.html                    ← Legacy v1.5 (basic XP, no Supabase — DO NOT USE)
CHANGELOG.md                        ← Version history
```

**Important**: `index.html` and `Future_and_conditionals/index.html` must always be kept in sync. Same for `teacher.html`. After editing the root file, copy it to `Future_and_conditionals/`.

## Architecture

Everything lives in single HTML files (no build step, no bundler). Each file contains inline CSS + JS + base64-embedded images.

### Student App (`index.html`)

- **9 views**: Home, Learn, Practice, Flashcards, Conditionals, Reinforce, Write, Exam, Leaderboard
- **12 skills**: present-simple, present-continuous, will, going-to, future-perfect, fpc, zero, first, second, third, mixed, inversion
- **4 tiers**: Tier 1 (A2/B1), Tier 2 (B1+), Tier 3 (B2), Tier 4 (B2+)
- **State**: All state in `localStorage` key `flstate`, synced to Supabase on every `persist()` call

### Teacher Dashboard (`teacher.html`)

- Real-time student tracking via Supabase realtime subscriptions + polling fallback
- Skill mastery heatmap, weakness analysis, section comparison
- Read receipts for teacher notices
- CSV export

## Supabase

- **URL**: `https://gfjiicfnwpkbkptwgnte.supabase.co`
- **Tables**: `futurelab_scores` (student state), `futurelab_interventions` (AI help logs), `futurelab_notices` (teacher messages), `futurelab_notice_reads` (read receipts)
- **Edge Functions**: `futurelab-explain-topic` (AI intervention), `futurelab-generate-exercises` (AI practice)
- **Computed column**: `accuracy` is generated in Supabase from `correct`/`answered` — never include it in sync payload

## XP System

XP is awarded **only by the module that calls the action**, not by `recordAnswer()`.

| Source | Correct | Wrong |
|--------|---------|-------|
| Practice Tier 1 | 10 XP | 2 XP |
| Practice Tier 2 | 15 XP | 2 XP |
| Practice Tier 3 | 20 XP | 2 XP |
| Practice Tier 4 | 30 XP | 2 XP |
| Learn miniCheck | 5 XP | 0 XP |
| Reinforce | 8 XP | 2 XP |
| Flashcards | 8 XP | — |
| Writing | 10 XP | — |
| Exam (score >= 50%) | 50 XP | — |
| Sentence Builder | 15 XP | — |

`recordAnswer()` handles: mastery tracking, skill XP (`addSkillXP`), badge checks. It does **NOT** call `addXP()`.

## Badges

- **13 global badges**: first, streak3, practice50, practice100, accuracy80, tense, cond, tierB1, tierB2, tierB2plus, exam, perfect, explorer
- **9 per-skill badges**: sk_lv2, sk_lv5, sk_lv10, sk_lv16, sk_lv31, sk_lv51, sk_lv66, sk_lv81, sk_acc80

## Key Conventions

- Inversion exercises must be **tier 3 or 4** (B2+), never tier 1
- All 12 skills must have entries in: `SKILLS`, `TENSES` (Learn lessons), practice `ITEMS`, `CARDS` (flashcards), `checkBadges()`
- SVG timelines: canvas is 640x200, axis at y=128. Keep 15px+ vertical gap between text layers to avoid overlap
- `syncNow()` for critical events (exam, badges). `syncToSupabase()` (debounced) for routine saves
- Teacher heatmap skill list must match student `SKILLS` object
