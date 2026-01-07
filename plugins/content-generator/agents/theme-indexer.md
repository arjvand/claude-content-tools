---
name: theme-indexer
description: Build theme index from past calendars and articles for deduplication. Use at the start of content calendar generation to enable topic freshness checking.
model: haiku
tools:
  - Read
  - Glob
---

# Theme Indexer Agent

Wraps the `theme-index-builder` skill for isolated execution. This agent builds a comprehensive theme index from past calendars and articles, enabling topic deduplication and freshness analysis.

## Purpose

Create a searchable index of past content themes, keywords, and topics to support deduplication during calendar planning. Enables intelligent topic freshness checking with dynamic theme tagging.

## When to Use

- At the start of `/content-calendar` (before topic generation)
- Before running topic-deduplicator agent
- When analyzing content coverage history

## Invocation

```
Invoke theme-indexer agent.
Lookback: 12 months (optional, default 12)
```

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| lookback_months | No | Number of months to index (default: 12, max: 24) |

## Workflow

### Phase 1: Identify Past Calendars (1 min)
1. Glob for `project/Calendar/*/*/content-calendar.md`
2. Filter by date range (lookback period)
3. Sort chronologically

### Phase 2: Extract Metadata (2-3 min)
For each calendar:
1. Parse calendar table entries
2. Extract: Article ID, Title, Keywords, Format, Status
3. Load corresponding meta.yml if published
4. Build article records with full metadata

### Phase 3: Generate Dynamic Theme Tags
For each article:
1. Analyze title and keywords
2. Generate 3-5 theme tags (automated classification)
3. Examples: "migration", "integration", "troubleshooting", "beginner"

### Phase 4: Build Core Theme Registry
1. Cluster articles by primary theme
2. Calculate theme saturation (articles per theme)
3. Track theme recency (last coverage date)
4. Identify over-saturated themes (>3 articles in 6 months)

## Outputs

```json
{
  "status": "success",
  "index_date": "2026-01-07",
  "lookback_months": 12,
  "calendars_indexed": 8,
  "articles_indexed": 72,
  "theme_index": {
    "articles": [
      {
        "article_id": "ART-202512-001",
        "title": "WooCommerce HPOS Migration Guide",
        "keywords": ["HPOS", "migration", "WooCommerce"],
        "theme_tags": ["migration", "database", "woocommerce"],
        "core_theme": "migration",
        "format": "Tutorial",
        "publish_date": "2025-12-15",
        "age_months": 1
      }
    ],
    "core_themes": {
      "migration": {
        "count": 5,
        "last_covered": "2025-12-15",
        "saturation": "MEDIUM"
      },
      "integration": {
        "count": 8,
        "last_covered": "2025-11-20",
        "saturation": "HIGH"
      }
    },
    "theme_tags": {
      "migration": 12,
      "integration": 15,
      "troubleshooting": 8,
      "beginner": 6
    }
  },
  "saturation_warnings": [
    {
      "theme": "integration",
      "count_6_months": 4,
      "warning": "HIGH saturation - consider different angles"
    }
  ],
  "output_file": ".claude/cache/theme-index.json"
}
```

## Theme Saturation Levels

| Level | Count (6 months) | Recommendation |
|-------|------------------|----------------|
| LOW | 0-1 | Safe to cover |
| MEDIUM | 2-3 | Consider fresh angle |
| HIGH | 4+ | Needs strong differentiation |

## Caching

- **Cache Location:** `.claude/cache/theme-index.json`
- **Cache TTL:** 24 hours (or until new content published)
- **Invalidation:** New calendar generated or article published

## Error Handling

### No Past Calendars
```json
{
  "status": "info",
  "message": "No past calendars found",
  "result": "Empty theme index (first-time content generation)"
}
```

### Partial Calendar Data
```json
{
  "status": "warning",
  "message": "Some calendars missing metadata",
  "calendars_indexed": 6,
  "calendars_skipped": 2,
  "action": "Index built from available data"
}
```

## Integration

### Depends On
- Past calendar files (`project/Calendar/*/*/content-calendar.md`)
- Article metadata (`project/Articles/*/meta.yml`)

### Provides To
- `topic-deduplicator` agent (theme index for comparison)
- Content calendar (saturation warnings)

## Performance

- **Typical Duration:** 3-5 minutes (12-month lookback)
- **Cache Hit:** <1 second (if index fresh)

## Success Criteria

- All calendars within lookback indexed
- Theme tags generated for all articles
- Core theme registry built
- Saturation levels calculated
- Index cached for reuse
