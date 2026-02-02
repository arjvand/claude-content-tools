---
name: write-article
description: Generate a complete article from the content calendar with research, writing, SEO, compliance, accessibility, and multi‑channel packaging (cross‑industry)
argument-hint: [calendar-path] [article-id] (e.g., "project/Calendar/2025/October/content-calendar.md ART-202510-001")
---

# Write Article from Calendar (Cross‑Industry)

Generate a publication‑ready article for **any industry or cause** based on a calendar entry, with built‑in research, compliance, accessibility, and packaging for your channels/CMS.

## Usage

```bash
/write-article project/Calendar/2025/October/content-calendar.md ART-202510-001
```

* First argument: Path to content calendar
* Second argument: Article ID (e.g., ART-202510-001)

---

## Workflow Overview

This command orchestrates multiple skill-specific agents in sequence:

```
Phase 1: Setup & Strategic Context Loading
├── 1A: requirements-loader → Validate config
├── 1B: Parse calendar entry → Extract article details
├── 1C: Load calendar context → Reuse gap pre-analysis (NEW - saves 5-10 min)
├── 1D: Content mix validation → Check format balance (OPTIONAL)
└── 1E: Theme deduplication → Check topic overlap (OPTIONAL)

Phase 2: Tier-Adaptive Research (Parallel)
├── Tier 1 (≥4.0): Full parallel research (15-20 min)
│   ├── @researcher (Agent 1) → Primary sources
│   └── @researcher (Agent 2) → Landscape analysis (skip gap if pre-analysis exists)
├── Tier 2 (3.0-3.9): Standard parallel research (10-15 min)
│   ├── @researcher (Agent 1) → Primary sources
│   └── @researcher (Agent 2) → Landscape analysis (skip gap if pre-analysis exists)
├── Tier 3 (2.0-2.9): Streamlined research (8-12 min)
│   └── @researcher (Agent 1 only) → Focused primary sources
├── Tier 4 (<2.0): Minimal research (5-8 min)
│   └── @researcher (Agent 2 only) → Light landscape overview
├── keyword-analyst → Keyword research
└── fact-checker (quick) → Verify research claims

Phase 3: Writing with Funnel Optimization
├── @writer → Draft article with funnel-stage tone/CTA (NEW)
├── media-discoverer → Find embeddable media
└── seo-optimizer → SEO optimization

Phase 4: Review & Export
├── @editor → Editorial review with funnel validation (NEW)
├── fact-checker (comprehensive) → Full claim verification
└── cms-exporter → CMS-ready export
```

---

## Phase 1: Setup & Configuration

### Step 1A: Load Configuration

**Invoke `requirements-loader` agent:**

```
Invoke requirements-loader agent for full config extraction.
```

**Expected Output:**
- Validated config JSON
- Brand voice, audience, compliance settings
- CMS platform configuration

**Blocking Gate:** If validation errors → STOP and report to user.

---

### Step 1B: Parse Calendar Entry

1. Read calendar file: `$1`
2. Extract details for Article ID: `$2`
   - Title, format, primary keyword
   - Funnel stage, publish date, CTA
   - SME requirements

3. Establish reference date:
   - Parse `publish_date` → `$REFERENCE_DATE`
   - If `$REFERENCE_DATE < TODAY` → `$HISTORICAL_MODE = true`

4. Create article directory:
   ```bash
   mkdir -p "project/Articles/[ARTICLE-ID]"
   ```

**Time:** <1 minute

---

### Step 1C: Load Calendar Context (NEW)

**Objective:** Reuse strategic analysis from calendar generation to avoid duplicate work

**Check for gap pre-analysis:**

```bash
# Extract year and month from calendar path
CALENDAR_DIR=$(dirname "$1")
PRE_ANALYSIS_PATH="${CALENDAR_DIR}/gap-pre-analysis/[ARTICLE-ID]-summary.md"

# Check if pre-analysis exists
if [ -f "$PRE_ANALYSIS_PATH" ]; then
  echo "✅ Gap pre-analysis found - loading calendar context"
else
  echo "⚠️ No gap pre-analysis found - will run full analysis in research phase"
fi
```

**If pre-analysis exists, extract strategic context:**

