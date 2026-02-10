---
name: content-calendar
description: Generate a monthly content calendar based on requirements.md configuration (cross-industry)
argument-hint: [month year] (e.g., "October 2025")
---

# Generate Content Calendar

Create a comprehensive content calendar for **$ARGUMENTS** based on editorial requirements from `requirements.md`.

**This command is cross-industry** — adapts to any brand, sector, or program defined in `requirements.md`.

---

## Reference Date Context

Parse `$ARGUMENTS` to establish:

- `$TARGET_MONTH` — Month name (e.g., "October")
- `$TARGET_YEAR` — Year (e.g., "2025")
- `$REFERENCE_DATE` — First day of target month (e.g., "2025-10-01")

**Historical Mode:** If `$REFERENCE_DATE` is in the past, set `$HISTORICAL_MODE = true` and apply date-filtered searches. Do NOT include topics about events after `$REFERENCE_DATE`.

---

## Workflow Overview

This command orchestrates multiple skill-specific agents in sequence:

```
Phase 1: Foundation
├── requirements-loader → Validate config
├── gsc-analyst (calendar mode) → GSC signals (if configured)
├── theme-indexer → Build theme index (if past calendars exist)
└── keyword-planner → Strategic keyword planning

Phase 2: Generation
├── @signal-researcher → Generate topic candidates (trend + GSC demand signals)
├── keyword-analyst (batch) → Validate keywords
├── gap-analyst (batch) → Competitive analysis (GSC-confirmed gaps pre-validated)
└── topic-deduplicator → Check for duplicates

Phase 3: Finalization
├── sme-assessor → Complexity assessment
└── Generate calendar table
```

---

## Phase 1: Foundation & Strategy

### Step 1: Load Configuration

**Invoke `requirements-loader` agent:**

```
Invoke requirements-loader agent for full config extraction.
```

**Expected Output:**
- Validated config JSON
- Any errors/warnings

**Blocking Gate:** If validation errors → STOP and report to user.

**Time:** <30 seconds

---

### Step 0C: GSC Search Signals (Conditional)

**Condition:** `config.analytics.gsc` exists and export path is valid. If not configured, skip silently and proceed to Step 1B.

**Invoke `gsc-analyst` agent (calendar integration mode):**

```
Invoke gsc-analyst agent in calendar integration mode.
Calendar: $TARGET_YEAR/$TARGET_MONTH
```

**Expected Output:**
- `project/Calendar/{Year}/{Month}/gsc-calendar-signals.md`
- New content opportunities (queries with no dedicated page, `gsc_validated: true`)
- Expansion targets (pages at position 11-50 with high impressions)
- Refresh candidates (good position, CTR below expected)
- Pillar gap analysis (query coverage per configured pillar)
- Seasonal patterns from Chart.csv (if available)

**If GSC data unavailable or stale:** Log info, proceed without GSC signals. All downstream steps work without GSC data.

**Time:** 3-4 minutes (skipped instantly if GSC not configured)

---

### Step 1B: Build Theme Index

**Invoke `theme-indexer` agent:**

```
Invoke theme-indexer agent.
Lookback: 12 months
```

**Expected Output:**
- Theme index with past topics
- Core theme saturation levels
- Articles indexed count

**Blocking Gate:** If past calendars exist but no theme index → STOP.

**Time:** 3-5 minutes

---

### Step 1C: Strategic Keyword Planning

**Invoke `keyword-planner` agent:**

```
Invoke keyword-planner agent in strategic planning mode for $TARGET_MONTH $TARGET_YEAR.
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
```

**Expected Output:**
- Topic cluster architecture
- Funnel-mapped keywords
- Prioritized keyword roadmap (Tier 1-4)
- `project/Calendar/{Year}/{Month}/keyword-strategy.md`

**Blocking Gate:** Verify keyword strategy before proceeding.

**Time:** 15-20 minutes

---

## Phase 2: Generation & Analysis

### Step 2: Generate Topic Candidates

**Invoke `@signal-researcher` agent:**

```
Invoke @signal-researcher agent.

Target: $TARGET_MONTH $TARGET_YEAR content calendar
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE

Using keyword strategy from: project/Calendar/{Year}/{Month}/keyword-strategy.md

GSC Signals (if available): project/Calendar/{Year}/{Month}/gsc-calendar-signals.md
- Treat GSC new content opportunities as supplementary demand signals
- GSC-backed candidates get `gsc_validated: true` flag and boosted priority
- Topic candidates come from TWO sources: trend-based signals AND GSC demand signals

Generate 12-15 topic candidates with:
- Keyword-aligned opportunities (prioritize Tier 1-2)
- Trend signals appropriate to reference date
- GSC demand signals (if gsc-calendar-signals.md exists)
- Format recommendations per requirements.md
```

**Expected Output:**
- 12-15 quality-screened topic candidates
- `project/Calendar/{Year}/{Month}/topic-candidates.md`
- Candidates sourced from GSC data are flagged with `gsc_validated: true`

