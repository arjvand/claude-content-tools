---
name: update-article
description: Update an existing article with edits, content changes, or structural modifications while maintaining quality standards
argument-hint: [article-id] [update-description] (e.g., "ART-202511-001 Fix the broken link in prerequisites and update WordPress version to 6.7")
---

# Update Article (Cross-Industry)

Update an existing publication-ready article while maintaining brand voice, SEO optimization, and quality standards. Supports minor fixes, moderate adjustments, and major structural changes.

## Usage

```bash
# Standard update with description
/update-article ART-202511-001 Fix the broken link in the prerequisites section
/update-article ART-202511-002 Update the WordPress version references from 6.5 to 6.7
/update-article ART-202511-003 Add a new section about accessibility best practices

# GSC-driven batch modes
/update-article --quick-wins              # Process all title/meta rewrite candidates
/update-article --striking-distance       # Report on position 10-20 articles
```

* First argument: Article ID (e.g., ART-202511-001) or batch flag (`--quick-wins`, `--striking-distance`)
* Second argument: Natural language description of the update request (for single-article mode)

---

## Workflow Overview

This command routes updates through appropriate validation based on complexity:

```
Phase 1: Setup
├── requirements-loader → Validate config
├── Locate article → Verify exists
├── [If GSC available] gsc-analyst (article mode) → Ranking context
└── Classify update → MINOR | MODERATE | MAJOR (auto-classified if GSC triggers)

Phase 2: Apply Changes (by tier)
├── MINOR → Direct edit (no agents)
├── MODERATE → Direct edit → @editor
└── MAJOR → @writer → @editor

Phase 3: Validation (by tier)
├── MINOR → Word count only
├── MODERATE → fact-checker (if new claims) → seo-optimizer
└── MAJOR → fact-checker → seo-optimizer → cms-exporter

Phase 4: Finalization
├── Update meta.yml changelog
└── Generate summary report
```

**Batch Modes (GSC-driven):**

```
Quick Wins Batch:
├── requirements-loader → Validate config
├── gsc-analyst (article mode) → Identify CTR underperformers
├── Filter: position <10, CTR <50% expected
├── For each candidate → MINOR update (title/meta rewrite)
└── Generate batch summary report

Striking Distance Report:
├── requirements-loader → Validate config
├── gsc-analyst (full analysis mode) → Position 10-20 articles
├── For each article → List target queries + recommended actions
└── Generate striking distance report
```

---

## Phase 1: Setup & Classification

### Step 1A: Load Configuration

**Invoke `requirements-loader` agent:**

```
Invoke requirements-loader agent for full config extraction.
```

**Blocking Gate:** If validation errors → STOP.

---

### Step 1B: Locate Article

```bash
ls -la "project/Articles/$1/"
```

**Error handling:** If not found, list available articles and exit.

---

### Step 1C: GSC Ranking Context (Conditional)

**Condition:** `config.analytics.gsc` exists and export path is valid.

**Invoke `gsc-analyst` agent in article optimization mode:**

```
Invoke gsc-analyst agent in article optimization mode.
Keyword: "[from meta.yml primary_keyword]"
Article ID: [ARTICLE-ID]
Page URL: [from meta.yml url field, if available]
```

**Output:** `project/Articles/[ARTICLE-ID]/gsc-article-data.md` with:
- Current position and impressions for target keyword
- CTR vs expected CTR at current position
- Query ecosystem (all queries driving impressions)
- Position trend (if multiple exports available)

**If GSC unavailable:** Skip silently, proceed to Step 1D.

**Time:** 2-3 minutes

---

### Step 1D: Classify Update Request

Analyze `$2` and auto-classify:

| Tier | Keywords | Scope | Agent Workflow |
|------|----------|-------|----------------|
| **MINOR** | fix, typo, spelling, grammar, broken link, formatting | Surface-level | Direct edit only |
| **MODERATE** | update, change, modify, add example, clarify, SEO | Content within structure | @editor review |
| **MAJOR** | add section, restructure, rewrite, expand | Structural changes | @writer + @editor |

**GSC-Driven Auto-Classification (when GSC data available):**

If no explicit update description is provided (or if using GSC signals to recommend updates), auto-classify based on GSC performance data:

| GSC Signal | Auto-Classification | Rationale |
|------------|-------------------|-----------|
| CTR below expected at position <10 | **MINOR** | Title/meta description rewrite needed |
| Position 10-20 with high impressions (>100/month) | **MODERATE** | Content strengthening to push into top 10 |
| Position declining >5 places vs previous export | **MAJOR** | Comprehensive refresh required |
| Multiple untargeted queries with impressions | **MODERATE** | Add sections addressing uncovered queries |
| Question-form queries not addressed | **MODERATE** | Add FAQ section for GSC question queries |