1. Read `gap-pre-analysis/[ARTICLE-ID]-summary.md`
2. Extract key context:
   - **Opportunity Score**: Numeric score (0.0-5.0)
   - **Tier Classification**: T1 (≥4.0), T2 (3.0-3.9), T3 (2.0-2.9), T4 (<2.0)
   - **Primary Differentiation Angle**: Main competitive advantage
   - **Top Opportunities**: 3-5 specific differentiation tactics
   - **Competitive Landscape Summary**: High-level market context

3. Save extracted context to:
   ```bash
   project/Articles/[ARTICLE-ID]/calendar-context.json
   ```

**Context JSON format:**

```json
{
  "source": "calendar_pre_analysis",
  "article_id": "ART-202510-001",
  "opportunity_score": 4.2,
  "tier": "T1",
  "primary_angle": "First comprehensive guide covering X feature",
  "top_opportunities": [
    "Coverage gap: 0/10 competitors address Y",
    "Depth gap: Only surface-level explanations elsewhere",
    "Format gap: No step-by-step tutorials available"
  ],
  "landscape_summary": "High competition (10+ ranking articles) but significant depth gaps",
  "skip_full_gap_analysis": true,

  "pre_analysis_date": "2025-10-01",
  "gap_breakdown": {
    "coverage": 5.0,
    "depth": 4.5,
    "format": 3.0,
    "recency": 4.8
  },
  "feasibility": "HIGH",
  "competitor_count": 8,
  "recommendation": "INCLUDE",
  "staleness": "FRESH",
  "days_old": 3
}
```

**Extraction Instructions:**

When extracting from gap-pre-analysis summary:

1. **Core fields** (already extracted):
   - opportunity_score, tier, primary_angle, top_opportunities, landscape_summary

2. **NEW: Extract gap breakdown scores** from pre-analysis:
   - Look for "Coverage Score:", "Depth Score:", "Format Score:", "Recency Score:"
   - Extract numeric values (0.0-5.0 scale)
   - If not found, default to null

3. **NEW: Extract metadata fields**:
   - feasibility: Look for "Feasibility: HIGH|MEDIUM|LOW"
   - competitor_count: Count competitors analyzed (e.g., "analyzed 8 competitors")
   - recommendation: Look for "INCLUDE|CONSIDER|EXCLUDE"
   - pre_analysis_date: Extract date from pre-analysis filename or content

4. **NEW: Calculate staleness**:
   ```bash
   # Calculate days between pre-analysis and today
   DAYS_OLD=$(( ($(date +%s) - $(date -d "$PRE_ANALYSIS_DATE" +%s)) / 86400 ))

   # Determine staleness status
   if [ $DAYS_OLD -lt 7 ]; then
     STALENESS="FRESH"
   elif [ $DAYS_OLD -lt 14 ]; then
     STALENESS="AGING"
   else
     STALENESS="STALE"
   fi
   ```

5. **Staleness warning**:
   - If STALE (>14 days): ⚠️ Warn that competitive landscape may have shifted
   - Suggest running fresh gap analysis or validating pre-analysis is still relevant

**Pass context flags to research phase:**
- `CALENDAR_CONTEXT_AVAILABLE = true|false`
- `SKIP_FULL_GAP_ANALYSIS = true|false` (only if pre-analysis exists AND staleness != STALE)
- `TIER_CLASSIFICATION = T1|T2|T3|T4` (for tier-adaptive research)
- `STALENESS_STATUS = FRESH|AGING|STALE` (for researcher awareness)

**Time:** 1.5-2.5 minutes (increased from 1-2 min due to additional field extraction)

---

### Step 1D: Content Mix Validation (OPTIONAL - 1 minute)

**Objective:** Ensure monthly format targets are balanced

**Check content mix allocation:**

1. Read parent calendar: `content-calendar.md`
2. Find "Content Mix Distribution" section
3. Extract format targets (e.g., 40% Analysis, 35% Tutorials, 25% News)

4. Count current format allocation in calendar:
   ```bash
   # Example: Count tutorials
   TUTORIAL_COUNT=$(grep "Format: Tutorial" content-calendar.md | wc -l)
   TOTAL_ARTICLES=$(grep "^## Article" content-calendar.md | wc -l)
   TUTORIAL_PCT=$((100 * TUTORIAL_COUNT / TOTAL_ARTICLES))
   ```

