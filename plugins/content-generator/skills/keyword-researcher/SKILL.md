---
name: keyword-researcher
description: Research keywords for search volume estimation, difficulty assessment, intent classification, and long-tail expansion. Use during content calendar planning or before article writing.
---

# Keyword Researcher Skill

## Purpose
Provide data-driven keyword research to validate topic viability, assess ranking difficulty, classify search intent, and expand primary keywords into semantic clusters. Fill the gap between topic discovery and SEO optimization.

## When to Use
- **Automatically:** During `/content-calendar` generation (topic validation phase) — Pre-Validation Mode
- **Automatically:** During `/write-article` research phase (before @writer) — Full Analysis Mode
- **Manually:** Before committing to a topic (keyword validation) — Pre-Validation Mode
- **Strategically:** When planning pillar/cluster content strategies — Full Analysis Mode
- **Proactively:** For keyword opportunity assessment — Pre-Validation Mode

## Invocation Modes

### Mode 1: Full Analysis (Default)

**Use During:** `/write-article` research phase (invoked by @researcher agent)

**Purpose:** Complete keyword research with long-tail expansion, semantic clustering, and placement recommendations for article writing

**Output:**
- Complete `keyword-research.md` (comprehensive report)
- Primary keyword validation with metrics
- 10-15 long-tail keyword suggestions
- 3-5 semantic keyword clusters
- Keyword placement recommendations for @writer

**Process:**
- Validates primary keyword via SERP analysis
- Estimates search volume via proxy signals
- Calculates difficulty score (1-100)
- Classifies search intent
- Expands to long-tail keywords
- Creates semantic clusters
- Generates placement recommendations

**Time:** 6-10 minutes per article

**Storage:** `project/Articles/[ARTICLE-ID]/keyword-research.md`

---

### Mode 2: Pre-Validation (Lightweight)

**Use During:** `/content-calendar` generation (topic screening phase)

**Purpose:** Quick keyword viability check for topic candidates before committing to gap analysis

**Output:**
- Lightweight summary file (1-page assessment)
- Keyword score (1-5 scale)
- Search volume estimation (HIGH/MEDIUM/LOW)
- Difficulty assessment (1-100)
- Search intent classification
- Viability recommendation (INCLUDE/CONSIDER/EXCLUDE)

**Process:**
- Analyzes primary keyword only (no expansion)
- Quick SERP analysis (top 5 results)
- Estimates difficulty based on competitor strength
- Classifies search intent
- No long-tail expansion (saved for full analysis)

**Time:** 2-3 minutes per topic

**Storage:** `project/Calendar/{Year}/{Month}/keyword-pre-validation/[ARTICLE-ID]-keyword.md`

---

### Mode 3: Batch Pre-Validation (High Performance)

**Use During:** `/content-calendar` generation when validating 10-15 topic candidates simultaneously

**Purpose:** Parallel keyword validation with intelligent SERP data reuse

**Output:**
- Individual summary files for each topic (same as Mode 2)
- Batch results JSON (structured data for all topics)
- Keyword opportunity ranking across all candidates
- Search intent distribution analysis

**Process:**
- **Step 1: Keyword Extraction (1 min)**
  - Extract primary keywords from topic-candidates.md
  - Normalize keyword variations
  - Identify potential keyword overlaps

- **Step 2: Parallel SERP Analysis (4-6 min)**
  - Execute WebSearch for all keywords simultaneously
  - Analyze top 5 results per keyword
  - Collect volume proxy signals (ads, features, related searches)

- **Step 3: Difficulty Scoring (2-3 min)**
  - Assess competitor strength for each keyword
  - Calculate difficulty scores (1-100)
  - Identify difficulty outliers

- **Step 4: Intent Classification (1-2 min)**
  - Classify all keywords by search intent
  - Detect mixed-intent keywords
  - Recommend content formats

- **Step 5: Output Generation (1 min)**
  - Save individual summaries
  - Generate batch results JSON
  - Return structured results

**Time:** 10-15 minutes for 12 topics (vs. 24-36 min sequential)
  - **Time Savings: 40-50% faster** through parallelization

