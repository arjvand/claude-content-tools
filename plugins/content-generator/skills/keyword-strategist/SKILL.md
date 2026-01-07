---
name: keyword-strategist
description: Create strategic keyword plans that map keywords to content strategy, topic clusters, funnel stages, and competitive positioning. Use during content calendar planning or article research to prioritize keywords based on business goals.
---

# Keyword Strategist Skill

## Purpose
Transform tactical keyword data into strategic keyword plans by building topic cluster architectures, mapping keywords to funnel stages, classifying competitive positioning, and generating prioritized keyword roadmaps aligned with business objectives.

**Key Distinction:**
- **keyword-researcher** = TACTICAL: "What are the metrics for this keyword?"
- **keyword-strategist** = STRATEGIC: "Which keywords should we target, in what order, and how do they connect to our content strategy?"

This skill works WITH keyword-researcher output, building strategic context on top of tactical keyword data. It does NOT duplicate SERP analysis or keyword metrics.

## When to Use
- **Automatically:** During `/content-calendar` generation (Step 1C, before topic discovery) — Strategic Planning Mode
- **Automatically:** During `/write-article` research phase (after keyword-researcher) — Article-Level Mode
- **Manually:** When planning quarterly/monthly keyword strategy — Strategic Planning Mode
- **Strategically:** When auditing topic cluster coverage — Cluster Refresh Mode
- **Proactively:** For pillar content planning — Strategic Planning Mode

---

## Invocation Modes

### Mode 1: Strategic Planning (Comprehensive)

**Use During:** `/content-calendar` generation (Step 1C, after config loading)

**Purpose:** Create quarterly or monthly keyword strategy to guide topic generation, signal research, and content prioritization

**Output:**
- Complete `keyword-strategy.md` (comprehensive strategy document)
- `keyword-strategy.json` (structured data for programmatic use)
- Topic cluster architecture with pillar → cluster mapping
- Funnel-balanced keyword distribution
- Prioritized keyword roadmap (Tier 1-4)

**Process:**
- Builds topic cluster keyword architecture from configured pillars
- Maps keywords to funnel stages (awareness/consideration/decision)
- Classifies keywords by competitive winnability
- Identifies SERP feature opportunities
- Applies seasonal and trend timing analysis
- Generates prioritized keyword roadmap with scoring

**Time:** 15-20 minutes

**Storage:** `project/Calendar/{Year}/{Month}/keyword-strategy.md`

**Invocation:**
```
Please use the keyword-strategist skill in strategic planning mode for [Month Year].
```

---

### Mode 2: Article-Level Strategy (Targeted)

**Use During:** `/write-article` Phase 2.3 (after keyword-researcher completes)

**Purpose:** Create keyword strategy for specific article, mapping primary keyword to secondary keywords, internal linking opportunities, and SERP feature targeting

**Input:**
- `article_id`: Article ID from calendar
- `primary_keyword`: From calendar entry
- `keyword_research_file`: Path to keyword-research.md (from keyword-researcher skill)

**Output:**
- Article-specific `keyword-strategy.md`
- Secondary keyword placement map
- Internal linking keyword strategy
- SERP feature targeting tactics
- Funnel position alignment

**Process:**
- Loads keyword-research.md data from keyword-researcher
- Maps primary to secondary keyword relationships
- Identifies funnel position and intent alignment
- Generates internal linking keyword map
- Identifies SERP feature targeting tactics
- Creates article-level keyword strategy

**Time:** 3-5 minutes

**Storage:** `project/Articles/[ARTICLE-ID]/keyword-strategy.md`

**Invocation:**
```
Please use the keyword-strategist skill in article-level mode for [ARTICLE-ID].
Primary Keyword: "[primary keyword from calendar]"
Keyword Research: project/Articles/[ARTICLE-ID]/keyword-research.md
```

---

### Mode 3: Cluster Refresh (Diagnostic)

**Use During:** Ad-hoc when evaluating existing content gaps or planning pillar content

**Purpose:** Analyze existing keyword coverage within a topic pillar and identify gaps in cluster strategy

**Input:**
- `topic_pillar`: Specific pillar to analyze (from requirements.md)
- `existing_articles`: Published article keywords (from meta.yml files)

**Output:**
- Cluster gap analysis report
- Keyword opportunities within pillar
- Internal linking optimization recommendations
- Pillar completion percentage

**Process:**
- Loads existing article keyword coverage from meta.yml files
- Builds complete cluster keyword map for specified pillar
- Identifies coverage gaps (keywords without articles)
- Prioritizes gap opportunities
- Generates refresh recommendations

**Time:** 8-12 minutes

**Storage:** `project/Calendar/{Year}/{Month}/cluster-refresh-{pillar-slug}.md`

**Invocation:**
```
Please use the keyword-strategist skill in cluster refresh mode for pillar "[Pillar Name]".
```

---

## Configuration-Driven Approach

**Before strategizing, load configuration using requirements-extractor:**

```markdown
Please use the requirements-extractor skill to load validated configuration from project/requirements.md.
```

**Extract the following from the structured output:**

1. **Topic Pillars**:
   - From `content.topic_pillars[]` → Core topic areas for cluster architecture
   - From `content.focus_areas[]` → Secondary focus for keyword selection

