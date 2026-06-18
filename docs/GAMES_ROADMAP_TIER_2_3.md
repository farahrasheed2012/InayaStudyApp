# InayaStudyApp — Games Roadmap (Tier 2 & Tier 3)

Saved plan for future implementation. **InayaStudyApp only** — not Science Bowl Coach, TossUp, or SohaAli.

---

## Completed: Tier 1 ✅

| Item | Status |
|------|--------|
| **Star Chart** | Topic stars: hollow → half → full → gold (`StarChartHelper`, `StarChartView`) |
| **Creature Compendium** | Perfect game score unlocks creature (`CollectedCreature`, `CreatureCatalog`) |
| **Pattern Puzzler** | Math — missing number in sequences |
| **Habitat Match** | Science — animal ↔ habitat matching |
| **Animal Rescue** | Science — narrative rescue, gentle wrong answers |
| **Math Duel** | Pass-the-device split-screen buzzer |

Infrastructure in place: `AppGameID`, `GameRouter`, `SuiteGameWrapper`, `GameSessionStore`, `GameContent`, Games tab.

---

## Tier 2 — Next batch ✅ Shipped

**Goal:** More variety of interaction; reuse existing `GameKit` / shells. Hook **Underwater Expedition** into the Compendium for replay.

**Status:** All five games implemented (June 2026).

### 1. Bubble Pop (Math)

- Bubbles float up with numbers; problem shown at top.
- Pop the bubble with the correct answer before it leaves the screen.
- **Difficulty:** Multiple correct bubbles per round (e.g. all multiples of 6).
- **TEKS:** Facts, multiplication, skip counting.
- **Build notes:** Similar arcade loop to Number Ninja; `GeometryReader` + timer; reuse `GameContent.mathProblem` / distractors.
- **Creature:** Bubble Blowfish 🐡

### 2. Frog Fly (Science)

- Frog on lily pad; vocab-labeled insects fly past.
- Tap the insect that answers the question (e.g. “Which is a decomposer?”).
- **TEKS:** Life science vocabulary, decomposers, adaptations.
- **Build notes:** Horizontal scrolling targets + tap hit zones; reuse science term banks from `GameContent`.
- **Creature:** Fly Catcher Frog 🐸 (or separate from Jumping Frog)

### 3. Shadow Match (Science)

- Silhouette of plant/animal part; pick organism from four choices.
- Escalate to adaptations ↔ environments (webbed feet → aquatic).
- **TEKS:** Life cycles, plant parts, adaptations.
- **Build notes:** Low-cost variant of Sparky Match / `GameChoiceGrid`; SF Symbol or emoji silhouettes.
- **Creature:** Shadow Owl 🦉

### 4. Underwater Expedition (Both)

- Submarine through zones: surface → coral reef → deep sea.
- Each zone mixes math + science questions.
- **Collectible:** Treasure unlocks creature cards in Compendium (extend `CreatureCatalog` or zone-specific creatures).
- **TEKS:** Cross-curricular review.
- **Build notes:** Zone state machine; reuse `SuiteGameWrapper` header; new `UnderwaterZone` enum in `GameContent`. Strong tie-in to existing Compendium UI.
- **Creature:** Per-zone creatures (e.g. Reef Ray, Deep Angler)

### 5. Potion Lab (Science)

- Match ingredients (states of matter, properties) to brew a potion.
- Wrong combos → silly failed reactions (animation + copy).
- Successful brew → bottle on shelf (visual collection, optional Compendium entry).
- **TEKS:** Matter, mixtures, properties.
- **Build notes:** Similar interaction to Sort It / multi-select; `GameContent` ingredient sets for 2nd vs 3rd grade.
- **Creature:** Potion Platypus 🦫

### Tier 2 — Also consider (lighter scope)

- **Jungle Trek (Science):** Side-scrolling path — **prefer reusing adventure map** with jungle art + “trek forward” on correct answer instead of a full side-scroller.
- **Galaxy Explorer (Math):** Constellation topic clusters — **prefer alternate map skin** on existing `AdventureMapView`, not a second progression system.

### Tier 2 — Implementation order (recommended)

1. Shadow Match (fastest)
2. Bubble Pop
3. Frog Fly
4. Potion Lab
5. Underwater Expedition (largest; do last in tier)

### Tier 2 — Per-game checklist

