---
name: theme-index-builder
description: Build comprehensive theme index from past content calendars for deduplication. Extracts topics, generates dynamic theme tags, and creates structured index for similarity analysis.
---

# Theme Index Builder Skill

## Purpose

Automate the construction of a comprehensive theme index from past content calendars. This index enables theme-level deduplication by tracking published topics, extracting core themes, and generating dynamic theme tags for similarity analysis.

Replaces manual theme indexing with a structured, repeatable process that:
- Parses past calendars within a configurable lookback window
- Extracts topic metadata (title, keyword, differentiation angle, gap type)
- Generates theme tags dynamically from project content (not hardcoded patterns)
- Builds core theme registry for strict 6-month deduplication
- Validates completeness and outputs structured JSON index

## When to Use

- **Automatically:** During signal research phase (invoked by @signal-researcher agent before topic generation)
- **Manually:** When rebuilding theme index after content migration or cleanup
- **Diagnostically:** When troubleshooting deduplication issues or analyzing theme saturation

## Configuration Requirements

This skill operates **without** requiring `requirements.md` — it analyzes actual calendar files directly. However, it respects these configuration settings if available:

- `content.topic_pillars[]` → Seed themes for tag generation
- `project.focus_areas[]` → Additional seed themes

If `requirements.md` is not available, the skill derives all themes from past calendar analysis only.

---

## Input Parameters

### Required
- `target_month`: Target calendar month (e.g., "November 2025")
- `calendar_directory`: Path to calendar directory (default: `project/Calendar/`)

### Optional
- `lookback_months`: How many months to index (default: 24, configurable for Phase 3 trend analysis)
- `output_path`: Where to save index JSON (default: same directory as target calendar)
- `include_requirements_themes`: Load seed themes from requirements.md (default: true)
- `include_time_series`: Build monthly time series data for trend analysis (default: true)

---

## Process

### Phase 1: Identify Past Calendars (1 minute)

**Step 1.1: Calculate Lookback Window**

From the target month, calculate the 24-month (or configured) lookback window:

```
Target: November 2025
Lookback: 24 months (default for Phase 3 trend analysis)
Window: November 2023 → October 2025 (inclusive)

Note: 12-month lookback still supported for backward compatibility
```

**Step 1.2: Find Calendar Files**

List all calendars in the directory:

```bash
ls -la project/Calendar/*/*/content-calendar.md
```

**Expected Structure:**
```
project/Calendar/2024/November/content-calendar.md
project/Calendar/2024/December/content-calendar.md
project/Calendar/2025/January/content-calendar.md
...
project/Calendar/2025/October/content-calendar.md
```

**Step 1.3: Filter to Lookback Window**

Include only calendars that fall within the lookback window. Calculate months ago for each:

```
Calendar: 2025/October → 1 month ago (from November 2025 target)
Calendar: 2025/September → 2 months ago
Calendar: 2024/November → 12 months ago
Calendar: 2023/December → 23 months ago
Calendar: 2023/November → 24 months ago
Calendar: 2023/October → 25 months ago (EXCLUDED - beyond 24-month window)
```

**Output:** List of calendar file paths within window, sorted by recency

---

### Phase 2: Extract Topic Metadata (2-3 minutes)

**Step 2.1: Parse Each Calendar File**

For each calendar within the lookback window, read the markdown file and parse the topic table.

**Expected Table Format:**
```markdown
| ID | Topic / Working Title | Keyword / Search Intent | Differentiation Angle | Primary Gap | Opportunity Score |
|----|----------------------|-------------------------|----------------------|-------------|-------------------|
| ART-202410-001 | [Title] | [keyword phrase] | [angle] | [Coverage/Depth/Format/Recency] | [score] |
```

**Step 2.2: Extract Metadata Fields**

For each row in the table, extract:

| Field | Column | Purpose |
|-------|--------|---------|
| `article_id` | ID | Unique identifier |
| `title` | Topic / Working Title | Primary theme signal |
| `keyword` | Keyword / Search Intent | SEO theme alignment |
| `differentiation_angle` | Differentiation Angle | Uniqueness marker |
| `primary_gap` | Primary Gap | Gap type (Coverage/Depth/Format/Recency) |
| `calendar_month` | (from file path) | When topic was planned |
| `months_ago` | (calculated from target) | Recency metric |

