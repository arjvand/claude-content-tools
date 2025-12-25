---
name: topic-deduplicator
description: Perform theme-level deduplication for topic candidates against past content. Uses similarity scoring, core theme matching, differentiation analysis, and 6-month hard-block enforcement.
---

# Topic Deduplicator Skill

## Purpose

Automate theme-level deduplication by comparing topic candidates against a theme index of past content. Prevents publishing duplicate or overly similar content through:

- **Similarity Scoring:** Multi-factor algorithm with keyword overlap, theme tags, title semantics, and core theme matching
- **Synonym Expansion:** Dynamic synonym detection for accurate paraphrase identification
- **6-Month Hard-Block:** Strict enforcement preventing same core theme within 6-month window
- **Differentiation Analysis:** Evaluates angle novelty for similar themes (7+ months old)
- **Time Decay:** Graduated thresholds based on topic recency

Replaces manual duplicate checking with systematic, repeatable deduplication that scales across all industries and content types.

## When to Use

- **Automatically:** During signal research phase (invoked by @signal-researcher for each topic candidate)
- **Manually:** When validating topic originality before calendar finalization
- **Diagnostically:** When troubleshooting why a topic was blocked or understanding similarity scores

---

## Input Parameters

### Required
- `topic_candidate`: Topic candidate object with:
  - `title`: Proposed topic title
  - `keyword`: Target keyword phrase
  - `differentiation_angle`: Unique angle description
  - `primary_gap`: Gap type (Coverage/Depth/Format/Recency)
  - `format`: Content format (Tutorial/Analysis/Guide/etc.)
  - `target_audience`: Audience segment (if specified)

- `theme_index`: Theme index JSON from theme-index-builder skill containing:
  - `topics[]`: Array of past topics with metadata
  - `theme_tags[]`: List of generated theme tags
  - `core_themes[]`: Core theme registry with patterns
  - `core_theme_saturation[]`: Saturation status per theme

### Optional
- `external_check`: Perform external novelty check via web search (default: true)
- `lookback_months`: Override theme index lookback (default: use index metadata)

---

## Process

### Phase 1: Pre-Processing (1 minute)

**Step 1.1: Extract Candidate Core Themes**

Analyze the topic candidate to determine its core themes:

**Extraction Process:**
1. Tokenize `title`, `keyword`, and `differentiation_angle`
2. Match against `core_themes[]` pattern matches from theme index
3. Assign **primary core theme** (best match) and optional **secondary core theme**

**Example:**
```
Candidate:
  title: "Migrating WooCommerce Data to REST API Endpoints"
  keyword: "woocommerce data migration api"

Core Themes Registry (from theme index):
  - "data-migration" → patterns: ["migration", "import", "sync", "data transfer"]
  - "woocommerce-api" → patterns: ["rest api", "endpoints", "integration"]

Assigned Core Themes:
  primary: "data-migration" (matches: migration, data)
  secondary: "woocommerce-api" (matches: woocommerce, api, endpoints)
```

**Step 1.2: Build Synonym Map (Dynamic)**

Generate synonym map for keyword expansion using:

1. **Universal Patterns** (works across all domains):

| Universal Pattern | Expansions |
|-------------------|------------|
| "how to [X]" | "guide to [X]", "[X] tutorial", "[X] walkthrough" |
| "best [X]" | "top [X]", "recommended [X]", "optimal [X]" |
| "[X] vs [Y]" | "[X] compared to [Y]", "[X] or [Y]", "[X] versus [Y]" |
| "complete [X]" | "comprehensive [X]", "full [X]", "ultimate [X]" |
| "[X] for beginners" | "intro to [X]", "getting started with [X]", "[X] 101" |

2. **Paraphrase Detection Patterns** (Universal):

