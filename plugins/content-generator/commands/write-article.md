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
  "skip_full_gap_analysis": true
}
```

**Pass context flags to research phase:**
- `CALENDAR_CONTEXT_AVAILABLE = true|false`
- `SKIP_FULL_GAP_ANALYSIS = true|false` (only if pre-analysis exists)
- `TIER_CLASSIFICATION = T1|T2|T3|T4` (for tier-adaptive research)

**Time:** 1-2 minutes

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
```

**@writer responsibilities:**
- Match voice & reading level from config
- Use plain language; include disclaimers where required
- Add alt text for images; ensure table headers
- Maintain word count targets

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

### Step 3C: SEO Optimization

**Invoke `seo-optimizer` agent:**

```
Invoke seo-optimizer agent.
Article: project/Articles/[ARTICLE-ID]/draft.md
Primary Keyword: "[primary keyword]"
```

**Expected Output:**
- Meta title (≤60 chars), meta description (150-160 chars)
- Keyword placement audit
- Internal linking recommendations (3-5)
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
```

**@editor responsibilities:**
- Source verification, date-check facts
- Compliance: claims policy, privacy, accessibility
- Brand voice consistency
- Media embed validation (if present)
- Add YAML frontmatter

**Output:** `project/Articles/[ARTICLE-ID]/article.md`

**Time:** 10-15 minutes

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
12. Competitive Analysis (scores, differentiation)
13. SEO Performance Expectations (SERP, traffic)
14. Fact-Checking Status (quick, comprehensive)
15. Editorial Review (status, blockers)
16. Publication Readiness (recommendation)
17. Performance Tracking (KPIs)
18. File Inventory (all generated files)
19. Workflow Metadata (agents, timing)
20. Production Notes

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