**Storage:**
- Individual summaries: `project/Calendar/{Year}/{Month}/keyword-pre-validation/[ARTICLE-ID]-keyword.md`
- Batch results: `project/Calendar/{Year}/{Month}/keyword-pre-validation/batch-results.json`

**Invocation:**
```
Please use the keyword-researcher skill in batch mode to validate keywords for all topic candidates from topic-candidates.md.
```

---

## Configuration-Driven Approach

**Before researching, load configuration using requirements-extractor:**

```markdown
Please use the requirements-extractor skill to load validated configuration from project/requirements.md.
```

**Extract the following from the structured output:**

1. **Domain Context**:
   - From `project.industry` → Industry for keyword interpretation
   - From `project.platform` → Platform-specific keyword modifiers

2. **Audience**:
   - From `audience.skill_level` → Keyword complexity preferences
   - From `audience.primary_roles` → Target searcher personas

3. **SEO Strategy**:
   - From `seo.strategy` → Target query patterns
   - From `seo.intent` → SEO strategic direction

4. **Content Parameters**:
   - From `content.formats` → Content type for intent matching
   - From `content.word_count_range` → Viability for long-tail keywords

**Use these extracted values throughout the keyword research process.**

---

## Phase 0: Load Configuration (30 seconds)

**Objective:** Extract relevant configuration from requirements.md

**Actions:**
1. Invoke requirements-extractor skill
2. Extract configuration fields listed above
3. Validate configuration is complete

**Output:** Configuration context for keyword interpretation

---

## Phase 1: Primary Keyword Analysis (2-3 minutes)

### Step 1.1: Keyword Extraction

**For Full Analysis Mode:**
- Extract primary keyword from article brief or calendar entry
- Normalize keyword (lowercase, remove extra spaces)
- Identify any provided search intent hints

**For Batch Mode:**
- Extract keywords from all topic candidates
- Build keyword list with article IDs

### Step 1.2: SERP Analysis

Execute WebSearch for primary keyword:

```
WebSearch: "[primary keyword]"
```

Analyze top 10 results (top 5 for pre-validation):

| Analysis Point | What to Extract |
|----------------|-----------------|
| Domain types | Official docs, blogs, forums, product pages |
| Domain authority signals | Recognized domains (.gov, .edu, major brands) |
| Content types | Tutorial, guide, comparison, product page |
| Content freshness | Publish dates (if visible in snippets) |
| Content depth signals | Word count indicators, structure complexity |
| SERP features | Featured snippets, PAA, knowledge panels |

### Step 1.3: Search Volume Estimation

**Without API access, estimate volume using proxy signals:**

| Signal | HIGH Volume | MEDIUM Volume | LOW Volume |
|--------|-------------|---------------|------------|
| SERP result count | 100M+ | 1M-100M | <1M |
| Ad presence | 3+ ads | 1-2 ads | No ads |
| Featured snippets | Present | Sometimes | Rarely |
| Related searches | 8+ suggestions | 4-7 | <4 |
| People Also Ask | 4+ questions | 2-3 | 0-1 |
| Video results | Present | Sometimes | Rarely |

**Volume Classification:**
- **HIGH**: 4+ signals indicate high volume
- **MEDIUM**: 2-3 signals indicate medium volume
- **LOW**: 0-1 signals indicate low volume

**Confidence Assessment:**
- Strong signals (ads, featured snippets) = HIGH confidence
- Weak signals (result count alone) = LOW confidence

### Step 1.4: Keyword Difficulty Assessment

Calculate difficulty score (1-100) based on competitive analysis:

| Factor | Weight | Scoring Criteria |
|--------|--------|------------------|
| Domain authority of top 3 | 40% | All high-authority (gov, edu, major brands) = 80+<br>Mixed authority = 40-80<br>Low authority (small blogs) = <40 |
| Content depth of top 5 | 25% | 3000+ words avg = 70+<br>1500-3000 words = 40-70<br><1500 words = <40 |
| Brand dominance | 20% | 3+ major brands in top 5 = 80+<br>1-2 brands = 40-80<br>No brands = <40 |
| Content recency | 15% | All <6 months old = 70+<br>Mixed ages = 40-70<br>All >12 months old = <40 |

