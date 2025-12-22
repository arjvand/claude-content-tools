# Requirements Extractor Skill

## Purpose

Centralized configuration extraction and validation for `requirements.md`. This skill eliminates repeated ad-hoc parsing across commands and agents, validates configuration completeness, and catches errors before workflow execution begins.

## Problem Solved

**Before this skill:**
- Every command/agent manually parses requirements.md with custom logic
- No validation that extraction captured all required fields
- Parsing errors caught 20+ minutes into workflows
- Inconsistent extraction patterns lead to bugs

**With this skill:**
- Single source of truth for configuration structure
- Validation happens in <30 seconds upfront
- Structured JSON output for programmatic consumption
- Consistent extraction across entire system

## Invocation Modes

### Mode 1: Full Extraction (Default)

Extract complete configuration and validate.

**Usage:**
```
I need to extract the complete configuration from requirements.md. Please use the requirements-extractor skill.
```

**Output:**
1. `config.json` - Complete structured configuration
2. `validation-report.md` - Issues and warnings found

### Mode 2: Validation Only

Check configuration validity without JSON export.

**Usage:**
```
I need to validate requirements.md for errors. Please use the requirements-extractor skill in validation mode.
```

**Output:**
- `validation-report.md` only (no JSON file)

### Mode 3: Subset Extract

Extract only specific sections for targeted use.

**Usage:**
```
I need just the SEO configuration from requirements.md. Please use the requirements-extractor skill to extract the SEO subset.
```

**Supported subsets:**
- `seo` - SEO strategy, internal linking, CTA, distribution
- `competitive` - Gap analysis configuration and weights
- `content` - Formats, mix, word counts, pillars
- `brand` - Brand identity, voice, guidelines
- `audience` - Roles, skill levels, segments

**Output:**
- Subset JSON with only requested sections

## Extraction Schema

The skill extracts requirements.md into this standardized structure:

```json
{
  "meta": {
    "config_version": "1.0",
    "last_updated": "YYYY-MM-DD",
    "extracted_at": "YYYY-MM-DD HH:MM:SS",
    "source_file": "/path/to/requirements.md"
  },
  "project": {
    "industry": "string",
    "platform": "string",
    "focus_areas": ["string"],
    "official_docs": "url",
    "community_forums": ["url"],
    "official_blogs": ["url"],
    "repository": "url"
  },
  "audience": {
    "primary_roles": ["string"],
    "skill_level": "beginner|intermediate|advanced|mixed",
    "primary_segment": "string",
    "secondary_segments": ["string"]
  },
  "brand": {
    "name": "string",
    "colors": {
      "primary": "hex",
      "accent": "hex"
    },
    "voice": {
      "traits": ["string"],
      "do": ["string"],
      "dont": ["string"]
    }
  },
  "content": {
    "objective": "string",
    "primary_kpi": "string",
    "formats": ["string"],
    "mix": {
      "format_name": 0.40
    },
    "word_count_range": [min, max],
    "topic_pillars": ["string"]
  },
  "seo": {
    "strategy": ["string"],
    "internal_linking": "string",
    "primary_cta": "string",
    "distribution_channels": ["string"]
  },
  "competitive": {
    "run_preanalysis": true,
    "topic_candidate_count": 12,
    "preanalysis_competitor_count": 8,
    "full_analysis_competitor_count": 10,
    "min_opportunity_score": 3.0,
    "required_tier1_pct": 0.60,
    "opportunity_weights": {
      "coverage": 0.30,
      "depth": 0.40,
      "format": 0.15,
      "recency": 0.15
    },
    "differentiation_priorities": ["string"]
  },
  "delivery": {
    "cms_platform": "string",
    "html_formatter_skill": "string|none",
    "image_style": "string"
  },
  "localization": {
    "language": "string",
    "regions": ["string"],
    "spelling": "US|UK"
  },
  "quality": {
    "sme_involvement": "string",
    "review_workflow": ["string"],
    "cadence": "string"
  }
}
```

## Validation Rules

### Required Fields (Error if missing)

**Project:**
- `industry` - What domain/niche
- `platform` - Specific platform/product
- `focus_areas` - At least 1 focus area

**Audience:**
- `primary_roles` - At least 1 role
- `skill_level` - Must be valid enum value

**Brand:**
- `name` - Brand name
- `voice.traits` - At least 2 traits

**Content:**
- `objective` - Content objective
- `formats` - At least 1 format
- `mix` - Content mix percentages
- `word_count_range` - [min, max] array