**Validation:**
- Skip rows with missing `article_id` or `title`
- Log warning if expected columns are missing
- Continue processing remaining rows

**Step 2.3: Calculate Months Ago**

For each topic, calculate how many months ago it was published relative to the target month:

```
Target: 2025-11 (November 2025)
Calendar: 2025-10 (October 2025)
→ months_ago = 1

Calendar: 2024-12 (December 2024)
→ months_ago = 11
```

---

### Phase 3: Generate Dynamic Theme Tags (2-3 minutes)

**CRITICAL:** Theme tags are **NOT hardcoded**. They are generated dynamically by analyzing past calendar content and configuration.

**Step 3.1: Extract Keywords from Past Topics**

For each topic in the theme index, extract keywords from:
1. `title` field
2. `keyword` field
3. `differentiation_angle` field

**Tokenization Process:**
- Remove stop words ("the", "a", "an", "for", "with", etc.)
- Extract 2-3 word phrases
- Stem to root forms (e.g., "migrating" → "migrate")

**Example:**
```
Title: "Migrating WooCommerce Data to Custom Endpoints"
Keyword: "woocommerce data migration api"
→ Extracted keywords: ["woocommerce", "data", "migration", "api", "endpoint", "custom"]
```

**Step 3.2: Cluster Keywords by Semantic Similarity**

Group similar keywords using:
- Shared root words (e.g., "security", "secure", "securing")
- Common co-occurrence patterns (keywords appearing together frequently)
- Manual synonym detection (common variations)

**Example Clusters:**
```
Cluster 1: ["migration", "migrate", "importing", "import", "sync"]
Cluster 2: ["security", "secure", "vulnerability", "authentication", "encryption"]
Cluster 3: ["performance", "optimization", "speed", "caching"]
```

**Step 3.3: Load Seed Themes from requirements.md (Optional)**

If `include_requirements_themes = true`, load seed themes from configuration:

```
Invoke requirements-extractor skill to get:
- content.topic_pillars[] → ["Data Integration", "Security", "Performance"]
- project.focus_areas[] → ["WooCommerce APIs", "Custom Development"]
```

Convert to lowercase kebab-case tags:
```
["data-integration", "security", "performance", "woocommerce-apis", "custom-development"]
```

**Step 3.4: Generate Theme Tags**

Combine:
1. Cluster-derived tags (from Step 3.2)
2. Seed themes from requirements.md (from Step 3.3)
3. Universal pattern tags (applied as relevant)

**Universal Pattern Categories:**

| Category | Tag Pattern | Examples |
|----------|-------------|----------|
| **Audience tags** | `for-[segment]` | `for-beginners`, `for-enterprise`, `for-developers` |
| **Format tags** | `[format-type]` | `tutorial`, `guide`, `analysis`, `comparison`, `deep-dive` |
| **Temporal tags** | `[time-context]` | `trends`, `news`, `update`, `announcement`, `forecast` |
| **Action tags** | `[verb-noun]` | `getting-started`, `troubleshooting`, `optimization` |

**Step 3.5: Assign Theme Tags to Each Topic**

For each topic, match against generated theme tags:

```
Topic: "Migrating WooCommerce Data to Custom Endpoints"
Keywords: ["migration", "woocommerce", "api", "custom", "endpoint"]

Matched Tags:
- "data-integration" (pillar match)
- "migration" (cluster match)
- "woocommerce-apis" (focus area match)
- "tutorial" (format pattern - inferred from title structure)
```

**Output:** Each topic now has `theme_tags: ["tag1", "tag2", "tag3"]`

---

### Phase 4: Build Core Theme Registry (1-2 minutes)

**Purpose:** Core themes are fundamental topic categories used for strict 6-month deduplication. They are more specific than theme tags.

**CRITICAL:** Core themes are extracted dynamically — do NOT use hardcoded theme lists.