2. **Audience**:
   - From `audience.skill_level` → Keyword complexity preferences
   - From `audience.primary_roles[]` → Target personas for funnel mapping

3. **SEO Strategy**:
   - From `seo.strategy[]` → Strategic direction for keyword selection
   - From `seo.primary_cta` → Conversion goal (maps to decision stage)
   - From `seo.internal_linking` → Internal linking strategy

4. **Content Parameters**:
   - From `content.formats[]` → Content types for format matching
   - From `content.mix` → Target distribution by content type
   - From `content.word_count_range` → Depth expectations

5. **Competitive Settings**:
   - From `competitive.opportunity_weights` → Gap prioritization weights
   - From `competitive.min_opportunity_score` → Threshold for inclusion

**Use these extracted values throughout the strategic planning process.**

---

## Phase 0: Load Configuration (30 seconds)

**Objective:** Extract strategic context from requirements.md

**Actions:**
1. Invoke requirements-extractor skill
2. Extract configuration fields listed above
3. Validate topic_pillars exist (required for cluster architecture)
4. Validate audience section exists (required for funnel mapping)

**Output:** Structured configuration context for strategic planning

**Validation Gate:**
- If `content.topic_pillars` is empty or missing → WARN: "No topic pillars configured. Cannot build cluster architecture."
- If `audience.primary_roles` is missing → WARN: "No audience roles defined. Funnel mapping may be less accurate."

---

## Phase 1: Topic Cluster Architecture (3-4 minutes)

**Objective:** Build pillar → cluster keyword structure from configured topic pillars

### Step 1.1: Pillar Keyword Identification

For each topic_pillar from configuration:

```
WebSearch: "[pillar topic] comprehensive guide"
WebSearch: "[pillar topic] complete tutorial"
WebSearch: "[pillar topic] everything you need to know"
```

Extract pillar-level keywords:
- High-volume, high-difficulty "head" keywords
- Typically 1-2 words defining the topical category
- These become aspirational long-term targets

**Pillar Keyword Attributes:**
| Attribute | Description |
|-----------|-------------|
| Pillar Name | From requirements.md topic_pillars |
| Head Keyword | Primary 1-2 word keyword |
| Pillar Variants | Alternative phrasings (2-3) |
| Difficulty | Typically 60-80+ (high competition) |
| Status | ASPIRATIONAL (long-term target) |

### Step 1.2: Cluster Keyword Expansion

For each pillar keyword, expand to cluster keywords using modifier patterns:

```
WebSearch: "[pillar keyword] how to"
WebSearch: "[pillar keyword] vs"
WebSearch: "[pillar keyword] best"
WebSearch: "[pillar keyword] tutorial"
WebSearch: "[pillar keyword] for beginners"
WebSearch: "[pillar keyword] examples"
WebSearch: "[pillar keyword] tools"
```

**Cluster Keyword Categories:**

| Category | Pattern | Content Application |
|----------|---------|---------------------|
| **How-To** | "[pillar] how to [action]" | Tutorial, step-by-step guides |
| **Comparison** | "[pillar] vs [alternative]" | Comparison articles, buyer guides |
| **Best-Of** | "best [pillar] [type]" | Listicles, recommendations |
| **Problem-Solution** | "[pillar] [problem] fix" | Troubleshooting guides |
| **Use-Case** | "[pillar] for [use case]" | Application guides |
| **Beginner** | "[pillar] for beginners" | Introductory content |
| **Tool-Specific** | "[pillar] with [tool]" | Integration guides |

### Step 1.3: Build Cluster Map

Generate topic cluster architecture:

```markdown
## Topic Cluster: [Pillar Name]

### Pillar Content (1 article)
- **Head Keyword:** "[pillar keyword]"
- **Format:** Comprehensive Guide (2500-3500 words)
- **Intent:** Informational (overview)
- **Status:** ASPIRATIONAL

### Cluster Content (8-15 articles)

**How-To Cluster:**
- "[how-to keyword 1]"
- "[how-to keyword 2]"
- "[how-to keyword 3]"

**Comparison Cluster:**
- "[comparison keyword 1]"
- "[comparison keyword 2]"

**Problem-Solution Cluster:**
- "[problem keyword 1]"
- "[problem keyword 2]"

**Use-Case Cluster:**
- "[use-case keyword 1]"
- "[use-case keyword 2]"
```

**Output:** Complete cluster map for all configured pillars

---

## Phase 2: Funnel Mapping (2-3 minutes)

**Objective:** Map keywords to buyer journey stages for balanced content distribution

### Step 2.1: Intent-to-Funnel Mapping

Classify keywords by funnel stage based on search intent patterns:

| Funnel Stage | Intent Type | Keyword Patterns | Content Goal |
|--------------|-------------|------------------|--------------|
| **Awareness** | Informational | "what is", "how does", "types of", "guide to", "tutorial" | Educate, build trust |
| **Consideration** | Commercial | "best", "vs", "comparison", "reviews", "alternatives", "top" | Evaluate options |
| **Decision** | Transactional | "buy", "pricing", "download", "signup", "demo", "trial" | Convert |

### Step 2.2: Funnel Distribution Analysis

Calculate target funnel balance from configuration and industry:

