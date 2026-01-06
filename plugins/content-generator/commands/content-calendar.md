---
name: content-calendar
description: Generate a monthly content calendar based on requirements.md configuration (cross‑industry)
argument-hint: [month year] (e.g., "October 2025")
---

# Generate Content Calendar (Cross‑Industry)

Create a comprehensive content calendar for **$ARGUMENTS** based on the editorial requirements from `requirements.md`.

**This command is cross‑industry** — it adapts to any brand, sector, cause, or program defined in `requirements.md` (e.g., consumer goods, finance, healthcare, education, nonprofit, SaaS, travel, arts & culture, public sector, etc.).

---

## Reference Date Context

When generating content for a specific month/year (e.g., "October 2021"), all temporal calculations must use the specified month/year as the **reference date** — NOT the current date.

### Reference Date Variables

Parse `$ARGUMENTS` to establish:

- `$TARGET_MONTH` — Month name (e.g., "October")
- `$TARGET_YEAR` — Year (e.g., "2021")
- `$REFERENCE_DATE` — First day of target month in ISO format (e.g., "2021-10-01")
- `$REFERENCE_END` — Last day of target month (e.g., "2021-10-31")

All temporal calculations use these variables:
- "Within 3 months" = 3 months relative to `$REFERENCE_DATE`
- "Last 6 months" = 6 months before `$REFERENCE_DATE`
- "Months ago" = calculated from `$REFERENCE_DATE`

### Historical Mode