| Pattern Type | Pattern A | Pattern B | Similarity Boost |
|--------------|-----------|-----------|------------------|
| Action variants | "how to [X]" | "guide to [X]" | +0.20 |
| Action variants | "[X] tutorial" | "learn [X]" | +0.20 |
| Comparison variants | "[X] vs [Y]" | "[X] compared to [Y]" | +0.20 |
| List variants | "top [N] [X]" | "best [X]" | +0.15 |
| Negation variants | "without [X]" | "avoid [X]" | +0.25 |
| Solution variants | "fix [X]" | "solve [X]" | +0.25 |
| Scope variants | "complete [X]" | "comprehensive [X]" | +0.15 |

3. **Project-Specific Synonyms** (learned from theme index):
   - Extract keyword variations from `core_themes[].pattern_matches`
   - Identify recurring synonym pairs in past topic titles/keywords
   - Build domain-specific synonym groups

**Example Synonym Map:**
```json
{
  "universal": {
    "migration": ["import", "sync", "transfer", "move"],
    "guide": ["tutorial", "walkthrough", "how-to", "learn"],
    "best": ["top", "recommended", "optimal", "leading"]
  },
  "project_specific": {
    "woocommerce": ["woo", "woo commerce"],
    "endpoint": ["api route", "rest endpoint", "api path"]
  }
}
```

---

### Phase 2: Core Theme Hard-Block Check (1 minute)

**CRITICAL:** This check **MUST** run first. If a core theme match is found within 6 months, the topic is **HARD BLOCKED** with no exceptions.

**Step 2.1: Check 6-Month Core Theme Conflict**

For the candidate's **primary core theme**, check `core_theme_saturation[]`:

```
Candidate Primary Core Theme: "data-migration"

From theme index core_theme_saturation:
  {
    "theme": "data-migration",
    "count_past_6_months": 2,
    "most_recent_month": "2025-10",
    "status": "SATURATED",
    "next_available": "2026-04"
  }

Result: SATURATED (count > 0 in past 6 months)
```

**Decision:**
- If `status == "SATURATED"` → **HARD BLOCK** immediately
- If `status == "AVAILABLE"` → Continue to similarity check

**Hard-Block Output:**
```json
{
  "dedup_status": "HARD_BLOCKED",
  "block_type": "core_theme",
  "core_theme_match": "data-migration",
  "block_reason": "Core theme 'data-migration' published 1 month(s) ago in ART-202510-003. Wait until April 2026 (6+ months) to revisit this theme.",
  "most_similar_id": "ART-202510-003",
  "most_similar_title": "Migrating Legacy Data to WooCommerce",
  "months_ago": 1
}
```

**If HARD BLOCKED:** Skip all remaining phases, return immediately with status.

---

### Phase 3: Similarity Scoring (2-3 minutes)

**Step 3.1: Calculate Similarity for All Past Topics**

For each topic in `theme_index.topics[]`, calculate similarity score using this algorithm:

```
theme_similarity_score = (
  keyword_overlap_score * 0.30 +
  theme_tag_overlap_score * 0.25 +
  title_semantic_similarity * 0.25 +
  core_theme_match_score * 0.20
)
```

**Component 1: Keyword Overlap Score (0-1)**

1. **Expand keywords** using synonym map from Step 1.2:
   ```
   Candidate keyword: "woocommerce data migration"
   Expanded: ["woocommerce", "woo", "data", "migration", "import", "sync", "transfer"]

   Past topic keyword: "woocommerce import guide"
   Expanded: ["woocommerce", "woo", "import", "sync", "guide", "tutorial"]
   ```

2. **Tokenize** expanded keywords into individual terms

3. **Count shared terms** between candidate and past topic:
   ```
   Candidate tokens: ["woocommerce", "woo", "data", "migration", "import", "sync", "transfer"]
   Past tokens: ["woocommerce", "woo", "import", "sync", "guide", "tutorial"]
   Shared: ["woocommerce", "woo", "import", "sync"] → 4 shared terms
   ```

4. **Divide by max keyword term count**:
   ```
   keyword_overlap_score = 4 / max(7, 6) = 4/7 ≈ 0.57
   ```

**Component 2: Theme Tag Overlap Score (0-1)**

