---
name: angle-generator
description: Systematically generate 3 angle variants (coverage, depth, use-case) from a single signal for multi-angle topic generation and composite scoring.
---

# Angle Generator Skill

## Purpose

Transform a single industry signal into 3 distinct topic angle variants to maximize novelty and differentiation opportunities. Each variant targets a different gap type or audience segment, enabling data-driven selection via composite scoring.

**Key Benefits:**
- **3x candidate pool:** Every signal generates 3 alternatives instead of 1
- **Systematic exploration:** Coverage, depth, and use-case angles cover the differentiation spectrum
- **Quality filtering:** Variants validated for clarity, keyword differentiation, and feasibility
- **Data-driven selection:** Enables composite scoring (novelty × opportunity × feasibility)

Replaces single-angle topic generation with systematic multi-variant approach, increasing novelty rates from 80-85% to 88-92%.

---

## When to Use

- **Automatically:** During signal research Phase 3 (topic candidate synthesis) for each signal cluster
- **Manually:** When a signal has high strategic value but the obvious angle seems saturated
- **Diagnostically:** To explore differentiation opportunities for a specific topic area

**NOT for:**
- Topics with only one viable angle (rare edge cases)
- Signals that are too narrow (already use-case-specific)
- Time-sensitive news that requires a specific angle

---

## Input Parameters

### Required

- `signal`: Signal object with:
  - `signal_type`: Type of signal (Product Release, Security Advisory, etc.)
  - `source`: Official source name
  - `date`: Signal date
  - `headline`: Signal headline or announcement title
  - `summary`: 2-3 sentence signal summary
  - `key_aspects`: Array of 3-5 key aspects/features/topics from signal

- `industry`: Industry/domain (from requirements.md)
  - Examples: "WordPress data integration", "React.js development", "Personal finance"
  - **Impact:** Influences terminology and angle framing

- `audience`: Target audience configuration
  - `primary_roles[]`: Target reader roles
  - `skill_level`: Beginner | Intermediate | Advanced
  - **Impact:** Affects use-case angle specificity and depth angle complexity

### Optional

- `content_formats[]`: Allowed content formats (from requirements.md)
  - Default: ["Tutorial", "Guide", "Analysis"]
  - **Impact:** Constrains variant format selection

- `alternative_angle_preference`: Preference weights for angle types
  - `depth_weight`: 0-1 (default: 0.6)
  - `use_case_weight`: 0-1 (default: 0.4)
  - **Impact:** Affects which variants get emphasized in output order

---

## Process

### Phase 1: Signal Analysis (1 minute)

**Step 1.1: Extract Core Topic**

Identify the central topic from the signal:

```
Signal Example:
  headline: "WooCommerce 8.5 Introduces HPOS 2.0 with Performance Improvements"
  summary: "WooCommerce releases High-Performance Order Storage (HPOS) 2.0
            with 40% faster query performance, improved scalability for
            large stores, and new migration rollback features."
  key_aspects:
    - HPOS 2.0 release
    - 40% performance improvement
    - Scalability enhancements
    - Migration rollback capability
    - Breaking changes from HPOS 1.x

Core Topic Extraction:
  primary_subject: "WooCommerce HPOS 2.0"
  primary_action: "Migration / Adoption / Optimization"
  primary_benefit: "Performance improvement and scalability"
```

**Step 1.2: Identify Angle Opportunities**

Map signal aspects to angle types:

| Aspect | Coverage Angle | Depth Angle | Use-Case Angle |
|--------|---------------|-------------|----------------|
| HPOS 2.0 release | Complete guide | Performance benchmarking | For high-volume stores |
| 40% performance | Overview | Query optimization deep-dive | For slow stores |
| Scalability | Feature coverage | Architecture analysis | For enterprise/agencies |
| Rollback capability | Migration guide | Rollback strategies | For risk-averse migrations |
| Breaking changes | Compatibility guide | Breaking change mitigation | For custom integrations |

**Select 3 angle opportunities** that maximize differentiation:
1. **Coverage angle:** Broad, comprehensive approach
2. **Depth angle:** Technical deep-dive on specific aspect
3. **Use-case angle:** Niche application or audience segment