**Difficulty Formula:**
```
difficulty = (authority × 0.40) + (depth × 0.25) + (brands × 0.20) + (recency × 0.15)
```

**Difficulty Tiers:**
| Score | Tier | Description |
|-------|------|-------------|
| 1-30 | Easy | Few established competitors, thin content, good opportunity |
| 31-60 | Moderate | Mixed competition, achievable with quality content |
| 61-80 | Difficult | Strong competition, needs exceptional content + authority |
| 81-100 | Very Difficult | Dominated by high-authority sites, consider alternatives |

---

## Phase 2: Search Intent Classification (1-2 minutes)

### Step 2.1: SERP Intent Signals

Analyze top 10 results to classify search intent:

| Intent Type | SERP Signals | Typical Content |
|-------------|--------------|-----------------|
| **Informational** | Knowledge panels, PAA boxes, how-to snippets, educational sites | Guides, tutorials, explainers, FAQs |
| **Commercial** | Product listings, review sites, comparison articles, "best" lists | Reviews, comparisons, buyer guides |
| **Transactional** | Shopping results, pricing pages, product pages, ads with "buy" | Product pages, pricing, checkout flows |
| **Navigational** | Brand homepage, specific site results, official pages | Official docs, brand pages, login pages |

### Step 2.2: Intent Distribution

Calculate intent distribution from SERP analysis:

```
informational_signals = count of tutorial/guide/explainer results
commercial_signals = count of review/comparison results
transactional_signals = count of product/pricing results
navigational_signals = count of brand/official results

total_signals = sum of all signals

primary_intent = intent with highest percentage
intent_confidence = primary_signals / total_signals
```

**Confidence Levels:**
- **HIGH** (>70%): Clear single intent dominates
- **MODERATE** (50-70%): Primary intent identifiable, some mixed signals
- **LOW** (<50%): Mixed intent, consider multiple content approaches

### Step 2.3: Content Format Recommendation

Based on intent classification, recommend content format:

| Primary Intent | Recommended Formats | Content Focus |
|----------------|---------------------|---------------|
| Informational | Tutorial, Guide, Explainer, How-To | Education, step-by-step, concepts |
| Commercial | Comparison, Review, Buyer's Guide, Analysis | Evaluation, pros/cons, recommendations |
| Transactional | Product page, Feature overview, Pricing guide | Features, benefits, CTAs |
| Navigational | Documentation, Resource page, Reference | Comprehensive, authoritative |

**Mixed Intent Handling:**
- If confidence <50%, recommend hybrid content structure
- Suggest content sections addressing multiple intents
- Flag for user review before proceeding

---

## Phase 3: Long-Tail Keyword Expansion (2-3 minutes) [Full Mode Only]

### Step 3.1: Autocomplete Mining

Execute WebSearch with keyword modifiers:

```
WebSearch: "[keyword] how to"
WebSearch: "[keyword] best"
WebSearch: "[keyword] vs"
WebSearch: "[keyword] for beginners"
WebSearch: "[keyword] tutorial"
WebSearch: "[keyword] guide"
WebSearch: "[keyword] examples"
WebSearch: "[keyword] [current year]"
```

Extract autocomplete suggestions and related searches from each query.

### Step 3.2: PAA (People Also Ask) Extraction

From SERP results, extract PAA questions:
- Question text
- Question type (how/what/why/when/where/can/should)
- Topical relevance to primary keyword

**Question Categories:**
| Type | Example Pattern | Content Opportunity |
|------|-----------------|---------------------|
| How | "How to [keyword]..." | Tutorial section, step-by-step |
| What | "What is [keyword]..." | Definition, explainer intro |
| Why | "Why [keyword]..." | Benefits, rationale section |
| When | "When to [keyword]..." | Use case, timing guidance |
| Can | "Can [keyword]..." | FAQ, capability coverage |
| Should | "Should I [keyword]..." | Decision guidance, comparison |