5. Compare current article format to targets:
   - If format allocation is **>10% over target**: ⚠️ Warn user
   - If format allocation is **within target**: ✅ Proceed

**Warning Example:**
```
⚠️ Content Mix Warning:
- Current Tutorial allocation: 45% (5 of 11 articles)
- Target Tutorial allocation: 35%
- This article is Tutorial format, pushing to 55%
- Consider switching to Analysis or News format to balance mix

Proceed? (Y/n)
```

**Document validation in meta.yml:**
```yaml
content_mix_validation:
  format: "Tutorial"
  target_pct: 35
  current_pct: 45
  status: "over_allocated"
  recommendation: "Consider alternative format for next article"
```

**Time:** 1 minute

---

### Step 1E: Theme Deduplication Check (OPTIONAL - 1 minute)

**Objective:** Catch unexpected topic overlap with past 6-12 months

**Check for theme index:**

```bash
# Look for theme index in calendar directory
THEME_INDEX="project/Calendar/theme-index.json"

if [ -f "$THEME_INDEX" ]; then
  echo "✅ Theme index found - checking for similar topics"
else
  echo "⚠️ No theme index - skipping deduplication check"
  # Optional: Suggest running theme-index-builder skill
fi
```

**If theme index exists:**

1. Read `theme-index.json`
2. Extract current article topic/title
3. Search for similar topics in past 6-12 months:
   - Exact keyword match: 🚨 High similarity
   - Semantic similarity >80%: ⚠️ Moderate similarity
   - Semantic similarity >70%: 🟡 Low similarity

4. If similarity detected:
   ```
   ⚠️ Topic Similarity Warning:
   - Current topic: "WooCommerce HPOS Migration Guide"
   - Similar past topic: "Migrating to WooCommerce HPOS" (July 2025)
   - Similarity score: 85%
   - Recommendation: Differentiate by focusing on [specific angle]

   Differentiation requirements:
   - Cover [aspect not covered in past article]
   - Target different audience segment
   - Update with latest developments since July

   Proceed? (Y/n)
   ```

**Pass differentiation requirements to research phase:**
- Add to research brief: "Differentiate from past article by..."
- Flag for extra attention in gap analysis

**Document validation in meta.yml:**
```yaml
theme_deduplication:
  similar_topics_found: true
  most_similar:
    article_id: "ART-202507-003"
    title: "Migrating to WooCommerce HPOS"
    similarity_score: 0.85
    date: "2025-07-15"
  differentiation_strategy: "Focus on edge cases and rollback procedures"
```

**Time:** 1 minute

---

## Phase 2: Research (Parallel Execution)

### Step 2A: Tier-Adaptive Parallel Research (UPDATED)

**Tier-Based Research Strategy:**

Based on opportunity score from Step 1C, allocate research depth:

- **Tier 1 (≥4.0)**: Full parallel research (both agents, comprehensive depth)
  - Time: 15-20 minutes (parallel execution)
  - Why: High-opportunity content deserves maximum research investment

- **Tier 2 (3.0-3.9)**: Standard parallel research (both agents, standard depth)
  - Time: 10-15 minutes (parallel execution)
  - Why: Solid opportunities warrant balanced research effort

- **Tier 3 (2.0-2.9)**: Streamlined research (Agent 1 only, focused depth)
  - Time: 8-12 minutes (single agent)
  - Why: Lower opportunities get efficient, targeted research

- **Tier 4 (<2.0)**: Minimal research (Agent 2 landscape only, light depth)
  - Time: 5-8 minutes (single agent)
  - Why: Minimal opportunities receive minimal research resources

**Default (no tier data)**: Standard Tier 2 research

---

**Launch Research Agents Based on Tier:**

**Tier 1 or Tier 2 - Launch BOTH agents IN PARALLEL:**

**Agent 1 - Primary Research (@researcher):**
```
Invoke @researcher agent for primary sources.
Article ID: [ARTICLE-ID]
Focus: Authoritative sources, evidence verification
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
Calendar Context: [Pass calendar-context.json if available]
Funnel Stage: [Awareness|Consideration|Decision] (from calendar entry)
Research Depth: [Full for T1, Standard for T2]
Output: project/Articles/[ARTICLE-ID]/research-primary.md
```