**Default Distribution:**
```
Awareness: 50% (broad reach, brand building)
Consideration: 35% (qualified traffic)
Decision: 15% (conversion-ready)
```

**Adjust based on configuration:**
- If `seo.primary_cta` is conversion-focused → Increase Decision to 20%
- If `content.objective` is brand awareness → Increase Awareness to 60%
- If `audience.skill_level` is advanced → Decrease Awareness to 40%

### Step 2.3: Current Distribution Assessment

If existing content available (not first calendar):

```
current_distribution = analyze_existing_articles(meta.yml files)

gap_analysis = {
  awareness: target_awareness - current_awareness,
  consideration: target_consideration - current_consideration,
  decision: target_decision - current_decision
}
```

**Gap Priority:**
- Gap >10% = HIGH priority to fill
- Gap 5-10% = MEDIUM priority
- Gap <5% = ON TARGET

### Step 2.4: Funnel-Balanced Keyword Selection

Prioritize keywords that fill funnel gaps:

```markdown
## Funnel-Prioritized Keywords

### Decision Stage (Priority: [HIGH/MED/LOW])
1. "[decision keyword 1]" - [conversion signal]
2. "[decision keyword 2]" - [conversion signal]

### Consideration Stage (Priority: [HIGH/MED/LOW])
1. "[consideration keyword 1]" - [evaluation signal]
2. "[consideration keyword 2]" - [evaluation signal]

### Awareness Stage (Priority: [HIGH/MED/LOW])
1. "[awareness keyword 1]" - [educational signal]
2. "[awareness keyword 2]" - [educational signal]
```

---

## Phase 3: Competitive Positioning (3-4 minutes)

**Objective:** Categorize keywords by winnability based on competitive landscape

### Step 3.1: Authority Assessment

Determine site authority level from configuration context:

| Authority Tier | Indicators | Winnable Keywords |
|----------------|------------|-------------------|
| **High Authority** | Established brand, 5+ years, many backlinks | Can compete for difficulty 60-75 |
| **Medium Authority** | Growing site, 2-5 years | Focus on difficulty 40-60 |
| **Low Authority** | New site, <2 years | Prioritize difficulty <40 |

**Default assumption:** Medium Authority (unless specified in config)

### Step 3.2: Keyword Winnability Classification

For each keyword in cluster map, classify winnability:

**Winnability Categories:**

| Category | Difficulty Range | Timeline | Strategy |
|----------|------------------|----------|----------|
| **Winnable** | <40 (Easy) | 1-3 months | Target immediately |
| **Achievable** | 40-60 (Moderate) | 3-6 months | Build supporting content |
| **Aspirational** | 60-80 (Difficult) | 6-12 months | Win cluster keywords first |
| **Avoid** | >80 (Very Difficult) | N/A | Too competitive, deprioritize |

### Step 3.3: Strategic Keyword Pathways

Map pathways from winnable to aspirational keywords:

```markdown
## Keyword Progression Pathway

### Target: "[Aspirational Keyword]" (Difficulty: 72)

**Building Blocks (Win First):**
1. "[Winnable keyword 1]" (Difficulty: 35) - Foundation
2. "[Achievable keyword 2]" (Difficulty: 48) - Technical depth
3. "[Achievable keyword 3]" (Difficulty: 52) - Related concept

**Pathway Timeline:**
- Months 1-2: Win building block keywords
- Months 3-4: Build topical authority with cluster content
- Month 5-6: Target aspirational keyword with pillar content

**Expected Outcome:** Top 10 ranking for aspirational keyword
```

### Step 3.4: Competitive Position Matrix

Generate winnability matrix for all keywords:

| Keyword | Difficulty | Winnability | Strategy | Priority |
|---------|------------|-------------|----------|----------|
| "[keyword 1]" | 32 | Winnable | Immediate target | Tier 1 |
| "[keyword 2]" | 48 | Achievable | Build supporting | Tier 2 |
| "[keyword 3]" | 68 | Aspirational | Long-term pathway | Tier 3 |
| "[keyword 4]" | 85 | Avoid | Too competitive | Tier 4 |

---

## Phase 4: SERP Feature Targeting (2-3 minutes)

**Objective:** Identify opportunities for featured snippets, PAA, and other SERP features

### Step 4.1: Featured Snippet Opportunity Analysis

For high-priority keywords, analyze SERP for snippet opportunities:

```
WebSearch: "[keyword]"
```

**Snippet Opportunity Signals:**

| Signal | Opportunity | Content Tactic |
|--------|-------------|----------------|
| Existing featured snippet | HIGH (can steal) | Better format, more complete answer |
| PAA boxes present | HIGH | Answer questions directly |
| No snippet but list SERP | MEDIUM | Create definitive answer format |
| Knowledge panel present | LOW | Google has authoritative answer |

**Snippet Format Targets:**

| Keyword Type | Target Format | Content Structure |
|--------------|---------------|-------------------|
| How-to questions | Ordered list | Numbered steps (5-8 steps) |
| Definition queries | Paragraph | Concise 40-60 word definition |
| Comparison queries | Table | Feature comparison table |
| List queries | Unordered list | Bulleted items (5-10) |

### Step 4.2: PAA Question Extraction

Extract People Also Ask questions for targeting:

```markdown
## PAA Questions to Answer

**Cluster: [Cluster Name]**
1. "[Question 1]?" — Answer in: FAQ section
2. "[Question 2]?" — Answer in: H2 section
3. "[Question 3]?" — Answer in: Standalone article
4. "[Question 4]?" — Answer in: FAQ section
```

### Step 4.3: Video and Rich Result Opportunities

Identify keywords showing video or other rich results:

```markdown
## Video SERP Opportunities

**Keywords with Video Carousels:**
- "[keyword 1]" — 3 YouTube videos in SERP
- "[keyword 2]" — Video carousel + PAA

**Recommendation:**
- Create complementary video content for high-value tutorials
- Embed videos in articles to capture video + text rankings
```

---

## Phase 5: Seasonal and Trend Timing (2-3 minutes)

**Objective:** Identify optimal timing for keyword targeting

### Step 5.1: Seasonal Pattern Detection

Analyze keyword seasonality based on industry context:

```
WebSearch: "[keyword] trends [current year]"
WebSearch: "[keyword] seasonal"
```

**Seasonal Categories:**

| Category | Pattern | Planning Action |
|----------|---------|-----------------|
| **Q4 Spike** | E-commerce, holiday prep | Publish early Q4 |
| **Q1 Spike** | New year planning, migrations | Publish late Q4 |
| **Q2 Spike** | Mid-year audits | Publish early Q2 |
| **Q3 Spike** | Back-to-school, fall prep | Publish mid-Q3 |
| **Evergreen** | Consistent year-round | Any time |

### Step 5.2: Trend Momentum Analysis

Classify keywords by trend direction:

```markdown
## Keyword Trend Analysis

### Rising Trends (Prioritize)
- "[keyword 1]" — +80% YoY (emerging topic)
- "[keyword 2]" — +50% YoY (growing interest)

### Stable Trends (Core Strategy)
- "[keyword 3]" — Consistent demand
- "[keyword 4]" — Mature topic

### Declining Trends (Deprioritize)
- "[keyword 5]" — -30% YoY (deprecated/outdated)
- "[keyword 6]" — -20% YoY (being replaced)
```

### Step 5.3: Timing Recommendations

Generate timing recommendations for target period:

```markdown
## Timing Recommendations for [Month Year]

**Publish Early [Month]:**
- "[keyword 1]" — Seasonal spike coming
- "[keyword 2]" — Trending up

**Publish Mid [Month]:**
- "[keyword 3]" — Evergreen, any time
- "[keyword 4]" — Evergreen, any time

**Avoid This Month:**
- "[keyword 5]" — Off-season (wait for [Month])
- "[keyword 6]" — Declining trend
```

---

## Phase 6: Prioritization Framework (2-3 minutes)

**Objective:** Score and rank keywords for strategic selection

### Step 6.1: Priority Score Calculation

**Formula:**
```
priority_score = (
  business_value × 0.25 +
  winnability × 0.25 +
  funnel_balance × 0.20 +
  serp_opportunity × 0.15 +
  timing × 0.15
)
```

### Step 6.2: Component Scoring (0-5 scale)

**Business Value:**
| Score | Criteria |
|-------|----------|
| 5 | HIGH volume + Transactional intent |
| 4 | HIGH volume + Commercial intent, OR MED volume + Transactional |
| 3 | HIGH volume + Informational, OR MED volume + Commercial |
| 2 | MED volume + Informational |
| 1 | LOW volume |

**Winnability:**
| Score | Criteria |
|-------|----------|
| 5 | Difficulty <30, clear competitive gaps |
| 4 | Difficulty 30-45, some gaps identified |
| 3 | Difficulty 45-60, achievable with quality |
| 2 | Difficulty 60-75, requires authority building |
| 1 | Difficulty >75, dominated by giants |

**Funnel Balance:**
| Score | Criteria |
|-------|----------|
| 5 | Fills funnel gap >10% |
| 4 | Fills funnel gap 5-10% |
| 3 | Matches target distribution |
| 2 | Over-indexed stage by 5-10% |
| 1 | Over-indexed stage by >10% |

**SERP Opportunity:**
| Score | Criteria |
|-------|----------|
| 5 | Featured snippet stealable + PAA presence |
| 4 | No snippet but PAA opportunities |
| 3 | Video carousel opportunity |
| 2 | Standard organic results only |
| 1 | Knowledge panel dominates |

**Timing:**
| Score | Criteria |
|-------|----------|
| 5 | Seasonal spike in 1-4 weeks + Rising trend |
| 4 | Seasonal spike in 1-4 weeks, OR Rising trend |
| 3 | Evergreen (stable year-round) |
| 2 | Off-season (3+ months to relevance) |
| 1 | Declining trend (-20%+ YoY) |

### Step 6.3: Priority Tier Classification

| Tier | Score Range | Description | Target Timeline |
|------|-------------|-------------|-----------------|
| **Tier 1** | 4.0-5.0 | Immediate priority | 1-4 weeks |
| **Tier 2** | 3.5-3.9 | Short-term priority | 4-8 weeks |
| **Tier 3** | 3.0-3.4 | Medium-term priority | 2-3 months |
| **Tier 4** | <3.0 | Long-term / Monitor | 3+ months |