### Step 3.3: Long-Tail Validation

For each candidate long-tail keyword (target 10-15):

1. **Relevance Check**: Semantic similarity to primary keyword
2. **Quick SERP Check**: Top 3 results for difficulty signal
3. **Content Potential**: Can this support 200+ words of content?
4. **Uniqueness**: Not redundant with other long-tails

**Long-Tail Output Format:**
| Keyword | Volume Est. | Difficulty | Intent | Content Use |
|---------|-------------|------------|--------|-------------|
| "[long-tail]" | MED | 35 | Info | H2 section |

### Step 3.4: Long-Tail Prioritization

Rank long-tails by opportunity score:

```
opportunity = (volume_score × 0.40) + ((100 - difficulty) × 0.40) + (relevance × 0.20)
```

Select top 10-15 long-tails for inclusion in report.

---

## Phase 4: Semantic Keyword Clustering (1-2 minutes) [Full Mode Only]

### Step 4.1: Term Extraction

From primary keyword + long-tails, extract:
- **Core terms**: Main nouns and verbs
- **Modifier terms**: Adjectives, adverbs
- **Entity terms**: Brands, products, versions

### Step 4.2: Semantic Grouping

Group keywords by thematic similarity:

**Cluster Templates:**

| Cluster Type | Keywords Pattern | Content Application |
|--------------|------------------|---------------------|
| Tutorial/How-To | "[keyword] tutorial", "how to [keyword]", "[keyword] step by step" | Main tutorial section |
| Comparison | "[keyword] vs [alt]", "best [keyword]", "[keyword] alternatives" | Comparison section or standalone |
| Problem-Solution | "[keyword] not working", "fix [keyword]", "[keyword] issues" | Troubleshooting section |
| Use-Case | "[keyword] for [use]", "[keyword] for [audience]" | Application examples |
| Beginner | "[keyword] for beginners", "[keyword] basics", "what is [keyword]" | Introductory content |

### Step 4.3: Cluster Prioritization

Score each cluster:

```
cluster_priority = (
  relevance_to_primary × 0.40 +
  estimated_volume × 0.30 +
  content_alignment × 0.20 +
  difficulty_accessibility × 0.10
)
```

**Priority Levels:**
- **HIGH** (0.70+): Must include in content
- **MEDIUM** (0.50-0.69): Should include if space allows
- **LOW** (<0.50): Optional, consider for future content

---

## Phase 5: Report Generation (30 seconds - 1 minute)

### Full Analysis Output

**Path:** `project/Articles/[ARTICLE-ID]/keyword-research.md`

