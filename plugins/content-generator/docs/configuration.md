# Configuration-Driven Architecture

How the system adapts to any topic through `requirements.md` configuration.

---

## How It Works

All agents, commands, and skills read `requirements.md` at runtime to extract:

| Configuration | Purpose |
|---------------|---------|
| Topic/Platform | What you're writing about |
| Official Documentation | Where authoritative sources are |
| Brand Voice | How content should sound |
| Target Audience | Who you're writing for |
| Content Strategy | What formats and mix to use |

**Result:** Change one file to completely reconfigure the entire system.

---

## Quick Start

### 1. Copy the template

```bash
cp requirements-template.md project/requirements.md
```

### 2. Fill in project details

- Industry/Niche
- Platform/Product
- Official Documentation Sources
- Brand Identity
- Focus Areas

### 3. Run the workflow

```bash
/content-calendar October 2025
/write-article Calendar/2025/October/content-calendar.md ART-202510-001
```

---

## Available Example Configurations

| Example | Domain | File |
|---------|--------|------|
| WordPress/WooCommerce | Technical web development | `examples/requirements-wordpress.md` |
| React.js | Frontend framework tutorials | `examples/requirements-react.md` |
| Python | Data science and automation | `examples/requirements-python.md` |
| Personal Finance | Investment and retirement | `examples/requirements-finance.md` |
| Psychology | Clinical practice guidance | `examples/requirements-psychology.md` |
| Entertainment | Film and TV criticism | `examples/requirements-entertainment.md` |

---

## Switching Topics

```bash
# View available configurations
ls examples/

# Switch to React.js
cp examples/requirements-react.md project/requirements.md

# Switch to Finance
cp examples/requirements-finance.md project/requirements.md

# All subsequent generation uses new config
/content-calendar November 2025
```

---

## Configuration Dimensions

### Example Comparison

| Dimension | WordPress | React.js | Python |
|-----------|-----------|----------|--------|
| **Niche** | Plugins, e-commerce | Components, patterns | Data, ML, automation |
| **Audience** | Site owners, devs (beginner-intermediate) | JS devs (intermediate) | Data pros (beginner-advanced) |
| **Brand Voice** | Friendly, practical | Clear, example-driven | Rigorous, educational |
| **Content Mix** | Tutorials 40-60%, analysis 20-40% | Tutorials 60-80%, deep-dives 20-40% | Tutorials 50%, cases 30%, theory 20% |
| **Length** | 700-2,200 words | 1,000-3,000 words | 1,500-4,000 words |
| **Examples** | Code snippets, plugin configs | CodeSandbox, GitHub repos | Jupyter notebooks, datasets |
| **CTA** | Newsletter subscribe | GitHub star, newsletter | Course enrollment, newsletter |

---

## Universal vs. Platform-Specific Components

### Universal (Topic-Agnostic)

These adapt to any topic via configuration:

- **Agents**: researcher, writer, editor, signal-researcher
- **Commands**: content-calendar, write-article
- **Skills**: competitive-gap-analyzer, content-research, seo-optimization, requirements-validator, theme-index-builder, topic-deduplicator

### Platform-Specific

Tied to specific platforms:

| Skill | Platform | Configuration |
|-------|----------|---------------|
| `gutenberg-formatter` | WordPress | Set `CMS Platform: WordPress (Gutenberg editor)` |

For non-WordPress projects, set `HTML Formatter Skill: none`

---

## Parallel Execution Pattern

The system uses **parallel agent execution** for performance optimization while maintaining quality.

### Research Phase Parallelization

**Pattern:** `/write-article` runs 2x `@researcher` agents concurrently, then merges results

```
┌─────────────────────────────┐
│   /write-article command    │
└──────────┬──────────────────┘
           │
           ├─────────────────┬─────────────────┐
           │                 │                 │
           v                 v                 v
    ┌────────────┐    ┌────────────┐    Wait for both
    │ Agent 1:   │    │ Agent 2:   │    to complete
    │ Primary    │    │ Landscape  │
    │ Sources    │    │ Analysis   │
    └─────┬──────┘    └─────┬──────┘
          │                 │
          │                 │
          └────────┬────────┘
                   │
                   v
           ┌──────────────┐
           │  Agent 3:    │
           │  Merge       │
           │  Coordinator │
           └──────────────┘
```

**Agent 1 - Primary Sources** (5-7 min):
- Official documentation research
- Fact verification and technical accuracy
- Code examples and technical requirements
- SME requirement assessment
- Output: `research-primary.md`

