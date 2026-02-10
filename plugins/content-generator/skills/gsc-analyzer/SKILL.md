---
name: gsc-analyzer
description: Analyzes Google Search Console CSV export data to provide search performance insights, content opportunities, and ranking optimization signals across 4 modes (Full Analysis, Calendar Integration, Article Optimization, Performance Dashboard)
---

# GSC Analyzer Skill

## Purpose

Analyze Google Search Console CSV export data to replace estimation-based workflows with real search performance data. Provides actionable signals for content calendar planning, article writing, SEO optimization, and performance tracking.

## When to Use

- **Automatically:** During `/content-calendar` generation (Calendar Integration mode) -- demand signals for topic selection
- **Automatically:** During `/write-article` research phase (Article Optimization mode) -- ranking context for target keyword
- **Manually:** For comprehensive search performance review (Full Analysis mode)
- **Automatically:** During performance analysis (Performance Dashboard mode) -- portfolio metrics and meta.yml updates

## Prerequisites

- GSC data exported as CSV from Google Search Console (Performance > Export)
- Export folder placed at path configured in `requirements.md` under `analytics.gsc.export_path`
- Minimum required files: `Queries.csv` and `Pages.csv`
- Optional files: `Chart.csv`, `Devices.csv`, `Countries.csv`, `Search appearance.csv`, `Filters.csv`

## Configuration

This skill reads from `requirements.md` under `analytics.gsc`:

| Field | Required | Description |
|-------|----------|-------------|
| `export_path` | Yes | Absolute path to GSC export folder |
| `site_url` | Yes | Site URL (must match Pages.csv domain) |
| `freshness_threshold_days` | No | Max age of export data before warning (default: 30) |
| `analysis_modes` | No | Enable/disable specific analysis capabilities |
| `filters.min_impressions` | No | Minimum impressions to include query (default: 5) |
| `filters.min_position` | No | Maximum position value to include (default: 100) |
| `filters.ctr_threshold` | No | CTR threshold for opportunity detection (default: 0.02) |
| `filters.position_opportunity_range` | No | Position range for striking distance queries (default: [5, 30]) |

**If `analytics.gsc` is not configured:** Skill exits silently. All calling commands proceed without GSC data (fully backward compatible).

## CSV File Specifications

### Queries.csv

| Column | Type | Description |
|--------|------|-------------|
| Top queries | string | Search query text |
| Clicks | integer | Total clicks from this query |
| Impressions | integer | Total impressions for this query |
| CTR | percentage | Click-through rate (e.g., "2.5%") |
| Position | float | Average position in search results |

### Pages.csv

| Column | Type | Description |
|--------|------|-------------|
| Top pages | string | Full URL of the page |
| Clicks | integer | Total clicks to this page |
| Impressions | integer | Total impressions for this page |
| CTR | percentage | Click-through rate |
| Position | float | Average position |

### Chart.csv (Optional)

| Column | Type | Description |
|--------|------|-------------|
| Date | date | Date (YYYY-MM-DD) |
| Clicks | integer | Daily clicks |
| Impressions | integer | Daily impressions |

### Devices.csv (Optional)

| Column | Type | Description |
|--------|------|-------------|
| Device | string | DESKTOP, MOBILE, TABLET |
| Clicks | integer | Clicks from device |
| Impressions | integer | Impressions from device |
| CTR | percentage | CTR by device |
| Position | float | Average position by device |

### Countries.csv (Optional)

| Column | Type | Description |
|--------|------|-------------|
| Country | string | Country name |
| Clicks | integer | Clicks from country |
| Impressions | integer | Impressions from country |
| CTR | percentage | CTR by country |
| Position | float | Average position by country |

---

## Key Data Transforms

### CTR Benchmarks by Position

Used to calculate expected CTR and identify optimization opportunities:

| Position | Expected CTR | Label |
|----------|-------------|-------|
| 1 | ~30% | Top result |
| 2 | ~16% | Second result |
| 3 | ~11% | Third result |
| 4 | ~8% | Above fold |
| 5 | ~6% | Above fold |
| 6-10 | ~3% | First page |
| 11-20 | ~1.5% | Second page |

**Site-specific override:** When sufficient data exists (50+ queries at a given position), calculate the site's own CTR curve from Pages.csv and use that instead of industry benchmarks.