Compare `theme_tags[]` assigned to candidate (from core theme extraction) vs past topic:

```
Candidate tags: ["data-integration", "migration", "woocommerce-apis", "tutorial"]
Past topic tags: ["data-integration", "migration", "woocommerce", "guide"]
Shared tags: ["data-integration", "migration"] → 2 shared

theme_tag_overlap_score = 2 / max(4, 4) = 0.50
```

**Component 3: Title Semantic Similarity (0-1)**

1. **Extract key noun phrases** from titles:
   ```
   Candidate: "Migrating WooCommerce Data to REST API Endpoints"
   → Nouns: ["migration", "woocommerce", "data", "rest api", "endpoints"]

   Past: "Complete WooCommerce Data Import Guide"
   → Nouns: ["woocommerce", "data", "import", "guide"]
   ```

2. **Check for shared action verbs** (e.g., "guide", "how to", "checklist"):
   ```
   Candidate: No action verb (descriptive title)
   Past: "guide" (action verb)
   → No shared action verb
   ```

3. **Detect similar structural patterns**:
   ```
   Candidate: "[Action] [Platform] [Object] to [Target]" pattern
   Past: "[Scope] [Platform] [Object] [Format]" pattern
   → Different patterns
   ```

4. **Apply paraphrase detection patterns** (from Step 1.2 table):
   ```
   "migrating" vs "import" → Solution variant (+0.25 similarity boost)
   ```

5. **Calculate base similarity + paraphrase boosts**:
   ```
   Base similarity (noun overlap): 3/5 = 0.60
   Paraphrase boost: +0.25
   title_semantic_similarity = min(0.60 + 0.25, 1.0) = 0.85
   ```

**Component 4: Core Theme Match Score (0-1)**

Compare core themes:

```
Candidate:
  primary: "data-migration"
  secondary: "woocommerce-api"

Past Topic:
  primary: "data-migration"
  secondary: "woocommerce"

Scoring:
- Exact primary core theme match? YES → Score = 1.0
- Secondary core theme overlap? YES → (already captured by primary)

core_theme_match_score = 1.0
```

**Scoring Rules:**
- **Exact primary core theme match:** Score = 1.0
- **Secondary core theme overlap only:** Score = 0.5
- **No core theme overlap:** Score = 0.0

**Step 3.2: Calculate Total Similarity**

```
theme_similarity_score = (
  0.57 * 0.30 +  // keyword_overlap_score
  0.50 * 0.25 +  // theme_tag_overlap_score
  0.85 * 0.25 +  // title_semantic_similarity
  1.0 * 0.20     // core_theme_match_score
)
= 0.171 + 0.125 + 0.2125 + 0.20
= 0.7085
≈ 0.71
```

**Step 3.3: Find Most Similar Past Topic**

Repeat similarity calculation for all topics in theme index. Select the topic with the **highest similarity score** as "most similar."

```
Most Similar: ART-202509-004
  Title: "Complete WooCommerce Data Import Guide"
  Similarity: 0.71
  Months Ago: 2
```

---

### Phase 4: Threshold Classification (1 minute)

**Step 4.1: Apply Similarity Thresholds**

Based on similarity score and recency, classify the candidate:

| Condition | Recency | Classification | Action |
|-----------|---------|----------------|--------|
| Same primary core theme | 0-5 months | **Recent Core Theme** | **HARD BLOCK** (handled in Phase 2) |
| Similarity ≥ 0.60 | 0-6 months | **Similar Recent** | **BLOCK** (strict) |
| Similarity ≥ 0.80 | Any age | **Near Duplicate** | **BLOCK** |
| Similarity 0.40-0.79 | 7+ months | **Similar Theme** | Check differentiation |
| Similarity < 0.40 | Any age | **Low Similarity** | **PASS** (NOVEL) |

**Example Classification:**
```
Most Similar Topic:
  Similarity: 0.71
  Months Ago: 2

Condition Check:
  - Core theme hard-block? NO (passed Phase 2)
  - Similarity ≥ 0.80? NO (0.71 < 0.80)
  - Similarity ≥ 0.60 AND within 6 months? YES (0.71 ≥ 0.60, 2 months ≤ 6)

Classification: SIMILAR RECENT → BLOCK
```