---

### Phase 2: Variant Generation (2-3 minutes)

**Step 2.1: Generate Coverage Angle Variant**

**Coverage Angle Pattern:**
```
"Complete [Topic] Guide: [Subtopic A], [B], [C]"
OR
"[Topic] Overview: [Feature 1], [Feature 2], [Feature 3]"
OR
"Everything You Need to Know About [Topic]"
```

**Target:**
- **Gap focus:** Coverage gaps (subtopics covered by 0-2 competitors)
- **Differentiation:** Breadth — comprehensive guide covering multiple aspects
- **Audience:** General (matches primary skill level, not specialized)
- **Format:** Guide or Tutorial

**Generation Process:**

1. **Extract 3-5 key subtopics** from signal aspects
2. **Construct title** using coverage pattern
3. **Generate keyword** emphasizing breadth (e.g., "complete", "comprehensive", "overview")
4. **Define differentiation angle:**
   - "Comprehensive coverage of [aspect A], [B], and [C]"
   - "Only guide covering all [N] features in one place"

**Example:**
```markdown
## Variant 1: Coverage Angle

**Title:** "Complete WooCommerce HPOS 2.0 Guide: Migration, Performance, and Rollback Strategies"

**Target Keyword:** "woocommerce hpos 2.0 complete guide"

**Format:** Guide

**Differentiation Angle:**
  "Comprehensive guide covering HPOS 2.0 migration process, performance
   optimization techniques, and rollback procedures — all in one resource.
   Only guide addressing the full adoption lifecycle from planning to
   post-migration optimization."

**Primary Gap Type:** Coverage (breadth)

**Target Audience:** Store owners and developers (general)

**Estimated Word Count:** 1,800-2,200 words
```

---

**Step 2.2: Generate Depth Angle Variant**

**Depth Angle Pattern:**
```
"[Topic] Deep Dive: [Advanced Aspect] [Technical Detail]"
OR
"Advanced [Topic]: [Specific Technique] Strategies"
OR
"[Topic] Performance [Optimization/Benchmarking/Analysis]"
```

**Target:**
- **Gap focus:** Depth gaps (shallow coverage, missing technical details)
- **Differentiation:** Technical depth — advanced analysis of specific aspect
- **Audience:** Intermediate to Advanced (more technical than primary)
- **Format:** Tutorial or Analysis

**Generation Process:**

1. **Select most technical aspect** from signal (performance, architecture, etc.)
2. **Narrow focus** to specific technical challenge or measurement
3. **Construct title** using depth pattern with technical terminology
4. **Generate keyword** emphasizing depth (e.g., "advanced", "deep dive", "optimization", "benchmarking")
5. **Define differentiation angle:**
   - "In-depth technical analysis of [specific aspect]"
   - "Only guide with [specific measurement/benchmark]"

**Example:**
```markdown
## Variant 2: Depth Angle

**Title:** "HPOS 2.0 Performance Benchmarking: Query Optimization and Scalability Analysis"

**Target Keyword:** "hpos 2.0 performance benchmarking optimization"

**Format:** Analysis

**Differentiation Angle:**
  "Technical deep-dive into HPOS 2.0 performance improvements with
   real-world benchmarks comparing 1.x vs 2.0 query performance across
   different store sizes. Includes query optimization strategies,
   index analysis, and scaling recommendations for 10K+ orders."

**Primary Gap Type:** Depth (technical analysis)

**Target Audience:** Advanced developers and performance engineers

**Estimated Word Count:** 1,500-1,800 words
```

---

**Step 2.3: Generate Use-Case Angle Variant**

**Use-Case Angle Pattern:**
```
"[Topic] for [Specific Use Case]: [Niche Challenge]"
OR
"How [Audience Segment] Can [Action] with [Topic]"
OR
"[Topic] Solutions for [Specific Industry/Scale/Problem]"
```

**Target:**
- **Gap focus:** Coverage gaps (niche subtopics) or audience segmentation
- **Differentiation:** Specific application — solves problem for defined segment
- **Audience:** Niche segment within primary audience (by role, scale, or use case)
- **Format:** Tutorial or Guide