```markdown
# Keyword Research Report: [ARTICLE-ID]

**Topic:** [Article topic/title]
**Primary Keyword:** "[primary keyword phrase]"
**Analysis Date:** YYYY-MM-DD
**Mode:** Full Analysis

---

## Executive Summary

| Metric | Value |
|--------|-------|
| Primary Keyword | "[keyword]" |
| Search Volume | HIGH / MEDIUM / LOW |
| Difficulty | XX/100 ([tier]) |
| Intent | [type] ([confidence]%) |
| Keyword Score | X.X/5.0 |
| Recommendation | PROCEED / CAUTION / RECONSIDER |

**Summary:** [2-3 sentence assessment of keyword opportunity]

---

## Primary Keyword Analysis

### Search Volume Estimation

| Signal | Observed | Interpretation |
|--------|----------|----------------|
| SERP Results | XX,XXX,XXX | [HIGH/MED/LOW] |
| Ad Presence | [count] ads | [signal] |
| Featured Snippets | Yes/No | [signal] |
| Related Searches | [count] | [signal] |
| People Also Ask | [count] | [signal] |

**Estimated Volume:** [HIGH / MEDIUM / LOW]
**Confidence:** [HIGH / MODERATE / LOW]
**Rationale:** [Brief explanation]

### Difficulty Assessment

| Factor | Score | Notes |
|--------|-------|-------|
| Domain Authority (Top 3) | XX/100 | [Brief analysis] |
| Content Depth (Top 5) | XX/100 | [Brief analysis] |
| Brand Dominance | XX/100 | [Brief analysis] |
| Content Recency | XX/100 | [Brief analysis] |
| **Overall Difficulty** | **XX/100** | **[TIER]** |

**SERP Snapshot:**
| Rank | Domain | Type | Depth Signal | Age |
|------|--------|------|--------------|-----|
| 1 | [domain] | [type] | [signal] | [age] |
| 2 | [domain] | [type] | [signal] | [age] |
| 3 | [domain] | [type] | [signal] | [age] |
| 4 | [domain] | [type] | [signal] | [age] |
| 5 | [domain] | [type] | [signal] | [age] |

---

## Search Intent Classification

**Primary Intent:** [Type] ([XX]% confidence)
**Secondary Intent:** [Type] ([XX]%)

**SERP Feature Analysis:**
- Knowledge Panel: Yes/No
- Featured Snippet: Yes/No ([type])
- People Also Ask: [count] questions
- Video Results: Yes/No
- Image Pack: Yes/No

**Content Format Recommendation:** [Format] with [specific angle]

**Intent Alignment Check:**
- Planned format: [from calendar]
- Recommended format: [from analysis]
- Alignment: ALIGNED / MISALIGNED (adjust recommended)

---

## Long-Tail Keywords

### High-Priority (Top 5)

| Keyword | Volume | Difficulty | Intent | Content Use |
|---------|--------|------------|--------|-------------|
| "[long-tail 1]" | [vol] | [diff] | [intent] | [use] |
| "[long-tail 2]" | [vol] | [diff] | [intent] | [use] |
| "[long-tail 3]" | [vol] | [diff] | [intent] | [use] |
| "[long-tail 4]" | [vol] | [diff] | [intent] | [use] |
| "[long-tail 5]" | [vol] | [diff] | [intent] | [use] |

### Additional Long-Tails (6-15)

| Keyword | Volume | Difficulty | Intent | Content Use |
|---------|--------|------------|--------|-------------|
| ... | ... | ... | ... | ... |

### Question Keywords (from PAA)

1. "[Question 1]?" — Answer in: [Section]
2. "[Question 2]?" — Answer in: [Section]
3. "[Question 3]?" — Answer in: [Section]
4. "[Question 4]?" — Answer in: [Section]

---

## Semantic Keyword Clusters

### Cluster 1: [Theme Name] (Priority: HIGH)

**Intent:** [Intent type]
**Keywords:**
- [keyword 1] (primary)
- [keyword 2]
- [keyword 3]

**Content Recommendation:** [How to incorporate]

### Cluster 2: [Theme Name] (Priority: MEDIUM)

[Same format...]

### Cluster 3: [Theme Name] (Priority: MEDIUM)

[Same format...]

---

## Keyword Placement Recommendations

### For @writer Agent

**Title (H1):**
- Include: "[primary keyword]"
- Position: Near start preferred
- Variation: "[modifier + primary]" acceptable

**First 100 Words:**
- Natural inclusion of primary keyword
- Context-setting secondary keyword

**H2 Headings (Suggested):**
1. "[H2 with long-tail 1]"
2. "[H2 with long-tail 2]"
3. "[H2 with semantic keyword]"
4. "[H2 with question keyword]"

**Meta Description:**
- Primary keyword: Near start
- Length: 150-160 characters
- CTA: Include from requirements.md
- Draft: "[Sample meta description]"

**Internal Linking Anchors:**
- "[anchor 1]" — natural placement
- "[anchor 2]" — natural placement

### Keyword Density Guidelines

| Keyword Type | Target Density | Placement |
|--------------|----------------|-----------|
| Primary | 1-2% | H1, first 100 words, H2, conclusion |
| Top Long-Tail | 0.5-1% each | Relevant H2/H3 sections |
| Semantic | Natural | Throughout body |
| Question | Once each | FAQ or inline |

---

## Recommendations Summary

**Keyword Viability:** [STRONG / MODERATE / WEAK]

**Proceed With:**
- [Key recommendation 1]
- [Key recommendation 2]
- [Key recommendation 3]

**Watch Out For:**
- [Challenge 1] — Mitigation: [approach]
- [Challenge 2] — Mitigation: [approach]

---

**Analysis Completed:** YYYY-MM-DD HH:MM
**Skill:** keyword-researcher (full analysis mode)
```