**Block Output:**
```json
{
  "dedup_status": "BLOCKED",
  "block_type": "recent_similar",
  "most_similar_id": "ART-202509-004",
  "most_similar_title": "Complete WooCommerce Data Import Guide",
  "theme_similarity_score": 0.71,
  "months_ago": 2,
  "block_reason": "Similar theme too recent. ART-202509-004 was published 2 month(s) ago with similarity 0.71. Wait until month 7+ or find significantly different angle."
}
```

**If BLOCKED:** Skip differentiation check, return immediately.

---

### Phase 5: Differentiation Analysis (2 minutes)

**Note:** This phase only runs for topics with:
- Similarity 0.40-0.79
- Most similar topic is 7+ months old

**Step 5.1: Calculate Differentiation Score**

Compare the candidate's differentiation angle against the most similar past topic:

**Component 1: Gap Type Difference (0-1)**

```
Candidate primary_gap: "Depth"
Past topic primary_gap: "Coverage"

gap_type_difference = (same gap?) ? 0.0 : 1.0
                     = 1.0  (different gaps)
```

**Component 2: Angle Novelty (0-1)**

Evaluate if the new angle addresses a **specific aspect not covered** by the past topic:

**Look for:**
- Different audience segment (e.g., "for beginners" vs "for advanced")
- Different use case (e.g., "e-commerce" vs "membership sites")
- Time-bound context (e.g., "2025 updates" vs general guide)
- Different format/deliverable (e.g., "checklist" vs "tutorial")

**Example:**
```
Candidate differentiation_angle:
  "Custom endpoint approach using WP REST API extensions, focus on security and performance optimization for large datasets"

Past topic differentiation_angle:
  "Beginner-friendly guide to WooCommerce import using CSV files and native tools"

Analysis:
  - Different audience? YES (advanced custom approach vs beginner native tools)
  - Different technical depth? YES (REST API extensions vs CSV import)
  - Different use case? YES (large datasets/performance vs general import)

angle_novelty = 1.0 (clearly distinct aspect)
```

**Component 3: Audience Difference (0-1)**

```
Candidate target_audience: "Intermediate developers"
Past topic target_audience: "Beginners"

audience_difference = (same audience?) ? 0.0 : 1.0
                     = 1.0  (different audience)
```

**Component 4: Format Difference (0-1)**

```
Candidate format: "Tutorial"
Past topic format: "Guide"

format_difference = (same format?) ? 0.0 : 1.0
                   = 0.0  (both are instructional formats - treated as same)
```

**Note:** Similar formats (Tutorial/Guide/Walkthrough, Analysis/Opinion/POV) are treated as same.

**Step 5.2: Calculate Total Differentiation Score**

```
differentiation_score = (
  gap_type_difference * 0.25 +
  angle_novelty * 0.40 +
  audience_difference * 0.20 +
  format_difference * 0.15
)
= (1.0 * 0.25) + (1.0 * 0.40) + (1.0 * 0.20) + (0.0 * 0.15)
= 0.25 + 0.40 + 0.20 + 0.0
= 0.85
```

---

### Phase 6: Time Decay Threshold (1 minute)

**Note:** Topics within 6 months are subject to hard-block rules (Phase 4). This time decay applies only to topics **7+ months old**.

**Step 6.1: Calculate Time-Decayed Threshold**

```
time_decay = min(1.0, months_ago / 12)
differentiation_threshold = 0.85 - (time_decay * 0.35)
```

**Example:**
```
Most similar topic months_ago: 8 months

time_decay = min(1.0, 8/12) = 0.67
differentiation_threshold = 0.85 - (0.67 * 0.35)
                          = 0.85 - 0.23
                          = 0.62
```

**Threshold Table:**