### Opportunity Score

Quantifies the potential click gain from improving CTR to expected levels:

```
opportunity_score = impressions x (expected_ctr - actual_ctr)
```

**Example:**
- Query: "wordpress migration guide"
- Position: 3, Impressions: 5,000, Actual CTR: 4%, Expected CTR: 11%
- Opportunity score: 5,000 x (0.11 - 0.04) = 350 potential additional clicks

### Authority Score

Measures a page's ranking strength across all queries driving traffic to it:

```
authority_score = sum(clicks x (1 / position)) for all queries to that page
```

Higher scores indicate pages with strong multi-query ranking authority. Used for internal link source selection.

### Freshness Detection

Parse export date from folder name convention:
```
{site}-Performance-on-Search-{YYYY-MM-DD}
```

Compare against `freshness_threshold_days` from config. Warn if stale but proceed with analysis (stale data is better than no data).

---

## Invocation Modes

### Mode 1: Full Analysis

**Purpose:** Comprehensive GSC report covering all query and page performance data.

**Use During:** Manual invocation for strategic review, periodic performance audits.

**Output Location:** `project/GSC/reports/gsc-analysis-full-{date}.md`

**Process:**

#### Step 1: Data Loading and Validation (30 seconds)

1. Read `analytics.gsc` config from requirements.md
2. Validate export path exists and contains required CSVs
3. Parse export date from folder name, check freshness
4. Load Queries.csv and Pages.csv (required)
5. Load Chart.csv, Devices.csv, Countries.csv if present

#### Step 2: Query Opportunity Segmentation (2-3 minutes)

Segment all queries into actionable categories:

**Quick Wins (Position 1-3, CTR below expected):**
- Already ranking well but underperforming on clicks
- Action: Title/meta description optimization
- Filter: `position <= 3 AND actual_ctr < expected_ctr * 0.7`

**Striking Distance (Position 4-10):**
- Close to page 1 top positions
- Action: Content strengthening, internal linking
- Filter: `position >= 4 AND position <= 10 AND impressions >= min_impressions`

**Hidden Gems (Position 11-30, high impressions):**
- Ranking on page 2-3 with proven demand
- Action: Dedicated content or major content refresh
- Filter: `position >= 11 AND position <= 30 AND impressions >= min_impressions * 10`

**CTR Opportunities (any position, CTR significantly below expected):**
- Ranking at various positions but CTR is low
- Action: SERP snippet optimization (title, meta, structured data)
- Filter: `actual_ctr < expected_ctr * 0.5`

#### Step 3: Query Clustering (1-2 minutes)

Group related queries by shared terms:
1. Tokenize all qualifying queries
2. Group by shared 2+ word stems
3. Identify query clusters (3+ queries sharing stems)
4. Calculate cluster-level metrics (total impressions, avg position, combined opportunity)

#### Step 4: Page Performance Scoring (1-2 minutes)

For each page in Pages.csv:
1. Calculate authority score
2. Map all queries driving impressions to this page
3. Identify primary keyword (highest impressions query)
4. Calculate page opportunity score (sum of query opportunities)
5. Assign performance tier:
   - **Star performers:** Position <5, CTR above expected
   - **Underperformers:** Position <10, CTR below expected * 0.5
   - **Growth candidates:** Position 10-30, impressions > threshold
   - **Declining:** Position >30 (if historical data available)

#### Step 5: Trend Analysis (1 minute, requires Chart.csv)

If Chart.csv is present:
1. Calculate 7-day moving averages for clicks and impressions
2. Identify trend direction (growing, stable, declining)
3. Detect seasonal patterns (weekly cycles, monthly trends)
4. Flag significant changes (>20% week-over-week)

#### Step 6: Device and Geographic Insights (optional)

If Devices.csv present:
- Performance comparison across DESKTOP, MOBILE, TABLET
- Identify device-specific optimization opportunities

If Countries.csv present:
- Top performing geographic regions
- Regional content opportunities

#### Step 7: Report Generation

Generate comprehensive report with:
1. Executive summary (top 5 findings)
2. Query opportunity segments (tables with metrics)
3. Query clusters (grouped themes)
4. Page performance tiers (ranked by opportunity)
5. Trend analysis (if Chart.csv available)
6. Device/geo insights (if data available)
7. Prioritized action items (ranked by potential click gain)