**Step 4.1: Extract Core Theme Patterns**

**Core Theme Extraction Sources:**
1. **Past Calendars** — Parse existing topic titles/keywords to identify recurring patterns
2. **requirements.md** — Use `content.topic_pillars[]` and `project.focus_areas[]` as seed themes

**Dynamic Extraction Process:**

1. **Scan all topics** and extract 2-3 word "theme cores" from titles:
   ```
   Title: "Securing WooCommerce REST API Endpoints"
   → Core themes: "woocommerce-api", "security"

   Title: "WooCommerce Product Import Performance"
   → Core themes: "woocommerce-import", "performance"
   ```

2. **Group similar topics** by common keywords (clustering heuristics):
   ```
   Topics about "migration", "import", "sync" → Core theme: "data-migration"
   Topics about "authentication", "security", "vulnerability" → Core theme: "security"
   ```

3. **Generate core themes automatically** from patterns found:
   - Extract noun phrases (2-4 words max)
   - Use kebab-case: `topic-subtopic`
   - Prefer noun-based themes over verb-based

4. **Cross-reference with requirements.md** focus areas to ensure coverage

**Step 4.2: Assign Core Themes to Topics**

Each topic gets **1-2 core themes**:
- **Primary core theme:** Main topic focus
- **Secondary core theme:** Optional, if topic spans multiple areas

**Example:**
```
Title: "Migrating WooCommerce Data to Custom REST API Endpoints"
Keyword: "woocommerce data migration api"
Differentiation: "Custom endpoint approach using WP REST API extensions"

→ Primary Core Theme: "data-migration"
→ Secondary Core Theme: "woocommerce-api"
```

**Step 4.3: Build Core Theme Registry**

Create a registry of all core themes found:

```
Core Theme Registry:
| Core Theme | Source | Pattern Matches |
|------------|--------|-----------------|
| data-migration | Past calendar + pillar | ["migration", "import", "sync", "data transfer"] |
| security | Past calendar + pillar | ["authentication", "vulnerability", "encryption"] |
| performance | Pillar | ["optimization", "speed", "caching", "scaling"] |
| woocommerce-api | Focus area | ["rest api", "endpoints", "integration"] |
| ... | ... | ... |
```

**Output:** Core theme list with pattern matches for similarity detection

---

### Phase 5: Build Theme Index Structure (2-3 minutes)

**Step 5.1: Build Time Series Data (Phase 3 Enhancement)**

If `include_time_series = true`, build monthly time series for trend analysis:

**Step 5.1.1: Group Topics by Month**

For each month in the lookback window, count topics by core theme:

```
Month: 2025-10 (1 month ago)
Topics: 8 total
  - data-migration: 1
  - security: 2
  - performance: 1
  - woocommerce-api: 1
  - other themes: 3

Month: 2025-09 (2 months ago)
Topics: 9 total
  - data-migration: 1
  - security: 0
  - performance: 2
  - ...
```

**Step 5.1.2: Build Time Series Arrays**

For each core theme, create a 24-element array with monthly counts (index 0 = most recent):

```json
{
  "theme": "data-migration",
  "time_series": [1, 1, 0, 0, 0, 0, 2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
  "labels": ["2025-10", "2025-09", "2025-08", ..., "2023-11"]
}
```

**Step 5.1.3: Calculate Trend Metrics**

For momentum analysis:
- **Recent average** (months 0-5): Average count over past 6 months
- **Previous average** (months 6-11): Average count for 6 months before that
- **Historical average** (months 12-23): Average count for 12 months before that

```
Example for "data-migration":
time_series: [1, 1, 0, 0, 0, 0, 2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]

Recent avg (0-5):    sum([1,1,0,0,0,0]) / 6 = 0.33
Previous avg (6-11): sum([2,0,1,0,0,0]) / 6 = 0.50
Historical avg (12-23): sum([1,0,0,0,0,0,0,0,0,0,0,0]) / 12 = 0.08
```

These metrics enable the trend-momentum-analyzer skill to classify momentum (ACCELERATING, STABLE, DECLINING, etc.).

**Step 5.2: Assemble Index**