**Generation Process:**

1. **Identify niche segments** from audience roles or signal aspects
   - By scale: "high-volume stores", "enterprise", "small stores"
   - By role: "agencies", "freelancers", "store owners"
   - By use case: "subscription stores", "B2B stores", "marketplace"
   - By challenge: "slow performance", "custom integrations", "legacy migrations"

2. **Select specific challenge** relevant to that segment
3. **Construct title** using use-case pattern
4. **Generate keyword** combining topic + segment (e.g., "[topic] for [segment]")
5. **Define differentiation angle:**
   - "Only guide addressing [specific segment's] unique challenge with [topic]"
   - "Tailored to [segment] requirements: [specific need]"

**Example:**
```markdown
## Variant 3: Use-Case Angle

**Title:** "HPOS 2.0 Migration Strategies for High-Volume WooCommerce Stores"

**Target Keyword:** "hpos 2.0 migration high volume stores"

**Format:** Tutorial

**Differentiation Angle:**
  "Migration guide specifically for stores with 10K+ orders, addressing
   unique challenges: zero-downtime migration, database load management,
   incremental rollout strategies, and rollback procedures for production
   environments. Includes store-size-specific benchmarks and risk mitigation."

**Primary Gap Type:** Coverage (niche use case)

**Target Audience:** Enterprise store owners and agencies managing large deployments

**Estimated Word Count:** 1,400-1,700 words
```

---

### Phase 3: Variant Validation (1 minute)

**Step 3.1: Topic Clarity Check**

For each variant, validate:

**Not too narrow:**
- ❌ "HPOS 2.0 Query Performance for Subscription Stores Using Custom Payment Gateways"
  - Too specific, likely <800 words, tiny audience
- ✅ "HPOS 2.0 Performance for High-Volume Stores"
  - Specific enough, 1,400+ words viable, sizable audience segment

**Not too broad:**
- ❌ "Everything About WooCommerce Performance"
  - Too broad, >3,000 words, overlaps with existing pillar content
- ✅ "Complete HPOS 2.0 Guide: Migration, Performance, Rollback"
  - Broad but scoped, 1,800-2,200 words, specific to HPOS 2.0

**Clear value proposition:**
- Title clearly communicates what reader will learn
- Not vague or clickbait-y
- Actionable outcome implied

---

**Step 3.2: Keyword Differentiation Check**

Ensure variants have **<40% keyword overlap** to maximize differentiation:

```
Variant 1: "woocommerce hpos 2.0 complete guide"
Variant 2: "hpos 2.0 performance benchmarking optimization"
Variant 3: "hpos 2.0 migration high volume stores"

Keyword Overlap Analysis:
  Variant 1 ∩ Variant 2: ["hpos", "2.0"] = 2/6 tokens = 33% ✅
  Variant 1 ∩ Variant 3: ["hpos", "2.0"] = 2/6 tokens = 33% ✅
  Variant 2 ∩ Variant 3: ["hpos", "2.0"] = 2/6 tokens = 33% ✅

Result: All variants have <40% overlap → PASS
```

**If overlap ≥40%:**
- Regenerate variant with more distinctive keyword
- Adjust angle to increase differentiation

---

**Step 3.3: Feasibility Check**

Assess resource requirements for each variant:

**Code Examples Needed?**
- Coverage angle: Basic examples (moderate effort)
- Depth angle: Advanced examples, benchmarks (high effort)
- Use-case angle: Specific scenario examples (moderate effort)

**Hands-On Testing Required?**
- Coverage angle: General testing (low barrier)
- Depth angle: Performance testing, metrics (high barrier)
- Use-case angle: Scenario-specific testing (medium barrier)

**SME Requirements:**
- Coverage angle: No SME needed (well-documented topic)
- Depth angle: SME recommended for benchmarking accuracy
- Use-case angle: SME optional (can interview target segment)