---

### Mode 2: Calendar Integration

**Purpose:** Extract topic opportunity signals for content calendar planning.

**Use During:** `/content-calendar` command, Step 0C (after requirements-loader, before theme-indexer).

**Output Location:** `project/Calendar/{Year}/{Month}/gsc-calendar-signals.md`

**Process:**

#### Step 1: Data Loading (30 seconds)

Same as Mode 1 Step 1.

#### Step 2: New Content Opportunities (1-2 minutes)

Identify queries with no dedicated page:
1. For each query with impressions >= `min_impressions * 5`:
   - Check if any page in Pages.csv is optimized for this query
   - "No dedicated page" = no page where this query is the primary keyword (highest impression query for that page)
2. Group unserved queries by topic theme
3. Calculate demand score: `impressions x position_potential`
4. Output as new content candidates with:
   - Query text
   - Impressions (real volume signal)
   - Current best-ranking position (if any)
   - Estimated traffic if dedicated page ranked top 3
   - `gsc_validated: true` flag

#### Step 3: Expansion Opportunities (1 minute)

Identify existing pages that could be expanded:
1. Pages at position 11-50 with impressions > threshold
2. Pages receiving impressions for queries not covered in content
3. Calculate expansion ROI: `impressions x (target_ctr - current_ctr)`
4. Output as content refresh/expansion candidates

#### Step 4: Refresh Candidates (30 seconds)

Identify pages that need updating:
1. Pages with declining CTR (if historical data available)
2. Pages at good position but CTR significantly below expected
3. Calculate refresh priority: `impressions x ctr_gap`

#### Step 5: Pillar Gap Analysis (30 seconds)

Cross-reference query clusters with configured topic pillars:
1. Map query clusters to `content.topic_pillars` from config
2. Identify pillars with low query coverage
3. Identify emerging topics (query clusters not matching any pillar)

#### Step 6: Output Generation

Generate structured calendar signals file:

```markdown
# GSC Calendar Signals

**Export Date:** {date}
**Data Freshness:** {days} days old
**Queries Analyzed:** {count}
**Pages Analyzed:** {count}

## New Content Opportunities

| # | Query Theme | Impressions | Best Position | Est. Traffic (Top 3) | Demand Score |
|---|------------|-------------|---------------|----------------------|-------------|
| 1 | {theme} | {N} | {pos} | {est} | {score} |

## Expansion Opportunities

| # | Page URL | Current Position | Impressions | Unserved Queries | Expansion ROI |
|---|---------|-----------------|-------------|-----------------|--------------|
| 1 | {url} | {pos} | {N} | {count} | {roi} |

## Refresh Candidates

| # | Page URL | Position | CTR | Expected CTR | CTR Gap | Priority |
|---|---------|----------|-----|-------------|---------|---------|
| 1 | {url} | {pos} | {ctr} | {expected} | {gap} | {score} |

## Pillar Coverage

| Pillar | Query Coverage | Gap Level |
|--------|---------------|-----------|
| {pillar} | {pct}% | {level} |

## Emerging Topics

| Query Cluster | Total Impressions | Related Pillar | Status |
|--------------|-------------------|---------------|--------|
| {cluster} | {N} | {pillar or "None"} | NEW |
```

**Structured JSON output** (for programmatic consumption by calendar command):

```json
{
  "gsc_signals": {
    "export_date": "YYYY-MM-DD",
    "freshness_days": 15,
    "new_content": [
      {
        "query_theme": "string",
        "primary_query": "string",
        "related_queries": ["string"],
        "impressions": 5000,
        "best_position": 15,
        "estimated_traffic_top3": 550,
        "demand_score": 8.5,
        "gsc_validated": true
      }
    ],
    "expansion": [
      {
        "page_url": "string",
        "current_position": 12,
        "impressions": 3000,
        "unserved_queries": ["string"],
        "expansion_roi": 250
      }
    ],
    "refresh": [
      {
        "page_url": "string",
        "position": 4,
        "current_ctr": 0.03,
        "expected_ctr": 0.08,
        "impressions": 8000,
        "priority_score": 400
      }
    ],
    "pillar_coverage": {
      "pillar_name": 0.75
    },
    "emerging_topics": [
      {
        "cluster": "string",
        "impressions": 2000,
        "related_pillar": "string or null"
      }
    ]
  }
}
```