**If `$REFERENCE_DATE` is in the past (compared to today's actual date):**

Set `$HISTORICAL_MODE = true` and apply these **CRITICAL RULES**:

1. **No Future Knowledge**: Do NOT include topics about events, releases, updates, or facts that occurred after `$REFERENCE_DATE`
2. **Search Filtering**: Use date-filtered searches (e.g., `before:2021-10-31` for Oct 2021)
3. **Language**: Write as if `$REFERENCE_DATE` is "today" — use present tense for events at that time
4. **Version Numbers**: Reference only versions released before `$REFERENCE_DATE`
5. **Trends**: Only discuss trends that were observable by `$REFERENCE_DATE`

**Example:**
- Target: October 2021
- ✅ DO include: React 17 features (released Oct 2020)
- ❌ DO NOT include: React 18 features (released March 2022)

**If `$REFERENCE_DATE` is today or in the future:**
- Set `$HISTORICAL_MODE = false`
- Proceed with standard mode (current date calculations)

---

## Step 1: Load and Validate Configuration

**Use the `requirements-extractor` skill** to load validated configuration:

```
Please use the requirements-extractor skill to load and validate configuration.
```

**Skill will provide:**
- Structured JSON with all configuration sections
- Validation report (any errors or warnings)
- Confirmation that config is complete and valid

**If validation errors found:**
- Report errors to user
- DO NOT proceed until requirements.md is fixed
- Provide specific guidance on what needs correction

**If validation successful:**
- Configuration now available in structured format
- Use `config.project.*`, `config.content.*`, `config.competitive.*`, etc. for all subsequent steps
- Key config sections to reference:
  - **project**: industry, platform, focus_areas, official_docs
  - **audience**: primary_roles, skill_level, primary_segment
  - **brand**: name, colors, voice
  - **content**: objective, formats, mix, word_count_range, topic_pillars
  - **seo**: strategy, internal_linking, primary_cta, distribution_channels
  - **competitive**: opportunity_weights, min_opportunity_score, required_tier1_pct
  - **localization**: language, regions, spelling

**Time:** <30 seconds (vs. 1-2 minutes manual parsing)

---

## Step 1B: Verify Past Calendar Loading (MANDATORY)

**BLOCKING CHECKPOINT:** This step ensures deduplication will be performed correctly.

### Process

1. **Check for existing calendars:**
   ```bash
   ls -la project/Calendar/*/*/content-calendar.md
   ```

2. **Count calendars in 12-month lookback window:**
   - Calculate dates from target month back 12 months
   - Count calendars within window
   - Record calendar files found

3. **Validation Gate:**

   | Condition | Result |
   |-----------|--------|
   | **No past calendars exist** | Proceed with `dedup_required = false` (first calendar) |
   | **Past calendars exist** | Require theme index confirmation from @signal-researcher |
   | **Past calendars exist + NO theme index** | **BLOCK — do not proceed to Step 2** |

4. **If past calendars found, require this confirmation from @signal-researcher:**

   ```markdown
   ## Theme Index Loaded ✅

   **Calendars Analyzed:** [N]
   **Past Topics Indexed:** [N]
   **Lookback Window:** [start] to [end]

   **Core Theme Saturation (6-Month Window):**
   [List of saturated vs available core themes]

   **Index Status:** ✅ READY
   ```

   **If this confirmation is NOT present:** STOP and request theme index loading before proceeding.

5. **Record for later verification:**
   - `past_calendars_found`: [N]
   - `theme_index_confirmed`: true/false
   - `dedup_required`: true/false

**CRITICAL:** Calendar generation MUST NOT proceed to Step 2 without theme index confirmation (when past calendars exist).

---

## Step 1A: Load Performance Insights (Optional but Recommended)

**Use the `content-performance-analyzer` skill** to inform strategy with historical data:

```
Please use the content-performance-analyzer skill to analyze the 6 months preceding $REFERENCE_DATE and provide recommendations for [Month Year] calendar.

Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
```

**Note:** Analysis window is always relative to `$REFERENCE_DATE`, not the current date. For historical calendars, this means analyzing content performance as it existed at that time.

**Skill will provide:**
- High-performing topic/format patterns
- Content mix optimization recommendations
- Topic pillar prioritization
- Seasonal insights for target month
- Refresh opportunities for existing content

**If insights available:**
- Adjust focus area priorities based on performance data
- Consider format distribution recommendations
- Note high-ROI topic areas
- Factor in seasonal patterns

**If no insights available (new blog or insufficient data):**
- Proceed with configured strategy from requirements.md
- Note: "First calendar - no historical performance data yet"

**Time:** 2-3 minutes (provides strategic intelligence)
**Skip if:** Fewer than 10 published articles, or time-constrained

Use insights to inform topic selection and content mix in subsequent steps.

---

## Step 2: Generate Topic Candidates (Automated)

**Delegate to the `@signal-researcher` agent** for domain-aware signal discovery and topic generation:

```
Agent: @signal-researcher
Input: Target month/year from $ARGUMENTS
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
```

**IMPORTANT for Historical Mode (`$HISTORICAL_MODE = true`):**
- Pass `$REFERENCE_DATE` to agent so all temporal calculations use it
- Agent MUST use date-filtered web searches (`before:$REFERENCE_END`)
- Agent MUST reject any signals about events after `$REFERENCE_DATE`

**Agent will:**
1. Load configuration (via requirements-extractor skill)
2. Select appropriate signal types for configured industry
3. Execute parallel web searches for current signals
4. Synthesize topic candidates from all viable signals (no arbitrary limit)
5. Perform preliminary quality screening:
   - Feasibility assessment (resources, SME needs, word count fit)
   - Relevance scoring (focus areas, audience, content mix)
   - Novelty check (internal duplicates, external saturation)
   - Risk flagging (compliance, legal, time-sensitive)
6. Generate structured `topic-candidates.md` document

**Agent Output:**
- File: `project/Calendar/{Year}/{Month}/topic-candidates.md`
- Contains: All viable topic candidates with:
  - Provisional Article IDs (ART-YYYYMM-001 onwards, sequential)
  - Signal sources and dates
  - Strategic rationale (why now, why us)
  - Preliminary scores (feasibility, relevance, novelty)
  - Recommended priority for gap analysis

**Time:** Scales with signal availability (typically 10-20 minutes)
**Benefits:**
- Systematic signal discovery across all industries
- Consistent quality screening
- Clear documentation of rationale
- Better topic candidates → higher average opportunity scores
- No artificial caps on opportunity identification

**What You'll Receive:**

Summary format:
```
Signal Research Complete ✅

Topics Generated: [N] candidates ([X] INCLUDE + [Y] CONSIDER)
Average Relevance: 4.5/5.0 stars
Novelty Rate: 83% ([X]/[N] truly novel)
High Feasibility: 83% ([X]/[N])
Predicted Tier 1: 58-75% ([X]-[Y] topics)

Top 3 Candidates:
1. ART-YYYYMM-001 - [Title] (5.0 relevance, recency advantage)
2. ART-YYYYMM-002 - [Title] (4.7 relevance, depth opportunity)
3. ART-YYYYMM-003 - [Title] (4.5 relevance, integration focus)

Flags:
- ⚠️ [X] high-risk topic(s) (legal review required)
- ⚠️ [Y] topics recommended for SME review

Output Saved: project/Calendar/{Year}/{Month}/topic-candidates.md

Ready for: Competitive Gap Pre-Analysis (batch mode)
```

Proceed to Step 2A with all generated topic candidates.

---

## Step 2A: Keyword Pre-Validation (Batch Mode - MANDATORY)

**Objective:** Validate keyword viability for all topic candidates before committing to gap analysis.

### Why Keyword Validation?

- **SEO Viability**: Ensure topics have actual search demand before investing in gap analysis
- **Difficulty Assessment**: Identify highly competitive keywords early
- **Intent Alignment**: Verify search intent matches planned content format
- **Resource Optimization**: Focus gap analysis on keyword-viable topics

### Process

**Invoke the `keyword-researcher` skill in BATCH MODE:**

```
Please use the keyword-researcher skill in batch mode to validate keywords for all topic candidates from topic-candidates.md.
```

**Skill will:**
1. **Keyword Extraction**: Extract primary keywords from all topic candidates
2. **Parallel SERP Analysis**: Execute web searches for all keywords simultaneously
3. **Volume Estimation**: Estimate search volume via proxy signals (ads, features, PAA)
4. **Difficulty Scoring**: Calculate difficulty (1-100) based on competitor analysis
5. **Intent Classification**: Classify search intent (informational, commercial, transactional, navigational)
6. **Output Generation**: Save individual summaries + batch results

**Skill Output:**

Individual keyword assessment files:
```
project/Calendar/{Year}/{Month}/keyword-pre-validation/
├── ART-YYYYMM-001-keyword.md
├── ART-YYYYMM-002-keyword.md
├── ...
└── ART-YYYYMM-[N]-keyword.md
```

Batch results JSON (structured data):
```
project/Calendar/{Year}/{Month}/keyword-pre-validation/batch-results.json
```

**Summary Format (per topic):**
```markdown
## [Topic/Keyword]
**Article ID:** ART-YYYYMM-NNN
**Keyword Score:** X.X/5.0
**Recommendation:** INCLUDE / CONSIDER / EXCLUDE

| Metric | Value | Score |
|--------|-------|-------|
| Search Volume | HIGH/MED/LOW | X/5 |
| Difficulty | XX/100 ([tier]) | X/5 |
| Intent | [type] | [clear/mixed] |
| Format Fit | [format] | X/5 |

### SERP Snapshot (Top 5)
| Rank | Domain | Type | Authority |
|------|--------|------|-----------|
[Top 5 competitors]

### Viability Summary
- **Strengths**: [Key advantages]
- **Challenges**: [Key challenges]
- **Verdict**: [1-2 sentence recommendation]
```

**Time:** 10-15 minutes for 12 topics (40% faster via parallelization)

**What You'll Receive:**

```
Keyword Pre-Validation Complete ✅

Topics Analyzed: [N]
Time: [X] minutes

Keyword Viability Distribution:
- INCLUDE: [X] topics ([Y]%) — Score ≥4.0
- CONSIDER: [X] topics ([Y]%) — Score 2.5-3.9
- ⚠️ FLAGGED: [X] topics ([Y]%) — Score <2.5 or Difficulty >70

Average Keyword Score: [X.X]/5.0
Average Difficulty: [XX]/100

Intent Distribution:
- Informational: [X] topics
- Commercial: [X] topics
- Other: [X] topics

Output Saved:
- Individual assessments: keyword-pre-validation/ART-*.md
- Batch results: keyword-pre-validation/batch-results.json

Ready for: Competitive Gap Pre-Analysis (Step 2B)
```

### Decision Point

- **⚠️ FLAG** topics with keyword score <2.5 for user review (keep in candidate list with warning)
- **⚠️ FLAG** topics with difficulty >70 for strategic review
- **PRIORITIZE** topics with high volume + moderate difficulty for gap analysis
- **VERIFY** search intent matches planned content format (flag mismatches)

**Note:** This step is MANDATORY. All topic candidates must pass keyword validation before gap analysis.

Proceed to Step 2B (Competitive Gap Pre-Analysis) with keyword-validated topics.

---

## Step 2B: Competitive Gap Pre-Analysis (Batch Mode - High Performance)

**Objective:** Analyze all topic candidates in parallel to assess differentiation opportunity and prioritize topics strategically.

### Why Batch Mode?

- **Speed**: 40% faster than sequential analysis
- **Consistency**: All topics analyzed with same competitor baseline
- **Intelligence**: Shared competitor data, intelligent caching
- **Efficiency**: Parallel searches, reduced API calls
- **Scalability**: Handles any number of topic candidates efficiently

### Process

**Invoke the `competitive-gap-analyzer` skill in BATCH MODE:**

```
Please use the competitive-gap-analyzer skill in batch mode to analyze all topic candidates from topic-candidates.md.
```

**Skill will:**
1. **Keyword Clustering**: Group similar topics, identify overlapping competitors
2. **Parallel Discovery**: Execute all web searches simultaneously, cache results
3. **Parallel Analysis**: Analyze competitor content in batches, build shared database
4. **Gap Scoring**: Calculate opportunity scores for all topics, reuse cached data
5. **Output Generation**: Save individual summaries + batch results

**Skill Output:**

Individual summary files for each topic candidate:
```
project/Calendar/{Year}/{Month}/gap-pre-analysis/
├── ART-YYYYMM-001-summary.md
├── ART-YYYYMM-002-summary.md
├── ...
└── ART-YYYYMM-[N]-summary.md
```

Batch results JSON (structured data):
```
project/Calendar/{Year}/{Month}/gap-pre-analysis/batch-results.json
```

**Summary Format (per topic):**
```markdown
## [Topic/Keyword]
**Article ID:** ART-YYYYMM-NNN
**Opportunity Score:** ⭐⭐⭐⭐ (4.2/5.0)
**Tier:** Tier 1 (High Opportunity)

### Gap Breakdown
- Coverage Gap: ⭐⭐⭐⭐⭐ (5/5) - 3 critical coverage gaps identified
- Depth Gap: ⭐⭐⭐⭐ (4/5) - Most competitors superficial
- Format Gap: ⭐⭐⭐ (3/5) - Some format opportunities
- Recency Gap: ⭐⭐⭐⭐⭐ (5/5) - Recent update not covered

### Primary Differentiation Angle
"First guide to cover [new feature X] with working code examples and field-mapping templates"

### Top 3 Opportunities
1. **Coverage (CRITICAL)**: 0/8 competitors cover [specific subtopic]
2. **Recency (CRITICAL)**: New version released 2 weeks ago, 0/8 updated
3. **Depth (HIGH-VALUE)**: 7/8 competitors theory-only, no code examples

### Competitive Landscape
- 8 competitors analyzed
- Average word count: 2,400
- Average publish date: 4 months ago
- Saturation level: Moderate (room for superior content)

### Feasibility: HIGH
- Official docs available ✅
- SME recommended (not required) ⚠️
- Fits word count range ✅
- Aligns with focus areas ✅
```

**Time:** Scales with number of topics (typically 15-30 minutes)
**Efficiency:** 40-45% faster than sequential analysis

**What You'll Receive:**

```
Batch Gap Analysis Complete ✅

Topics Analyzed: [N]
Time: [X] minutes (40% faster than sequential)

Opportunity Distribution:
- Tier 1 (High): [X] topics ([Y]%) ⭐⭐⭐⭐⭐
- Tier 2 (Moderate): [X] topics ([Y]%) ⭐⭐⭐⭐
- Tier 3 (Low): [X] topics ([Y]%) ⭐⭐⭐
- Tier 4 (Saturated): [X] topics ❌

Average Opportunity Score: [X.X]/5.0
Tier 1 Percentage: [Y]% (target: ≥60%)

Recommendation: Select topics meeting tier and quality thresholds for calendar.

Output Saved:
- Individual summaries: gap-pre-analysis/ART-*.md
- Batch results: gap-pre-analysis/batch-results.json
- Competitor cache: .claude/skills/competitive-gap-analyzer/cache/

Ready for: Topic Selection & SME Assessment
```

---

## Step 2C: Deduplication Report Verification (MANDATORY)

**BLOCKING CHECKPOINT:** This step verifies that deduplication was performed before topic selection.

### Required Artifact

When `dedup_required = true` (past calendars exist), the @signal-researcher agent MUST have saved:

```
project/Calendar/{Year}/{Month}/deduplication-report.md
```

### Verification Process

1. **Check for deduplication report:**
   ```bash
   ls -la project/Calendar/{Year}/{Month}/deduplication-report.md
   ```

2. **Verify report contains required sections:**
   - [ ] Executive Summary with statistics
   - [ ] Comparison Matrix (ALL candidates listed)
   - [ ] HARD BLOCKED Topics section (if any)
   - [ ] BLOCKED Topics section (if any)
   - [ ] Core Theme Saturation Analysis
   - [ ] Validation Signature with checkboxes

3. **Validation Gate:**

   | Condition | Result |
   |-----------|--------|
   | `dedup_required = false` (first calendar) | Proceed (no report needed) |
   | Report exists with all required sections | Proceed to topic selection |
   | Report missing | **BLOCK — request @signal-researcher to regenerate** |
   | Report incomplete | **BLOCK — request @signal-researcher to complete** |

4. **Extract key metrics for calendar header:**
   - `past_calendars_analyzed`: [N]
   - `past_topics_indexed`: [N]
   - `candidates_before_dedup`: [N]
   - `blocked_by_dedup`: [N]
   - `passed_topics`: [N]

5. **Verify no blocked topics in final selection:**
   - Cross-check selected topics against "HARD BLOCKED" and "BLOCKED" lists
   - If any blocked topic is in selection → **REJECT and request correction**

**CRITICAL:** Calendar generation MUST NOT proceed to Step 3 without verified deduplication report (when past calendars exist).

---

### Topic Selection Strategy

**Select all topics meeting quality thresholds for final calendar using batch results:**

1. **Tier Balance (ENFORCED):**
   - Minimum 60% Tier 1 topics (use `config.competitive.required_tier1_pct`)
   - No maximum total number of topics
   - Include all Tier 1 and Tier 2 topics by default
   - Include Tier 3 IF strategic value (explicit rationale required)
   - Exclude all Tier 4 topics (note in exclusions)

2. **Content Mix Compliance:**
   - Maintain `config.content.mix` percentages across final selection
   - Within each format, prioritize higher-opportunity topics
   - Scale total volume based on available high-quality opportunities

3. **Feasibility Filter:**
   - Only include Medium or High feasibility
   - Low feasibility requires user approval

4. **Diversity Check:**
   - Variety across `config.content.topic_pillars`
   - Avoid 3+ consecutive similar topics
   - Balance quick wins (recency) with evergreen (depth)

**Document Selection Rationale:**
- Opportunity tier and score
- Primary gap type + competitive advantage
- Why it beats other candidates in format category

**Document Exclusions:**
- Why excluded (saturation, feasibility, mix balance)
- Alternative angle suggestions

---

## Step 3: Generate the Content Calendar

Create a table for **$ARGUMENTS** with the structure below. **Enhanced with keyword research and competitive gap analysis columns.**

Include all selected topics (no limit on number of rows).

| ID | Week | Publish Date | Topic / Working Title | Format | Channel | Audience Segment | Funnel Stage | Keyword / Search Intent | **KW Score** | **Volume** | **Difficulty** | **Opp. Score** | **Primary Gap** | **Differentiation Angle** | **Media Opp** | Word Count | Goal / KPI | Primary CTA | Source Type | SME? | Priority |
| -- | ---- | ------------ | --------------------- | ------ | ------- | ---------------- | ------------ | ----------------------- | ------------ | ---------- | -------------- | -------------- | --------------- | ------------------------- | ------------- | ---------- | ---------- | ----------- | ----------- | ---- | -------- |

**Column Descriptions:**

**Keyword Research Columns (from Step 2A):**
- **KW Score**: X.X/5.0 — Overall keyword viability score from keyword-researcher skill
- **Volume**: HIGH/MED/LOW — Estimated search volume based on SERP signals
- **Difficulty**: XX/100 — Keyword difficulty score (1-30 Easy, 31-60 Moderate, 61-80 Difficult, 81-100 Very Difficult)

**Competitive Gap Columns (from Step 2B):**
- **Opp. Score**: ⭐⭐⭐⭐⭐ (1-5 stars) — Overall competitive opportunity score from gap pre-analysis
- **Primary Gap**: Coverage/Depth/Format/Recency — Primary type of competitive advantage identified
- **Differentiation Angle**: One sentence describing how this article will demonstrably exceed competitors
- **Media Opp**: High/Moderate/Low — Opportunity for media embeds (videos, social posts, examples)
  - **High**: Tutorials/how-tos (demo videos), expert analysis (social posts), case studies (visual examples)
  - **Moderate**: Product reviews (official announcements), comparisons (visual demonstrations)
  - **Low**: News/announcements (time-sensitive), text-only analysis (no visual value)
- **Priority**: Tier 1 (🟢 high-opp), Tier 2 (🟡 moderate-opp), Tier 3 (🟠 strategic) — Strategic importance

### ID Generation Rules

* **Format**: `ART-YYYYMM-NNN` (e.g., `ART-202510-001`)
* Parse month and year from `$ARGUMENTS`
* Generate sequential IDs starting from **001** (pad with leading zeros)

### Requirements for Each Topic (Enforced)

1. **Originality**: Distinct angle; confirm low saturation and cite primary sources.
2. **Timeliness**: Anchor to signals within 3 months of `$REFERENCE_DATE`. For historical dates (`$HISTORICAL_MODE = true`), only include signals that existed before `$REFERENCE_DATE`.
3. **Relevance**: Align with **Industry/Brand**, **Themes**, **Audience**, **Locale**, and **Channels** from config.
4. **Audience Fit**: Match the specified **persona** and **funnel stage**; state the expected reader outcome.
5. **Search & Discovery**: Include a primary keyword (if SEO channel) and define search intent.
6. **Compliance & Ethics**: Respect regulatory constraints (e.g., financial/medical claims), brand claims policy, accessibility and inclusivity guidelines; add required **disclaimers**.
7. **Length & Packaging**: Set length by format (e.g., blog 800–1,800 words; report 1,500–3,000; social short‑form 15–60s; video 3–8 min; podcast 20–40 min). Provide channel‑specific caption or thumbnail hook where applicable.
8. **Distribution & Repurposing**: Suggest at least **2 spin‑offs** (e.g., thread, reel, carousel, email snippet) and **1 collaboration** idea (partner, creator, association) when relevant.

### Content Mix (Flexible Volume)

Use **Content Mix** percentages from `requirements.md` (e.g., Tutorials/How‑tos, Explainers, Case Studies, Data/Trends, Opinion/POV, News/Announcements, Community/Stories). Scale percentages to the total number of selected topics.

---

## Step 4: Validation Checklist (Per Topic)

* **Duplication Check**: Search to confirm novelty; specify the unique angle.
* **Recency Check**: Link to the trigger (policy change, event, report, launch) and date.
* **Compliance Check**: Note any required legal/ethical disclaimers. Avoid individualized advice.
* **Feasibility Check**: Confirm access to data, spokespeople, or assets needed.
* **Measurement Plan**: Identify 1–2 leading indicators (e.g., CTR, save rate) and a primary KPI.

---

## Step 5: SME Requirements Assessment (Automated)

**Use the `sme-complexity-assessor` skill** for systematic SME requirement determination:

```
Please use the sme-complexity-assessor skill to assess all selected topics from the calendar.
```

**Skill will assess each topic across 4 dimensions:**
1. **Technical Depth** (1-5★): Code complexity, advanced concepts, edge cases
2. **Domain Specificity** (1-5★): Specialized knowledge requirements
3. **Risk Level** (1-5★): Misinformation potential, security, compliance
4. **Verification Needs** (1-5★): Hands-on testing, production validation

**Skill Output:**

Individual SME assessments per topic:
- **Composite Complexity Score** (1-5): Weighted average of 4 dimensions
- **SME Requirement Level**:
  - ✅ **No SME** (score <2.5, no dimension ≥4): Standard editorial review
  - ⚠️ **SME Recommended** (score 2.5-3.9, any dimension =4): Beneficial but not critical
  - 🚨 **SME Required** (score ≥4.0 OR risk ≥4): Critical for quality/safety
- **SME Profile**: Specific expertise needed (not vague "expert")
  - Example: "Senior [Platform] Developer (5+ years)" NOT "SME needed"
- **Review Scope**: Which sections need validation (not "entire article")
- **Estimated Time**: 30 min, 1 hour, 2-3 hours
- **Risk Flags**: Security, legal/compliance, benchmarks, medical advice

Batch summary table:
```markdown
## SME Requirements Summary

**Topics Assessed:** [N]
**Breakdown:**
- ✅ No SME: [X] topics ([Y]%)
- ⚠️ SME Recommended: [X] topics ([Y]%)
- 🚨 SME Required: [X] topics ([Y]%)

### SME Required
| ID | Title | Score | Risk | SME Profile | Time |
|----|-------|-------|------|-------------|------|
[List all SME Required topics]

### SME Recommended
| ID | Title | Score | Driver | SME Profile | Time |
|----|-------|-------|--------|-------------|------|
[List all SME Recommended topics]

**Total SME Time:** [X-Y] hours
**SME Profiles Needed:**
[List unique SME profiles needed]

**Recommendation:** Engage SMEs during planning to confirm availability.
```

**Add to Calendar:**
- Column: "SME Requirements" → None | Recommended (profile) | Required (profile)
- Column: "Est. Review Time" → 30m, 1h, 2h, etc.
- Notes: Total SME hours and profiles needed

**Time:** 1-2 minutes (systematic assessment)
**Benefits:**
- Objective complexity scoring (not gut feel)
- Specific SME profiles (better resource planning)
- Scoped reviews (section-level, not full article)
- Consistent flagging criteria across all calendars

---

## Step 6: Save to Calendar Directory

1. Parse the month and year from `$ARGUMENTS`
2. Create the directory structure: `project/Calendar/{Year}/{Month}/`
3. Save the complete calendar as: `project/Calendar/{Year}/{Month}/content-calendar.md`
4. Confirm the file has been saved successfully

---

## Output Format

1. **Calendar Table** (as above with keyword research and gap analysis columns)

2. **Keyword Validation Summary** (REQUIRED section — must appear in every calendar)

   Include this section at the top of the calendar, after the header:

   ```markdown
   ---

   ## Keyword Validation Summary

   This calendar was generated with mandatory keyword pre-validation.

   | Metric | Value |
   |--------|-------|
   | **Topics Validated** | [N] |
   | **INCLUDE (Score ≥4.0)** | [N] ([X]%) |
   | **CONSIDER (Score 2.5-3.9)** | [N] ([X]%) |
   | **⚠️ FLAGGED (Score <2.5 or Difficulty >70)** | [N] ([X]%) |
   | **Average Keyword Score** | [X.X]/5.0 |
   | **Average Difficulty** | [XX]/100 |

   **Intent Distribution:**
   - Informational: [N] topics
   - Commercial: [N] topics
   - Other: [N] topics

   **Flagged Topics:** [List any flagged topics with reasons]

   **Keyword Pre-Validation Report:** See `keyword-pre-validation/batch-results.json` for full data.

   ---
   ```

3. **Deduplication Verification** (REQUIRED section — must appear in every calendar)

   Include this section at the top of the calendar, after the header:

   ```markdown
   ---

   ## Deduplication Verification

   This calendar was generated with mandatory deduplication checks.

   | Metric | Value |
   |--------|-------|
   | **Past Calendars Analyzed** | [N] |
   | **Past Topics Indexed** | [N] |
   | **Candidates Before Dedup** | [N] |
   | **HARD BLOCKED (Core Theme)** | [N] |
   | **BLOCKED (Similarity)** | [N] |
   | **Final Topic Count** | [N] |

   **Theme Spacing Compliance:**
   - ✅ No core themes repeated within 6 months
   - ✅ All similar themes (0.40+) have sufficient differentiation
   - ✅ No near-duplicates (0.80+) in final calendar

   **Deduplication Report:** See `deduplication-report.md` for full comparison matrix.

   ---
   ```

   **Note:** If this is the first calendar (no past calendars exist), display:
   ```markdown
   ## Deduplication Verification

   **Status:** First calendar for this project — no deduplication required.

   ---
   ```

4. **Competitive Gap Analysis Summary** (required section below table)

   Include this section immediately after the calendar table:

   ```markdown
   ---

   ## Competitive Gap Analysis Summary

   ### High-Opportunity Topics (Tier 1) 🟢

   **ART-YYYYMM-NNN: [Topic Title]** ⭐⭐⭐⭐⭐ (4.8/5)
   - **Primary Gap**: Recency (critical) / Coverage (critical) / Depth (high-value) / Format (moderate)
   - **Differentiation Angle**: "First guide covering [new feature] with [unique element]"
   - **Key Opportunities**:
     - 0/10 competitors cover [specific feature/subtopic] (coverage gap)
     - 8/10 competitors outdated (version X vs current version Y) (recency gap)
     - 9/10 lack [code examples/diagrams/templates] (depth/format gap)
   - **Why We'll Win**: [First-mover advantage / Comprehensive depth / Unique format]
   - **Pre-Analysis Reference**: `gap-pre-analysis/ART-YYYYMM-NNN-summary.md`

   [Repeat for all Tier 1 topics]

   ### Moderate-Opportunity Topics (Tier 2) 🟡

   **ART-YYYYMM-NNN: [Topic Title]** ⭐⭐⭐⭐ (3.7/5)
   [Same format as Tier 1]

   ### Strategic Topics (Tier 3) 🟠

   **ART-YYYYMM-NNN: [Topic Title]** ⭐⭐⭐ (2.8/5)
   - **Why Included Despite Lower Score**: [Brand alignment / Product launch tie-in / Audience request / Pillar completion]
   - [Rest of format as above]

   ### Topics Excluded from Calendar

   **[Topic Title]** — ⭐ (1.8/5) — **Reason**: Oversaturated (10/10 high-quality competitors published <30 days)
   **[Topic Title]** — ⭐⭐ (2.3/5) — **Reason**: Low feasibility (requires lab testing, SME unavailable)
   **[Topic Title]** — ⭐⭐ (2.5/5) — **Reason**: Content mix balance (already 70% tutorials, need more analysis)

   **Alternative Angles to Consider**:
   - [Excluded Topic 1]: Try narrower focus on [specific use case/audience]
   - [Excluded Topic 2]: Wait for [upcoming release/event] then revisit with recency angle
   ```

5. **Below the gap analysis summary, include for each item:**

   * **Rationale** (originality & timeliness; what trigger you're tying to)
   * **SME requirement** (if any) and proposed reviewer profile
   * **CTA placement** (aligning with `PRIMARY_CTA` from config)
   * **Distribution & Repurposing ideas** (by channel)
   * **Measurement plan** (KPI + leading indicator)

> **Note:** For sensitive categories (health, finance, legal, safety), include a short disclaimer and avoid personalized advice. Respect accessibility standards (headings, alt text, color contrast), and ensure inclusivity in examples and imagery.

---

### Quick Start Example

**Invocation:** `/content-calendar [Month Year]`

**Fully Automated Enhanced Workflow:**

1. **Step 1: Load & Validate Config** (<30 sec)
   - Invoke `requirements-extractor` skill
   - Validate requirements.md completeness
   - Load structured configuration

2. **Step 1A: Performance Insights (Optional)** (2-3 min)
   - Invoke `content-performance-analyzer` skill
   - Analyze last 6 months performance data
   - Get content mix and topic recommendations

3. **Step 2: Generate Topic Candidates** (10-20 min)
   - Invoke `@signal-researcher` agent
   - Domain-aware signal discovery
   - Generate all viable quality-screened topics (no limit)
   - Save to `topic-candidates.md`

4. **Step 2A: Keyword Pre-Validation (MANDATORY)** (10-15 min)
   - Invoke `keyword-researcher` skill (batch mode)
   - Parallel SERP analysis for all keywords
   - Calculate keyword scores, volume estimates, difficulty
   - Flag low-viability topics for review
   - Save to `keyword-pre-validation/`

5. **Step 2B: Batch Gap Analysis** (15-30 min)
   - Invoke `competitive-gap-analyzer` skill (batch mode)
   - Parallel analysis of keyword-validated topics
   - Calculate opportunity scores (Tier 1-4)
   - Save individual summaries + batch results

6. **Step 3: Generate Calendar Table** (2-5 min)
   - Select all topics meeting quality thresholds (min 60% Tier 1)
   - Generate calendar with keyword + gap analysis columns (flexible volume)
   - Include Competitive Gap Analysis Summary

7. **Step 4: Validation** (1-3 min)
   - Verify originality, recency, compliance
   - Check feasibility and measurement plans

8. **Step 5: SME Assessment** (1-3 min)
   - Invoke `sme-complexity-assessor` skill
   - Systematic complexity scoring
   - Generate SME requirements summary
   - Add SME columns to calendar

9. **Step 6: Save Calendar** (<30 sec)
   - Save to `project/Calendar/[YEAR]/[MONTH]/content-calendar.md`
   - Confirm successful save

**Time Estimate:**
- **Original workflow**: 15-20 minutes (manual, fixed 8-12 topics)
- **Previous enhanced workflow**: 40-50 minutes (manual + sequential gap analysis, fixed 12 topics)
- **New fully automated workflow**: 40-75 minutes (includes keyword validation + scales with opportunity volume)

**Time Scaling:** Scales with number of viable opportunities, not artificially capped

**Quality Improvements:**
- **SEO Intelligence**: Keyword validation ensures search demand before gap analysis
- **Strategic Intelligence**: Performance-driven topic selection
- **Domain Expertise**: @signal-researcher adapts to any industry
- **Competitive Intelligence**: Batch gap analysis with caching
- **Systematic Quality**: Objective SME assessment
- **Efficiency**: 40% faster analysis via parallelization
- **Scalability**: Handles any volume of opportunities (no artificial caps)

**Value Add:**
- ✅ Validate keyword viability BEFORE investing in gap analysis
- ✅ Choose topics where you'll demonstrably win (not just trending)
- ✅ Data-driven content mix optimization (learn from what works)
- ✅ Risk mitigation (avoid low-search-volume and oversaturated topics upfront)
- ✅ Clear differentiation strategy before writing begins
- ✅ Objective SME requirements (better resource planning)
- ✅ Consistent quality across all industries/topics
- ✅ Flexible volume scales with market opportunities (not arbitrary limits)

**Expected Outcomes:**
- 20% higher average opportunity scores (keyword + gap screening)
- 70%+ Tier 1 topics (vs. 60% minimum)
- Faster time-to-rank (keyword-informed differentiation)
- Better resource planning (systematic SME assessment)
- Maximized opportunity capture (no high-quality topics left on table)