**Agent 2 - Landscape Research (@researcher):**
```
Invoke @researcher agent for landscape analysis.
Article ID: [ARTICLE-ID]
Focus: Competitive landscape, gap analysis, media discovery
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
Calendar Context: [Pass calendar-context.json if available]
Funnel Stage: [Awareness|Consideration|Decision] (from calendar entry)
Skip Gap Analysis: [true if pre-analysis exists, false otherwise]
Research Depth: [Full for T1, Standard for T2]
Output: project/Articles/[ARTICLE-ID]/research-landscape.md
```

**⚠️ PARALLEL NOTE:** Both agents MUST be launched in a SINGLE message.

---

**Tier 3 - Launch Agent 1 ONLY (Primary Sources):**

**Agent 1 - Streamlined Primary Research (@researcher):**
```
Invoke @researcher agent for focused primary sources.
Article ID: [ARTICLE-ID]
Focus: Core authoritative sources, essential evidence
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
Calendar Context: [Pass calendar-context.json if available]
Funnel Stage: [Awareness|Consideration|Decision] (from calendar entry)
Research Depth: Focused (streamlined mode)
Output: project/Articles/[ARTICLE-ID]/research-primary.md
```

Note: Skip Agent 2 and gap analysis for Tier 3. Use calendar pre-analysis context directly.

---

**Tier 4 - Launch Agent 2 ONLY (Landscape Overview):**

**Agent 2 - Minimal Landscape Research (@researcher):**
```
Invoke @researcher agent for landscape overview.
Article ID: [ARTICLE-ID]
Focus: Quick competitive overview, basic context
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
Calendar Context: [Pass calendar-context.json if available]
Skip Gap Analysis: true (use pre-analysis)
Research Depth: Light (minimal mode)
Output: project/Articles/[ARTICLE-ID]/research-landscape.md
```

Note: Skip Agent 1 for Tier 4. Minimal research for low-opportunity content.

---

**Time Investment by Tier:**
- T1: 15-20 minutes (maximum quality)
- T2: 10-15 minutes (standard quality)
- T3: 8-12 minutes (efficient quality)
- T4: 5-8 minutes (minimal viable quality)

---

### Step 2B: Keyword Analysis

**Invoke `keyword-analyst` agent:**

```
Invoke keyword-analyst agent in full mode.
Article ID: [ARTICLE-ID]
Primary Keyword: "[primary keyword from calendar entry]"
```

**Expected Output:**
- Volume, difficulty, intent classification
- Long-tail keyword expansion (10-15)
- Semantic keyword clusters (3-5)
- `project/Articles/[ARTICLE-ID]/keyword-research.md`

**Time:** 6-10 minutes

---

### Step 2C: Research Synthesis

**After parallel research completes:**

1. Merge `research-primary.md` + `research-landscape.md`
2. Create unified `research-brief.md`
3. Resolve conflicts (use conservative SME requirements)

---

### Step 2D: Quick Fact-Check

**Invoke `fact-checker` agent (quick mode):**

```
Invoke fact-checker agent in quick mode.
Article ID: [ARTICLE-ID]
Source: project/Articles/[ARTICLE-ID]/research-brief.md
```

**Expected Output:**
- Claim verification status
- `project/Articles/[ARTICLE-ID]/claim-audit-quick.md`

**Blocking Gate:** If FAIL → address critical claims before proceeding.

**Time:** 2-3 minutes

---

## Phase 3: Writing & Enhancement

### Step 3A: Write Draft

**Invoke `@writer` agent:**

```
Invoke @writer agent.
Article ID: [ARTICLE-ID]
Research Brief: project/Articles/[ARTICLE-ID]/research-brief.md
Keyword Research: project/Articles/[ARTICLE-ID]/keyword-research.md
Format: [format from calendar]
Tier: [T1|T2|T3|T4] (from calendar-context.json)
Opportunity Score: [score] (from calendar-context.json)
```

**Tier-Adaptive Depth Guidelines (NEW):**