---

### Mode 3: Article Optimization

**Purpose:** Provide ranking context and query ecosystem data for a specific article's target keyword.

**Use During:** `/write-article` command, Step 1F (after calendar context, before research phase).

**Output Location:** `project/Articles/{ARTICLE-ID}/gsc-article-data.md`

**Input Required:**
- Target keyword (from article brief or calendar entry)
- Article ID (for file naming)
- Page URL (if article is an update of existing published content)

**Process:**

#### Step 1: Data Loading (30 seconds)

Same as Mode 1 Step 1.

#### Step 2: Target Keyword Ranking Context (1 minute)

Search Queries.csv for the target keyword and close variants:
1. Exact match lookup
2. Partial match (target keyword contained within longer queries)
3. For each match, extract: clicks, impressions, CTR, position
4. Calculate opportunity score if ranking exists
5. If no match: report "No existing ranking data" (keyword is new territory)

#### Step 3: Query Ecosystem Discovery (1-2 minutes)

Find all queries driving impressions to the target URL (if page URL provided) or queries related to the target keyword:

1. **If page URL provided:**
   - Cross-reference Pages.csv URL with all Queries.csv entries
   - List all queries where this page appears in results
   - Rank by impressions

2. **If no page URL (new content):**
   - Find queries in Queries.csv sharing 2+ terms with target keyword
   - Group by theme
   - These represent the real query landscape users search around this topic

Output as query ecosystem:
- Primary queries (high impressions, directly related)
- Secondary queries (moderate impressions, related themes)
- Long-tail queries (low impressions, specific variants)
- Question-form queries (queries containing "how", "what", "why", "when", "can")

#### Step 4: CTR Gap Analysis (30 seconds)

For the target keyword (if ranking exists):
1. Compare actual CTR against position-expected CTR
2. Calculate CTR gap percentage
3. Provide specific optimization recommendations:
   - CTR > expected: "Strong SERP presence, maintain current approach"
   - CTR within 20% of expected: "Normal CTR, minor optimization possible"
   - CTR < 50% of expected: "Significant CTR gap - title/meta optimization needed"

#### Step 5: Device Performance (30 seconds, requires Devices.csv)

If device data available:
- Compare position and CTR across DESKTOP vs MOBILE
- Flag significant device gaps (>2 position difference)
- Recommend device-specific optimizations

#### Step 6: Untargeted Query Discovery (30 seconds)

Identify valuable queries that no current page targets well:
1. Queries with impressions > threshold where best ranking page is position >20
2. Queries related to target keyword theme but not directly addressed
3. These become potential H2/H3 sections or FAQ entries

#### Step 7: Report Generation

```markdown
# GSC Article Data: {Target Keyword}

**Article ID:** {ARTICLE-ID}
**Target Keyword:** "{keyword}"
**Analysis Date:** {date}
**Export Freshness:** {days} days

## Ranking Context

| Metric | Value |
|--------|-------|
| Current Position | {pos} or "Not ranked" |
| Impressions | {N} |
| Clicks | {N} |
| CTR | {pct}% |
| Expected CTR (at position) | {pct}% |
| CTR Gap | {pct}% |
| Opportunity Score | {score} potential clicks |

## Query Ecosystem

### Primary Queries (directly targeted)
| Query | Impressions | Position | CTR | Opportunity |
|-------|-------------|----------|-----|------------|
| {query} | {N} | {pos} | {pct} | {score} |

### Secondary Queries (related themes)
| Query | Impressions | Position | CTR |
|-------|-------------|----------|-----|
| {query} | {N} | {pos} | {pct} |

### Long-Tail Queries
| Query | Impressions | Position |
|-------|-------------|----------|
| {query} | {N} | {pos} |

### Question-Form Queries (FAQ candidates)
| Query | Impressions | Position |
|-------|-------------|----------|
| {query} | {N} | {pos} |

## CTR Analysis

**Status:** {Strong / Normal / Gap detected}
**Recommendation:** {specific action}

## Device Performance

| Device | Position | CTR | Gap |
|--------|----------|-----|-----|
| Desktop | {pos} | {pct} | — |
| Mobile | {pos} | {pct} | {diff} |

## Content Recommendations

### Sections to Include (from query ecosystem)
1. {H2/H3 suggestion based on query cluster}
2. {H2/H3 suggestion based on question queries}

### FAQ Entries (from question-form queries)
1. {question query} ({N} impressions)
2. {question query} ({N} impressions)

### Untargeted Opportunities
| Query | Impressions | Best Current Position | Recommendation |
|-------|-------------|----------------------|---------------|
| {query} | {N} | {pos} | {action} |
```

