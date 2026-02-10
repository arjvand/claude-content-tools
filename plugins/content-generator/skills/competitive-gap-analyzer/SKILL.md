---
name: competitive-gap-analyzer
description: Analyzes top-ranking competitors to identify strategic differentiation opportunities (coverage, depth, format, recency gaps)
---

# Competitive Gap Analyzer Skill

## Purpose
Analyze top-ranking competitor content to identify strategic differentiation opportunities. Transform content strategy from "write about trending topics" to "write demonstrably superior content."

## When to Use
- **Automatically:** During research phase for new articles (invoked by @researcher agent) — Full Analysis Mode
- **Automatically:** During content calendar generation (invoked by calendar command) — Pre-Analysis Mode
- **Manually:** Before updating/refreshing existing content — Full Analysis Mode
- **Strategically:** When planning pillar/cluster content strategies — Pre-Analysis Mode
- **Proactively:** For keyword opportunity assessment — Pre-Analysis Mode

## Invocation Modes

### Mode 1: Full Analysis (Default)

**Use During:** `/write-article` research phase (invoked by @researcher agent)

**Purpose:** Complete competitive analysis with detailed implementation tactics for article writing

**Output:**
- Complete `gap-analysis-report.md` (comprehensive report)
- Differentiation strategy summary for research brief
- Detailed implementation guidance for @writer
- Validation checklist for @editor

**Process:**
- Analyzes 8-10 competitors (top-ranking)
- Deep analysis of all gap types (coverage, depth, format, recency)
- Generates 3-tier prioritized differentiation strategy
- Provides specific implementation details (word counts, examples needed, etc.)

**Time:** 5-10 minutes per article

**Storage:** `project/Articles/[ARTICLE-ID]/gap-analysis-report.md`

---

### Mode 2: Pre-Analysis (Lightweight)

**Use During:** `/content-calendar` generation (topic prioritization phase)

**Purpose:** Quick competitive assessment for topic selection and prioritization

**Output:**
- Lightweight summary file (concise opportunity assessment)
- Opportunity score (1-5★) with gap breakdown
- Primary differentiation angle (1-2 sentences)
- Top 3 opportunities
- Feasibility assessment

**Process:**
- Analyzes 5-8 competitors (faster, top-ranking only)
- Quick assessment of all gap types
- Calculates opportunity score
- Identifies primary differentiation angle
- No detailed implementation tactics (saved for full analysis)

**Time:** 2-3 minutes per topic

**Storage:** `project/Calendar/{Year}/{Month}/gap-pre-analysis/[ARTICLE-ID]-summary.md`

---

### Mode 3: Batch Pre-Analysis (High Performance) ⚡

**Use During:** `/content-calendar` generation when analyzing 10-15 topic candidates simultaneously

**Purpose:** Parallel competitive assessment of multiple topics with intelligent caching and data reuse

**Output:**
- Individual summary files for each topic (same as Mode 2)
- Batch results JSON (structured data for all topics)
- Competitor data cache (reusable across similar keywords)
- Comparative insights (topics ranked by opportunity)

**Process:**
- **Step 1: Keyword Clustering (1 min)**
  - Group topics by keyword similarity
  - Identify overlapping competitor sets
  - Plan shared searches

- **Step 2: Parallel Competitor Discovery (3-5 min)**
  - Execute WebSearch for all unique keywords simultaneously
  - Cache competitor URLs and metadata
  - Deduplicate competitors appearing in multiple searches

- **Step 3: Parallel Content Analysis (8-12 min)**
  - Fetch competitor content (WebFetch) in parallel batches (3-4 at a time)
  - Analyze structure, depth, format, recency
  - Build shared competitor database

- **Step 4: Gap Scoring (3-5 min)**
  - For each topic, calculate gaps using shared/cached competitor data
  - Reuse competitor analysis for similar keywords
  - Generate opportunity scores
  - Produce pre-analysis summaries

- **Step 5: Output Generation (1-2 min)**
  - Save individual summaries: `project/Calendar/{Year}/{Month}/gap-pre-analysis/[ARTICLE-ID]-summary.md`
  - Save batch results: `project/Calendar/{Year}/{Month}/gap-pre-analysis/batch-results.json`
  - Return structured results to caller

**Time:** 15-20 minutes for 12 topics (vs. 24-36 min sequential Mode 2)
  - **Time Savings: 40-45% faster** through parallelization and caching

**Storage:**
- Individual summaries in `gap-pre-analysis/` directory
- Batch results in `gap-pre-analysis/batch-results.json`
- Competitor cache in `.claude/skills/competitive-gap-analyzer/cache/`

**Invocation:**
```
Please use the competitive-gap-analyzer skill in batch mode to analyze all 12 topic candidates from topic-candidates.md.
```

Or explicitly specify:
```
I need batch pre-analysis for topics ART-202511-001 through ART-202511-012.
```

