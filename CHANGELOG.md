# FutureLab - Changelog

## v2.1.0 — Bug Fixes, Inversion Lesson & Cleanup (2026-06-02)

### Bug Fixes

#### XP Double-Counting (Critical)
- **Fixed**: `recordAnswer()` was calling `addXP(15)` for correct and `addXP(3)` for wrong answers, ON TOP of the XP each module already awarded. Students received 25-45 XP per correct practice answer while the UI showed 10-30.
- **Fix**: Removed `addXP()` calls from `recordAnswer()`. Each module now controls its own XP independently. `recordAnswer()` only handles mastery tracking and skill XP via `addSkillXP()`.
- **Added**: `addXP(2)` for wrong answers in Practice and Reinforce to reward participation without inflating scores.

#### SVG Timeline Overlaps
- **Third Conditional**: Title text "imaginary past → imaginary past result" overlapped with formula labels "If + had + PP" and "would have + PP". Fixed by separating vertical positions (title at y=60, formulas at y=78) and shortening title text.
- **Mixed Conditional**: Long title "past condition → present/future result (or vice versa)" touched the lateral formula labels on both sides. Fixed by raising title to y=60, reducing formula font-size to 10px, and shortening title.
- **Inversion (new)**: Strikethrough "✗ if" annotation collided with formula text "If I had known…". Fixed by repositioning strikethrough to the left (x=95-125) and below the formula (y=88 vs y=76).

#### Leaderboard Filter Button
- **Fixed**: `filterSection('all')` did not properly highlight the "All" button — it reapplied `btn-ghost` class and only used inline styles inconsistently. Now all buttons are fully reset (class + inline styles) before applying the active state.

---

### New Content

#### Conditional Inversion (Learn Module)
- **Learn Module**: Full lesson card with concept explanation (3 patterns: Had, Were, Should), animated timeline SVG showing "If I had known → Had I known" transformation, 2 example sentences with TTS, signal words, worked example with step-by-step reasoning, and mini-check quiz.
- Previously, students had practice exercises and exam questions for Inversion but no lesson to learn the concept. Now integrated into the Learn tab alongside all other tenses/conditionals.

#### Inversion Exercise Tier Correction
- **Fixed**: 17 AI-generated Conditional Inversion exercises were incorrectly marked as `tier:1` (A2/B1). Changed to `tier:3` (B2) since Conditional Inversion is an advanced topic. Beginner students will no longer receive these questions.

---

### Sync & Cleanup

#### Teacher Dashboard
- Added `third` (Third Conditional) to the skill mastery heatmap — was missing from the skills array while present in student data.
- Synced `teacher.html` between root and `Future_and_conditionals/` directory, preserving Read Receipts feature from root.

#### Third Conditional Restoration
- Upstream commit `6ed4c0b` had removed Third Conditional content from root `index.html`. Restored from `Future_and_conditionals/index.html` which retained the complete content (SKILLS entry, TENSES lesson, 6 practice items, flashcards c13/c14, conditionals block, sentence machine slot, badge check).

#### Legacy File Archival
- Moved `futurelab.html` (v1, no XP/badges/Supabase) and `template2.html` (v1.5, basic XP only) to `archive/` directory. These are obsolete predecessors of `index.html` and should not be used or maintained.

---

### Technical Details

#### Modified Functions
| Function | Change |
|----------|--------|
| `recordAnswer()` | Removed `addXP(15)` and `addXP(3)` calls — now only tracks mastery + skill XP |
| `submitAnswer()` | Now sole source of practice XP; added `addXP(2)` for wrong answers |
| `submitRfAnswer()` | Added `addXP(2)` for wrong answers in Reinforce |
| `filterSection()` | Full inline style reset before applying active state |
| `timelineSVG()` | Added `inversion` handler; fixed coordinates in `third` and `mixed` |

#### New TENSES Entry
| Skill ID | Name | Color | Timeline Type |
|----------|------|-------|---------------|
| `inversion` | Conditional Inversion | `#0D9488` | `inversion` |

#### Files Changed
| File | Change |
|------|--------|
| `index.html` | All bug fixes + new inversion lesson |
| `Future_and_conditionals/index.html` | Synced copy of root |
| `teacher.html` | Added `third` to heatmap skills |
| `Future_and_conditionals/teacher.html` | Synced copy of root |
| `futurelab.html` | Moved to `archive/` |
| `template2.html` | Moved to `archive/` |
| `CLAUDE.md` | Created — project guide for AI assistants |

---

## v2.0.0 — Major Platform Upgrade (2026-05-30)

### Bug Fixes
- **Fixed duplicate skill detail modal**: `showSkillDetail()` now calls `closeSkillDetail()` before opening a new modal, preventing overlay stacking.
- **Fixed empty `recordExamToReview()`**: Function now properly registers incorrect exam answers into `state.review` for Smart Review, enabling the review queue to work as intended.