**Localization:**
- `spelling` - Must be "US" or "UK"

### Format Validation (Error if incorrect)

1. **Content Mix:** Percentages must sum to 100% (±1% tolerance)
   ```json
   {"tutorials": 0.40, "playbooks": 0.30, "news": 0.30}
   // Sum = 1.00 ✓
   ```

2. **Opportunity Weights:** Must sum to 1.0 exactly
   ```json
   {"coverage": 0.30, "depth": 0.40, "format": 0.15, "recency": 0.15}
   // Sum = 1.00 ✓
   ```

3. **URLs:** Must be valid format (http/https)
   ```
   https://developer.wordpress.org/ ✓
   developer.wordpress.org ✗ (missing protocol)
   ```

4. **Word Count Range:** Must be [min, max] with min < max
   ```json
   [900, 2000] ✓
   [2000, 900] ✗ (min > max)
   ```

5. **Percentages:** Must be in 0.0-1.0 range
   ```
   0.40 ✓ (40%)
   40 ✗ (should be 0.40)
   ```

### Consistency Checks (Warning if inconsistent)

1. **Format Alignment:** `content.formats` must match keys in `content.mix`
   ```json
   // ✓ Consistent
   "formats": ["Tutorial", "Playbook"],
   "mix": {"tutorials": 0.60, "playbooks": 0.40}

   // ✗ Inconsistent - "Deep Dive" not in mix
   "formats": ["Tutorial", "Deep Dive"],
   "mix": {"tutorials": 1.0}
   ```

2. **Topic Candidate Count:** Should be ≥ target calendar size + 2
   ```
   topic_candidate_count: 12 ✓ (for 8-10 article calendar)
   topic_candidate_count: 8 ⚠️ (too few for 10 article calendar)
   ```

3. **CMS Platform Alignment:** `cms_platform` vs. `html_formatter_skill`
   ```
   cms_platform: "WordPress"
   html_formatter_skill: "gutenberg-formatter" ✓

   cms_platform: "Markdown files"
   html_formatter_skill: "gutenberg-formatter" ⚠️ (mismatch)
   ```

4. **Competitor Counts:** Pre-analysis count ≤ Full analysis count
   ```
   preanalysis_competitor_count: 8
   full_analysis_competitor_count: 10 ✓

   preanalysis_competitor_count: 12
   full_analysis_competitor_count: 8 ⚠️ (pre > full)
   ```

### Deprecation Warnings

Flag outdated configuration patterns and suggest modern alternatives:

- Old field names (suggest new equivalents)
- Deprecated format values
- Obsolete competitive analysis settings

## Skill Workflow

### Step 1: Load Requirements File

```markdown
1. Read requirements.md from project root
2. Parse markdown structure (H2 sections = top-level keys)
3. Extract bullet points, tables, and structured data
4. Handle missing optional sections gracefully
```

### Step 2: Extract Structured Data

For each section:

**Project Definition:**
- Parse "Industry/Niche" → `project.industry`
- Parse "Platform/Product" → `project.platform`
- Parse bullet list under "Focus Areas" → `project.focus_areas[]`
- Extract URLs from "Official Documentation" → `project.official_docs`

**Audience:**
- Parse roles from bullet list → `audience.primary_roles[]`
- Extract skill level from "Skill Level Range" → `audience.skill_level`
- Parse primary segment → `audience.primary_segment`

**Brand Identity:**
- Extract brand name → `brand.name`
- Parse color codes → `brand.colors.{primary, accent}`
- Extract voice traits → `brand.voice.traits[]`
- Parse DO/DON'T examples → `brand.voice.{do[], dont[]}`

**Content Strategy:**
- Parse content formats → `content.formats[]`
- Extract percentages from mix → `content.mix{}`
- Parse word count range → `content.word_count_range[min, max]`
- Extract topic pillars → `content.topic_pillars[]`

**Competitive Gap Analysis:**
- Parse enabled/disabled → `competitive.run_preanalysis`
- Extract numeric settings → `competitive.*_count`
- Parse opportunity weights → `competitive.opportunity_weights{}`
- Extract min scores and thresholds

**Delivery & Localization:**
- Extract CMS platform → `delivery.cms_platform`
- Parse HTML formatter → `delivery.html_formatter_skill`
- Extract language/spelling → `localization.{language, spelling}`

### Step 3: Validate Extracted Data

Run validation rules in order:

1. **Required Fields Check** (errors if missing)
2. **Format Validation** (errors if malformed)
3. **Consistency Checks** (warnings if inconsistent)
4. **Deprecation Warnings** (informational)

