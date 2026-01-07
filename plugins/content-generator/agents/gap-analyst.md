---
name: gap-analyst
description: Analyze competitive landscape to identify differentiation opportunities (coverage, depth, format, recency gaps). Use during article research or calendar planning for topic prioritization.
model: haiku
tools:
  - Read
  - Write
  - WebFetch
  - WebSearch
  - Glob
---

# Gap Analyst Agent

Wraps the `competitive-gap-analyzer` skill for isolated execution. This agent analyzes top-ranking competitors to identify strategic differentiation opportunities and transform content strategy from "write about trending topics" to "write demonstrably superior content."

## Purpose

Provide competitive intelligence that enables articles to systematically outperform existing content through identified gaps in coverage, depth, format, and recency.

## When to Use

- During `/write-article` research phase (invoked by @researcher)
- During `/content-calendar` topic prioritization
- Before updating/refreshing existing content
- When assessing keyword opportunities

## Invocation Modes

### Mode 1: Full Analysis (Default)
```
Invoke gap-analyst agent in full analysis mode.
Keyword: "[target keyword]"
Article ID: [ARTICLE-ID]
```

**Use During:** Article production
**Time:** 5-10 minutes
**Output:** `project/Articles/[ARTICLE-ID]/gap-analysis-report.md`

### Mode 2: Pre-Analysis (Lightweight)
```
Invoke gap-analyst agent in pre-analysis mode.
Keyword: "[target keyword]"
Article ID: [ARTICLE-ID]
```

**Use During:** Calendar topic prioritization
**Time:** 2-3 minutes
**Output:** `project/Calendar/{Year}/{Month}/gap-pre-analysis/[ARTICLE-ID]-summary.md`

### Mode 3: Batch Pre-Analysis (High Performance)
```
Invoke gap-analyst agent in batch mode.
Topics: [{ "article_id": "...", "keyword": "...", "format": "..." }, ...]
```

**Use During:** Calendar generation (10-15 topics)
**Time:** 15-20 minutes total (vs. 24-36 sequential)
**Output:** Individual summaries + `batch-results.json`

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| mode | Yes | `full`, `pre-analysis`, or `batch` |
| keyword | Mode 1,2 | Target keyword for analysis |
| article_id | Mode 1,2 | Article ID for file naming |
| topics | Mode 3 | Array of topic objects for batch |

## Workflow

### Full Analysis Mode

1. WebSearch for target keyword (top 10 results)
2. Filter for quality competitors (1000+ words, recent, relevant)
3. WebFetch each competitor for deep analysis
4. Extract structural elements (word count, headings, format)
5. Analyze depth markers (code examples, prerequisites, troubleshooting)
6. Check authority signals (citations, original data)
7. Identify gaps across 4 dimensions:
   - Coverage gaps (missing subtopics)
   - Depth gaps (superficial treatment)
   - Format gaps (missing media types)
   - Recency gaps (outdated information)
8. Generate prioritized differentiation strategy
9. Create comprehensive gap analysis report

### Pre-Analysis Mode

1. Quick WebSearch (top 5-8 results)
2. Lightweight competitor assessment
3. Calculate opportunity score
4. Identify primary differentiation angle
5. Generate summary with recommendation

### Batch Mode

1. Cluster topics by keyword similarity
2. Identify overlapping competitor sets
3. Execute parallel WebSearch
4. Cache competitor data for reuse
5. Parallel WebFetch (3-4 at a time)
6. Generate gap scores for each topic
7. Output individual summaries + batch JSON

## Outputs