---

### Mode 4: Performance Dashboard

**Purpose:** Generate portfolio-level performance metrics and auto-populate article meta.yml files with GSC data.

**Use During:** `content-performance-analyzer` skill, or manual invocation for periodic reporting.

**Output Location:** `project/GSC/reports/gsc-performance-dashboard.md`

**Process:**

#### Step 1: Data Loading (30 seconds)

Same as Mode 1 Step 1.

#### Step 2: URL-to-Article Mapping (1-2 minutes)

Map Pages.csv URLs to article IDs using 3 strategies (in order of priority):

1. **Exact URL match:** Check `meta.yml` `url` field across all articles
   ```bash
   grep -r "url:" project/Articles/*/meta.yml
   ```

2. **Slug-based matching:** Extract URL slug and match against article ID or title
   ```
   https://example.com/woocommerce-hpos-migration/ → search for "hpos-migration" in article metadata
   ```

3. **Manual mapping:** Read `project/GSC/url-mapping.json` if it exists
   ```json
   {
     "https://example.com/custom-url/": "ART-202510-001",
     "https://example.com/another/": "ART-202510-002"
   }
   ```

4. **Unmatched URLs:** Log separately for manual review

#### Step 3: Per-Article Performance Aggregation (1-2 minutes)

For each mapped article:
1. Aggregate all queries driving traffic to the article's URL
2. Calculate:
   - Total clicks, impressions
   - Primary keyword (highest impression query)
   - Average position (weighted by impressions)
   - Overall CTR
   - Top 5 queries by impressions
   - Opportunity score (sum of query-level opportunities)
   - Authority score

#### Step 4: Meta.yml Auto-Population (1 minute)

For each mapped article, update `meta.yml` with GSC performance data:

```yaml
# GSC Performance Data (auto-populated by gsc-analyzer)
gsc_data:
  last_updated: "YYYY-MM-DD"
  export_date: "YYYY-MM-DD"
  total_clicks: 1234
  total_impressions: 56789
  avg_position: 8.3
  avg_ctr: 0.022
  primary_keyword: "wordpress migration guide"
  top_queries:
    - query: "wordpress migration guide"
      impressions: 5000
      position: 3.2
      ctr: 0.045
    - query: "migrate wordpress site"
      impressions: 3200
      position: 7.1
      ctr: 0.018
  opportunity_score: 450
  authority_score: 156.3
  performance_tier: "growth_candidate"
```

#### Step 5: Portfolio Scoring (30 seconds)

Assign performance tiers to each article:

| Tier | Criteria | Action |
|------|----------|--------|
| Star Performer | Position <5, CTR above expected | Maintain, build authority |
| Steady Performer | Position <10, CTR within range | Monitor, minor optimizations |
| Growth Candidate | Position 10-30, impressions > threshold | Content strengthening priority |
| Underperformer | Position <10, CTR <50% expected | SERP optimization (title/meta) |
| Low Visibility | Position >30 or minimal impressions | Major refresh or consolidate |

#### Step 6: Dashboard Report Generation