- [x] Add `AppGameID` case in `GameCatalog.swift`
- [x] Add creature in `CreatureCatalog.swift`
- [x] Add content generators in `GameContent.swift`
- [x] Implement game view (`Games/Math|Science|Cross/`)
- [x] Wire `GameRouter.swift`
- [x] Register in `project.pbxproj`
- [x] Verify full-screen canvas + button taps
- [x] Test perfect score → Compendium unlock

---

## Tier 3 — Build later ✅ Shipped

**Goal:** Persistent worlds and narrative depth.

**Status:** All five games implemented, including SwiftData persistence for Town Builder and Terrarium Builder (`BuilderStore`, `TownBuildState`, `TerrariumBuildState`).

### 1. Town Builder (Math)

- Earn lumber/bricks/glass by solving problems; spend to build town (houses, parks, shops).
- Harder problems → rarer materials.
- **Town persists between sessions** (SwiftData or dedicated `TownState` model).
- **TEKS:** Word problems, money, measurement.
- **Risk:** Largest UI surface — building placement, economy balance.

### 2. Terrarium Builder (Science)

- Answer ecosystem questions to earn plants, animals, terrain.
- Place into terrarium; validate balance (producer/consumer ratio).
- Living terrarium animates when balanced.
- **TEKS:** Ecosystems, food webs, habitats.
- **Risk:** Simulation rules + validation logic.

### 3. Mystery Island (Both)

- Short illustrated mystery (“plants dying — why?”).
- Chapters = math/science questions revealing clues.
- Culprit changes per playthrough (salt in soil, broken water cycle, etc.).
- **Risk:** Lots of unique narrative content per run.

### 4. Time Traveler (Math)

- Historical eras with era-appropriate math (Roman coins, Egyptian cubits, medieval market).
- **TEKS:** Contextual math; needs tight alignment or stays “fun extra.”
- **Risk:** Custom content per era.

### 5. Meteor Math (Math)

- Meteors with numbers fly toward Earth; target “Make 48” — tap two that multiply/add to target.
- Speed increases over time.
- **Risk:** Real-time collision/timing; more engineering than Bubble Pop.

### Tier 3 — Prerequisites

- [x] Tier 2 games shipping and stable
- [ ] Compendium + Star Chart feedback from Inaya
- [x] SwiftData schema plan for persistent builders (`TownState`, `TerrariumState`) — lightweight V1→V2 migration in `SwiftDataSchemaMigration.swift`
- [x] Content authoring workflow for narrative games (Mystery Island, Time Traveler)

### Tier 3 — Implementation order (recommended)

1. Meteor Math (arcade, no persistence)
2. Mystery Island (narrative, session-scoped)
3. Time Traveler (content-heavy)
4. Terrarium Builder (persistence + rules)
5. Town Builder (most scope)

---

## Explicitly out of scope (other apps)

| Project | Notes |
|---------|--------|
| **ScienceBowlCoach** | Middle-school NSB; buzzer drills only. Optional later: speed duel / mental math sprint — not narrative games. |
| **TossUp** | Same as above. |
| **SohaAli folder** | Schedules/scripts — not an app. |

---

## Architecture reminders (when implementing)

- New games: `AppGameID` → `GameCatalog` → `GameRouter` → `SuiteGameWrapper` (or standalone shell like `MathDuelGame`).
- Full-screen: `.gameScreenCanvas()` on shells; `GameChoiceGrid(layout: .fill)` for answer grids.
- Navigation: `NavigationLink(value:)` + `navigationDestination(for:)` — avoid `navigationDestination(isPresented:)` on game screens.
- Progress: `GameSessionStore.recordCompletion` for sessions/badges/creatures.
- Map: enhance `AdventureMapView` / `MapProgressHelper` for skins — don’t duplicate progression systems.

---

## Original inspiration (user list)

<details>
<summary>Full brainstorm categories</summary>

**Adventure / World Map:** Galaxy Explorer, Jungle Trek, Underwater Expedition

**Building / Crafting:** Town Builder, Potion Lab, Terrarium Builder

**Puzzle / Logic:** Pattern Puzzler ✅, Habitat Match ✅, Shadow Match

**Arcade / Reflex:** Meteor Math, Bubble Pop, Frog Fly

**Story / Narrative:** Mystery Island, Time Traveler, Animal Rescue ✅

**Multiplayer:** Math Duel ✅, Science Showdown (future: Math Duel reskin)

**Collection / Meta:** Creature Compendium ✅, Star Chart ✅

</details>

---

*Last updated: June 2026 — Tier 2 & 3 shipped (25 games total in Games tab).*