Pass tier classification to writer with specific depth expectations:

- **T1 (Score ≥4.0):** Comprehensive, detailed content
  - Word count: 1,800-2,200 words
  - Depth: Expert-level tutorial or in-depth analysis
  - Examples: Multiple detailed code examples, comprehensive troubleshooting sections
  - Expected sections: 8-10 H2 sections with substantial depth

- **T2 (Score 3.0-3.9):** Standard, well-developed content
  - Word count: 1,400-1,800 words
  - Depth: Intermediate-level analysis or standard guide
  - Examples: 2-3 practical examples with explanations
  - Expected sections: 6-8 H2 sections

- **T3 (Score 2.0-2.9):** Focused, concise content
  - Word count: 1,000-1,400 words
  - Depth: Targeted guide or focused analysis
  - Examples: 1-2 key examples
  - Expected sections: 4-6 H2 sections

- **T4 (Score <2.0):** Quick overview or introduction
  - Word count: 800-1,200 words
  - Depth: Overview or basic introduction
  - Examples: Single illustrative example
  - Expected sections: 4-5 H2 sections

**@writer responsibilities:**
- Match voice & reading level from config
- Use plain language; include disclaimers where required
- Add alt text for images; ensure table headers
- **Apply tier-specific word count targets** (see above)
- Document tier classification in draft metadata

**Output:** `project/Articles/[ARTICLE-ID]/draft.md`

**Time:** 15-25 minutes

---

### Step 3B: Media Discovery

**Invoke `media-discoverer` agent:**

```
Invoke media-discoverer agent.
Topic: "[article topic/keyword]"
Content Type: [format from calendar]
Article ID: [ARTICLE-ID]
```

**Expected Output:**
- Ranked embed candidates (0-3)
- Placement recommendations
- `project/Articles/[ARTICLE-ID]/media-discovery.md`

**Time:** 3-5 minutes

---

### Step 3B.5: Media Embed Pre-Validation (NEW)

**Objective:** Validate embeddability BEFORE Phase 4 to prevent late-stage rework

**For articles with media recommendations only.** Skip if media-discovery.md shows 0 candidates.

**Process:**

1. **Read discovered media candidates:**
   ```bash
   # Extract candidate URLs from media-discovery.md
   CANDIDATES=$(grep "url:" project/Articles/[ARTICLE-ID]/media-discovery.md)
   ```

2. **Quick embeddability check for each candidate:**
   ```markdown
   For each media URL:
   - ✅ URL accessible (not 404, not private)
   - ✅ Platform supports embedding (YouTube, Twitter, LinkedIn, Instagram)
   - ✅ Content is public (not requires login)
   - ✅ Not geo-blocked (accessible from target regions)
   - ⚠️ Flag if any validation fails
   ```

3. **Validation methods:**
   - **YouTube:** Check video is public, not deleted
   - **Twitter/X:** Check tweet is public, account not private
   - **LinkedIn:** Check post is public, not requires login
   - **Instagram:** Check post is public, account not private

4. **Update media-discovery.md with validation status:**
   ```markdown
   ## Media Embed Pre-Validation Results

   **Candidates (3):**

   1. ✅ YouTube: https://youtube.com/watch?v=abc123
      - Status: VALIDATED
      - Embeddable: Yes
      - Public: Yes
      - Notes: Active, official WooCommerce channel

   2. ❌ Twitter: https://twitter.com/user/status/xyz789
      - Status: FAILED
      - Embeddable: No
      - Issue: Account is private
      - Action: Request alternative from writer

   3. ⚠️ LinkedIn: https://linkedin.com/posts/...
      - Status: WARNING
      - Embeddable: Yes (with caveats)
      - Issue: Requires LinkedIn login to view full content
      - Action: Consider alternative or use with disclaimer

   **Summary:**
   - Validated: 1/3
   - Failed: 1/3
   - Warnings: 1/3
   - Recommendation: Replace private Twitter embed before Phase 4
   ```

5. **If validation failures exist:**
   - Request writer to find alternative embeds (brief note in draft)
   - Update media-discovery.md with replacement candidates
   - Mark failed embeds for removal