**Input Format:**
```json
{
  "mode": "batch-preanalysis",
  "topics": [
    {
      "article_id": "ART-202511-001",
      "keyword": "WooCommerce HPOS migration",
      "format": "Tutorial"
    },
    {
      "article_id": "ART-202511-002",
      "keyword": "WordPress webhook retry logic",
      "format": "Tutorial"
    }
    // ...10-15 topics total
  ]
}
```

**Output Format:**
```json
[
  {
    "article_id": "ART-202511-001",
    "keyword": "WooCommerce HPOS migration",
    "opportunity_score": 4.5,
    "tier": "Tier 1",
    "gap_breakdown": {
      "coverage": 4.2,
      "depth": 4.8,
      "format": 4.0,
      "recency": 5.0
    },
    "primary_angle": "First comprehensive guide covering HPOS 8.3 with custom query migration patterns",
    "top_opportunities": [
      "Coverage gap: 0/8 competitors address custom query migration",
      "Depth gap: 0/8 provide working code examples",
      "Recency gap: 0/8 cover WooCommerce 8.3 (released 2 weeks ago)"
    ],
    "feasibility": "High",
    "summary_path": "gap-pre-analysis/ART-202511-001-summary.md",
    "competitors_analyzed": 8,
    "cache_hits": 0
  },
  {
    "article_id": "ART-202511-002",
    "keyword": "WordPress webhook retry logic",
    "opportunity_score": 4.2,
    "tier": "Tier 1",
    "gap_breakdown": {
      "coverage": 4.5,
      "depth": 4.0,
      "format": 3.8,
      "recency": 4.5
    },
    "primary_angle": "Complete retry logic patterns with exponential backoff examples",
    "top_opportunities": [
      "Coverage gap: 1/8 competitors cover exponential backoff",
      "Depth gap: 0/8 provide production-ready error handling",
      "Format gap: 0/8 include flowcharts or visual guides"
    ],
    "feasibility": "High",
    "summary_path": "gap-pre-analysis/ART-202511-002-summary.md",
    "competitors_analyzed": 8,
    "cache_hits": 2
  }
  // ...results for all topics
]
```

**Caching Strategy:**

**Cache Location:** `.claude/skills/competitive-gap-analyzer/cache/`

**Cache Entry Structure:**
```json
{
  "keyword_hash": "md5_of_keyword",
  "keyword": "WooCommerce HPOS migration",
  "cached_at": "2025-11-05T14:30:00Z",
  "expires_at": "2025-11-12T14:30:00Z",
  "competitors": [
    {
      "url": "https://example.com/hpos-guide",
      "title": "HPOS Migration Guide",
      "word_count": 2400,
      "structure": {
        "h2_topics": ["Introduction", "Prerequisites", "Migration Steps", ...],
        "h3_subtopics": {...}
      },
      "depth_markers": {
        "code_examples": 5,
        "troubleshooting": true,
        "prerequisites": true
      },
      "publish_date": "2025-10-15",
      "domain": "example.com"
    }
    // ...8-10 competitors
  ]
}
```

**Cache Logic:**
- Check cache before WebSearch for each keyword
- If cache exists AND <7 days old AND ≥5 competitors → use cached data
- If cache stale or insufficient → refresh with new WebSearch
- Shared cache across batch reduces redundant fetches by 30-50%

**Cache Benefits:**
- **Speed:** Instant retrieval for cached keywords (0 seconds vs. 2-3 min)
- **API Efficiency:** Reduces WebSearch/WebFetch calls by 30-50%
- **Consistency:** All topics analyzed with same competitor baseline
- **Cost:** Lower API usage

**Cache Management:**
```bash
# View cache status
ls -lh .claude/skills/competitive-gap-analyzer/cache/

# Clear expired cache (automatic, but can force)
find .claude/skills/competitive-gap-analyzer/cache/ -mtime +7 -delete

# Clear all cache (force refresh)
rm -rf .claude/skills/competitive-gap-analyzer/cache/*
```

**Performance Comparison:**

| Mode | Topics | Time | Throughput | Cache | Use Case |
|------|--------|------|------------|-------|----------|
| **Mode 2 (Sequential)** | 12 | 24-36 min | 2.0-3.0 min/topic | ❌ No | Single topic, detailed focus |
| **Mode 3 (Batch)** | 12 | 15-20 min | 1.25-1.67 min/topic | ✅ Yes | Calendar generation, multiple topics |

**Savings: 40-45% faster (9-16 minutes saved per calendar)**

---

**How to Specify Mode:**

The skill automatically detects mode based on context:
- If invoked during `/content-calendar` with multiple topics → **Batch Pre-Analysis Mode** (Mode 3)
- If invoked during `/content-calendar` with single topic → **Pre-Analysis Mode** (Mode 2)
- If invoked during `/write-article` or manually → **Full Analysis Mode** (Mode 1)

You can explicitly request a mode by mentioning:
- "batch mode" or "batch pre-analysis"
- "pre-analysis mode" (single topic)
- "full analysis mode"

## Configuration