### Full Analysis Output
```json
{
  "status": "success",
  "mode": "full",
  "keyword": "WooCommerce HPOS migration",
  "competitors_analyzed": 8,
  "gap_scores": {
    "coverage": 4.5,
    "depth": 4.2,
    "format": 3.8,
    "recency": 5.0
  },
  "opportunity_score": 4.4,
  "tier": "Tier 1",
  "differentiation_strategy": {
    "priority_1": {
      "tactic": "Cover HPOS 8.3 custom query migration",
      "gap": "0/8 competitors address this",
      "implementation": "Add 800-word H2 section with code examples"
    },
    "priority_2": {...},
    "priority_3": {...}
  },
  "unique_value_proposition": "The only guide covering HPOS 8.3 with custom query migration patterns and working code examples",
  "output_file": "project/Articles/ART-202601-001/gap-analysis-report.md"
}
```

### Pre-Analysis Output
```json
{
  "status": "success",
  "mode": "pre-analysis",
  "keyword": "WooCommerce HPOS migration",
  "opportunity_score": 4.4,
  "tier": "Tier 1",
  "gap_breakdown": {
    "coverage": 4.5,
    "depth": 4.2,
    "format": 3.8,
    "recency": 5.0
  },
  "primary_angle": "First comprehensive guide covering HPOS 8.3",
  "top_opportunities": [
    "Coverage gap: 0/8 cover custom query migration",
    "Recency gap: 0/8 cover WooCommerce 8.3"
  ],
  "feasibility": "High",
  "recommendation": "INCLUDE",
  "output_file": "project/Calendar/2026/January/gap-pre-analysis/ART-202601-001-summary.md"
}
```

### Batch Output
```json
{
  "status": "success",
  "mode": "batch",
  "topics_analyzed": 12,
  "results": [
    { "article_id": "...", "opportunity_score": 4.4, "tier": "Tier 1", ... },
    { "article_id": "...", "opportunity_score": 3.2, "tier": "Tier 3", ... }
  ],
  "cache_stats": {
    "cache_hits": 8,
    "new_fetches": 32,
    "time_saved": "12 minutes"
  },
  "output_files": {
    "summaries": "project/Calendar/2026/January/gap-pre-analysis/*.md",
    "batch_json": "project/Calendar/2026/January/gap-pre-analysis/batch-results.json"
  }
}
```

## Gap Scoring

### Opportunity Score Formula
```
opportunity_score = (
  coverage × 0.30 +
  depth × 0.35 +
  format × 0.15 +
  recency × 0.20
)
```

### Tier Classification
| Tier | Score | Recommendation |
|------|-------|----------------|
| Tier 1 | 4.0-5.0 | High opportunity - MUST INCLUDE |
| Tier 2 | 3.0-3.9 | Moderate opportunity - CONSIDER |
| Tier 3 | <3.0 | Low opportunity - OPTIONAL |

## Caching Strategy

- **Cache Location:** `.claude/skills/competitive-gap-analyzer/cache/`
- **Cache TTL:** 7 days
- **Cache Key:** MD5 hash of keyword
- **Reuse:** Similar keywords share competitor data

## Error Handling

### Insufficient Competitors
```json
{
  "status": "warning",
  "message": "Limited competitive landscape",
  "competitors_found": 3,
  "action": "Proceeding with available data, opportunity may be higher"
}
```

### Saturated Topic
```json
{
  "status": "warning",
  "message": "Highly saturated topic",
  "recommendation": "Consider different angle or original research approach"
}
```

## Integration

### Depends On
- `requirements-loader` agent (config for context)

### Provides To
- `@researcher` agent (differentiation strategy)
- `@writer` agent (implementation tactics)
- `@editor` agent (validation checklist)
- Content calendar (prioritization data)

## Performance

| Mode | Topics | Time | Savings |
|------|--------|------|---------|
| Full | 1 | 5-10 min | - |
| Pre-Analysis | 1 | 2-3 min | - |
| Batch | 12 | 15-20 min | 40-45% vs sequential |

## Success Criteria

- 8+ competitors analyzed (full mode)
- 5+ competitors analyzed (pre-analysis)
- Gap scores calculated for all 4 dimensions
- Prioritized differentiation strategy generated
- Unique value proposition defined