```markdown
# GSC Performance Dashboard

**Generated:** {date}
**Export Date:** {date}
**Articles Mapped:** {N} / {total pages}
**Unmapped URLs:** {N}

## Portfolio Summary

| Metric | Value |
|--------|-------|
| Total Clicks | {N} |
| Total Impressions | {N} |
| Average Position | {pos} |
| Average CTR | {pct}% |
| Articles Tracked | {N} |

## Performance Tiers

| Tier | Count | Total Clicks | Avg Position | Action |
|------|-------|-------------|-------------|--------|
| Star Performer | {N} | {clicks} | {pos} | Maintain |
| Steady Performer | {N} | {clicks} | {pos} | Monitor |
| Growth Candidate | {N} | {clicks} | {pos} | Strengthen |
| Underperformer | {N} | {clicks} | {pos} | Optimize SERP |
| Low Visibility | {N} | {clicks} | {pos} | Refresh/Consolidate |

## Top Articles by Clicks

| # | Article ID | Primary Keyword | Clicks | Impressions | Position | CTR | Tier |
|---|-----------|----------------|--------|-------------|----------|-----|------|
| 1 | {id} | {keyword} | {N} | {N} | {pos} | {pct} | {tier} |

## Top Opportunities (by potential click gain)

| # | Article ID | Primary Keyword | Current Clicks | Opportunity Score | Action |
|---|-----------|----------------|---------------|-------------------|--------|
| 1 | {id} | {keyword} | {N} | {score} | {action} |

## Unmapped URLs

| URL | Clicks | Impressions | Position | Notes |
|-----|--------|-------------|----------|-------|
| {url} | {N} | {N} | {pos} | Needs manual mapping |

## Meta.yml Updates

Updated {N} article meta.yml files with GSC performance data.
See individual article directories for updated metadata.
```

---

## Error Handling

### Scenario 1: GSC Not Configured

**Condition:** `analytics.gsc` section absent from requirements.md

**Response:** Exit silently. Return empty result. Calling command proceeds without GSC data. No error, no warning.

### Scenario 2: Export Path Invalid

**Condition:** `export_path` does not exist or is missing required CSVs

**Response:**
- Log warning: "GSC export path not found or missing required files (Queries.csv, Pages.csv)"
- Return empty result with warning flag
- Calling command proceeds without GSC data

### Scenario 3: Stale Data

**Condition:** Export date exceeds `freshness_threshold_days`

**Response:**
- Log warning: "GSC data is {N} days old (threshold: {threshold} days)"
- Proceed with analysis (stale data is better than no data)
- Include staleness warning in all output reports

### Scenario 4: Empty CSV Files

**Condition:** Queries.csv or Pages.csv contains headers but no data rows

**Response:**
- Log warning: "GSC export contains no data"
- Return empty result
- This can happen for new sites with no search presence yet

### Scenario 5: Domain Mismatch

**Condition:** `site_url` does not match domains in Pages.csv

**Response:**
- Log warning: "Site URL {site_url} does not match Pages.csv domains"
- Proceed with analysis using Pages.csv data as-is
- Include mismatch warning in report

---

## Quality Guidelines

### Analysis Quality

**DO:**
- Parse CSV data accurately (handle quoted fields, commas in values)
- Use position-appropriate CTR benchmarks (not flat averages)
- Calculate site-specific CTR curves when sufficient data exists
- Filter out low-quality queries (brand misspellings, irrelevant terms)
- Cross-reference queries with pages for accurate mapping

**DON'T:**
- Treat GSC data as exact (positions and CTR are averages)
- Over-rely on single-day data (use export period totals)
- Report raw data without actionable interpretation
- Mix up "impressions" with "traffic" (impressions = search appearances)
- Ignore the filters configured in requirements.md

### Report Quality

**DO:**
- Sort tables by the most actionable metric (opportunity score, impressions)
- Provide specific recommendations with each data point
- Include calculation methodology for transparency
- Flag data quality issues (staleness, small sample sizes)
- Use consistent formatting across all modes

**DON'T:**
- Generate reports with no data (return empty result instead)
- Include queries below configured minimum impressions
- Present opportunity scores without context (always show the calculation)
- Omit the export date and freshness status

---

## Performance Optimization

### CSV Parsing Efficiency

- Read CSVs once, store parsed data in memory for all subsequent operations
- Skip header rows automatically
- Handle percentage fields (strip "%" suffix, convert to decimal)
- Handle locale-specific number formats (commas as thousands separators)

### Caching

- No persistent cache needed (data comes from static CSV files)
- In-memory caching within a single invocation is sufficient
- Re-read CSVs on each invocation to ensure fresh data

---

## Integration Points

### Provides To