**CTR Benchmark Table (site-specific if available, defaults below):**

| Position | Expected CTR | "Below Expected" Threshold |
|----------|-------------|---------------------------|
| 1 | ~30% | <20% |
| 2 | ~16% | <10% |
| 3 | ~11% | <7% |
| 4-5 | ~6-8% | <4% |
| 6-10 | ~3% | <1.5% |

**Time:** <1 minute

---

## Phase 2: Apply Changes

### For MINOR Updates

Apply changes directly:

1. Identify specific changes from update request
2. Make targeted edits to `article.md`
3. Show diff preview
4. **Skip to Phase 4** (metadata update)

**Time:** 2-5 minutes

---

### For MODERATE Updates

Apply changes with editor review:

1. Make targeted edits to `article.md`
2. Show diff preview

**Invoke `@editor` agent:**

```
Invoke @editor agent.
Article ID: [ARTICLE-ID]
Draft: project/Articles/[ARTICLE-ID]/article.md
Update Type: MODERATE
Update Description: $2
```

**Time:** 10-15 minutes

---

### For MAJOR Updates

**Invoke `@writer` agent:**

```
Invoke @writer agent.
Article ID: [ARTICLE-ID]
Current Article: project/Articles/[ARTICLE-ID]/article.md
Research Brief: project/Articles/[ARTICLE-ID]/research-brief.md
Update Request: $2
Mode: Update (preserve existing structure except for requested changes)
```

**Then invoke `@editor` agent:**

```
Invoke @editor agent.
Article ID: [ARTICLE-ID]
Draft: project/Articles/[ARTICLE-ID]/article.md
Update Type: MAJOR
Update Description: $2
```

**Time:** 20-30 minutes

---

## Phase 3: Validation Suite

### Step 3A: Word Count Check (ALWAYS)

```bash
wc -w "project/Articles/$1/article.md"
```

Compare against configured range.

---

### Step 3B: Fact-Checker (if new claims)

**Invoke `fact-checker` agent (if MODERATE/MAJOR with new claims):**

```
Invoke fact-checker agent in comprehensive mode.
Article ID: [ARTICLE-ID]
Source: project/Articles/[ARTICLE-ID]/article.md
Focus: [Specific new claims from update]
```

**Blocking Gate:** If FAIL → block, request user verification.

**Time:** 5-10 minutes

---

### Step 3C: SEO Optimization (MODERATE/MAJOR)

**Invoke `seo-optimizer` agent:**

```
Invoke seo-optimizer agent.
Article: project/Articles/[ARTICLE-ID]/article.md
Primary Keyword: "[from meta.yml]"
```

**Time:** 2-3 minutes

---

### Step 3D: CMS Export (MAJOR only)

**Invoke `cms-exporter` agent:**

```
Invoke cms-exporter agent.
Article: project/Articles/[ARTICLE-ID]/article.md
Format: [from config]
```

**Time:** 30-60 seconds

---

## Phase 4: Finalization

### Step 4A: Update Metadata

Update `meta.yml` with:

```yaml
last_updated: "YYYY-MM-DD"
word_count: [new count]
status: "updated"

changelog:
  - date: "YYYY-MM-DD"
    type: "minor|moderate|major"
    description: "[Brief description from $2]"
    changes:
      - file: article.md
        summary: "[What was changed]"
```

---

### Step 4B: Summary Report

```markdown
## Article Update Complete

**Article ID:** $1
**Title:** [from meta.yml]
**Update Type:** [Minor/Moderate/Major]
**Date:** YYYY-MM-DD

### Update Request
> $2

### Changes Applied
- [Change 1 summary]
- [Change 2 summary]

### Validation Results
| Check | Status | Notes |
|-------|--------|-------|
| Word Count | [PASS/WARN] | [X] words |
| Fact-Check | [PASS/SKIP] | [N] claims verified |
| SEO | [PASS/SKIP] | Keyword density [X]% |
| Editor Review | [APPROVED/SKIP] | [Quality rating] |

**Status:** Ready for republication
```

---

## GSC Batch Modes

### Quick Wins Batch (`--quick-wins`)

**Purpose:** Process all title/meta description rewrite candidates in a single batch pass. Highest ROI-to-effort ratio.

**Prerequisites:** `config.analytics.gsc` exists with valid export data.

**Process:**

1. **Load GSC data:** Invoke `gsc-analyst` in full analysis mode.

2. **Filter candidates:** Identify articles where:
   - Position <10 (already ranking well)
   - CTR <50% of expected CTR at that position
   - Minimum 50 impressions/month (enough data to matter)