This skill reads from `requirements.md`:
- **Industry/Niche**: Determines topic context for competitor identification
- **Platform/Product**: Focuses analysis on relevant competitors
- **Target Audience**: Determines appropriate depth and technical level
- **Content Mix & Formats**: Prioritizes matching format gaps
- **Word Count Range**: Informs depth recommendations
- **Focus Areas**: Weights gap priorities
- **SEO Strategy**: Influences keyword and ranking analysis approach

## Process

### Step 1: Competitor Identification

**Input Required:**
- Target keyword (from article brief or calendar entry)
- Article ID (for file naming)

**Actions:**
1. **Search for top competitors:**
   ```
   Use WebSearch with exact target keyword
   Retrieve top 10 ranking articles
   ```

2. **Filter results for quality:**
   - Published within last 12 months (prefer 6 months)
   - Substantial content (1000+ words estimated)
   - Relevant to configured topic/platform
   - Exclude: aggregators, press releases, pure product pages

3. **Record competitor metadata:**
   For each competitor article:
   - URL
   - Title
   - Publish date (if available)
   - Domain (extract from URL)
   - Estimated domain authority (based on domain recognition: high/medium/low)

**Output:** List of 5-10 qualified competitor articles

---

### Step 2: Content Analysis

For each competitor article, use WebFetch to analyze and extract:

#### 2A: Structural Elements

**Word Count:**
- Estimate total word count from content length
- Compare against our configured range from requirements.md

**Heading Structure:**
- List all H2 topics covered
- List key H3 subtopics under each H2
- Identify content organization pattern

**Content Format:**
- Tutorial (step-by-step instructions)
- Listicle (numbered or bulleted list article)
- Guide (comprehensive overview)
- Comparison (product/method comparison)
- Analysis/Opinion
- News/Announcement
- Case Study

**Media Types Present:**
- Screenshots (count or yes/no)
- Videos (embedded, count)
- Diagrams/Infographics
- Code snippets (count)
- Tables
- Interactive elements

#### 2B: Depth Markers

**Prerequisites Section:**
- Present? (yes/no)
- If yes, what's covered?

**Step-by-Step Instructions:**
- Present? (yes/no)
- If yes, count number of steps
- Are steps explained (why) or just listed (what)?

**Code Examples:**
- Count of code blocks
- Languages used
- Quality: working examples vs. snippets

**Troubleshooting Section:**
- Present? (yes/no)
- If yes, how many issues covered?

**Advanced Tips/Use Cases:**
- Present? (yes/no)
- Depth level: beginner, intermediate, advanced

#### 2C: Authority Signals

**Expert Quotes:**
- Present? (yes/no)
- Count if present
- Type: named experts, anonymous, author's own

**Original Data/Research:**
- Present? (yes/no)
- Type: benchmarks, surveys, case studies, testing results

**External Sources Cited:**
- Count of external references
- Types: official docs, research papers, credible sources

**Recency Indicators:**
- Specific dates mentioned?
- Version numbers mentioned?
- References to recent releases/updates (last 3 months)?

#### 2D: User Experience Elements

**Navigation:**
- Table of contents? (yes/no)
- Jump links?
- Sticky navigation?

**Visual Aid Ratio:**
- Calculate: images per 500 words
- Assess: helpful or decorative?

**Internal Links:**
- Count of internal links
- Quality: contextual or generic?

**Interactive Elements:**
- Calculators
- Demos
- Quizzes
- Downloadable resources

**Readability:**
- Average paragraph length (short/medium/long)
- Sentence complexity (simple/mixed/complex)
- Use of bullet points and lists

---

### Step 3: Gap Identification

Compare all competitors to identify opportunities:

#### 3A: Coverage Gaps (What's Missing)

**GSC-Confirmed Coverage Gaps (Conditional):**

If GSC data is available (via `gsc-article-data.md` or `gsc-calendar-signals.md`), identify GSC-confirmed gaps BEFORE competitor analysis:

- **Queries with high impressions but no dedicated page** are PROVEN coverage gaps — real search demand validates the opportunity without competitor analysis.
- **Process:**
  1. Load GSC query data (from gsc-analyst output or Queries.csv directly)
  2. Identify queries with 50+ monthly impressions where no existing article targets them
  3. Cross-reference with Pages.csv to confirm no page ranks in top 20 for the query
  4. Mark these as **GSC-Confirmed Critical Gaps** (automatically 5-star priority)

- **Output format:**

| Query | Monthly Impressions | Current Best Page | Position | Gap Type |
|-------|-------------------|-------------------|----------|----------|
| "[query]" | [N] | [URL or none] | [N or -] | No dedicated coverage / Complete gap |

GSC-confirmed gaps are added to the Coverage Gaps section with highest priority. They do not require competitor validation since real search demand proves the opportunity.

**If GSC data unavailable:** Skip this sub-step, proceed with standard competitor-based gap identification below.

---