| Consumer | Mode | Data Provided |
|----------|------|---------------|
| `/content-calendar` | Calendar Integration | New content opportunities, expansion targets, refresh candidates, pillar gaps |
| `@signal-researcher` | Calendar Integration | Demand-validated topic signals with `gsc_validated: true` flag |
| `gap-analyst` (batch) | Calendar Integration | Pre-validated content gaps (skip competitor analysis for GSC-confirmed gaps) |
| `keyword-planner` | Calendar Integration | Seasonal patterns from Chart.csv |
| `/write-article` | Article Optimization | Query ecosystem, ranking context, FAQ candidates, H2/H3 suggestions |
| `@researcher` (Agent 1) | Article Optimization | Validated user queries for research scope |
| `@researcher` (Agent 2) | Article Optimization | Real position context for landscape analysis |
| `keyword-analyst` | Article Optimization | Real impressions as volume signal, long-tail queries |
| `seo-optimizer` | Article Optimization | Authority-based internal link targets, CTR benchmarks |
| `@editor` | Article Optimization | Validation that GSC queries are addressed in content |
| `content-performance-analyzer` | Performance Dashboard | Portfolio metrics, per-article performance, meta.yml data |

### Depends On

| Dependency | Purpose |
|------------|---------|
| `requirements-loader` | Load `analytics.gsc` configuration |
| GSC CSV export files | Source data for all analysis |

---

## Success Metrics

### Skill Performance

- **Mode 1 (Full):** Complete analysis in under 8 minutes
- **Mode 2 (Calendar):** Generate signals in under 4 minutes
- **Mode 3 (Article):** Produce article data in under 3 minutes
- **Mode 4 (Dashboard):** Generate dashboard in under 5 minutes
- **CSV parsing accuracy:** 100% (no dropped or misread rows)
- **URL mapping rate:** >80% of Pages.csv URLs matched to articles

### Content Impact

- **Calendar quality:** GSC-backed topics should achieve higher average position than non-GSC topics
- **Article relevance:** Articles addressing GSC query ecosystem should capture more long-tail traffic
- **CTR improvement:** Articles optimized with GSC CTR data should close CTR gap by 30%+
- **Update efficiency:** GSC-triggered updates should prioritize highest ROI opportunities

---

## Usage Examples

### Example 1: Calendar Planning with GSC Signals

```
During /content-calendar for March 2026:

1. requirements-loader validates config (analytics.gsc present)
2. gsc-analyst invoked in Calendar Integration mode
3. Skill reads GSC export from configured path
4. Outputs gsc-calendar-signals.md with:
   - 5 new content opportunities (queries with no dedicated page)
   - 3 expansion opportunities (pages at position 11-30)
   - 2 refresh candidates (good position, low CTR)
   - Pillar coverage gaps identified
5. @signal-researcher receives GSC signals alongside trend data
6. Calendar includes mix of GSC-validated and trend-based topics
```

### Example 2: Article Research with GSC Context

```
During /write-article for ART-202603-005 ("WordPress REST API Caching"):

1. gsc-analyst invoked in Article Optimization mode
2. Skill finds "wordpress rest api caching" in Queries.csv:
   - Position: 14, Impressions: 3,200, CTR: 1.2%
3. Query ecosystem reveals:
   - "wordpress api cache headers" (800 impressions)
   - "how to cache wordpress rest api responses" (500 impressions)
   - "wordpress transient api caching" (1,200 impressions)
4. Recommendations:
   - Include H2 section on "Cache Headers for REST API"
   - Add FAQ: "How to cache REST API responses?"
   - Cover transient API pattern (high demand)
5. @researcher agents use query ecosystem to scope research
6. @writer incorporates suggested sections
7. @editor validates all high-impression queries addressed
```

### Example 3: Performance Dashboard

```
Monthly performance review:

1. gsc-analyst invoked in Performance Dashboard mode
2. Maps 45/52 Pages.csv URLs to article IDs
3. Updates 45 meta.yml files with GSC data
4. Dashboard shows:
   - 8 Star Performers (position <5)
   - 15 Steady Performers
   - 12 Growth Candidates (biggest opportunity pool)
   - 5 Underperformers (CTR optimization needed)
   - 5 Low Visibility (refresh or consolidate)
5. Top opportunity: ART-202601-003 at position 6 with 12,000 impressions
   - Opportunity score: 480 additional clicks if moved to position 3
6. 7 URLs unmapped, logged for manual review
```