### Step 6.4: Generate Prioritized Roadmap

```markdown
## Prioritized Keyword Roadmap

### Tier 1: Immediate Priority (Score 4.0-5.0)

| Rank | Keyword | Score | Cluster | Funnel | Format | Target Date |
|------|---------|-------|---------|--------|--------|-------------|
| 1 | "[keyword]" | 4.8 | [Cluster] | Decision | Comparison | Week 1 |
| 2 | "[keyword]" | 4.5 | [Cluster] | Consider | Tutorial | Week 2 |

### Tier 2: Short-Term Priority (Score 3.5-3.9)

| Rank | Keyword | Score | Cluster | Funnel | Format | Target Date |
|------|---------|-------|---------|--------|--------|-------------|
| 3 | "[keyword]" | 3.9 | [Cluster] | Aware | Guide | Week 4 |
| 4 | "[keyword]" | 3.7 | [Cluster] | Consider | Review | Week 5 |

### Tier 3: Medium-Term Priority (Score 3.0-3.4)
[Same format...]

### Tier 4: Long-Term / Monitor (<3.0)
[Same format...]
```

---

## Phase 7: Output Generation (1 minute)

### Strategic Planning Output

**Path:** `project/Calendar/{Year}/{Month}/keyword-strategy.md`

```markdown
# Keyword Strategy: [Month Year]

**Generated:** YYYY-MM-DD
**Planning Horizon:** Monthly
**Target Period:** [Month Year]

---

## Executive Summary

**Strategic Focus:**
[2-3 sentence summary of keyword strategy for this period]

**Key Priorities:**
1. [Priority 1 - e.g., "Fill consideration-stage funnel gap"]
2. [Priority 2 - e.g., "Capitalize on seasonal timing"]
3. [Priority 3 - e.g., "Build toward aspirational keywords"]

**Keyword Distribution:**
- **Tier 1 (Immediate):** [N] keywords
- **Tier 2 (Short-term):** [N] keywords
- **Tier 3 (Medium-term):** [N] keywords
- **Total Keywords Mapped:** [N]

**Expected Outcomes:**
- [X]% of Tier 1 keywords ranking top 10 within 90 days
- Funnel balance improved to target distribution
- [X] SERP feature opportunities targeted

---

## Topic Cluster Architecture

### Pillar 1: [Pillar Name]

**Head Keyword:** "[pillar keyword]"
**Difficulty:** [XX]/100
**Status:** [Winnable | Achievable | Aspirational]

**Cluster Keywords:**

| Keyword | Difficulty | Volume | Intent | Funnel | Priority |
|---------|------------|--------|--------|--------|----------|
| "[cluster keyword 1]" | 35 | MED | Info | Aware | Tier 1 |
| "[cluster keyword 2]" | 42 | LOW | Comm | Consid | Tier 2 |

**Cluster Gaps Identified:**
- [Gap 1 - missing keyword/topic]
- [Gap 2 - missing keyword/topic]

**Internal Linking Strategy:**
- Pillar links to: [list cluster articles]
- Each cluster links to: Pillar + 2-3 related clusters

---

### Pillar 2: [Pillar Name]
[Same structure...]

---

## Funnel-Stage Distribution

### Current vs. Target Balance

| Funnel Stage | Current | Target | Gap | Action |
|--------------|---------|--------|-----|--------|
| Awareness | 65% | 50% | -15% | Deprioritize |
| Consideration | 28% | 35% | +7% | Increase focus |
| Decision | 7% | 15% | +8% | Significant increase |

### Funnel-Optimized Keywords

**Decision Stage (Priority: HIGH)**
| Keyword | Difficulty | Signal |
|---------|------------|--------|
| "[keyword 1]" | 38 | Pricing intent |
| "[keyword 2]" | 45 | Buy signal |

**Consideration Stage (Priority: MEDIUM)**
[Same format...]

**Awareness Stage (Priority: LOW)**
[Same format...]

---

## Competitive Positioning Matrix

### Keyword Winnability

**Winnable (1-3 months)**
| Keyword | Difficulty | Our Advantage | Strategy |
|---------|------------|---------------|----------|
| "[keyword 1]" | 32 | Recency gap | First comprehensive guide |
| "[keyword 2]" | 28 | Coverage gap | Niche depth |

**Achievable (3-6 months)**
[Same format...]

**Aspirational (6-12 months)**
| Keyword | Difficulty | Building Blocks | Timeline |
|---------|------------|-----------------|----------|
| "[keyword]" | 68 | Win [cluster 1], [cluster 2] first | Month 6+ |

---

## SERP Feature Opportunities

### Featured Snippet Targets

| Keyword | Current Snippet | Tactic | Target Format |
|---------|-----------------|--------|---------------|
| "[keyword 1]" | Incomplete | Complete answer | Ordered list |
| "[keyword 2]" | None | Create definitive | Definition |

### PAA Questions to Answer

**Cluster: [Cluster Name]**
1. "[Question 1]?" — FAQ section
2. "[Question 2]?" — H2 section

---

## Seasonal & Trend Timing

### Timing Recommendations

| Timing | Keywords | Rationale |
|--------|----------|-----------|
| Early [Month] | "[kw1]", "[kw2]" | Seasonal spike |
| Mid [Month] | "[kw3]", "[kw4]" | Evergreen |
| Avoid | "[kw5]" | Off-season |

### Trend Momentum

**Rising (Prioritize):** "[keyword]" +80% YoY
**Declining (Avoid):** "[keyword]" -30% YoY

---

## Prioritized Keyword Roadmap

### Tier 1: Immediate Priority (Score 4.0-5.0)

| Rank | Keyword | Score | Cluster | Funnel | Format | Target |
|------|---------|-------|---------|--------|--------|--------|
| 1 | "[keyword]" | 4.8 | [Cluster] | Decision | Comparison | Week 1 |
| 2 | "[keyword]" | 4.5 | [Cluster] | Consider | Tutorial | Week 2 |

### Tier 2: Short-Term Priority (Score 3.5-3.9)
[Same format...]

### Tier 3: Medium-Term Priority (Score 3.0-3.4)
[Same format...]

---

## Recommendations for Signal Research

When invoking @signal-researcher, prioritize:

1. **Tier 1 Keywords:** [list top 3-5]
2. **Funnel Gap Keywords:** [consideration + decision stage]
3. **Seasonal Keywords:** [relevant seasonal keywords]

**Format Recommendations:**
| Keyword Type | Recommended Format |
|--------------|-------------------|
| How-to cluster | Tutorial |
| Comparison cluster | Analysis |
| Problem-solution | Troubleshooting Guide |

---

## Success Metrics

| Metric | Target |
|--------|--------|
| Tier 1 keywords in top 10 | 70% within 90 days |
| Funnel balance | Within 5% of target |
| Featured snippets | 3+ captured |
| Cluster completion | 80%+ per pillar |

---

**Strategy Generated:** YYYY-MM-DD HH:MM
**Skill:** keyword-strategist (strategic planning mode)
```