Generate validation report with:
- ✅ Passed checks
- ❌ Critical errors (block workflow)
- ⚠️ Warnings (proceed with caution)
- 📌 Deprecation notices (update recommended)

### Step 4: Output Generation

**Full Extraction Mode:**
1. Save structured JSON to `.claude/cache/config.json`
2. Save validation report to `.claude/cache/validation-report.md`
3. Return summary to caller

**Validation Only Mode:**
1. Save validation report to `.claude/cache/validation-report.md`
2. Return summary (do not create JSON)

**Subset Extract Mode:**
1. Filter JSON to requested subset
2. Return subset data to caller
3. No file persistence (ephemeral)

### Step 5: Caching

- Cache config.json with timestamp
- Cache expires after 1 hour
- Subsequent invocations within 1 hour reuse cached data
- Manual invalidation: delete `.claude/cache/config.json`

## Example Outputs

### Example 1: Successful Full Extraction

**validation-report.md:**
```markdown
# Configuration Validation Report

**File:** requirements.md
**Extracted:** 2025-11-05 14:32:15
**Status:** ✅ Valid (2 warnings)

## Summary

- ✅ All required fields present
- ✅ Format validation passed
- ⚠️ 2 consistency warnings
- 📌 0 deprecation notices

---

## Validation Details

### Required Fields ✅
- ✅ project.industry: "WordPress data integration"
- ✅ project.platform: "WordPress, WooCommerce, Gravity Forms"
- ✅ audience.primary_roles: 3 roles found
- ✅ brand.name: "Summix Blog"
- ✅ content.formats: 5 formats found
- ✅ localization.spelling: "US"

### Format Validation ✅
- ✅ Content mix sums to 100.0% (tolerance: ±1%)
- ✅ Opportunity weights sum to 1.0
- ✅ Word count range valid: [900, 2000]
- ✅ All URLs valid (4 checked)
- ✅ Percentages in correct range (0.0-1.0)

### Consistency Checks ⚠️
- ✅ Content formats match content mix keys
- ⚠️ **Warning:** topic_candidate_count (12) slightly low for 10-article target
  - Recommendation: Increase to 14-15 for better selection
- ⚠️ **Warning:** CMS platform "WordPress" but html_formatter_skill is "none"
  - Recommendation: Set to "gutenberg-formatter" for WordPress
- ✅ Competitor counts aligned (pre: 8, full: 10)

### Deprecation Notices 📌
- No deprecated patterns detected

---

## Configuration Summary

**Extracted 8/8 sections:**
1. ✅ Project Definition
2. ✅ Audience
3. ✅ Brand Identity
4. ✅ Content Strategy
5. ✅ SEO & Distribution
6. ✅ Competitive Gap Analysis
7. ✅ Delivery Settings
8. ✅ Localization

**Cached to:** .claude/cache/config.json
**Cache expires:** 2025-11-05 15:32:15
```