**Time:** 10-20 minutes

---

### Step 2A: Keyword Pre-Validation

**Invoke `keyword-analyst` agent (batch mode):**

```
Invoke keyword-analyst agent in batch mode.
Keywords: [extracted from topic-candidates.md]
```

**Expected Output:**
- Keyword validation results for all candidates
- Volume/difficulty/intent for each
- Feasibility recommendations
- `project/Calendar/{Year}/{Month}/keyword-pre-validation/`

**Decision:** Flag topics with difficulty >70 or volume=LOW for review.

**Time:** 4-6 minutes

---

### Step 2B: Competitive Gap Pre-Analysis

**Invoke `gap-analyst` agent (batch mode):**

```
Invoke gap-analyst agent in batch mode.
Topics: [keyword-validated topics from Step 2A]

GSC Pre-Validation (if gsc-calendar-signals.md exists):
- Topics flagged with `gsc_validated: true` represent GSC-confirmed content gaps
  (queries with real search demand but no dedicated page)
- For GSC-confirmed gaps: skip full competitor analysis, assign minimum Tier 2
  (GSC data already proves demand exists)
- Still run differentiation angle analysis for GSC-confirmed topics
```

**Expected Output:**
- Opportunity scores (1-5) for each topic
- Tier classification (Tier 1-4)
- Primary differentiation angles
- `project/Calendar/{Year}/{Month}/gap-pre-analysis/`
- `batch-results.json`
- GSC-confirmed topics marked with `gsc_pre_validated: true` in results

**Time:** 15-20 minutes (parallelized, faster for GSC-confirmed gaps)

---

### Step 2C: Deduplication Verification

**Invoke `topic-deduplicator` agent:**

```
Invoke topic-deduplicator agent.
Topic Candidates: [topics from gap analysis]
Reference Date: $REFERENCE_DATE
```

**Expected Output:**
- Approved/blocked status for each topic
- Similarity scores
- Differentiation requirements for 7+ month topics

**Blocking Gate:** Remove blocked topics from selection.

**Time:** 3-5 minutes

---

## Phase 3: Finalization

### Step 3: SME Assessment

**Invoke `sme-assessor` agent:**

```
Invoke sme-assessor agent.
Topics: [approved topics from deduplication]
```

**Expected Output:**
- Complexity scores per topic
- SME requirement levels (None/Optional/Recommended/Required)
- Expertise areas needed

**Time:** 30-60 seconds

---

### Step 4: Generate Calendar Table

Using results from all agents, generate the content calendar:

**Selection Criteria:**
- Minimum 60% Tier 1 topics
- Balanced content mix per requirements.md
- No blocked (duplicate) topics
- Feasible within resources

**Calendar Format:**

| ID | Title | Keyword | Format | Gap Score | Tier | Keyword Diff | Funnel | GSC | SME | Status |
|----|-------|---------|--------|-----------|------|--------------|--------|-----|-----|--------|
| ART-YYYYMM-001 | ... | ... | ... | 4.5 | T1 | 42 | Consider | Yes | None | Pending |

The **GSC** column indicates whether the topic was validated by GSC search demand data (`Yes` = `gsc_validated: true`, `—` = trend-based only).

**Include:**
- Gap Analysis Summary (Tier distribution)
- GSC Signal Summary (if GSC data was available: new content opportunities used, expansion targets, refresh candidates)
- Excluded Topics with reasons
- SME Requirements Summary
- Content Mix Distribution

**Save to:** `project/Calendar/{Year}/{Month}/content-calendar.md`

---

## Output Files

| File | Description |
|------|-------------|
| `content-calendar.md` | Final calendar with all metadata |
| `gsc-calendar-signals.md` | GSC demand signals (if GSC configured) |
| `keyword-strategy.md` | Strategic keyword plan |
| `keyword-strategy.json` | Structured keyword data |
| `topic-candidates.md` | Raw topic candidates |
| `keyword-pre-validation/*.md` | Keyword validation reports |
| `gap-pre-analysis/*.md` | Individual gap summaries |
| `gap-pre-analysis/batch-results.json` | Batch gap analysis results |

---

## Time Estimate

| Phase | Duration |
|-------|----------|
| Phase 1: Foundation | 20-25 minutes |
| Phase 2: Generation | 30-45 minutes |
| Phase 3: Finalization | 5-10 minutes |
| **Total** | **55-80 minutes** |

---

## Quality Outcomes

- **Keyword-Validated:** All topics verified for search demand
- **Competitive Intelligence:** Differentiation strategy per topic
- **Deduplication:** No redundant content
- **SME Planning:** Clear expert requirements
- **Strategic Alignment:** Funnel-balanced, pillar-organized

---

## Quick Reference

```bash
# Generate calendar
/content-calendar January 2026

# Historical calendar (past date)
/content-calendar October 2021

# Check output
ls project/Calendar/2026/January/
```