---

### Pre-Validation Output

**Path:** `project/Calendar/{Year}/{Month}/keyword-pre-validation/[ARTICLE-ID]-keyword.md`

```markdown
# Keyword Pre-Validation: [ARTICLE-ID]

**Keyword:** "[primary keyword]"
**Analysis Date:** YYYY-MM-DD
**Mode:** Pre-Validation

---

## Quick Assessment

| Metric | Value | Score |
|--------|-------|-------|
| Search Volume | [HIGH/MED/LOW] | X/5 |
| Difficulty | XX/100 ([tier]) | X/5 |
| Intent | [type] | [clear/mixed] |
| Format Fit | [format] | X/5 |

**Keyword Score:** X.X/5.0
**Recommendation:** INCLUDE / CONSIDER / EXCLUDE

---

## SERP Snapshot (Top 5)

| Rank | Domain | Type | Authority | Age |
|------|--------|------|-----------|-----|
| 1 | [domain] | [type] | [signal] | [age] |
| 2 | [domain] | [type] | [signal] | [age] |
| 3 | [domain] | [type] | [signal] | [age] |
| 4 | [domain] | [type] | [signal] | [age] |
| 5 | [domain] | [type] | [signal] | [age] |

---

## Volume Signals

| Signal | Observed |
|--------|----------|
| Ads | [count] |
| Featured Snippet | Yes/No |
| PAA Questions | [count] |
| Related Searches | [count] |

**Volume Estimate:** [HIGH/MEDIUM/LOW] ([confidence])

---

## Difficulty Assessment

**Score:** XX/100 ([EASY/MODERATE/DIFFICULT/VERY DIFFICULT])

**Key Factors:**
- Top domains: [summary]
- Content depth: [summary]
- Brand presence: [summary]

---

## Intent Classification

**Primary:** [type] ([XX]% confidence)
**Recommended Format:** [format]

---

## Viability Summary

**Strengths:**
- [Strength 1]
- [Strength 2]

**Challenges:**
- [Challenge 1]
- [Challenge 2]

**Verdict:** [1-2 sentence recommendation]

---

**Analysis Completed:** YYYY-MM-DD HH:MM
```

---

### Batch Results Output

**Path:** `project/Calendar/{Year}/{Month}/keyword-pre-validation/batch-results.json`

```json
{
  "meta": {
    "analysis_date": "YYYY-MM-DD",
    "topics_analyzed": 12,
    "analysis_time_minutes": 12,
    "mode": "batch-prevalidation"
  },
  "summary": {
    "include_count": 8,
    "consider_count": 3,
    "exclude_count": 1,
    "average_difficulty": 45,
    "average_keyword_score": 3.8,
    "intent_distribution": {
      "informational": 7,
      "commercial": 3,
      "transactional": 1,
      "navigational": 1
    }
  },
  "results": [
    {
      "article_id": "ART-YYYYMM-NNN",
      "keyword": "[primary keyword]",
      "keyword_score": 4.2,
      "volume": "HIGH",
      "difficulty": 38,
      "difficulty_tier": "MODERATE",
      "intent": "informational",
      "intent_confidence": 0.85,
      "recommended_format": "tutorial",
      "recommendation": "INCLUDE",
      "summary_path": "keyword-pre-validation/ART-YYYYMM-NNN-keyword.md"
    }
  ],
  "rankings": {
    "by_opportunity": ["ART-001", "ART-003", "ART-002", "..."],
    "by_difficulty_asc": ["ART-005", "ART-001", "ART-003", "..."],
    "by_volume_desc": ["ART-001", "ART-002", "ART-004", "..."]
  }
}
```