**Benefits:**
- Prevents editor discovering broken embeds 10+ minutes later
- Writer can find replacements while context is fresh
- Reduces rework in Phase 4
- Ensures all embeds work before editorial review

**Decision Tree:**
- **All candidates validated:** Proceed to Step 3C
- **1-2 failures:** Note in draft, proceed (editor will verify)
- **All candidates failed:** Skip media embeds, proceed

**Time:** 2-3 minutes (saves 5-10 minutes in Phase 4 if issues found)

---

### Step 3C: SEO Optimization

**Invoke `seo-optimizer` agent:**

```
Invoke seo-optimizer agent.
Article: project/Articles/[ARTICLE-ID]/draft.md
Primary Keyword: "[primary keyword]"
Tier: [T1|T2|T3|T4] (from calendar-context.json)
```

**Tier-Adaptive SEO Targets (NEW):**

Pass tier classification to SEO optimizer for appropriate expectations:

- **T1 (Score ≥4.0):** Comprehensive SEO optimization
  - Target word count: 2,000+ words
  - Expected H2 sections: 8-10
  - Internal links: 5-7
  - Keyword density: 1.5-2%
  - Long-tail variations: 5+

- **T2 (Score 3.0-3.9):** Standard SEO optimization
  - Target word count: 1,600+ words
  - Expected H2 sections: 6-8
  - Internal links: 4-6
  - Keyword density: 1.2-1.8%
  - Long-tail variations: 3-5

- **T3 (Score 2.0-2.9):** Focused SEO optimization
  - Target word count: 1,200+ words
  - Expected H2 sections: 4-6
  - Internal links: 3-5
  - Keyword density: 1-1.5%
  - Long-tail variations: 2-3

- **T4 (Score <2.0):** Basic SEO optimization
  - Target word count: 1,000+ words
  - Expected H2 sections: 4-5
  - Internal links: 2-4
  - Keyword density: 1-1.2%
  - Long-tail variations: 1-2

**Expected Output:**
- Meta title (≤60 chars), meta description (150-160 chars)
- Keyword placement audit (tier-adjusted targets)
- Internal linking recommendations (tier-adjusted count)
- E-E-A-T cues
- `project/Articles/[ARTICLE-ID]/seo-audit.md`

**Time:** 2-3 minutes

---

## Phase 4: Review & Export

### Step 4A: Editorial Review

**Invoke `@editor` agent:**

```
Invoke @editor agent.
Article ID: [ARTICLE-ID]
Draft: project/Articles/[ARTICLE-ID]/draft.md
SEO Audit: project/Articles/[ARTICLE-ID]/seo-audit.md
Media Discovery: project/Articles/[ARTICLE-ID]/media-discovery.md
Tier: [T1|T2|T3|T4] (from calendar-context.json)
Opportunity Score: [score]
```

**Tier-Adaptive Review Stringency (NEW):**

Editor applies review rigor based on tier:

- **T1 (Score ≥4.0):** Comprehensive review
  - Full fact-check with comprehensive mode (15+ min)
  - Thorough claim verification across all sources
  - Detailed compliance review
  - Complete media embed validation
  - Full gap analysis mandate checklist validation

- **T2 (Score 3.0-3.9):** Standard review
  - Standard fact-check with comprehensive mode (10-12 min)
  - Verify key claims and statistics
  - Standard compliance checks
  - Media embed validation
  - Spot-check gap analysis tactics

- **T3 (Score 2.0-2.9):** Focused review
  - Targeted fact-check (8-10 min)
  - Verify statistics and legal/compliance claims only
  - Basic compliance checks
  - Quick media validation
  - Review only P1 gap tactics

- **T4 (Score <2.0):** Basic review
  - Light fact-check (5-8 min)
  - Verify only legal/compliance claims
  - Basic brand voice check
  - Skip media validation (low visual need)
  - Minimal gap validation

**@editor responsibilities:**
- Source verification, date-check facts (tier-adjusted depth)
- Compliance: claims policy, privacy, accessibility
- Brand voice consistency
- Media embed validation (if present, tier-adjusted)
- Add YAML frontmatter
- **Validate gap analysis mandate checklist** (tier-adjusted)

**Output:** `project/Articles/[ARTICLE-ID]/article.md`