---

### Article-Level Output

**Path:** `project/Articles/[ARTICLE-ID]/keyword-strategy.md`

```markdown
# Keyword Strategy: [ARTICLE-ID]

**Article:** [Article Title]
**Primary Keyword:** "[primary keyword]"
**Generated:** YYYY-MM-DD

---

## Keyword Hierarchy

### Primary Keyword
- **Keyword:** "[primary keyword]"
- **Difficulty:** [XX]/100
- **Volume:** [HIGH | MED | LOW]
- **Intent:** [Informational | Commercial | Transactional]
- **Funnel Stage:** [Awareness | Consideration | Decision]

### Secondary Keywords

| Keyword | Placement | Density Target | Section |
|---------|-----------|----------------|---------|
| "[secondary 1]" | H2 heading | 0.5-1% | [Section name] |
| "[secondary 2]" | Body text | 0.3-0.5% | [Section name] |
| "[secondary 3]" | H3 heading | 0.3% | [Section name] |

### Long-Tail Keywords

| Keyword | Content Use | Priority |
|---------|-------------|----------|
| "[long-tail 1]" | FAQ section | HIGH |
| "[long-tail 2]" | Troubleshooting | MEDIUM |

---

## Competitive Positioning

**Winnability:** [Winnable | Achievable | Aspirational]
**Estimated Time to Rank:** [X-Y weeks/months]

**Our Advantages:**
- [Advantage 1]
- [Advantage 2]

**Competitor Weaknesses:**
- [Weakness 1]
- [Weakness 2]

---

## SERP Feature Strategy

### Featured Snippet Target
**Current Status:** [Snippet exists | No snippet | PAA only]
**Target Format:** [Ordered list | Definition | Table]
**Tactic:** [Specific formatting instruction]

### PAA Questions to Answer
1. "[Question 1]?"
2. "[Question 2]?"

---

## Internal Linking Strategy

### Link TO This Article From:
| Existing Article | Anchor Text | Section |
|------------------|-------------|---------|
| [Article Title] | "[anchor]" | [Section] |

### Link FROM This Article To:
| Target Article | Anchor Text | Our Section |
|----------------|-------------|-------------|
| [Article Title] | "[anchor]" | [Section] |

---

## Content Format Recommendations

**Optimal Format:** [Format type]
**Rationale:** [Why this format matches intent]

**Structure Suggestions:**
- [Structure recommendation 1]
- [Structure recommendation 2]

---

## Funnel Alignment

**This Article's Funnel Stage:** [Stage]
**CTA Alignment:** [How CTA connects to funnel position]
**Next Content:** [What reader should consume next]

---

**Strategy Generated:** YYYY-MM-DD HH:MM
**Skill:** keyword-strategist (article-level mode)
```

---

### JSON Output

**Path:** `project/Calendar/{Year}/{Month}/keyword-strategy.json`