| Months Ago | Time Decay | Differentiation Threshold | Notes |
|------------|------------|---------------------------|-------|
| 0-6 months | N/A | N/A | **HARD BLOCK** (Phase 4) |
| 7 months | 0.58 | 0.65 | Very high bar |
| 8 months | 0.67 | 0.62 | High bar |
| 9 months | 0.75 | 0.59 | Moderate bar |
| 10 months | 0.83 | 0.56 | Standard |
| 11 months | 0.92 | 0.53 | Approaching lenient |
| 12 months | 1.00 | 0.50 | Lenient (themes can revisit) |

**Step 6.2: Compare Differentiation Score to Threshold**

```
differentiation_score: 0.85
differentiation_threshold: 0.62

Pass Condition: differentiation_score >= differentiation_threshold
                0.85 >= 0.62 → YES

Result: DIFFERENTIATED (PASS)
```

**Differentiated Output:**
```json
{
  "dedup_status": "DIFFERENTIATED",
  "most_similar_id": "ART-202501-002",
  "most_similar_title": "Beginner's Guide to WooCommerce CSV Import",
  "theme_similarity_score": 0.62,
  "differentiation_score": 0.85,
  "differentiation_threshold": 0.62,
  "months_ago": 8,
  "pass_reason": "Similar theme (8 months ago) with sufficient differentiation (0.85 >= 0.62). Angle focuses on advanced REST API approach vs beginner CSV import."
}
```

**Blocked by Differentiation Output:**
```json
{
  "dedup_status": "BLOCKED",
  "block_type": "insufficient_differentiation",
  "most_similar_id": "ART-202501-002",
  "most_similar_title": "WooCommerce Data Migration Guide",
  "theme_similarity_score": 0.68,
  "differentiation_score": 0.45,
  "differentiation_threshold": 0.62,
  "months_ago": 8,
  "block_reason": "Insufficient differentiation from ART-202501-002 (diff: 0.45 < threshold: 0.62). Angle is too similar to past coverage."
}
```

---

### Phase 7: External Novelty Check (Optional, 1 minute)

**Step 7.1: Perform Basic Web Search**

If `external_check = true`, perform basic web search to check if topic is saturated externally:

```
Search Query: "[candidate keyword]" site:competitors
Example: "woocommerce data migration api" site:wpbeginner.com OR site:torquemag.io
```

**Step 7.2: Assess External Saturation**

- **Low saturation:** <5 relevant results → External novelty confirmed
- **Moderate saturation:** 5-15 results → Angle needed to stand out
- **High saturation:** 15+ results → External duplicate concerns

**Note:** External check does NOT override internal deduplication status. It provides additional context only.

---

## Output Format

### Deduplication Result JSON

```json
{
  "dedup_status": "NOVEL|DIFFERENTIATED|BLOCKED|HARD_BLOCKED",
  "candidate": {
    "title": "Candidate title",
    "keyword": "target keyword phrase",
    "core_themes": {
      "primary": "primary-theme",
      "secondary": "secondary-theme"
    }
  },
  "comparison": {
    "most_similar_id": "ART-YYYYMM-NNN",
    "most_similar_title": "Past topic title",
    "theme_similarity_score": 0.XX,
    "similarity_breakdown": {
      "keyword_overlap": 0.XX,
      "theme_tag_overlap": 0.XX,
      "title_semantic": 0.XX,
      "core_theme_match": 0.XX
    },
    "months_ago": N
  },
  "decision": {
    "block_type": "core_theme|near_duplicate|recent_similar|insufficient_differentiation|null",
    "core_theme_match": "theme-name (if HARD_BLOCKED)",
    "differentiation_score": 0.XX,
    "differentiation_threshold": 0.XX,
    "pass_reason": "Explanation if NOVEL or DIFFERENTIATED",
    "block_reason": "Explanation if BLOCKED or HARD_BLOCKED"
  },
  "external_check": {
    "performed": true,
    "saturation": "low|moderate|high",
    "note": "External context (optional)"
  },
  "timestamp": "ISO-8601 timestamp"
}
```

### Status Definitions