**Time:** 10-15 minutes (T1-T2), 8-12 minutes (T3), 5-10 minutes (T4)

---

### Step 4B: Comprehensive Fact-Check

**Invoke `fact-checker` agent (comprehensive mode):**

```
Invoke fact-checker agent in comprehensive mode.
Article ID: [ARTICLE-ID]
Source: project/Articles/[ARTICLE-ID]/article.md
```

**Expected Output:**
- Full claim verification with web search
- `project/Articles/[ARTICLE-ID]/claim-audit-full.md`

**Blocking Gate:** If FAIL → revisions required before export.

**Time:** 5-10 minutes

---

### Step 4C: CMS Export

**Invoke `cms-exporter` agent:**

```
Invoke cms-exporter agent.
Article: project/Articles/[ARTICLE-ID]/article.md
Format: [from config - gutenberg | ghost | medium | html]
```

**Expected Output:**
- CMS-ready export file
- `project/Articles/[ARTICLE-ID]/article.html` (or format-specific)

**Time:** 30-60 seconds

---

## Phase 5: Finalization

### Step 5A: Generate Metadata

Create `project/Articles/[ARTICLE-ID]/meta.yml` with 20 sections:

1. Article Identification (ID, format, funnel stage)
2. Publication Details (title, slug, date, author)
3. Content Summary (excerpt, word count, personas)
4. SEO Metadata (meta title, description, keywords)
5. Links & Citations (internal, external)
6. Compliance & Legal (disclaimers, flags)
7. Accessibility (checklist, notes)
8. Visual Assets (featured image, diagrams)
9. Code Examples (language, status)
10. Embeds & Media (count, metadata)
11. Social & Distribution (LinkedIn, X, newsletter)
12. Competitive Analysis (scores, differentiation) **[ENHANCED - see below]**
13. SEO Performance Expectations (SERP, traffic)
14. Fact-Checking Status (quick, comprehensive)
15. Editorial Review (status, blockers)
16. Publication Readiness (recommendation)
17. Performance Tracking (KPIs)
18. File Inventory (all generated files)
19. Workflow Metadata (agents, timing)
20. Production Notes

---

### Section 12: Competitive Analysis (ENHANCED)

**Link calendar context for traceability:**

```yaml
12. competitive_analysis:
    gap_analysis_performed: true

    # ENHANCED: Expanded calendar context with gap breakdown
    calendar_context:
      source_file: "Calendar/2025/October/gap-pre-analysis/ART-202510-001-summary.md"
      opportunity_score: 4.2
      tier_classification: "T1"
      primary_angle: "First comprehensive guide covering HPOS edge cases"
      prediction_date: "2025-09-15"

      # NEW: Pre-analysis metadata
      pre_analysis_date: "2025-10-01"
      staleness_status: "FRESH"
      days_old_at_writing: 5

      # NEW: Gap breakdown scores (enables editor validation)
      gap_breakdown:
        coverage: 5.0
        depth: 4.5
        format: 3.0
        recency: 4.8

      # NEW: Strategic context
      feasibility: "HIGH"
      competitor_count: 8
      recommendation: "INCLUDE"

    # NEW: Required tactics validation structure (enables editor checklist)
    required_tactics:
      p1:
        - tactic: "Coverage gap: 0/10 competitors address custom query migration"
          gap_type: "coverage"
          gap_score: 5.0
          implemented: null    # Editor validates during Phase 2A
          evidence: ""         # Editor fills with section/line numbers
        - tactic: "Depth gap: Only surface-level explanations elsewhere"
          gap_type: "depth"
          gap_score: 4.5
          implemented: null
          evidence: ""
      p2:
        - tactic: "Format gap: No step-by-step tutorials available"
          gap_type: "format"
          gap_score: 3.0
          implemented: null
          evidence: ""
      p3: []  # Optional tactics

    # Existing fields
    unique_value_proposition: "[UVP from gap analysis]"
    primary_differentiation_angle: "[angle from gap-analysis-report.md]"
    p1_tactics_implemented: ["Tactic 1", "Tactic 2"]
    p2_tactics_implemented: ["Tactic 1"]
    competitive_landscape: "[summary]"

    # ENHANCED: Post-publication tracking with prediction baseline
    post_publication:
      opportunity_score_accuracy: null  # To be filled: (actual / predicted) × 100
      predicted_score: 4.2
      actual_score: null  # Calculated post-publication from performance data
      serp_position_actual: null  # Actual ranking achieved (target: top 3)
      traffic_actual_30d: null  # Actual traffic in first 30 days
      conversions_actual_30d: null  # Actual conversions (signups, downloads, etc.)
      measurement_date: null  # When metrics were collected
```