**Agent 2 - Competitive Landscape** (5-7 min):
- Competitive gap analysis (8-10 competitors)
- Differentiation opportunity identification
- Media embed discovery
- Market positioning insights
- Output: `research-landscape.md`, `gap-analysis-report.md`, `media-discovery.md`

**Agent 3 - Merge Coordinator** (2-3 min):
- Merge research-primary.md + research-landscape.md
- Conflict resolution (technical accuracy vs. market positioning)
- Verification checklist validation
- Output: `research-brief.md`

### Benefits

- **Speed**: ~10-12 minutes total vs. ~15-20 minutes sequential (40-45% faster)
- **Quality**: Separate agents focus on different expertise areas
- **Validation**: Merge step cross-validates findings

### Merge Strategy

1. **Source Verification**: Agent 1's official sources authoritative, Agent 2's competitive findings validate
2. **Differentiation**: Agent 2's gap analysis primary, Agent 1's depth enhances
3. **Media Embeds**: Agent 2's discovery validated by Agent 1's credibility checks
4. **Conflicts**: Technical accuracy → Agent 1 precedence; Market positioning → Agent 2 precedence

### Failure Modes

- **Agent failure**: Fall back to single-agent research
- **Merge conflicts**: Escalate to @editor with conflict log
- **Verification failure**: Manual review by @editor

See `docs/workflow.md` Phase 2 for complete documentation.

---

## Configuration Access Pattern (MANDATORY)

**All agents and skills MUST use `requirements-extractor` for configuration access.**

### ✅ CORRECT Pattern

```markdown
Please use the requirements-extractor skill to load and validate configuration from project/requirements.md.
```

The skill returns structured JSON with validated configuration including:
- `project.industry`, `project.platform`, `project.official_docs`, etc.
- `audience.primary_roles`, `audience.skill_level`
- `brand.voice.traits`, `brand.voice.guidelines`
- `content.formats`, `content.objectives`, `content.length`
- `seo.intent`, `seo.internal_linking`, `seo.primary_cta`
- `cms.platform`, `cms.export_format`

**Benefits:**
- **Validation**: Configuration errors caught upfront (not 20 minutes into workflow)
- **Consistency**: All components parse config identically
- **Structured Output**: JSON schema prevents field name typos
- **Maintainability**: Single parsing implementation to update

### ❌ WRONG Pattern (Anti-Pattern)

```bash
# DO NOT DO THIS
!cat project/requirements.md
# Then manually parse with grep/awk/sed
```

**Why this is wrong:**
- No validation - malformed config causes late failures
- Inconsistent parsing - different components extract differently
- Error-prone - field name changes break multiple files
- Hard to debug - ad-hoc parsing logic scattered everywhere

### Enforcement

**Plugin Validation Check:**
```bash
# Detect anti-pattern usage (should return 0 results)
grep -r "cat.*requirements\.md" plugins/content-generator/agents/ plugins/content-generator/skills/
```

**Updated Components (Priority 4):**
- ✅ `agents/researcher.md` - Uses requirements-extractor
- ✅ `agents/writer.md` - Uses requirements-extractor
- ✅ `agents/editor.md` - Uses requirements-extractor
- ✅ `skills/content-research/` - Uses requirements-extractor
- ✅ `skills/seo-optimization/` - Uses requirements-extractor
- ✅ `skills/cms-formatter/` - Uses requirements-extractor
- ✅ `skills/media-discovery/` - Uses requirements-extractor

**Already Compliant:**
- ✅ `agents/signal-researcher.md` - Uses requirements-extractor
- ✅ `commands/content-calendar.md` - Uses requirements-extractor
- ✅ `skills/sme-complexity-assessor/` - Uses requirements-extractor
- ✅ `skills/requirements-validator/` - Uses requirements-extractor (self-referential)
- ✅ `skills/theme-index-builder/` - Does not use requirements-extractor (analyzes past calendars directly)
- ✅ `skills/topic-deduplicator/` - Does not use requirements-extractor (uses theme index input)

---

## Modular Deduplication Architecture (Priority 3)

### Overview

The signal-researcher agent has been refactored from a monolithic 67KB file to a lightweight 44KB orchestration layer by extracting complex theme indexing and deduplication logic into two reusable skills.

### Architecture Transformation

**Before:** Monolithic (67KB)
```
┌──────────────────────────────────────┐
│   @signal-researcher                 │
│   - Config loading (5KB)             │
│   - Theme indexing (15KB)            │
│   - Signal discovery (15KB)          │
│   - Topic generation (10KB)          │
│   - Deduplication logic (20KB)       │
│   - Output generation (7KB)          │
└──────────────────────────────────────┘
```