---

### New Content

#### Third Conditional (Complete Module)
- **Learn Module**: Full lesson card with animated timeline SVG, structure formula (`If + had + PP, would have + PP`), 2 example sentences with TTS, signal words, worked example with step-by-step reasoning, and mini-check quiz.
- **Practice Engine**: 6 new exercises (Tier 2-3) — multiple choice, fill-in-the-blank, and error correction.
- **Flashcards**: 2 new cards (`c13`, `c14`) covering structure and concept.
- **Conditionals Module**: Full block with description, formula, 3 real-use examples, and common error warning.
- **Sentence Machine**: New "Imaginary past" slot with Third Conditional example.
- **Exam**: Already had Third Conditional questions — now students learn the concept before being tested.

#### Mixed Conditional (Enhanced Module)
- **Learn Module**: Full lesson card with animated timeline SVG showing cross-time conditions, dual structure formulas (past->present and present->past), 2 example sentences, worked example, and mini-check.
- **Practice Engine**: 5 new exercises (Tier 3-4) covering both mixed conditional patterns.
- **Flashcards**: 2 new cards (`c15`, `c16`) for both mixed conditional patterns.
- **Conditionals Module**: Full block with description, dual formula, 3 real-use examples.
- **Sentence Machine**: New "Cross-time" slot with Mixed Conditional example.

#### Translation Exercises (Writing Studio)
- **Zero Conditional Translation**: "Si calientas hielo, se derrite." -> English
- **First Conditional Translation**: "Si llueve manana, me quedare en casa." -> English
- **Second Conditional Translation**: "Si yo fuera presidente, construiria mas escuelas." -> English
- **Paragraph Builder**: Write 3 connected sentences using "will", "going to", and Future Perfect.
- All exercises include regex-based structure validation, feedback messages, and model answers with TTS.

---

### Data Integrity & Sync

#### Immediate Sync on Critical Events
- New `syncNow()` function bypasses the 1.5s debounce timer for critical events.
- Called automatically after:
  - Exam completion (`finishExam`)
  - Badge awards (`award`)
- Prevents data loss when students close tabs immediately after important achievements.

#### Supabase Sync Payload Enhanced
- `card_box` (Leitner flashcard box state) now included in sync payload.
- `best_exam_score` now synced alongside `exam_score`.
- Sync body extracted to reusable `buildSyncBody()` function.

#### Sync Status Indicator
- New visual indicator in the top stats bar showing cloud sync status.
- Three states with distinct colors:
  - **Saved** (green) — data successfully synced
  - **Saving...** (gold, pulsing) — sync in progress
  - **Sync error** (red) — sync failed
- Hidden on screens < 520px to save space.

#### Intervention Logging
- New `logIntervention()` function stores student confusion queries and AI responses to Supabase table `futurelab_interventions`.
- Payload includes: student_name, section, skill, confusion text, AI response, level, timestamp.
- Enables teachers to analyze common misconceptions per skill.

---

### Gamification Improvements

#### XP Anti-Inflation System
- Previous: Flat 250 XP needed for all levels after level 9.
- New progressive scaling via `xpNeeded()`:

| Level Range | XP Required |
|-------------|-------------|
| 1-3         | 100 XP      |
| 4-6         | 150 XP      |
| 7-9         | 200 XP      |
| 10-12       | 300 XP      |
| 13-15       | 400 XP      |
| 16+         | 500 XP      |

#### Best Exam Score Tracking
- New `state.bestExamScore` tracks the highest exam score ever achieved.
- New `state.examHistory` array stores all attempts with score and date.
- Exam result screen now shows: "Best score: X% - Attempt #N".
- Confirmation dialog before retaking exam shows last and best scores.

#### Leaderboard Percentile Rank
- After leaderboard loads, shows personalized message: "You are in the top X% of [all students/your section] (XP/EXAM/ACCURACY)".
- Calculates based on student's position relative to total students.
- Hidden when student is not in the leaderboard or only 1 student exists.

---

### Accessibility (WCAG 2.1 AA)

#### ARIA Attributes
- Navigation tabs: `role="tablist"` on container, `role="tab"` + `aria-selected` + `aria-controls` on each tab.
- View panels: `role="tabpanel"` + `aria-hidden` on all 9 view containers.
- Dropdown menu: `aria-haspopup`, `aria-expanded`, `role="menu"`, `role="menuitem"`.
- Dynamic updates: `go()` function toggles `aria-selected` and `aria-hidden` on navigation.