**Identify Underexplored Subtopics:**
- Topics mentioned by 0 competitors = **Critical gap**
- Topics mentioned by 1-2 competitors = **High-value gap**
- Topics mentioned by 3-4 competitors = **Moderate gap**
- Topics mentioned by 5+ competitors = Saturated (avoid unless you can go deeper)

**Find Unanswered Questions:**
- What questions do users likely have that no competitor answers?
- What "how do I..." scenarios are ignored?
- What edge cases are overlooked?

**Identify Ignored Use Cases:**
- Audience segments not addressed
- Industry-specific applications missed
- Workflow variations not covered

**Calculate Coverage Gap Priority:**
- 5 stars: 3+ critical gaps identified (or any GSC-confirmed gaps with 200+ impressions)
- 4 stars: 1-2 critical gaps or 3+ high-value gaps (or GSC-confirmed gaps with 50-200 impressions)
- 3 stars: Multiple moderate gaps
- 2 stars: Few small gaps
- 1 star: Saturated coverage

#### 3B: Depth Gaps (Superficial Coverage)

**Identify Shallow Areas:**
- Topics where competitors average <200 words
- Topics mentioned but not explained
- "Just do X" statements without showing how

**Find Missing Technical Elements:**
- Code examples: 0-2 competitors provide working code = gap
- Configuration details: "just configure" without examples = gap
- Edge cases: potential issues not addressed = gap
- Error handling: no troubleshooting guidance = gap

**Assess Prerequisites Coverage:**
- Do competitors assume too much knowledge?
- Are setup steps skipped?
- Is version compatibility mentioned?

**Calculate Depth Gap Priority:**
- 5 stars: Major technical gaps in high-importance areas
- 4 stars: Multiple moderate technical gaps
- 3 stars: Some superficial coverage areas
- 2 stars: Generally adequate depth
- 1 star: Competitors already very deep

#### 3C: Format Gaps (Presentation Opportunities)

**Identify Missing Formats:**
- Video walkthroughs: 0-1 competitors have video = gap
- Comparison tables: 0-2 competitors use tables = gap
- Downloadable resources: 0-1 competitors provide downloads = gap
- Interactive demos: 0 competitors have interactive = gap
- Visual diagrams: 0-2 competitors use diagrams = gap

**Calculate Visual Aid Opportunity:**
- Competitor average: X images per Y words
- Opportunity: Increase ratio by 50-100% if competitors are light on visuals
- Focus on: screenshots, annotated diagrams, process flows

**Assess Structural Enhancements:**
- Table of contents: present in <50% = opportunity
- Quick reference guide/cheat sheet: 0-1 competitors = opportunity
- Summary checklist: 0-2 competitors = opportunity
- Before/after examples: 0-2 competitors = opportunity

**Calculate Format Gap Priority:**
- 5 stars: Multiple high-impact format gaps (video, interactive, etc.)
- 4 stars: Several moderate format opportunities
- 3 stars: Some format enhancements possible
- 2 stars: Competitors already diverse in format
- 1 star: Limited format differentiation possible

#### 3D: Recency Gaps (Outdated Information)

**GSC Impression Trends for Recency Validation (Conditional):**

If GSC data is available, use impression trends to validate whether users are actively searching for newer content:

- **Process:**
  1. Check GSC Queries.csv for version-specific queries (e.g., "wordpress 6.7", "react 19", "python 3.13")
  2. Compare impressions for version-specific queries — rising impressions for newer versions confirm recency demand
  3. Check Chart.csv for overall impression trends on the topic — growing impressions suggest increasing user interest
  4. Identify queries containing "new", "latest", "update", "[year]" — these signal users actively seeking fresh content

- **Output:**

| Version Query | Monthly Impressions | Trend | Recency Signal |
|--------------|-------------------|-------|---------------|
| "[topic] 6.7" | 450 | Rising | Users seeking new version coverage |
| "[topic] 6.5" | 120 | Declining | Previous version losing relevance |

GSC impression trends provide evidence-based recency validation: if users are searching for newer versions, the recency gap is confirmed with real demand data rather than just competitor analysis.

**If GSC data unavailable:** Skip this sub-step, proceed with standard recency analysis below.

---

**Check Version Currency:**
- What product/plugin versions do competitors reference?
- Is there a newer version released in last 3 months?
- Gap = competitors reference outdated versions

**Identify Recent Developments:**
- New features released in last 3 months not mentioned = **Critical recency gap**
- API changes or best practice updates not reflected = **High-value gap**
- Deprecated methods still recommended = **Critical gap**

**Assess Content Freshness:**
- How many competitors updated in last 6 months?
- <50% updated = recency advantage opportunity
- Check publish dates and "last updated" indicators

**Calculate Recency Gap Priority:**
- 5 stars: Major version/feature released, 0-2 competitors cover it (or GSC shows rising impressions for new version queries)
- 4 stars: Significant updates missed by most competitors (or GSC shows moderate impression growth for version queries)
- 3 stars: Some outdated information present
- 2 stars: Most competitors reasonably current
- 1 star: All competitors very fresh

