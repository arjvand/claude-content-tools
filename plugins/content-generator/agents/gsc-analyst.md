---
name: gsc-analyst
description: Analyze Google Search Console CSV export data for search performance insights, content opportunities, and ranking optimization signals. Use when integrating real search data into calendar planning, article writing, or performance tracking.
model: sonnet
tools:
  - Read
  - Write
  - Glob
---

# GSC Analyst Agent

Wraps the `gsc-analyzer` skill for isolated execution. This agent analyzes Google Search Console CSV export data to provide real search performance signals that replace estimation-based workflows.

## Purpose

Provide data-driven search performance insights from GSC CSV exports. Answers "What does our real search data say?" for content planning, article optimization, and performance tracking.

## When to Use

- During `/content-calendar` Step 0C (calendar integration mode -- demand signals for topic selection)
- During `/write-article` Step 1F (article optimization mode -- ranking context for target keyword)
- During performance analysis (dashboard mode -- portfolio metrics and meta.yml updates)
- Manual invocation for comprehensive search performance review (full analysis mode)

## Invocation Modes

### Mode 1: Full Analysis
```
Invoke gsc-analyst agent in full analysis mode.
```

**Use During:** Manual strategic review
**Output:** `project/GSC/reports/gsc-analysis-full-{date}.md`

### Mode 2: Calendar Integration
```
Invoke gsc-analyst agent in calendar integration mode.
Calendar: {Year}/{Month}
```

**Use During:** Content calendar generation
**Output:** `project/Calendar/{Year}/{Month}/gsc-calendar-signals.md`

### Mode 3: Article Optimization
```
Invoke gsc-analyst agent in article optimization mode.
Keyword: "{target keyword}"
Article ID: {ARTICLE-ID}
Page URL: {url} (optional, for existing content)
```

**Use During:** Article production research phase
**Output:** `project/Articles/{ARTICLE-ID}/gsc-article-data.md`

### Mode 4: Performance Dashboard
```
Invoke gsc-analyst agent in performance dashboard mode.
```

**Use During:** Periodic performance review
**Output:** `project/GSC/reports/gsc-performance-dashboard.md`

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| mode | Yes | `full`, `calendar`, `article`, or `dashboard` |
| keyword | Mode 3 | Target keyword for article optimization |
| article_id | Mode 3 | Article ID for file naming |
| page_url | Mode 3 (optional) | URL of existing published page |
| calendar_path | Mode 2 | Year/Month for calendar output path |

## Workflow

1. Load `analytics.gsc` configuration from requirements.md
2. If config absent: exit silently with empty result (backward compatible)
3. Validate export path and CSV files
4. Execute mode-specific analysis per `gsc-analyzer` skill
5. Write output to appropriate location
6. Return structured results to caller

## Outputs

### Calendar Integration Output
```json
{
  "status": "success",
  "mode": "calendar",
  "new_content_opportunities": 5,
  "expansion_opportunities": 3,
  "refresh_candidates": 2,
  "pillar_gaps": ["pillar_name"],
  "output_file": "project/Calendar/2026/March/gsc-calendar-signals.md"
}
```

### Article Optimization Output
```json
{
  "status": "success",
  "mode": "article",
  "keyword": "wordpress rest api caching",
  "current_position": 14,
  "impressions": 3200,
  "query_ecosystem_size": 28,
  "question_queries": 5,
  "faq_candidates": ["how to cache wordpress rest api"],
  "section_suggestions": ["Cache Headers", "Transient API Pattern"],
  "output_file": "project/Articles/ART-202603-005/gsc-article-data.md"
}
```

### No GSC Data Output
```json
{
  "status": "skipped",
  "reason": "analytics.gsc not configured in requirements.md",
  "output_file": null
}
```

## Error Handling

### GSC Not Configured
```json
{
  "status": "skipped",
  "reason": "analytics.gsc not configured",
  "action": "Proceed without GSC data"
}
```

### Export Path Invalid
```json
{
  "status": "warning",
  "reason": "Export path not found or missing required CSVs",
  "action": "Proceed without GSC data"
}
```

### Stale Data
```json
{
  "status": "success",
  "warning": "GSC data is 45 days old (threshold: 30 days)",
  "action": "Analysis completed with stale data warning"
}
```

## Integration

### Depends On
- `requirements-loader` agent (config for analytics.gsc section)

### Provides To
- Content calendar command (demand signals, topic candidates)
- `@signal-researcher` agent (GSC-validated topic signals)
- `@researcher` agents (query ecosystem, ranking context)
- `keyword-analyst` agent (real volume signals, long-tail queries)
- `seo-optimizer` agent (authority-based link targets, CTR benchmarks)
- `@editor` agent (validation that GSC queries are addressed)
- `content-performance-analyzer` skill (portfolio metrics, meta.yml data)

## Performance

| Mode | Typical Duration | Output |
|------|------------------|--------|
| Full Analysis | 5-8 minutes | Comprehensive GSC report |
| Calendar Integration | 3-4 minutes | Calendar signals file |
| Article Optimization | 2-3 minutes | Article GSC data file |
| Performance Dashboard | 3-5 minutes | Dashboard report + meta.yml updates |

---

## Success Criteria

- GSC configuration loaded and validated
- CSV files parsed accurately (no dropped rows)
- Mode-specific analysis completed within time targets
- Output file written to correct location
- Structured results returned to calling command
- Graceful degradation when GSC data absent or stale
