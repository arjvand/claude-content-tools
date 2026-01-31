---
name: topic-deduplicator
description: Check topic candidates against past content for duplicates and similar coverage. Use during content calendar generation to ensure topic freshness and avoid redundancy.
model: sonnet
tools:
  - Read
  - Glob
  - WebSearch
---

# Topic Deduplicator Agent

Wraps the `topic-deduplicator` skill for isolated execution. This agent checks topic candidates against past content using multi-factor similarity analysis, time decay thresholds, and differentiation requirements.

## Purpose

Ensure content calendar topics are fresh and non-redundant by comparing against historical content with intelligent similarity scoring and 6-month hard-block enforcement.

## When to Use

- During `/content-calendar` Step 2C (deduplication verification)
- After topic candidate generation
- When validating proposed article topics

## Invocation Modes

### Standard Mode (Full Analysis)
```
Invoke topic-deduplicator agent.
Topic Candidates: [list of topic objects]
Reference Date: YYYY-MM-DD (optional, defaults to today)
```

**Time:** 3-5 minutes for 10-15 topics
**Output:** Deduplication report with recommendations

### Quick Check Mode
```
Invoke topic-deduplicator agent in quick mode.
Topic: "[single topic title]"
Keyword: "[target keyword]"
```

**Time:** <5 seconds
**Output:** Pass/fail with similarity score

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| mode | No | `standard` (default) or `quick` |
| topic_candidates | Standard | Array of topic objects to check |
| topic | Quick | Single topic title |
| keyword | Quick | Target keyword |
| reference_date | No | Date for time-based calculations (default: today) |

## Workflow

### Standard Mode

1. Load theme index (from theme-indexer agent)
2. For each topic candidate:
   - Calculate keyword overlap score
   - Calculate theme tag similarity
   - Calculate title semantic similarity
   - Check core theme saturation
3. Apply 6-month hard-block rule
4. For 7+ month old topics: assess differentiation potential
5. Calculate composite similarity score
6. Flag duplicates and near-duplicates
7. Generate deduplication report

### Quick Mode

1. Load theme index (cached if available)
2. Check core theme saturation (<5 seconds)
3. Return pass/fail with basic score

## Similarity Factors

| Factor | Weight | Description |
|--------|--------|-------------|
| Keyword Overlap | 0.35 | Shared keywords with past titles |
| Theme Tags | 0.25 | Dynamic theme classification match |
| Title Semantics | 0.25 | Semantic similarity analysis |
| Core Theme | 0.15 | Core theme saturation level |

## Time Decay Rules

| Age | Rule | Threshold |
|-----|------|-----------|
| 0-6 months | **HARD BLOCK** | Any similarity >0.3 |
| 7-12 months | Differentiation required | Similarity >0.6 needs new angle |
| 12-18 months | Refresh allowed | Similarity >0.8 still needs update |
| 18+ months | Refresh encouraged | Topic likely outdated |

## Outputs

### Standard Mode Output
```json
{
  "status": "success",
  "mode": "standard",
  "reference_date": "2026-01-07",
  "topics_checked": 12,
  "results": {
    "approved": [
      {
        "article_id": "ART-202601-001",
        "title": "...",
        "status": "APPROVED",
        "similarity_score": 0.15,
        "notes": "No similar past content"
      }
    ],
    "blocked": [
      {
        "article_id": "ART-202601-005",
        "title": "...",
        "status": "BLOCKED",
        "similarity_score": 0.72,
        "matched_article": "ART-202509-003",
        "matched_title": "...",
        "age_months": 4,
        "reason": "6-month hard-block: too similar to recent content"
      }
    ],
    "needs_differentiation": [
      {
        "article_id": "ART-202601-008",
        "title": "...",
        "status": "NEEDS_DIFFERENTIATION",
        "similarity_score": 0.65,
        "matched_article": "ART-202504-002",
        "age_months": 9,
        "required_angle": "Must address new features or different audience segment"
      }
    ]
  },
  "summary": {
    "approved": 8,
    "blocked": 2,
    "needs_differentiation": 2
  }
}
```

### Quick Mode Output
```json
{
  "status": "success",
  "mode": "quick",
  "topic": "WooCommerce HPOS Migration",
  "result": "PASS",
  "similarity_score": 0.12,
  "core_theme_saturation": "LOW",
  "notes": "No recent coverage of this topic"
}
```

## Error Handling

### No Theme Index
```json
{
  "status": "warning",
  "message": "No theme index found",
  "action": "Run theme-indexer agent first, or proceeding with limited historical check"
}
```

### No Historical Content
```json
{
  "status": "info",
  "message": "First calendar - no historical content to check",
  "result": "All topics APPROVED (first-time content)"
}
```

## Integration

### Depends On
- `theme-indexer` agent (theme index for comparison)
- Past calendars and articles (historical data)

### Provides To
- Content calendar (deduplication results)
- Topic selection logic (approved/blocked status)

## Performance

| Mode | Topics | Time |
|------|--------|------|
| Standard | 10-15 | 3-5 minutes |
| Quick | 1 | <5 seconds |

## Success Criteria

- All topics checked against 12-24 month history
- 6-month hard-block enforced
- Differentiation requirements flagged
- Clear approve/block recommendations
- Similarity scores calculated