```json
{
  "meta": {
    "generated_at": "ISO-8601",
    "planning_horizon": "monthly",
    "target_period": "Month Year",
    "skill_version": "1.0.0"
  },
  "summary": {
    "total_keywords": 45,
    "tier1_count": 8,
    "tier2_count": 15,
    "tier3_count": 22,
    "pillars_mapped": 4,
    "funnel_distribution": {
      "awareness": 0.48,
      "consideration": 0.35,
      "decision": 0.17
    }
  },
  "topic_clusters": [
    {
      "pillar_name": "Pillar Name",
      "pillar_keyword": "pillar keyword",
      "pillar_difficulty": 65,
      "pillar_status": "aspirational",
      "clusters": [
        {
          "keyword": "cluster keyword",
          "difficulty": 42,
          "volume": "MED",
          "intent": "informational",
          "funnel_stage": "awareness",
          "winnability": "achievable",
          "priority_tier": 2,
          "priority_score": 3.8,
          "serp_features": ["paa", "snippet_opportunity"],
          "recommended_format": "Tutorial"
        }
      ]
    }
  ],
  "prioritized_roadmap": [
    {
      "rank": 1,
      "keyword": "keyword",
      "priority_score": 4.8,
      "cluster": "Cluster Name",
      "funnel_stage": "decision",
      "winnability": "winnable",
      "serp_opportunity": "featured_snippet",
      "timing": "immediate",
      "recommended_format": "Comparison"
    }
  ],
  "funnel_analysis": {
    "current_distribution": {
      "awareness": 0.65,
      "consideration": 0.28,
      "decision": 0.07
    },
    "target_distribution": {
      "awareness": 0.50,
      "consideration": 0.35,
      "decision": 0.15
    },
    "gap_keywords": {
      "consideration": ["keyword1", "keyword2"],
      "decision": ["keyword3", "keyword4"]
    }
  },
  "serp_opportunities": {
    "featured_snippets": [
      {
        "keyword": "keyword",
        "current_snippet": "incomplete_paragraph",
        "target_format": "ordered_list",
        "tactic": "Step-by-step numbered list"
      }
    ],
    "paa_questions": [
      "Question 1?",
      "Question 2?"
    ]
  }
}
```

---

## Integration with Commands

### Integration with `/content-calendar` (Step 1C)

**Insert after Step 1B (Verify Past Calendars), before Step 2 (Topic Generation):**

```markdown
## Step 1C: Strategic Keyword Planning (RECOMMENDED)

**Objective:** Create strategic keyword foundation to guide signal research and topic prioritization.

### Process

**Invoke the `keyword-strategist` skill in STRATEGIC PLANNING MODE:**

```
Please use the keyword-strategist skill in strategic planning mode for [Month Year].
```

**Skill will:**
1. Build topic cluster keyword architecture from configured pillars
2. Map keywords to funnel stages (awareness/consideration/decision)
3. Classify keywords by winnability (winnable/achievable/aspirational)
4. Identify SERP feature opportunities
5. Apply seasonal and trend timing analysis
6. Generate prioritized keyword roadmap

**Output:**
- `project/Calendar/{Year}/{Month}/keyword-strategy.md`
- `project/Calendar/{Year}/{Month}/keyword-strategy.json`

**Time:** 15-20 minutes

**Pass to Signal Research (Step 2):**

When invoking @signal-researcher, include:

1. **Tier 1 Keywords** (immediate priority)
2. **Funnel Gap Keywords** (consideration + decision stage)
3. **Seasonal Keywords** (timing advantage)

**Decision Point:**
- **REQUIRED:** Load keyword strategy if exists
- **SKIP IF:** Time-constrained or first-time user (proceed without strategy)

**Note:** Keyword strategy is RECOMMENDED but not MANDATORY. Calendar generation can proceed without it, but topic selection quality improves significantly with strategic keyword foundation.
```

---

### Integration with `/write-article` (Phase 2.3)

**Insert after keyword-researcher runs in Phase 2, before Phase 2.5 (Research Synthesis):**

```markdown
## Phase 2.3: Article Keyword Strategy

**After keyword-researcher completes (keyword-research.md available):**

**Invoke the `keyword-strategist` skill in ARTICLE-LEVEL MODE:**

```
Please use the keyword-strategist skill in article-level mode for [ARTICLE-ID].
Primary Keyword: "[primary keyword from calendar]"
Keyword Research: project/Articles/[ARTICLE-ID]/keyword-research.md
```

**Skill will:**
1. Load keyword-research.md data (from keyword-researcher)
2. Map primary to secondary keyword relationships
3. Identify funnel position and intent alignment
4. Generate internal linking keyword map
5. Identify SERP feature targeting tactics
6. Create article-level keyword strategy

**Output:** `project/Articles/[ARTICLE-ID]/keyword-strategy.md`

**Time:** 3-5 minutes

**Pass to @writer (via research-brief.md):**

### Keyword Strategy Summary

**Primary Keyword:**
- Keyword: "[primary keyword]"
- Placement: Title (H1), first 100 words, at least one H2

**Secondary Keywords:**
| Keyword | Placement | Section |
|---------|-----------|---------|
| "[secondary 1]" | H2 heading | [Section] |
| "[secondary 2]" | Body text | [Section] |

**SERP Feature Targeting:**
- Format for snippet: [format type]
- PAA questions to answer: [list]

**Internal Linking:**
- Link TO: [existing articles with anchor text]
- Link FROM: [target articles with anchor text]

**Funnel Alignment:**
- Stage: [stage]
- CTA: [how CTA connects to funnel]

**Pass to @editor (editorial checklist):**

### Keyword Strategy Validation

- [ ] Primary keyword in H1 (title)
- [ ] Primary keyword in first 100 words
- [ ] Primary keyword in at least one H2
- [ ] Secondary keywords distributed appropriately
- [ ] Content formatted for target snippet type
- [ ] PAA questions answered in content
- [ ] Internal links use target keywords
- [ ] Content matches funnel stage intent
```