---

## Integration with Commands

### Integration with `/content-calendar`

**Insert after Step 2 (topic generation), before gap analysis:**

```markdown
## Step 2A: Keyword Pre-Validation

**Invoke keyword-researcher skill in BATCH MODE:**

```
Please use the keyword-researcher skill in batch mode to validate keywords for all topic candidates from topic-candidates.md.
```

**Skill will:**
1. Extract primary keywords from topic candidates
2. Execute parallel SERP analysis
3. Calculate difficulty and volume for each
4. Classify search intent
5. Save individual summaries + batch results

**Output:**
- Individual assessments: `keyword-pre-validation/[ARTICLE-ID]-keyword.md`
- Batch results: `keyword-pre-validation/batch-results.json`

**Decision Point:**
- **EXCLUDE** topics with keyword score <2.5 (low viability)
- **FLAG** topics with difficulty >70 for strategic review
- **PRIORITIZE** topics with high volume + moderate difficulty
- **VERIFY** intent matches planned content format
```

---

### Integration with `/write-article`

**Insert in Phase 2 (Research), as part of @researcher Agent 1 work:**

```markdown
### Phase 2.1: Keyword Research

**Invoke keyword-researcher skill (full mode):**

```
Please use the keyword-researcher skill to perform full keyword analysis for article [ARTICLE-ID].
```

**Skill will:**
1. Validate primary keyword from calendar entry
2. Estimate search volume and difficulty
3. Classify search intent
4. Generate long-tail keyword expansion (10-15)
5. Create semantic keyword clusters (3-5)
6. Produce placement recommendations

**Output:** `project/Articles/[ARTICLE-ID]/keyword-research.md`

**Pass to @writer:**
- Keyword placement recommendations (H1, H2s, first 100 words)
- Long-tail keywords for section targeting
- Semantic clusters for natural density
- Meta description draft
```

---

### Integration with `seo-optimization` Skill

**Data flow: Keyword research informs SEO optimization**

```markdown
**Before optimizing, check for keyword-research.md:**

If `project/Articles/[ARTICLE-ID]/keyword-research.md` exists:

1. Load keyword placement recommendations
2. Verify primary keyword is in H1, first 100 words
3. Check long-tail keywords are distributed in H2/H3s
4. Validate keyword density matches guidelines
5. Use drafted meta description as starting point

If keyword research not available:
- Proceed with standard SEO optimization
- Note: Keyword research recommended for future articles
```

---

## Quality Guidelines

### DO:
- **Search first**: Always use WebSearch for actual SERP data (no assumptions)
- **Multiple signals**: Use 3+ proxy signals for volume estimation
- **Context awareness**: Consider industry/platform from requirements.md
- **Intent matching**: Recommend content formats that match search intent
- **Actionable output**: Provide specific placement guidance for @writer
- **Audience fit**: Adapt keyword complexity to configured skill level
- **Validate long-tails**: Ensure each has content potential before including

### DON'T:
- **Claim exact volumes**: No API access means no precise numbers
- **Format mismatch**: Don't recommend keywords incompatible with content type
- **Keyword stuffing**: Max 15-20 keywords (primary + long-tails + semantic)
- **Skip analysis**: Never estimate difficulty without SERP analysis
- **Ignore config**: Always read industry/platform context
- **Over-cluster**: Max 5 semantic clusters to maintain focus
- **Assume intent**: Always verify intent via SERP analysis

---

## Error Handling

### Scenario 1: Ambiguous Primary Keyword

**Issue:** Keyword has multiple meanings or industries (e.g., "Python" = language vs. snake)

**Detection:** SERP results show mixed topics, unrelated content types

**Response:**
1. Document ambiguity in report
2. Analyze which meaning dominates SERP
3. Suggest modifier: "[keyword] + [qualifier]" (e.g., "Python programming")
4. Flag for user review: "Keyword requires disambiguation"
5. Provide alternative keywords if available

---

### Scenario 2: Extremely Competitive Keyword (Difficulty >85)