**Feasibility Scoring (0-1):**
```
feasibility_score = (
  has_code_examples * 0.3 +
  has_official_docs * 0.4 +
  within_word_count * 0.3
)

Example Scores:
  Coverage angle: (1.0 * 0.3) + (1.0 * 0.4) + (1.0 * 0.3) = 1.0 (high)
  Depth angle: (0.7 * 0.3) + (1.0 * 0.4) + (1.0 * 0.3) = 0.91 (high)
  Use-case angle: (0.8 * 0.3) + (1.0 * 0.4) + (1.0 * 0.3) = 0.94 (high)
```

---

## Output Format

### Angle Variants JSON

```json
{
  "signal": {
    "signal_type": "Product Release",
    "source": "WooCommerce",
    "headline": "WooCommerce 8.5 Introduces HPOS 2.0",
    "core_topic": "WooCommerce HPOS 2.0"
  },
  "variants": [
    {
      "variant_id": 1,
      "variant_type": "coverage",
      "title": "Complete WooCommerce HPOS 2.0 Guide: Migration, Performance, and Rollback Strategies",
      "keyword": "woocommerce hpos 2.0 complete guide",
      "format": "Guide",
      "differentiation_angle": "Comprehensive coverage of HPOS 2.0 migration, performance optimization, and rollback procedures in one resource.",
      "primary_gap": "Coverage",
      "target_audience": "Store owners and developers (general)",
      "estimated_word_count": "1,800-2,200",
      "validation": {
        "clarity": "pass",
        "keyword_differentiation": 0.33,
        "feasibility_score": 1.0
      }
    },
    {
      "variant_id": 2,
      "variant_type": "depth",
      "title": "HPOS 2.0 Performance Benchmarking: Query Optimization and Scalability Analysis",
      "keyword": "hpos 2.0 performance benchmarking optimization",
      "format": "Analysis",
      "differentiation_angle": "Technical deep-dive with real-world benchmarks comparing 1.x vs 2.0 query performance and scaling recommendations.",
      "primary_gap": "Depth",
      "target_audience": "Advanced developers and performance engineers",
      "estimated_word_count": "1,500-1,800",
      "validation": {
        "clarity": "pass",
        "keyword_differentiation": 0.33,
        "feasibility_score": 0.91
      }
    },
    {
      "variant_id": 3,
      "variant_type": "use_case",
      "title": "HPOS 2.0 Migration Strategies for High-Volume WooCommerce Stores",
      "keyword": "hpos 2.0 migration high volume stores",
      "format": "Tutorial",
      "differentiation_angle": "Migration guide for stores with 10K+ orders: zero-downtime migration, load management, incremental rollout.",
      "primary_gap": "Coverage",
      "target_audience": "Enterprise store owners and agencies",
      "estimated_word_count": "1,400-1,700",
      "validation": {
        "clarity": "pass",
        "keyword_differentiation": 0.33,
        "feasibility_score": 0.94
      }
    }
  ],
  "metadata": {
    "generation_timestamp": "ISO-8601",
    "variants_generated": 3,
    "validation_status": "all_passed"
  }
}
```

---

## Error Handling

### Scenario 1: Signal Too Narrow (Single Viable Angle)

**Response:**
- Generate only 1-2 variants instead of 3
- Flag in output: `"warning": "Signal topic too narrow for 3 distinct angles"`
- Return available variants with recommendation to use single-angle approach

**Example:**
```
Signal: "WooCommerce Payment Gateway X Adds Apple Pay Support"
→ Too narrow for 3 angles (already use-case-specific)
→ Generate 1 variant: "How to Enable Apple Pay on [Gateway X]"
```

### Scenario 2: Signal Too Broad (Overlaps with Pillar Content)

**Response:**
- Narrow variants to specific aspects of broad signal
- Flag in output: `"warning": "Signal overlaps with pillar content, variants narrowed"`
- Ensure variants don't duplicate existing pillar coverage

### Scenario 3: Keyword Overlap ≥40%

**Response:**
- Regenerate variant with more distinctive keyword
- If still failing after 2 attempts, flag variant as low differentiation
- Return with warning: `"warning": "Variant [N] has high keyword overlap with variant [M]"`

### Scenario 4: Missing Required Signal Fields