---

## Quality Guidelines

### DO:
- **Build on keyword-researcher data:** Never duplicate SERP analysis — use existing difficulty/volume scores
- **Map to pillars:** Every keyword should belong to a topic cluster
- **Balance the funnel:** Actively identify and fill funnel gaps
- **Consider winnability realistically:** Base on actual site authority, not aspirations
- **Target SERP features:** Include specific tactics for snippet capture
- **Factor timing:** Seasonal and trend data should influence prioritization
- **Generate actionable roadmaps:** Specific keywords with specific timelines

### DON'T:
- **Recommend unwinnable keywords:** Avoid difficulty >75 unless building pathway
- **Ignore funnel balance:** Every calendar should address all funnel stages
- **Skip cluster architecture:** Random keywords without pillar connection reduce SEO impact
- **Over-complicate scoring:** Keep prioritization framework transparent
- **Generate without config:** Always load requirements.md first
- **Duplicate keyword-researcher work:** This skill is strategic overlay, not tactical replacement

---

## Error Handling

### Scenario 1: Missing keyword-researcher Data (Article Mode)

**Issue:** keyword-research.md not found for article

**Detection:** File not found at expected path

**Response:**
```markdown
Keyword research data not found.

**Expected:** project/Articles/[ARTICLE-ID]/keyword-research.md
**Status:** File not found

**Action Required:** Run keyword-researcher skill first.

**Fallback:** Proceeding with basic strategy using calendar entry keyword only.
Limited strategic recommendations available without keyword research data.
```

---

### Scenario 2: No Topic Pillars Configured

**Issue:** requirements.md missing topic_pillars

**Detection:** Empty or missing `content.topic_pillars` in config

**Response:**
```markdown
No topic pillars configured in requirements.md.

**Expected:** content.topic_pillars should contain 3-6 pillars
**Current:** Empty or missing

**Impact:** Cannot build topic cluster architecture

**Action Required:** Add topic pillars to requirements.md:
```yaml
topic_pillars:
  - "Pillar 1"
  - "Pillar 2"
  - "Pillar 3"
```

**Fallback:** Generating flat keyword list without cluster structure.
Strategic value reduced without pillar-based organization.
```

---

### Scenario 3: No Historical Data for Funnel Analysis

**Issue:** First calendar — no existing articles for funnel distribution

**Detection:** No meta.yml files found in Articles directory

**Response:**
```markdown
First calendar - no historical content for funnel analysis.

**Impact:** Cannot calculate current funnel distribution

**Fallback:** Using default target distribution:
- Awareness: 50%
- Consideration: 35%
- Decision: 15%

Funnel balance analysis will be available after first articles are published.
```

---

### Scenario 4: Configuration Validation Errors

**Issue:** requirements-extractor reports validation errors

**Detection:** Extractor returns validation errors

**Response:**
```markdown
Configuration validation errors detected.

**Errors:**
[List of errors from requirements-extractor]

**Impact:** Strategic planning may be incomplete or inaccurate

**Action Required:** Fix configuration errors before proceeding:
[Specific guidance for each error]

**Proceed with caution?**
- If errors are minor (warnings), proceed with documented limitations
- If errors are critical (missing sections), STOP and fix configuration
```

---

### Scenario 5: Insufficient SERP Data for Cluster Building

**Issue:** WebSearch returns limited results for pillar keywords

**Detection:** <5 meaningful results for cluster expansion

**Response:**
```markdown
Limited SERP data for cluster expansion.

**Pillar:** [Pillar name]
**Results Found:** [N] (expected: 10+)

**Possible Causes:**
- Niche or emerging topic
- Overly specific pillar definition
- Regional/language limitations

**Fallback:**
- Using available data with reduced cluster depth
- Manual cluster definition recommended

**Recommendations:**
- Broaden pillar keyword for more results
- Add related topics manually
- Consider alternative pillar definition
```

---

## Success Metrics

### Skill Performance

| Metric | Target |
|--------|--------|
| Strategic planning time | <20 minutes |
| Article-level time | <5 minutes |
| Cluster refresh time | <12 minutes |
| Pillar coverage | 100% of configured pillars mapped |
| Funnel distribution accuracy | Within 5% of target |

### Strategic Impact

| Metric | Target |
|--------|--------|
| Tier 1 keyword ranking | 70% reach top 10 within 90 days |
| Featured snippet capture | 25% of targeted snippets |
| Funnel balance improvement | Within 5% of target distribution |
| Topic cluster completion | 80%+ of cluster keywords covered in 6 months |
| Internal linking density | 3-5 internal links per article |

### Business Impact

| Metric | Target |
|--------|--------|
| Organic traffic increase | +30% from keyword-driven topics |
| Conversion rate improvement | +15% from funnel-balanced content |
| Time to rank improvement | -20% (faster rankings) |
| Content efficiency | +25% (less wasted effort on unwinnable keywords) |

---

**Skill Version:** 1.0.0
**Last Updated:** 2026-01-07