---

### Step 4: Differentiation Strategy

Based on gap analysis, generate **prioritized tactical recommendations**:

#### Strategy Selection Criteria

**Priority 1 Strategies** (Must implement):
- Addresses 5-star gap (critical opportunity)
- Aligns with configured focus areas from requirements.md
- Feasible within word count and format constraints
- High search intent (validates user demand)

**Priority 2 Strategies** (Should implement):
- Addresses 4-star gap (high-value opportunity)
- Complements Priority 1 strategies
- Differentiates from majority of competitors

**Priority 3 Strategies** (Nice-to-have):
- Addresses 3-star gap (moderate opportunity)
- Enhances overall quality
- Time/resources permitting

#### Strategy Components

For each recommended strategy, specify:

**1. Tactic Name:**
- Clear, specific action (e.g., "Add Mobile Performance Optimization Section")

**2. Why It Works:**
- Gap addressed: "0/10 competitors cover this"
- User need: "High search intent for '[related keyword]'"
- Alignment: "Matches configured focus area: [area]"
- Competitive advantage: "Immediate differentiation"

**3. Implementation Details:**
- Specific action: "Add dedicated H2 section (500-700 words)"
- Content requirements: "Include 3 code examples with before/after metrics"
- Format requirements: "Add comparison table showing performance gains"
- Research needed: "Benchmark 3-5 popular plugins/setups"

**4. Success Metrics:**
- SEO: "Rank in top 3 for '[keyword] mobile performance'"
- Engagement: "20%+ higher time-on-page than competitor average"
- Authority: "Attract backlinks from developers sharing benchmarks"
- Conversion: "Higher newsletter signup rate from value delivered"

#### Unique Value Proposition

Synthesize differentiation strategies into a single sentence:

**Format:**
"The only guide that [Unique Element 1] with [Unique Element 2] and [Unique Element 3]"

**Example:**
"The only guide that includes real performance benchmarks with mobile-specific optimization steps and downloadable test scripts"

---

### Step 5: Report Generation

**Choose report type based on mode:**

#### Option A: Full Analysis Report (Default Mode)

Create comprehensive gap analysis report saved as:
```
project/Articles/[ARTICLE-ID]/gap-analysis-report.md
```

**Full Report Structure:**

1. **Executive Summary**
   - Key opportunity (1 sentence)
   - Recommended strategy (brief tactical approach)
   - Expected impact (specific advantage)

2. **Competitor Landscape Overview**
   - Table with: Rank, Title, Domain, Word Count, Format, Publish Date, Depth Score
   - Landscape observations (averages, patterns, trends)

3. **Gap Analysis**
   - Coverage Gaps (with priority rating)
   - Depth Gaps (with priority rating)
   - Format Gaps (with priority rating)
   - Recency Gaps (with priority rating)

4. **Differentiation Strategy**
   - Priority 1 Strategy (5 stars, must implement)
   - Priority 2 Strategy (4 stars, should implement)
   - Priority 3 Strategy (3 stars, nice-to-have)
   - Each with: Tactic, Why It Works, Implementation, Success Metrics

5. **Competitive Positioning**
   - "After implementing differentiation strategy, this article will..."
   - Checklist of advantages gained
   - Unique value proposition statement

6. **Research Sources**
   - List all competitor URLs analyzed
   - Additional research sources (forums, docs, GitHub)

7. **Reviewer Notes**
   - Guidance for @writer agent
   - Validation checklist for @editor agent

**Report Template:** Use `templates/gap-report-template.md`

---

#### Option B: Pre-Analysis Summary (Lightweight Mode)

Create lightweight summary saved as:
```
project/Calendar/{Year}/{Month}/gap-pre-analysis/[ARTICLE-ID]-summary.md
```

**Pre-Analysis Summary Structure:**