Create structured JSON index:

```json
{
  "metadata": {
    "target_month": "2025-11",
    "lookback_months": 24,
    "calendars_analyzed": 24,
    "topics_indexed": 187,
    "generated_at": "2025-10-15T14:32:00Z",
    "includes_time_series": true
  },
  "theme_tags": [
    "data-integration",
    "security",
    "performance",
    "woocommerce-apis",
    "tutorial",
    "guide",
    ...
  ],
  "core_themes": [
    {
      "theme": "data-migration",
      "source": "past_calendar+pillar",
      "pattern_matches": ["migration", "import", "sync", "data transfer"],
      "time_series": [1, 1, 0, 0, 0, 0, 2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      "time_series_labels": ["2025-10", "2025-09", "2025-08", "2025-07", "2025-06", "2025-05", "2025-04", "2025-03", "2025-02", "2025-01", "2024-12", "2024-11", "2024-10", "2024-09", "2024-08", "2024-07", "2024-06", "2024-05", "2024-04", "2024-03", "2024-02", "2024-01", "2023-12", "2023-11"],
      "trend_metrics": {
        "recent_avg": 0.33,
        "previous_avg": 0.50,
        "historical_avg": 0.08
      }
    },
    {
      "theme": "security",
      "source": "past_calendar+pillar",
      "pattern_matches": ["authentication", "vulnerability", "encryption"],
      "time_series": [2, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      "time_series_labels": ["2025-10", "2025-09", "2025-08", "2025-07", "2025-06", "2025-05", "2025-04", "2025-03", "2025-02", "2025-01", "2024-12", "2024-11", "2024-10", "2024-09", "2024-08", "2024-07", "2024-06", "2024-05", "2024-04", "2024-03", "2024-02", "2024-01", "2023-12", "2023-11"],
      "trend_metrics": {
        "recent_avg": 0.50,
        "previous_avg": 0.17,
        "historical_avg": 0.00
      }
    },
    ...
  ],
  "topics": [
    {
      "article_id": "ART-202510-001",
      "title": "Migrating WooCommerce Data to Custom REST API Endpoints",
      "keyword": "woocommerce data migration api",
      "differentiation_angle": "Custom endpoint approach using WP REST API extensions",
      "primary_gap": "Depth",
      "calendar_month": "2025-10",
      "months_ago": 1,
      "theme_tags": ["data-integration", "migration", "woocommerce-apis", "tutorial"],
      "core_themes": {
        "primary": "data-migration",
        "secondary": "woocommerce-api"
      }
    },
    ...
  ]
}
```

**Step 5.3: Calculate Core Theme Saturation (6-Month Window)**

For each core theme, count occurrences in the past 6 months (uses time_series[0:6] for efficiency):

```json
{
  "core_theme_saturation": [
    {
      "theme": "data-migration",
      "count_past_6_months": 2,
      "most_recent_month": "2025-10",
      "status": "SATURATED",
      "next_available": "2026-04"
    },
    {
      "theme": "security",
      "count_past_6_months": 0,
      "most_recent_month": "2025-03",
      "status": "AVAILABLE",
      "next_available": "now"
    },
    ...
  ]
}
```

**Saturation Status:**
- **SATURATED:** Core theme appeared 1+ times in past 6 months
- **AVAILABLE:** Core theme has NOT appeared in past 6 months

---

### Phase 6: Validation & Output (1 minute)

**Step 6.1: Validate Index Completeness**

Check that:
- All calendars within lookback window were parsed
- All topics have required fields (`article_id`, `title`, `keyword`)
- Theme tags and core themes were successfully generated
- No duplicate article IDs exist

**Step 6.2: Generate Validation Report**

Output confirmation block:

```markdown
## Theme Index Loaded ✅

**Lookback Window:** 24 months (November 2023 → October 2025)
**Calendars Found:** 24
**Topics Indexed:** 187

**Calendar Details:**
| Month | Topics | Example Title |
|-------|--------|---------------|
| October 2025 | 8 | Migrating WooCommerce Data to Custom REST API Endpoints |
| September 2025 | 9 | Securing WooCommerce Customer Data with Encryption |
| ... | ... | ... |

**Core Theme Saturation (Past 6 Months):**
| Core Theme | Count | Most Recent | Status |
|------------|-------|-------------|--------|
| data-migration | 2 | October 2025 | 🔴 SATURATED |
| security | 0 | March 2025 | 🟢 AVAILABLE |
| performance | 1 | August 2025 | 🔴 SATURATED |
| woocommerce-api | 1 | September 2025 | 🔴 SATURATED |
| ... | ... | ... | ... |

**Saturation Status Legend:**
- **🟢 AVAILABLE**: Core theme available (0 occurrences in past 6 months)
- **🔴 SATURATED**: Core theme blocked (1+ occurrences in past 6 months)

**Index Status:** ✅ READY
```

**Step 6.3: Save Index Files**

Save to the calendar directory:

1. **`theme-index.json`** — Full structured index
2. **`theme-index-validation.md`** — Human-readable validation report

```bash
mkdir -p "project/Calendar/2025/November"
# Save theme-index.json
# Save theme-index-validation.md
```

---

## Output Format

### theme-index.json

```json
{
  "metadata": {
    "target_month": "YYYY-MM",
    "lookback_months": 24,
    "calendars_analyzed": 24,
    "topics_indexed": 187,
    "generated_at": "ISO-8601 timestamp",
    "skill_version": "theme-index-builder v2.0",
    "includes_time_series": true
  },
  "theme_tags": ["tag1", "tag2", "tag3", ...],
  "core_themes": [
    {
      "theme": "theme-name",
      "source": "past_calendar+pillar|past_calendar|pillar|focus_area",
      "pattern_matches": ["keyword1", "keyword2", ...],
      "time_series": [N, N, N, ..., N],
      "time_series_labels": ["YYYY-MM", "YYYY-MM", ..., "YYYY-MM"],
      "trend_metrics": {
        "recent_avg": 0.00,
        "previous_avg": 0.00,
        "historical_avg": 0.00
      }
    },
    ...
  ],
  "topics": [
    {
      "article_id": "ART-YYYYMM-NNN",
      "title": "Article Title",
      "keyword": "target keyword phrase",
      "differentiation_angle": "Unique angle description",
      "primary_gap": "Coverage|Depth|Format|Recency",
      "calendar_month": "YYYY-MM",
      "months_ago": N,
      "theme_tags": ["tag1", "tag2", "tag3"],
      "core_themes": {
        "primary": "primary-theme",
        "secondary": "secondary-theme"
      }
    },
    ...
  ],
  "core_theme_saturation": [
    {
      "theme": "theme-name",
      "count_past_6_months": N,
      "most_recent_month": "YYYY-MM",
      "status": "SATURATED|AVAILABLE",
      "next_available": "YYYY-MM|now"
    },
    ...
  ]
}
```

### theme-index-validation.md

Human-readable report documenting:
- Lookback window and calendars analyzed
- Topics indexed count
- Calendar details table
- Core theme saturation table
- Index status and readiness confirmation

---

## Error Handling

### Scenario 1: No Past Calendars Found

**Response:**
- Output: "First calendar for this project — no deduplication required"
- Create empty index with metadata only
- Set `topics: []`, `theme_tags: []`, `core_themes: []`
- Validation report: "No past calendars found. This is the first content calendar."

### Scenario 2: Calendar File Parsing Fails

**Response:**
- Log which calendar(s) failed to parse
- Include error details (missing table, malformed markdown)
- Continue processing remaining calendars
- Mark failed calendars in validation report
- If >50% fail, abort and request manual intervention

### Scenario 3: Missing Expected Columns

**Response:**
- Log warning with calendar path and missing columns
- Skip topics with missing critical fields (`article_id`, `title`)
- Continue processing remaining topics
- Include warning in validation report

### Scenario 4: Theme Extraction Fails

**Response:**
- If no theme tags can be generated:
  - Fall back to basic keyword extraction only
  - Log warning: "Limited theme tags — using keyword-only analysis"