3. **For each candidate:**
   - Load current `article.md` and `meta.yml`
   - Analyze current title tag and meta description
   - Identify the primary query driving impressions
   - Rewrite title tag to better match query intent and improve CTR
   - Rewrite meta description with stronger call-to-action
   - Apply as MINOR update (direct edit, no agent review)
   - Update `meta.yml` changelog

4. **Generate batch report:**

```markdown
## Quick Wins Batch Report

**Date:** YYYY-MM-DD
**GSC Export Date:** YYYY-MM-DD
**Candidates Found:** [N]
**Candidates Processed:** [N]

### Updates Applied

| Article ID | Keyword | Position | Old CTR | Expected CTR | Change |
|------------|---------|----------|---------|-------------|--------|
| ART-xxx | keyword | 3 | 4.2% | 11% | Title + meta rewritten |
| ... | ... | ... | ... | ... | ... |

### Estimated Impact
**Total potential click gain:** [sum of (impressions x (expected_ctr - current_ctr))]
```

**Output:** `project/GSC/reports/quick-wins-batch-{date}.md`

**Time:** 2-5 minutes per candidate, typically 5-15 candidates per batch.

---

### Striking Distance Report (`--striking-distance`)

**Purpose:** Auto-generate a prioritized list of articles at position 10-20 with specific action items to push each into the top 10.

**Prerequisites:** `config.analytics.gsc` exists with valid export data.

**Process:**

1. **Load GSC data:** Invoke `gsc-analyst` in full analysis mode.

2. **Filter striking distance articles:** Identify pages where:
   - Average position 10-20 for at least one query
   - Minimum 100 impressions/month
   - Page maps to a known article ID (via meta.yml URL or slug matching)

3. **For each article, analyze:**
   - All queries driving impressions (the query ecosystem)
   - Which queries are in striking distance (position 10-20)
   - Content gaps: queries with impressions but no dedicated section in article
   - CTR performance vs position benchmarks
   - Recommended update type (MODERATE or MAJOR)

4. **Generate striking distance report:**

```markdown
## Striking Distance Report

**Date:** YYYY-MM-DD
**GSC Export Date:** YYYY-MM-DD
**Articles in Striking Distance:** [N]
**Total Potential Click Gain:** [estimated monthly clicks if moved to top 5]

### Priority Rankings

#### 1. [Article Title] (ART-xxx)
**Current Position:** 14 | **Impressions:** 2,400/month | **Current Clicks:** 36/month
**Potential Clicks (if top 5):** ~144/month (+108)

**Target Queries:**
| Query | Position | Impressions | Action |
|-------|----------|-------------|--------|
| "primary keyword" | 14 | 1,800 | Strengthen H1 section |
| "long tail variant" | 17 | 600 | Add dedicated H2 section |

**Recommended Update:** MODERATE
**Actions:**
- Add 300-500 words covering "long tail variant"
- Strengthen internal linking from authority pages
- Update meta title to include "long tail variant"

---

#### 2. [Next Article...]
...
```

**Output:** `project/GSC/reports/striking-distance-{date}.md`

**Time:** 5-10 minutes for report generation.

---

## Time Estimate

| Update Type | Duration |
|-------------|----------|
| MINOR | 2-5 minutes |
| MODERATE | 15-25 minutes |
| MAJOR | 30-45 minutes |
| Quick Wins Batch | 2-5 min/article |
| Striking Distance Report | 5-10 minutes |

---

## Error Handling

| Error | Response |
|-------|----------|
| Article not found | List available articles |
| Validation warning | Show options: proceed, fix, abort |
| Unverified claims | Block until sources provided |

---

## Quick Reference

```bash
# Fix typo (MINOR)
/update-article ART-202511-001 Fix the typo "recieve" in paragraph 2

# Update version (MODERATE)
/update-article ART-202511-001 Update WordPress version from 6.5 to 6.7

# Add section (MAJOR)
/update-article ART-202511-001 Add new section about accessibility best practices

# GSC-driven batch: rewrite underperforming titles/meta (requires GSC data)
/update-article --quick-wins

# GSC-driven report: articles close to top 10 (requires GSC data)
/update-article --striking-distance
```

---

## Output Files

| File | Updated When |
|------|--------------|
| `article.md` | Always |
| `meta.yml` | Always (changelog) |
| `gsc-article-data.md` | When GSC data available (Step 1C) |
| `claim-audit-full.md` | If new claims (MODERATE/MAJOR) |
| `seo-audit.md` | MODERATE/MAJOR |
| `article.html` | MAJOR only |
| `project/GSC/reports/quick-wins-batch-{date}.md` | Quick Wins batch mode |
| `project/GSC/reports/striking-distance-{date}.md` | Striking Distance report |