#### Visual Feedback (Color + Icon)
- Practice engine correct answers: Green background + `::before` content "checkmark" icon.
- Practice engine wrong answers: Red background + `::before` content "X" icon.
- Exam correct answers: Same checkmark/X pattern.
- Ensures colorblind users can distinguish right/wrong without relying on color alone.

#### Focus Trap
- `trapFocus()` utility function traps Tab key within modal overlays.
- Escape key closes modals.
- Applied to: intervention modal, name modal.
- Prevents keyboard users from tabbing out of modal context.

#### Keyboard Support
- Spacebar flips flashcards when Flashcards view is active.
- Does not interfere with text inputs (checks activeElement tag).

---

### Navigation Redesign

#### Consolidated Tab Bar
- Reduced from 9 visible tabs to 7 primary tabs + dropdown menu.
- Primary tabs: Home, Learn, Practice, Flashcards, Write, Exam, Leaderboard.
- Dropdown "More" menu contains: Conditionals, Reinforce.
- Dropdown has proper ARIA attributes and closes on outside click.
- Dropdown items update active state correctly via `go()` function.

---

### Responsive Design (Full Cross-Platform)

#### Viewport & Platform Support
- Enhanced viewport meta: `viewport-fit=cover` for notched devices, `maximum-scale=5` for accessibility zoom.
- `apple-mobile-web-app-capable` and `mobile-web-app-capable` meta tags.
- `theme-color` meta tag for browser chrome coloring.
- Safe area insets (`env(safe-area-inset-*)`) for iPhone X+ notch and Android punch-hole cameras.

#### Touch Optimization
- `@media(pointer:coarse)`: All interactive elements get minimum 44x44px touch targets (Apple HIG / Material Design guideline).
- `-webkit-overflow-scrolling: touch` on scrollable containers.
- `overscroll-behavior-y: contain` prevents background scroll on modals.
- `-webkit-text-size-adjust: 100%` prevents text resize on orientation change.

#### Breakpoints

| Breakpoint | Target Devices |
|------------|---------------|
| 320-359px  | iPhone SE, small Android phones |
| 360-480px  | iPhone 12/13/14, Galaxy S series |
| 481-600px  | iPhone Plus/Max, Pixel XL |
| 601-1023px | iPad, Surface Go, tablets |
| 1024-1279px | iPad Pro, laptop screens |
| 1280-1439px | Standard desktop monitors |
| 1440-2559px | Large monitors, ultrawide |
| 2560px+    | 4K monitors, iMac 5K |

#### Landscape Mode
- `@media(max-height:500px) and (orientation:landscape)`: Optimized layout for phones in landscape.
- Sticky header becomes relative to save vertical space.
- Flashcard height reduced, modals repositioned.

#### Print Styles
- Hides non-essential UI (top bar, toasts, modals, sync indicator).
- White background, black text.
- All views visible for complete printout.

---

### Technical Details

#### New Functions
| Function | Purpose |
|----------|---------|
| `xpNeeded(lv)` | Calculate XP required for a given level |
| `buildSyncBody()` | Build Supabase sync payload (reusable) |
| `doSync()` | Execute sync immediately |
| `syncNow()` | Immediate sync (bypasses debounce) |
| `showSyncStatus(s)` | Update sync indicator UI |
| `logIntervention(skill, confusion, response)` | Log intervention to Supabase |
| `trapFocus(el)` | Trap Tab/Escape key within modal element |

#### New State Properties
| Property | Type | Purpose |
|----------|------|---------|
| `state.bestExamScore` | number/null | Highest exam score ever achieved |
| `state.examHistory` | array | All exam attempts with score and date |

#### New Supabase Tables Used
| Table | Purpose |
|-------|---------|
| `futurelab_interventions` | Stores student confusion queries and AI responses |

#### New Skills
| Skill ID | Name | Added To |
|----------|------|----------|
| `third` | Third Conditional | SKILLS, SKILL_LABELS, TENSES, ITEMS, CARDS, CONDS, MACHINE, checkBadges |

#### New Practice Items
- 6 Third Conditional exercises (Tier 2-3)
- 5 Mixed Conditional exercises (Tier 3-4)
- 4 Translation writing exercises + 1 paragraph builder

#### New Flashcards
- `c13`: Third Conditional structure
- `c14`: Third Conditional concept (can't change the past)
- `c15`: Mixed Conditional past->present
- `c16`: Mixed Conditional present->past

---

### File Statistics
| Metric | Before | After |
|--------|--------|-------|
| Total lines | 2,233 | 2,648 |
| Functions | ~80 | ~88 |
| Practice items | ~80 | ~91 |
| Flashcards | 12 | 16 |
| Writing tasks | 4 | 8 |
| Conditional types taught | 3 | 5 |
| Sentence Machine slots | 3 | 5 |
| CSS breakpoints | 5 | 12 |
| ARIA attributes | 0 | 20+ |