```markdown
# Competitive Gap Pre-Analysis: [Topic/Keyword]

**Article ID:** ART-YYYYMM-NNN
**Analysis Date:** YYYY-MM-DD
**Target Keyword:** "[keyword phrase]"
**Analysis Mode:** Pre-Analysis (Lightweight)

---

## Executive Summary

**Opportunity Score:** ⭐⭐⭐⭐ (4.2/5.0)
**Tier:** Tier 1 (High-Opportunity) / Tier 2 (Moderate) / Tier 3 (Low)
**Recommendation:** INCLUDE / CONSIDER / EXCLUDE

**Primary Differentiation Angle:**
"[One sentence describing how this article will demonstrably exceed competitors]"

---

## Gap Breakdown

| Gap Type | Score | Assessment |
|----------|-------|------------|
| Coverage | ⭐⭐⭐⭐⭐ (5/5) | 3 critical coverage gaps identified |
| Depth | ⭐⭐⭐⭐ (4/5) | Most competitors superficial, lacking code examples |
| Format | ⭐⭐⭐ (3/5) | Some format differentiation opportunities |
| Recency | ⭐⭐⭐⭐⭐ (5/5) | Recent update (2 weeks) not covered by competitors |

**Opportunity Score Calculation:**
```
(Coverage: 5 × 0.30) + (Depth: 4 × 0.35) + (Format: 3 × 0.15) + (Recency: 5 × 0.20)
= 1.5 + 1.4 + 0.45 + 1.0 = 4.35 → 4.4/5.0 ⭐⭐⭐⭐
```

---

## Top 3 Opportunities

### 1. Coverage Gap (CRITICAL) ⭐⭐⭐⭐⭐
**Finding:** 0/8 competitors cover [specific subtopic/feature]
**Evidence:** Searched "[related keyword]" - no results matching this angle
**Why It Matters:** High search intent, no existing comprehensive resource
**Quick Win:** First-mover advantage

### 2. Recency Gap (CRITICAL) ⭐⭐⭐⭐⭐
**Finding:** Version X.Y released 2 weeks ago, 0/8 competitors updated
**Evidence:** Latest competitor update was 4 months ago (pre-X.Y release)
**Why It Matters:** Breaking feature affects [use case], practitioners need current guidance
**Quick Win:** Immediate relevance

### 3. Depth Gap (HIGH-VALUE) ⭐⭐⭐⭐
**Finding:** 7/8 competitors theory-only, no working code examples
**Evidence:** Average code blocks per article: 0.5 (1 competitor had 4, rest had 0)
**Why It Matters:** Practitioners need implementation guidance, not just concepts
**Differentiation:** Include 5+ code examples with explanations

---

## Competitive Landscape

**Competitors Analyzed:** 8 (top-ranking for "[keyword]")

| Rank | Domain | Word Count | Format | Publish Date | Notes |
|------|--------|------------|--------|--------------|-------|
| 1 | example.com | 2,400 | Tutorial | 4 months ago | Plugin-focused, no code |
| 2 | another.com | 1,800 | Listicle | 6 months ago | Outdated version |
| ... | ... | ... | ... | ... | ... |

**Landscape Summary:**
- Average word count: 2,200
- Average publish date: 5 months ago
- Saturation level: Moderate (room for superior content)
- Common format: Tutorial (5/8), Listicle (2/8), Guide (1/8)
- Code examples: Only 1/8 competitors include working code
- Diagrams: 2/8 competitors have visual diagrams

---

## Feasibility Assessment

**Overall Feasibility:** HIGH / MEDIUM / LOW

**Checklist:**
- [ ] ✅ Official documentation available ([URL])
- [ ] ✅ No SME required (intermediate-level topic)
- [ ] ✅ Fits configured word count range (target: 1,500 words within 900-2,000 range)
- [ ] ✅ Aligns with focus areas (matches "[Focus Area]" from requirements.md)
- [ ] ✅ Appropriate depth for target audience (intermediate)
- [ ] ✅ No specialized testing/hardware required
- [ ] ⚠️ May require [minor consideration]

**Potential Blockers:** None identified / [Describe if any]

**Time Estimate:** [X] hours research + [Y] hours writing = [Z] hours total

---

## Unique Value Proposition

**After implementing differentiation strategy, this article will be:**

"The only [keyword] guide that covers [unique element 1: new version X.Y] with [unique element 2: working code examples] and [unique element 3: field-mapping templates]"

**Competitive Advantages:**
1. ✅ First comprehensive guide for version X.Y (recency advantage)
2. ✅ Only resource with 5+ working code examples (depth advantage)
3. ✅ Includes downloadable templates (format advantage)

---

## Recommendation

**Include in Calendar:** YES / MAYBE / NO

**Rationale:**
[2-3 sentences explaining why this topic should/shouldn't be included in the content calendar based on opportunity score, feasibility, and strategic alignment]

**Priority Tier:** Tier 1 (High-Opportunity) — MUST INCLUDE

**Suggested Publish Week:** Week [N] of [Month] (rationale: [timing reason])

---

## Next Steps

**If topic is selected for calendar:**
1. Full competitive gap analysis during `/write-article` phase
2. Detailed implementation tactics from @researcher
3. @writer focuses on Priority 1-2 differentiation tactics
4. @editor validates differentiation execution

**Full Analysis:** Will be generated at `project/Articles/[ARTICLE-ID]/gap-analysis-report.md` during article writing phase

---

**Analysis Completed:** [Timestamp]
**Analyst:** competitive-gap-analyzer skill (pre-analysis mode)
```

---

### Step 6: Research Brief Integration (Full Analysis Mode Only)

Create concise **Differentiation Strategy section** for research brief:

```markdown
## Differentiation Strategy

Based on competitive analysis of [N] top-ranking articles for "[keyword]":

### Priority 1: [Tactic Name] ⭐⭐⭐⭐⭐
**Gap:** [Specific gap identified]
**Action:** [Specific implementation guidance]
**Why:** [User value + competitive advantage]

### Priority 2: [Tactic Name] ⭐⭐⭐⭐
**Gap:** [Specific gap identified]
**Action:** [Specific implementation guidance]
**Why:** [User value + competitive advantage]

### Priority 3: [Tactic Name] ⭐⭐⭐
**Gap:** [Specific gap identified]
**Action:** [Specific implementation guidance]
**Why:** [User value + competitive advantage]

### Unique Value Proposition
"[One sentence describing what makes this article uniquely valuable]"

**Full Analysis:** See `gap-analysis-report.md` for complete competitive landscape, gap priorities, and implementation details.
```

---

## Output Files

### Full Analysis Mode
**Primary Output:**
- `project/Articles/[ARTICLE-ID]/gap-analysis-report.md` - Complete analysis report

**Secondary Output:**
- Differentiation Strategy section (text to be inserted into research brief)

### Pre-Analysis Mode
**Primary Output:**
- `project/Calendar/{Year}/{Month}/gap-pre-analysis/[ARTICLE-ID]-summary.md` - Lightweight summary

**Secondary Output:**
- Opportunity score and differentiation angle (for content calendar table)

---

## Quality Guidelines

### Analysis Quality

**DO:**
- Analyze actual top-ranking competitors (use WebSearch, not assumptions)
- Identify gaps that serve user needs (not just "different for different's sake")
- Provide specific, actionable implementation guidance
- Prioritize gaps based on configured focus areas
- Validate recommendations against requirements.md constraints

**DON'T:**
- Recommend adding content just to be longer
- Suggest differentiation that doesn't serve user intent
- Ignore feasibility (word count limits, format constraints)
- Copy competitor approaches without adding value
- Overlook alignment with configured brand voice and strategy

### Report Quality

**DO:**
- Use specific numbers and evidence ("0/10 competitors", "average 150 words")
- Provide URLs for all competitors analyzed
- Clearly mark priorities (5-star vs. 3-star)
- Include implementation specifics (word counts, number of examples)
- Connect gaps to user value and business goals

**DON'T:**
- Make vague statements ("competitors lack depth")
- Omit evidence or examples
- Create overwhelming lists (focus on top 3 priorities)
- Skip implementation details
- Ignore configured requirements from requirements.md

---

## Usage Examples

### Example 1: Automatic Invocation (Standard Workflow)

```
@researcher agent is working on article ART-202510-003
Article calendar entry includes: "Target Keyword: WooCommerce checkout optimization"

Researcher invokes competitive-gap-analyzer skill:
  - Input: keyword = "WooCommerce checkout optimization", article_id = "ART-202510-003"
  - Skill searches, analyzes 8 competitors, generates gap-analysis-report.md
  - Researcher incorporates differentiation strategy into research-brief.md

Writer receives research brief with clear differentiation tactics
Editor validates differentiation strategy was implemented
```

### Example 2: Manual Invocation (Content Planning)

```
User wants to evaluate keyword opportunities before creating calendar

User invokes: Skill competitive-gap-analyzer
User provides: keyword = "WordPress security hardening"

Skill generates gap analysis showing:
  - 5-star Coverage Gap: No competitor covers file permission auditing
  - 4-star Depth Gap: Security plugin configs shown but not explained
  - 5-star Recency Gap: New security features in WordPress 6.4 (released 1 month ago)

User decides: High-opportunity topic, adds to content calendar with differentiation notes
```

### Example 3: Content Refresh Analysis

```
Existing article ART-202508-005 published 6 months ago
User wants to refresh for competitiveness

User invokes: Skill competitive-gap-analyzer
User provides: keyword = "[article's target keyword]", article_id = "ART-202508-005"

Skill compares:
  - Current competitor landscape (6 months later)
  - Identifies new gaps that emerged
  - Identifies where competitors now exceed our article

Researcher updates article with new differentiation tactics
Editor validates refresh meets new competitive landscape
```

---

## Error Handling

### Scenario 1: Insufficient Competitors Found

**Issue:** WebSearch returns <5 quality competitors

**Response:**
- Document in report: "Limited competitive landscape ([N] competitors found)"
- Still perform analysis on available competitors
- Note opportunity: "Low competition = easier to rank"
- Adjust strategy: Focus on comprehensive coverage rather than differentiation

### Scenario 2: Saturated Topic

**Issue:** All gaps are low-priority (1-2 stars), competitors very comprehensive