**Response:**
- Attempt generation with available fields (degraded mode)
- Flag in output: `"warning": "Missing signal fields: [list], variants may be lower quality"`

---

## Quality Guidelines

### DO:

- Generate 3 variants for every signal (coverage, depth, use-case)
- Ensure <40% keyword overlap between variants
- Validate feasibility for each variant (code examples, docs, word count)
- Use industry-appropriate terminology (matches audience skill level)
- Include clear differentiation angles (specific value proposition)
- Estimate realistic word counts based on angle scope

### DON'T:

- Generate duplicate variants (different title, same content)
- Use clickbait or vague titles
- Create variants that overlap with existing pillar content
- Generate angles that are too narrow (<800 words) or too broad (>3,000 words)
- Skip validation steps (clarity, keyword differentiation, feasibility)
- Force 3 variants when signal only supports 1-2 viable angles

---

## Success Metrics

### Accuracy
- **Variant distinctiveness:** ≥90% of variant sets have <40% keyword overlap
- **Feasibility accuracy:** ≥85% of variants pass feasibility assessment (no resource blockers)
- **Clarity pass rate:** ≥95% of variants pass topic clarity check

### Performance
- **Generation speed:** ≤3 minutes per signal (3 variants)
- **Validation speed:** ≤1 minute for all 3 variants

### Quality
- **Variant selection success:** ≥80% of selected variants pass full deduplication later
- **Composite score range:** Selected variants average 0.75+ composite score
- **User satisfaction:** Variants feel genuinely different (not forced)

---

## Integration

### Used By

**@signal-researcher Agent:**
- Invokes angle-generator during Phase 3 (topic candidate synthesis)
- Passes signal object + configuration
- Receives 3 variants for composite scoring and selection

**Manual Invocation:**
```
Please use the angle-generator skill to generate variants for this signal.

Signal:
  signal_type: "Product Release"
  source: "WooCommerce"
  headline: "WooCommerce 8.5 Introduces HPOS 2.0 with Performance Improvements"
  summary: "WooCommerce releases HPOS 2.0 with 40% faster query performance..."
  key_aspects:
    - HPOS 2.0 release
    - 40% performance improvement
    - Scalability enhancements
    - Migration rollback capability

Industry: "WordPress data integration"
Audience: Store owners and developers (intermediate skill level)
```

### Inputs From

**requirements.md:**
- `project.industry` → Industry/domain for terminology
- `audience.primary_roles[]` → Target audience for use-case angles
- `audience.skill_level` → Affects depth angle complexity
- `content.formats[]` → Allowed formats for variants

---

## Example Invocation

### Scenario: Technology Signal (Product Release)

**Input:**
```json
{
  "signal": {
    "signal_type": "Product Release",
    "source": "React.js",
    "headline": "React 19 Introduces Server Components and Actions",
    "summary": "React 19 release includes stable Server Components, Server Actions, improved Suspense, and new use() hook for data fetching.",
    "key_aspects": [
      "Server Components (stable)",
      "Server Actions",
      "Improved Suspense",
      "use() hook",
      "Performance improvements"
    ]
  },
  "industry": "React.js development",
  "audience": {
    "primary_roles": ["Frontend developers", "Full-stack engineers"],
    "skill_level": "Intermediate"
  }
}
```

**Output: 3 Variants**

1. **Coverage Angle:** "Complete React 19 Guide: Server Components, Actions, and the use() Hook"
2. **Depth Angle:** "React 19 Server Components Deep Dive: Architecture and Performance Analysis"
3. **Use-Case Angle:** "Migrating to React 19 Server Components: Strategies for Existing Next.js Apps"

**Keyword Overlap:** 25-33% (all under 40% threshold) ✅

---

## Notes

- Angle generation is **deterministic for a given signal** (same signal → same variants)
- Variants are **unscored** at generation time (scoring happens in signal-researcher)
- Validation ensures variants are **viable candidates**, not that they'll all be used
- The skill generates angles, but **selection is delegated** to composite scoring logic
- Use-case angles can target **role, scale, industry, or problem** segments
- Depth angles should require **intermediate to advanced skill level** to justify technical depth