**After:** Modular (60KB total, separated)
```
┌────────────────────┐
│ @signal-researcher │ (44KB)
│ - Orchestration    │
│ - Config loading   │
│ - Signal discovery │
│ - Topic generation │
│ - Output           │
└─────────┬──────────┘
          │ delegates to
          ├──→ theme-index-builder (30KB skill)
          └──→ topic-deduplicator (35KB skill)
```

### Benefits

- **Maintainability:** Complex logic isolated and testable independently
- **Reusability:** Skills can be invoked standalone for diagnostics
- **Consistency:** Centralized deduplication ensures uniform behavior
- **Performance:** Theme index can be cached and reused across calendar runs

### New Skills

#### theme-index-builder

**Purpose:** Build comprehensive theme index from past calendars

**Inputs:**
- `target_month`: Calendar month (e.g., "November 2025")
- `lookback_months`: How far back to index (default: 12)
- `calendar_directory`: Path to calendars (default: `project/Calendar/`)
- `include_requirements_themes`: Load seed themes from requirements.md (default: true)

**Process:**
1. Identify past calendars within lookback window
2. Parse calendar tables and extract topic metadata
3. Generate dynamic theme tags from actual project content (NOT hardcoded)
4. Build core theme registry for strict 6-month deduplication
5. Calculate core theme saturation status
6. Output structured theme index JSON + validation report

**Outputs:**
- `theme-index.json` — Structured index with topics, theme tags, core themes, saturation data
- `theme-index-validation.md` — Human-readable validation report

**Key Features:**
- **Dynamic theme generation:** Derives tags from actual content, not hardcoded patterns
- **6-month saturation tracking:** Enforces theme spacing for content variety
- **Synonym detection:** Learns project-specific terminology variations
- **Validation required:** MUST output confirmation before proceeding

**Invoked by:**
- `@signal-researcher` agent during Phase 1, Step 1.2 (calendar generation)
- Manual invocation for index rebuilding/diagnostics

**Example:**
```
Please use the theme-index-builder skill to build the theme index.

Parameters:
  target_month: "November 2025"
  lookback_months: 12
  calendar_directory: "project/Calendar/"
  include_requirements_themes: true
```

#### topic-deduplicator

**Purpose:** Perform theme-level deduplication for topic candidates

**Inputs:**
- `topic_candidate`: Object with title, keyword, differentiation_angle, primary_gap, format
- `theme_index`: Theme index JSON from theme-index-builder

**Process:**
1. Extract candidate's core themes
2. **CRITICAL:** Check for 6-month core theme hard-block (no exceptions)
3. Calculate similarity score against all past topics using multi-factor algorithm:
   - Keyword overlap (30%, with synonym expansion)
   - Theme tag overlap (25%)
   - Title semantic similarity (25%, with paraphrase detection)
   - Core theme match (20%)
4. Apply threshold classification:
   - Same core theme within 6 months → **HARD_BLOCKED**
   - Similarity ≥ 0.60 within 6 months → **BLOCKED**
   - Similarity ≥ 0.80 (any age) → **BLOCKED**
   - Similarity 0.40-0.79 (7+ months) → Check differentiation
   - Similarity < 0.40 → **NOVEL**
5. For 7+ month old similar themes: Calculate differentiation score
6. Apply time-decayed threshold (stricter for recent content)
7. Return deduplication status with detailed reasoning

**Outputs:**
```json
{
  "dedup_status": "NOVEL|DIFFERENTIATED|BLOCKED|HARD_BLOCKED",
  "comparison": {
    "most_similar_id": "ART-YYYYMM-NNN",
    "theme_similarity_score": 0.XX,
    "months_ago": N
  },
  "decision": {
    "block_type": "core_theme|near_duplicate|recent_similar|insufficient_differentiation|null",
    "block_reason": "[explanation if blocked]",
    "pass_reason": "[explanation if passed]"
  }
}
```

**Key Features:**
- **6-month hard-block:** Same core theme can only appear twice/year
- **Synonym expansion:** Universal patterns + project-specific synonyms
- **Paraphrase detection:** Identifies semantic duplicates ("how to X" = "X tutorial")
- **Time decay:** Graduated thresholds based on recency
- **Differentiation analysis:** Evaluates angle novelty for similar themes

**Invoked by:**
- `@signal-researcher` agent during Phase 4, Step 4.3 (for each topic candidate)
- Manual invocation for deduplication diagnostics

**Example:**
```
Please use the topic-deduplicator skill to check this candidate.

Topic Candidate:
  title: "Migrating WooCommerce Data to REST API Endpoints"
  keyword: "woocommerce data migration api"
  differentiation_angle: "Custom endpoint approach using WP REST API extensions"
  primary_gap: "Depth"
  format: "Tutorial"

Theme Index: [loaded theme-index.json]
```