- **NOVEL:** No similar topics found (similarity < 0.40) — completely original
- **DIFFERENTIATED:** Similar theme exists (7+ months old) but angle is sufficiently different
- **BLOCKED:** Topic blocked due to:
  - `near_duplicate`: Similarity ≥ 0.80 (any age)
  - `recent_similar`: Similarity ≥ 0.60 within 6 months
  - `insufficient_differentiation`: Failed differentiation threshold (7+ months)
- **HARD_BLOCKED:** Topic blocked due to `core_theme` match within 6 months (no exceptions)

---

## Error Handling

### Scenario 1: Theme Index Missing or Invalid

**Response:**
- Return error status immediately
- Do NOT proceed with deduplication (no index = no validation possible)
- Error message: "Theme index required for deduplication. Run theme-index-builder first."

### Scenario 2: Candidate Missing Required Fields

**Response:**
- Log warning with missing field names
- Attempt deduplication with available fields (degraded mode)
- Flag in output: `"warning": "Deduplication performed with incomplete candidate data"`

### Scenario 3: No Past Topics in Index

**Response:**
- Automatic NOVEL status for all candidates
- Output: `"dedup_status": "NOVEL", "note": "First calendar - no past topics to compare"`

### Scenario 4: Core Theme Extraction Fails

**Response:**
- Skip core theme hard-block check (no core theme data)
- Continue with similarity analysis only
- Flag in output: `"warning": "Core theme extraction failed - 6-month hard-block disabled"`

---

## Quality Guidelines

### DO:
- Run core theme hard-block check FIRST (Phase 2 before Phase 3)
- Use synonym expansion for accurate keyword overlap
- Apply paraphrase detection patterns universally
- Calculate differentiation ONLY for topics 7+ months old
- Provide detailed block reasons with specific data

### DON'T:
- Skip core theme check (critical for 6-month enforcement)
- Use hardcoded synonym lists (build dynamically from theme index)
- Allow differentiation bypass for topics <7 months old
- Return generic "duplicate" status (must specify block type)
- Proceed without theme index validation

---

## Success Metrics

### Accuracy
- **Precision:** ≥95% of BLOCKED topics are true duplicates/overly similar
- **Recall:** ≥90% of true duplicates are correctly identified as BLOCKED
- **Consistency:** Same topic candidate receives same status across runs

### Performance
- **Processing Speed:** ≤1 minute per candidate (for index with 100 topics)
- **Similarity Calculation:** ≤5 seconds for full theme index scan

### Quality
- **Block Rate:** 10-20% of candidates blocked (healthy filtering, not over-blocking)
- **Hard-Block Precision:** 100% of HARD_BLOCKED topics violate 6-month core theme rule
- **Differentiation Success:** 70-80% of similar themes (7+ months) pass differentiation

---

## Integration

### Used By

**@signal-researcher Agent:**
- Invokes topic-deduplicator during Phase 4, Step 4.3 (Novelty Check)
- Passes each topic candidate + theme index
- Uses dedup status to filter candidates

**Manual Invocation:**
```
Please use the topic-deduplicator skill to check this topic candidate.

Topic Candidate:
  title: "Migrating WooCommerce Data to REST API Endpoints"
  keyword: "woocommerce data migration api"
  differentiation_angle: "Custom endpoint approach using WP REST API extensions"
  primary_gap: "Depth"
  format: "Tutorial"

Theme Index: project/Calendar/2025/November/theme-index.json
```

### Inputs From

**theme-index-builder Skill:**
- `theme-index.json` — Full theme index with past topics, theme tags, core themes, saturation data

---

## Example Invocation

### Scenario 1: NOVEL Topic (No Similar Content)

**Input:**
```json
{
  "candidate": {
    "title": "Building Custom WooCommerce Webhooks for Inventory Management",
    "keyword": "woocommerce webhooks inventory automation",
    "differentiation_angle": "Real-time inventory sync using webhook architecture",
    "primary_gap": "Coverage",
    "format": "Tutorial"
  },
  "theme_index": { /* loaded from theme-index.json */ }
}
```