**config.json:**
```json
{
  "meta": {
    "config_version": "1.0",
    "last_updated": "2025-10-15",
    "extracted_at": "2025-11-05 14:32:15",
    "source_file": "/home/alpha/Local Sites/Summix/Blog2/requirements.md"
  },
  "project": {
    "industry": "WordPress data integration",
    "platform": "WordPress, WooCommerce, Gravity Forms, CRMs",
    "focus_areas": [
      "Content portability and migration",
      "CRM integration patterns",
      "Form data workflows",
      "Multi-system data sync"
    ],
    "official_docs": "https://developer.wordpress.org/",
    "community_forums": [
      "https://wordpress.org/support/",
      "https://woocommerce.com/community/"
    ],
    "official_blogs": [
      "https://make.wordpress.org/",
      "https://woocommerce.com/blog/"
    ],
    "repository": "https://github.com/wordpress"
  },
  "audience": {
    "primary_roles": [
      "Site owners",
      "Freelance developers",
      "Agencies"
    ],
    "skill_level": "intermediate",
    "primary_segment": "Developers managing client sites with complex integrations"
  },
  "brand": {
    "name": "Summix Blog",
    "colors": {
      "primary": "#2271b1",
      "accent": "#00a32a"
    },
    "voice": {
      "traits": ["Friendly", "Practical", "Precise"],
      "do": [
        "Use clear, jargon-free language",
        "Provide working code examples",
        "Explain the 'why' behind recommendations"
      ],
      "dont": [
        "Use marketing hype",
        "Make unsupported claims",
        "Oversimplify complex topics"
      ]
    }
  },
  "content": {
    "objective": "Establish authority in WordPress data integration",
    "primary_kpi": "Brand lift and impressions",
    "formats": [
      "Tutorial",
      "Integration Playbook",
      "Deep Dive",
      "Product News",
      "Industry Analysis"
    ],
    "mix": {
      "tutorials": 0.40,
      "playbooks": 0.30,
      "deep_dives": 0.15,
      "news": 0.10,
      "analysis": 0.05
    },
    "word_count_range": [900, 2000],
    "topic_pillars": [
      "WooCommerce Integration",
      "Content Migration",
      "CRM Workflows",
      "Form Processing"
    ]
  },
  "seo": {
    "strategy": ["Keyword-first", "Topic clusters", "Opportunistic"],
    "internal_linking": "3-5 contextual links per article",
    "primary_cta": "Newsletter subscribe",
    "distribution_channels": ["Newsletter", "RSS"]
  },
  "competitive": {
    "run_preanalysis": true,
    "topic_candidate_count": 12,
    "preanalysis_competitor_count": 8,
    "full_analysis_competitor_count": 10,
    "min_opportunity_score": 3.0,
    "required_tier1_pct": 0.60,
    "opportunity_weights": {
      "coverage": 0.30,
      "depth": 0.40,
      "format": 0.15,
      "recency": 0.15
    },
    "differentiation_priorities": [
      "Technical depth",
      "Working code examples",
      "Real-world integration patterns"
    ]
  },
  "delivery": {
    "cms_platform": "WordPress (Gutenberg editor)",
    "html_formatter_skill": "none",
    "image_style": "Technical diagrams and screenshots"
  },
  "localization": {
    "language": "English",
    "regions": ["United States", "Global"],
    "spelling": "US"
  },
  "quality": {
    "sme_involvement": "Required for integration tutorials",
    "review_workflow": ["@editor", "Legal/Compliance", "SME (technical tutorials)"],
    "cadence": "2 posts per month"
  }
}
```

### Example 2: Critical Errors Found

**validation-report.md:**
```markdown
# Configuration Validation Report

**File:** requirements.md
**Extracted:** 2025-11-05 14:45:30
**Status:** ❌ Invalid (3 critical errors)

## Summary

- ❌ 3 critical errors (blocks workflow)
- ⚠️ 1 consistency warning
- 📌 1 deprecation notice

**⚠️ WORKFLOW BLOCKED:** Fix critical errors before proceeding.

---

## Critical Errors ❌

### 1. Missing Required Field: `brand.voice.traits`
**Location:** Brand Identity section
**Issue:** No voice traits specified
**Fix:** Add at least 2 brand voice traits (e.g., "Friendly", "Practical")

### 2. Invalid Content Mix: Sum is 95%
**Location:** Content Strategy > Content Mix
**Current:** {"tutorials": 0.40, "playbooks": 0.30, "news": 0.25}
**Issue:** Percentages sum to 95% (expected 100% ±1%)
**Fix:** Adjust mix to sum to 100% (1.0)

### 3. Invalid Word Count Range: [2000, 900]
**Location:** Content Strategy > Word Count
**Current:** [2000, 900]
**Issue:** Minimum (2000) > Maximum (900)
**Fix:** Reverse to [900, 2000]

---

## Warnings ⚠️

### Consistency: Competitor Count Mismatch
**Issue:** preanalysis_competitor_count (12) > full_analysis_competitor_count (8)
**Expected:** Pre-analysis should analyze fewer competitors than full analysis
**Recommendation:** Set preanalysis_competitor_count to 8 or less

---

## Deprecation Notices 📌

### Deprecated Field: `competitive.enable_gap_analysis`
**Old:** `enable_gap_analysis: true`
**New:** `run_preanalysis: true`
**Action:** Update field name in requirements.md

---

## Next Steps

1. Fix 3 critical errors listed above
2. Address consistency warning (optional but recommended)
3. Update deprecated field name
4. Re-run requirements-extractor skill to validate

**No config.json generated** (blocked by errors)
```

### Example 3: Subset Extract (SEO only)

**Invocation:**
"Extract just the SEO configuration using requirements-extractor skill"

**Output (returned directly, not saved):**
```json
{
  "seo": {
    "strategy": ["Keyword-first", "Topic clusters", "Opportunistic"],
    "internal_linking": "3-5 contextual links per article",
    "primary_cta": "Newsletter subscribe",
    "distribution_channels": ["Newsletter", "RSS"]
  },
  "meta": {
    "subset": "seo",
    "extracted_at": "2025-11-05 14:50:00"
  }
}
```