- If no core themes can be generated:
  - Use article IDs as unique identifiers only
  - Disable 6-month hard-block (no core theme data available)
  - Log warning: "Core theme extraction failed — deduplication limited"

---

## Quality Guidelines

### DO:
- Parse all calendars within lookback window systematically
- Generate theme tags from actual project content (not hardcoded lists)
- Validate that all topics have required fields
- Calculate core theme saturation for 6-month window
- Output structured JSON for programmatic consumption
- Provide human-readable validation report

### DON'T:
- Use hardcoded theme lists (must be dynamic)
- Skip calendars within lookback window without reason
- Proceed if >50% of calendars fail to parse
- Create index without validation confirmation
- Assume specific column names (detect from header row)

---

## Success Metrics

### Index Quality
- **Completeness:** 100% of calendars within lookback window indexed
- **Accuracy:** 100% of topics have required fields (`article_id`, `title`, `keyword`)
- **Theme Coverage:** ≥80% of topics assigned theme tags and core themes
- **Saturation Accuracy:** Core theme saturation correctly calculated for 6-month window

### Performance
- **Indexing Speed:** ≤3 minutes for 24 calendars with ~200 topics (includes time series)
- **Parsing Success:** ≥95% of calendars successfully parsed
- **Validation:** 100% of indexes validated before output
- **Time Series:** ≤30 seconds to build 24-month arrays for all core themes

---

## Integration

### Used By

**@signal-researcher Agent:**
- Invokes theme-index-builder during Phase 1, Step 1.2
- Uses theme index for deduplication in Phase 4, Step 4.3
- Passes theme index to topic-deduplicator skill

**Manual Invocation:**
```
Please use the theme-index-builder skill to rebuild the theme index for November 2025.

Parameters:
- target_month: "November 2025"
- lookback_months: 12
- calendar_directory: "project/Calendar/"
```

### Outputs Used By

**topic-deduplicator Skill:**
- Reads `theme-index.json` to compare candidates against past topics
- Uses `theme_tags` and `core_themes` for similarity scoring
- Enforces 6-month hard-block using `core_theme_saturation`

---

## Example Invocation

### Scenario: Building Index for November 2025 Calendar

**Input:**
```
target_month: "November 2025"
lookback_months: 24
calendar_directory: "project/Calendar/"
include_requirements_themes: true
include_time_series: true
```

**Process:**
1. Identify calendars: November 2023 → October 2025 (24 months)
2. Parse 24 calendar files, extract 187 topics
3. Generate 32 theme tags from content + requirements.md
4. Build 15 core themes from recurring patterns
5. Assign theme tags and core themes to all 187 topics
6. Build time series arrays (24 months) with trend metrics for each core theme
7. Calculate saturation: 7 core themes SATURATED, 8 AVAILABLE
8. Save `theme-index.json` and `theme-index-validation.md`

**Output Files:**
- `project/Calendar/2025/November/theme-index.json`
- `project/Calendar/2025/November/theme-index-validation.md`

**Validation Report:**
```markdown
## Theme Index Loaded ✅

**Lookback Window:** 24 months (November 2023 → October 2025)
**Calendars Found:** 24
**Topics Indexed:** 187

**Core Theme Saturation (Past 6 Months):**
| Core Theme | Count | Most Recent | Status |
|------------|-------|-------------|--------|
| data-migration | 2 | October 2025 | 🔴 SATURATED |
| security | 0 | March 2025 | 🟢 AVAILABLE |
| performance | 1 | August 2025 | 🔴 SATURATED |
| ... | ... | ... | ... |

**Index Status:** ✅ READY
```

---

## Notes

- This skill is **topic-agnostic** — works for any industry/domain
- Theme tags and core themes are **derived from actual content**, not hardcoded patterns
- Index is **versioned** (skill_version in metadata) for future compatibility
- Validation report is **mandatory** — no index is complete without it
- **Phase 3 Enhancement:** 24-month lookback with time series data for trend momentum analysis
- **Backward Compatible:** 12-month lookback still supported (set `lookback_months: 12`)
- Time series enables ACCELERATING/DECLINING momentum classification via trend-momentum-analyzer skill