**Process:**
- Core theme check: "webhook-automation" NOT in saturation list → PASS
- Similarity check: Highest similarity = 0.32 (< 0.40 threshold) → NOVEL

**Output:**
```json
{
  "dedup_status": "NOVEL",
  "candidate": {
    "title": "Building Custom WooCommerce Webhooks for Inventory Management",
    "keyword": "woocommerce webhooks inventory automation",
    "core_themes": {
      "primary": "webhook-automation",
      "secondary": "inventory-management"
    }
  },
  "comparison": {
    "most_similar_id": "ART-202503-007",
    "most_similar_title": "WooCommerce Inventory Tracking Best Practices",
    "theme_similarity_score": 0.32,
    "months_ago": 7
  },
  "decision": {
    "block_type": null,
    "pass_reason": "No similar topics found (similarity 0.32 < 0.40 threshold). Topic is completely original."
  }
}
```

### Scenario 2: HARD_BLOCKED (Core Theme Within 6 Months)

**Input:**
```json
{
  "candidate": {
    "title": "Advanced WooCommerce Data Migration Strategies",
    "keyword": "woocommerce data migration advanced",
    "core_themes": {
      "primary": "data-migration"
    }
  },
  "theme_index": {
    "core_theme_saturation": [
      {
        "theme": "data-migration",
        "count_past_6_months": 1,
        "most_recent_month": "2025-10",
        "status": "SATURATED"
      }
    ]
  }
}
```

**Process:**
- Core theme check: "data-migration" SATURATED (1 occurrence in past 6 months) → HARD BLOCK

**Output:**
```json
{
  "dedup_status": "HARD_BLOCKED",
  "block_type": "core_theme",
  "core_theme_match": "data-migration",
  "block_reason": "Core theme 'data-migration' published 1 month(s) ago in ART-202510-003. Wait until April 2026 (6+ months) to revisit this theme.",
  "most_similar_id": "ART-202510-003",
  "most_similar_title": "Migrating Legacy WooCommerce Data",
  "months_ago": 1
}
```

### Scenario 3: DIFFERENTIATED (Similar Theme, Strong Angle)

**Input:**
```json
{
  "candidate": {
    "title": "WooCommerce Security Hardening for Enterprise",
    "keyword": "woocommerce security enterprise hardening",
    "differentiation_angle": "Enterprise-specific security configurations, compliance requirements (PCI DSS), advanced authentication",
    "primary_gap": "Depth",
    "format": "Guide",
    "target_audience": "Enterprise developers"
  }
}
```

**Process:**
- Core theme check: "security" last published 8 months ago → PASS
- Similarity check: Highest similarity = 0.58 with "WooCommerce Security Best Practices" (8 months ago) → Similar Theme
- Differentiation check:
  - Different gap type: YES (Depth vs Coverage)
  - Different audience: YES (Enterprise vs General)
  - Different angle: YES (Compliance/PCI DSS vs General best practices)
  - Differentiation score: 0.78 vs threshold 0.62 → PASS

**Output:**
```json
{
  "dedup_status": "DIFFERENTIATED",
  "comparison": {
    "most_similar_id": "ART-202502-005",
    "most_similar_title": "WooCommerce Security Best Practices",
    "theme_similarity_score": 0.58,
    "months_ago": 8
  },
  "decision": {
    "differentiation_score": 0.78,
    "differentiation_threshold": 0.62,
    "pass_reason": "Similar theme (8 months ago) with sufficient differentiation (0.78 >= 0.62). Angle focuses on enterprise compliance vs general best practices."
  }
}
```

---

## Notes

- Deduplication is **mandatory** for all topic candidates when past calendars exist
- 6-month core theme hard-block is **non-negotiable** — no differentiation bypass
- Synonym expansion and paraphrase detection are **dynamic** (not hardcoded)
- Time decay only applies to topics **7+ months old** (stricter for recent content)
- External check is **supplementary** (does not override internal dedup status)