### Deduplication Decision Flow

```
┌─────────────────────────────────────────────────────────────┐
│                    FOR EACH CANDIDATE                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Step 1: Core theme match within 6 months?           │   │
│  │         YES → HARD_BLOCKED (no exceptions)          │   │
│  │         NO  → Continue                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                           ↓                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Step 2: Any similar topics (≥0.40)?                 │   │
│  │         NO  → NOVEL ✅                              │   │
│  │         YES → Continue                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                           ↓                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Step 3: Similarity ≥0.80 (any age)?                 │   │
│  │         YES → BLOCKED (near duplicate)              │   │
│  │         NO  → Continue                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                           ↓                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Step 4: Similarity ≥0.60 AND within 6 months?       │   │
│  │         YES → BLOCKED (too recent)                  │   │
│  │         NO  → Continue                              │   │
│  └─────────────────────────────────────────────────────┘   │
│                           ↓                                 │
│  ┌─────────────────────────────────────────────────────┐   │
│  │ Step 5: Check differentiation (7+ months only)      │   │
│  │         diff_score < threshold → BLOCKED            │   │
│  │         diff_score ≥ threshold → DIFFERENTIATED ✅  │   │
│  └─────────────────────────────────────────────────────┘   │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Usage Example

**Full workflow during calendar generation:**

```
1. @signal-researcher invokes theme-index-builder
   → Outputs: theme-index.json, theme-index-validation.md

2. @signal-researcher generates 12 topic candidates

3. For each candidate, @signal-researcher invokes topic-deduplicator
   → Input: candidate + theme-index.json
   → Output: dedup_status + reasoning

4. @signal-researcher filters candidates:
   - ✅ NOVEL / DIFFERENTIATED → Include
   - ❌ BLOCKED / HARD_BLOCKED → Exclude

5. Final output: topic-candidates.md with dedup status for each
```

### Impact

**Before Refactor:**
- signal-researcher.md: 67KB, 1748 lines
- All logic embedded, difficult to maintain
- Deduplication logic not reusable

**After Refactor:**
- signal-researcher.md: 44KB, 1145 lines (34% reduction)
- theme-index-builder: Reusable, testable, cacheable
- topic-deduplicator: Consistent deduplication across all invocations
- Total: Better separation of concerns, easier maintenance

---

## Adding Platform-Specific Skills

1. Create skill in `.claude/skills/[platform]-[feature]/`
2. Document in `requirements-template.md`
3. Add conditional logic in commands if needed

---

## Cross-Domain Examples

### Technical Tutorial (React.js)

```
Topic: "React Server Components: When to Use Them"
Research: Official React docs + RFC discussions + community patterns
Differentiation: Comparison matrix of CSR/SSR/RSC tradeoffs
Content: Tutorial with CodeSandbox examples + decision flowchart
Word Count: 2,400 words
```

### Non-Technical Analysis (Finance)

```
Topic: "Tax-Loss Harvesting: A Complete Guide for 2025"
Research: IRS regulations + academic studies + platform docs
Differentiation: Worked examples with actual tax calculations
Content: Step-by-step guide with decision trees
Word Count: 1,800 words
```

**Observation:** Same workflow (research → gap analysis → write → review), different execution based on domain.

---

## Directory Structure

```
project/
├── .claude/
│   ├── agents/
│   │   ├── researcher.md
│   │   ├── writer.md
│   │   └── editor.md
│   ├── commands/
│   │   ├── content-calendar.md
│   │   └── write-article.md
│   └── skills/
│       ├── competitive-gap-analyzer/
│       ├── content-research/
│       ├── seo-optimization/
│       ├── requirements-validator/
│       └── gutenberg-formatter/
├── requirements.md           # Active configuration
├── requirements-template.md  # Template for new projects
├── examples/                 # Pre-configured examples
├── Calendar/                 # Monthly calendars
└── Articles/                 # Article folders
```

---

## Distribution Channels by Domain

| Domain | Channels |
|--------|----------|
| Blog/Content Sites | Newsletter, RSS, social media |
| Technical Documentation | npm, PyPI, GitHub, API docs |
| Video Tutorials | YouTube, Vimeo, Udemy |
| Research/Academic | Journals, arXiv, conferences |
| Business/Finance | LinkedIn, industry publications |

---

## Quality Metrics

| Metric | Measurement |
|--------|-------------|
| Editorial compliance | Review pass rate |
| SEO performance | Keyword rankings |
| Engagement | Subscriptions, shares, downloads |
| Accuracy | Validation rate, corrections needed |