## Integration Examples

### Example 1: Content Calendar Command

**Before (manual parsing):**
```markdown
## Step 1: Load Configuration

Read requirements.md and extract:
- Industry/niche → $INDUSTRY
- Platform → $PLATFORM
- Focus areas → $FOCUS_AREAS
- Content mix → $CONTENT_MIX
(... 20+ variables manually extracted)
```

**After (using skill):**
```markdown
## Step 1: Load Configuration

Invoke requirements-extractor skill:
- Load and validate configuration
- If validation errors found → Report errors and exit
- If validation passed → Use config.json for all subsequent steps

Access config via:
- project.industry, project.platform, project.focus_areas
- content.mix, content.formats, content.word_count_range
- competitive.* for gap analysis settings
- All other config sections as needed
```

### Example 2: Writer Agent

**Before:**
```markdown
## Phase 0: Load Brand Voice

Parse requirements.md Brand Identity section:
- Extract voice traits
- Extract DO/DON'T examples
- Parse spelling preference
```

**After:**
```markdown
## Phase 0: Load Brand Voice

Invoke requirements-extractor skill with subset=brand:
- Get brand.voice.traits, brand.voice.{do, dont}
- Get localization.spelling
- Apply voice guidelines to all writing
```

### Example 3: Error Detection

**Scenario:** User updates requirements.md with invalid content mix

**Without skill:**
- Calendar command runs for 25 minutes
- Gap analysis completes
- Calendar assembly fails: "Content mix doesn't sum to 100%"
- User wastes 25 minutes

**With skill:**
- Calendar command invokes requirements-extractor (15 seconds)
- Validation detects: "Content mix sums to 85% (expected 100%)"
- Command exits immediately with error report
- User fixes config and re-runs (wasted: 15 seconds)

## Caching Strategy

### Cache Location
`.claude/cache/config.json`

### Cache Lifetime
- 1 hour from extraction timestamp
- Invalidated when requirements.md modified (compare mtimes)

### Cache Behavior

**First invocation:**
1. Extract requirements.md → config.json
2. Save to cache with timestamp
3. Return config

**Subsequent invocations (within 1 hour):**
1. Check if cache exists and not expired
2. Compare requirements.md mtime vs. cache timestamp
3. If valid → return cached config (instant)
4. If expired or requirements.md changed → re-extract

**Manual invalidation:**
```bash
rm .claude/cache/config.json
```

## Success Metrics

### Efficiency Metrics
- ⏱️ Extraction time: <30 seconds (target)
- ⏱️ Validation time: <5 seconds (target)
- ⏱️ Cache hit rate: >80% (within workflows)

### Quality Metrics
- 🎯 Error detection rate: 100% of format violations
- 🎯 False positive rate: <5% (minimal spurious warnings)
- 🎯 Config parsing consistency: 100% (same input → same output)

### Impact Metrics
- 📊 Commands using skill: 100% (eventually)
- 📊 Mid-workflow failures: -90% (catch errors early)
- 📊 Time saved per command: 2-3 minutes (no repeated parsing)

## Error Handling

### Graceful Degradation

If requirements.md is missing or severely malformed:
1. Return error report with specific issue
2. Provide example of correct format
3. Link to requirements-template.md
4. Do NOT proceed with partial/guessed config

### Partial Configurations

If optional sections missing:
1. Use sensible defaults where possible
2. Document what defaults were applied
3. Warn user that defaults are in use
4. Suggest adding explicit configuration

## Future Enhancements

### Phase 2 (Optional)
1. **Configuration Diffing:** Compare current vs. previous config to detect changes
2. **Multi-Project Support:** Cache configs for multiple projects
3. **Config Templates:** Provide industry-specific templates
4. **Visual Validation:** Generate HTML validation report with syntax highlighting
5. **Auto-Fix Suggestions:** Offer "Would you like me to fix this?" for common errors

---

## Usage in This Project

**When to invoke:**
- ✅ At start of every command (especially /content-calendar, /write-article)
- ✅ Before agent invocations that need config
- ✅ When skills need specific config sections
- ✅ After user updates requirements.md (validation)

**How to invoke:**
```
Please use the requirements-extractor skill to load and validate configuration.
```

**What you get:**
- Structured JSON with all configuration
- Validation report with any issues
- Cache for fast subsequent access
- Confidence that config is valid

**This skill is the foundation for all config-driven automation in this project.**