**Response:**
- Document in report: "Highly saturated topic - differentiation challenging"
- Recommend alternative strategies:
  - Original research/data (can't be copied)
  - Expert interviews (unique perspective)
  - Format innovation (video, interactive)
  - Recency focus (be first to update)
- Flag for user decision: "Consider different keyword/angle"

### Scenario 3: WebFetch Limitations

**Issue:** Can't access competitor content (paywall, JavaScript-heavy, etc.)

**Response:**
- Document in report: "Unable to analyze [N] competitors due to access limitations"
- Analyze available competitors
- Note in recommendations: "Manual review of [blocked URLs] recommended"
- Proceed with analysis based on accessible competitors

### Scenario 4: Unclear Target Keyword

**Issue:** Article brief doesn't specify clear target keyword

**Response:**
- Extract keyword from article title
- If still unclear, ask user: "Please specify target keyword for competitive analysis"
- Alternative: Skip competitive analysis, note in research brief

---

## Performance Optimization

### Efficiency Measures

**Batch Processing:**
- Make WebSearch calls in parallel when possible
- Use WebFetch efficiently (analyze multiple elements per fetch)

**Caching:**
- Cache competitor analysis for 7 days (same keyword)
- Store in: `.claude/skills/competitive-gap-analyzer/cache/[keyword-hash].json`
- Check cache first: if analysis <7 days old, use cached data

**Timeout Management:**
- Set max analysis time: 5 minutes per article
- If timeout approaching, prioritize:
  1. Top 5 competitors (not full 10)
  2. Coverage + Recency gaps (most impactful)
  3. Generate abbreviated report

---

## Integration with Workflow

### Researcher Agent Integration

**Trigger:** @researcher invokes skill after verifying topic originality

**Input Provided:**
- Target keyword (from article brief)
- Article ID (for file naming)
- Configuration (from requirements.md)

**Output Received:**
- gap-analysis-report.md (full report saved)
- Differentiation strategy text (for research brief)

**Researcher Actions:**
1. Review gap analysis report
2. Insert differentiation strategy into research-brief.md
3. Ensure differentiation tactics align with research findings
4. Flag any infeasible tactics for user review

### Editor Agent Integration

**Trigger:** @editor reviews final article before approval

**Input Required:**
- gap-analysis-report.md (from research phase)
- article.md (final article to validate)

**Validation Checklist:**
- [ ] Priority 1 tactics implemented?
- [ ] Priority 2 tactics implemented?
- [ ] Unique value proposition delivered?
- [ ] Differentiation adds user value (not just different)?

**Editor Actions:**
1. Compare article against differentiation strategy
2. Flag missing Priority 1 tactics for revision
3. Verify differentiation claims are accurate
4. Optionally: Re-run analysis to confirm competitive positioning

---

## Success Metrics

### Skill Performance Metrics

**Efficiency:**
- Analysis completion time: Target <5 minutes per article
- Competitor identification success rate: 80%+ find 8+ quality competitors
- Cache hit rate: 30%+ (reduces redundant analysis)

**Accuracy:**
- Gap identification accuracy: 90%+ (validated post-publication via ranking analysis)
- Differentiation strategy adoption: 80%+ tactics implemented by writer
- User satisfaction: 85%+ find recommendations actionable

### Content Impact Metrics

**Search Performance:**
- Top 3 ranking: 60%+ articles rank in top 3 for target keyword within 90 days
- Top 10 ranking: 90%+ articles rank in top 10 within 60 days
- Featured snippet: 15%+ articles earn featured snippet

**Engagement:**
- Time-on-page: 20%+ higher than competitor average
- Scroll depth: 75%+ scroll to bottom (indicates comprehensive value)
- Bounce rate: 15%+ lower than site average

**Authority:**
- Backlinks: 3+ natural backlinks within 6 months per article
- Social shares: 2x competitor average
- Citations: Become referenced resource (tracked via brand mentions)

### Business Impact Metrics

**Traffic:**
- 30%+ increase per article vs. non-analyzed articles
- Cumulative: 45,000+ pageviews annually (100 articles)

**Conversion:**
- 25%+ higher newsletter signup rate from differentiated articles
- Revenue: $15,000+ additional annual revenue from conversions

**Brand Authority:**
- Become go-to resource in configured niche
- Industry recognition (mentions, conference invites)
- Competitor citing (validation of thought leadership)

---

## Continuous Improvement

### Feedback Loop

**Track Performance:**
- Log all analyses: keyword, date, competitors, recommendations
- Track article outcomes: ranking, traffic, engagement, conversions
- Correlate: which gap types drive best results?

**Iterate Strategy:**
- Refine gap priority scoring based on outcomes
- Adjust depth scoring weights based on what drives engagement
- Update templates based on what writers find most actionable

**Share Learnings:**
- Monthly review: "Top competitive insights discovered"
- Quarterly analysis: "Gap types with highest ROI"
- Annual report: "Competitive positioning wins"

---

## Conclusion

The Competitive Gap Analyzer is a strategic content intelligence system. It transforms article creation from art to science by systematically identifying where competitors fall short and providing actionable tactics to exceed their coverage, depth, format, and recency.

**Key Success Factors:**
1. **Automatic Integration:** Runs seamlessly during research phase
2. **Actionable Output:** Writers receive specific implementation guidance
3. **Validation Built-In:** Editors verify differentiation was executed
4. **Configuration-Driven:** Adapts to any topic via requirements.md
5. **Evidence-Based:** Recommendations backed by specific gap analysis

**The Result:**
Every article becomes a calculated move to dominate its keyword space through demonstrable superiority.