**Issue:** Dominated by high-authority sites, low ranking probability

**Detection:** Top 5 results all from major brands/authorities

**Response:**
1. Document competitive landscape
2. Calculate realistic difficulty score
3. Identify any gaps (recency, depth, format)
4. Recommend long-tail alternatives with lower difficulty
5. Suggest differentiation angle if proceeding
6. Flag: "Primary keyword highly competitive - consider long-tail focus"

---

### Scenario 3: Very Low Search Volume

**Issue:** No ads, few related searches, limited PAA signals

**Detection:** <3 volume proxy signals indicate low volume

**Response:**
1. Verify keyword spelling/phrasing
2. Check for alternative phrasings with more volume
3. Assess if topic is emerging (low volume but growing)
4. Document limitations in report
5. Recommend: "Low volume detected - verify topic demand before proceeding"
6. Suggest broader keyword alternatives

---

### Scenario 4: Mixed Search Intent (<50% confidence)

**Issue:** SERP shows mix of informational, commercial, transactional results

**Detection:** No single intent exceeds 50% of results

**Response:**
1. Document intent distribution percentages
2. Identify which intent aligns with content goals
3. Recommend content structure addressing multiple intents
4. Suggest section breakdown: "Intro (informational) → Analysis (commercial) → Action (transactional)"
5. Flag: "Mixed intent - recommend hybrid content structure"

---

### Scenario 5: Insufficient SERP Data

**Issue:** WebSearch returns limited results (rare topic, new terminology)

**Detection:** <10 meaningful results, few SERP features

**Response:**
1. Document data limitations
2. Use available signals, note confidence level
3. Check for related/broader keywords
4. Flag: "Limited SERP data - manual validation recommended"
5. Recommend proceeding with caution or topic pivot

---

### Scenario 6: Intent Mismatch with Planned Format

**Issue:** SERP intent doesn't match calendar's planned content format

**Detection:** Planned format (e.g., "tutorial") but SERP shows commercial intent

**Response:**
1. Document intent analysis
2. Compare with planned format from calendar
3. If mismatch: "SERP shows [intent], but planned format is [format]"
4. Recommend adjustment options:
   - Modify content format to match intent
   - Target different keyword matching planned format
   - Proceed with awareness of ranking challenge
5. Flag for user decision before writing

---

## Keyword Score Calculation

**Overall Keyword Score (1-5 scale):**

```
keyword_score = (
  volume_score × 0.30 +
  (5 - (difficulty / 20)) × 0.30 +
  intent_clarity × 0.20 +
  format_alignment × 0.20
)
```

**Component Scores:**

| Component | HIGH (5) | MEDIUM (3) | LOW (1) |
|-----------|----------|------------|---------|
| Volume | HIGH volume | MEDIUM volume | LOW volume |
| Difficulty | <30 (Easy) | 30-60 (Moderate) | >60 (Difficult) |
| Intent Clarity | >70% confidence | 50-70% | <50% |
| Format Alignment | Perfect match | Partial match | Mismatch |

**Recommendation Thresholds:**
- **INCLUDE** (4.0-5.0): Strong keyword, proceed confidently
- **CONSIDER** (2.5-3.9): Viable with adjustments, review factors
- **EXCLUDE** (<2.5): Weak keyword, suggest alternative

---

## Success Metrics

### Skill Performance

| Metric | Target |
|--------|--------|
| Full analysis time | <10 minutes |
| Pre-validation time | <3 minutes |
| Batch mode (12 topics) | <15 minutes |
| Volume estimation accuracy | 75%+ (when validated against search console) |
| Difficulty prediction accuracy | 80%+ topics rank within predicted tier |

### Content Quality Impact

| Metric | Target |
|--------|--------|
| Primary keyword ranking | 70%+ articles reach top 10 within 90 days |
| Long-tail ranking | 85%+ targeted long-tails reach top 20 |
| Intent alignment | 90%+ articles match SERP-dominant content type |

---

**Skill Version:** 1.0.0
**Last Updated:** 2026-01-06