**Benefits:**
- Traceability from calendar prediction to article performance
- Enables retrospective analysis of opportunity scoring accuracy
- Documents tier classification used for resource allocation
- Links pre-analysis for context on strategic decisions

**Time:** 2-3 minutes

---

### Step 5B: Generate Summary Report

Create `project/Articles/[ARTICLE-ID]/summary.md`:

```markdown
## Article Generation Complete ✅

**Article ID:** [ARTICLE-ID]
**Topic:** [Topic]
**Format:** [format]
**Word Count:** XXXX (target: X–Y)
**Keyword:** [primary]

### Files Created
- research-brief.md, draft.md, article.md
- article.html, meta.yml, summary.md

### Validation
- ✅ Voice & reading level
- ✅ Accessibility checklist
- ✅ SEO/E‑E‑A‑T
- ✅ Compliance & disclaimers

**Status:** Ready for publication
```

---

## Output Files

| File | Description |
|------|-------------|
| `research-primary.md` | Primary sources (parallel Agent 1) |
| `research-landscape.md` | Landscape analysis (parallel Agent 2) |
| `research-brief.md` | Merged research brief |
| `keyword-research.md` | Keyword analysis |
| `media-discovery.md` | Embed candidates |
| `claim-audit-quick.md` | Quick fact-check |
| `draft.md` | Writer output |
| `seo-audit.md` | SEO recommendations |
| `claim-audit-full.md` | Comprehensive fact-check |
| `article.md` | Final article |
| `article.html` | CMS export |
| `meta.yml` | Full metadata (20 sections) |
| `summary.md` | Production summary |

---

## Time Estimate

| Phase | Duration | Notes |
|-------|----------|-------|
| Phase 1: Setup & Context | 3-6 minutes | +2-4 min for calendar context loading |
| Phase 2: Tier-Adaptive Research | 5-20 minutes | **Varies by tier** (see breakdown below) |
| Phase 3: Writing & Enhancement | 20-35 minutes | No change |
| Phase 4: Review & Export | 15-25 minutes | No change |
| Phase 5: Finalization | 5-10 minutes | No change |
| **Total (Tier 1)** | **48-96 minutes** | High-opportunity articles (full research) |
| **Total (Tier 2)** | **43-91 minutes** | Standard articles (standard research) |
| **Total (Tier 3)** | **41-89 minutes** | Lower-opportunity (streamlined research) |
| **Total (Tier 4)** | **38-86 minutes** | Minimal-opportunity (light research) |

### Phase 2 Research Time by Tier (with gap analysis reuse)

| Tier | Opportunity Score | Research Depth | Time |
|------|-------------------|----------------|------|
| T1 | ≥4.0 | Full parallel (both agents) | 15-20 minutes |
| T2 | 3.0-3.9 | Standard parallel (both agents) | 10-15 minutes |
| T3 | 2.0-2.9 | Streamlined (Agent 1 only) | 8-12 minutes |
| T4 | <2.0 | Minimal (Agent 2 only) | 5-8 minutes |

**Key Efficiency Gains:**
- **Gap Analysis Reuse**: Saves 5-10 minutes per article when pre-analysis exists
- **Tier-Adaptive Research**: Optimizes resource allocation (high-value gets more, low-value gets less)
- **Net Effect**: 3-10 minute time savings per article while maintaining/improving quality

---

## Error Handling

If any phase fails:
1. Report exact step and probable cause
2. Suggest fix
3. Allow resume from last successful phase

---

## Quick Reference

```bash
# Generate article
/write-article project/Calendar/2025/October/content-calendar.md ART-202510-001

# Check output
ls project/Articles/ART-202510-001/

# Verify word count
wc -w project/Articles/ART-202510-001/article.md
```
