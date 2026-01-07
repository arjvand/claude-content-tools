---
name: write-article
description: Generate a complete article from the content calendar with research, writing, SEO, compliance, accessibility, and multi‑channel packaging (cross‑industry)
argument-hint: [calendar-path] [article-id] (e.g., "project/Calendar/2025/October/content-calendar.md ART-202510-001")
---

# Write Article from Calendar (Cross‑Industry)

Generate a publication‑ready article for **any industry or cause** based on a calendar entry, with built‑in research, compliance, accessibility, and packaging for your channels/CMS.

## Usage

```bash
/write-article project/Calendar/2025/October/content-calendar.md ART-202510-001
```

* First argument: Path to content calendar
* Second argument: Article ID (e.g., ART-202510-001)

---

## Phase 0: Load Project Configuration

Read the configuration to adapt tone, claims, and outputs:

```bash
!cat project/requirements.md
```

**Extract and store these values (use all that exist, fall back gracefully):**

* **Domain / Industry or Issue Area** (e.g., healthcare, fintech, education, nonprofit, public sector, retail, travel)
* **Brand / Program / Product** and positioning (USP, messaging pillars)
* **Audience segments & reading level** (personas, roles, demographics)
* **Objectives & KPIs** (traffic, sign‑ups, donations, RSVPs, sales, retention)
* **Regions / Locales & Language** (spelling variants, cultural notes)
* **Voice & Tone** (style guide, examples)
* **Compliance & Disclaimers** (e.g., HIPAA/GDPR/FINRA/ASA/ICO; claims policy; consent & privacy notes)
* **Accessibility requirements** (alt text policy, color contrast, captions, reading level)
* **Approved formats & channel mix** (blog, newsletter, LinkedIn, X, Instagram, TikTok, YouTube, podcast, PR)
* **Trusted sources**

  * Primary: brand newsroom/docs, regulators/gov, standards bodies, journals, industry associations
  * Secondary: reputable newsrooms, analysts, market research, NGOs
* **CMS platform & export preferences** (WordPress Gutenberg/HTML/Markdown; internal linking rules)
* **Media style guide** (brand colors, imagery constraints, iconography)

---

## Phase 0.3: Establish Reference Date

**Extract reference date from calendar entry to enable Historical Mode when appropriate.**

1. Parse `publish_date` from calendar entry
2. Store as `$REFERENCE_DATE` (format: YYYY-MM-DD)
3. Compare to today's actual date:

```
IF $REFERENCE_DATE < TODAY:
  $HISTORICAL_MODE = true
ELSE:
  $HISTORICAL_MODE = false
```

**Historical Mode Rules for Article Production:**

When `$HISTORICAL_MODE = true`:

1. **Research Sources**: Only use sources published before `$REFERENCE_DATE`
2. **Web Searches**: Use date-filtered searches (`before:$REFERENCE_DATE`)
3. **Content Perspective**: Write as if `$REFERENCE_DATE` is "today"
4. **No Future Knowledge**: Do NOT reference events, releases, or data after `$REFERENCE_DATE`
5. **Version Numbers**: Only reference versions that existed at `$REFERENCE_DATE`
6. **Language**: Use present tense for events current at `$REFERENCE_DATE`

**Example:**
```
Calendar Entry: ART-202110-001
Publish Date: 2021-10-15
$REFERENCE_DATE = 2021-10-15
$HISTORICAL_MODE = true (if today > 2021-10-15)

✅ Valid: "React 17 introduced new JSX transform..."
❌ Invalid: "React 18 (released 2022) added concurrent features..."
```

---

## Phase 0.5: Create Article Directory

**Before proceeding, create the article directory structure:**

```bash
mkdir -p "project/Articles/[ARTICLE-ID]"
```

**Directory Structure:**
- All article files will be saved to: `project/Articles/[ARTICLE-ID]/`
- This includes: `research-brief.md`, `draft.md`, `article.md`, `article.html`, `meta.yml`, etc.

**Example:**
```bash
mkdir -p "project/Articles/ART-202510-001"
```

**Verification:**
```bash
ls -la "project/Articles/[ARTICLE-ID]/"
```

---

## Phase 1: Load Calendar Entry

1. Read the specified calendar file:

```bash
!cat $1
```

2. Extract details for **Article ID: `$2`**

   * Working title / Topic
   * **Format** (explainer, how‑to, case study, interview, data/trends, opinion/POV, news/announcement, buyer’s guide, comparison, FAQ/myth‑buster, impact story, event recap)
   * Target keyword & search intent (if applicable)
   * Audience segment & **funnel stage** (Awareness/Consideration/Decision/Retention)
   * Channel(s) & locale/region
   * Word count (or time length)
   * Publish date & **primary CTA**
   * Source type (official/secondary) & **SME required?**
3. Display the extracted info for confirmation (non‑blocking).

---

## Phase 2: Research (Parallel Execution)

**Execute BOTH research agents IN PARALLEL** for faster, more comprehensive research from different angles.

### Agent 1: Primary Research (@researcher)

**@researcher — Focus on authoritative sources and evidence:**

* Confirm topical **timeliness** relative to `$REFERENCE_DATE` (signals within 3 months before reference date)
* **Historical Mode**: Only use sources published before `$REFERENCE_DATE`; use date-filtered searches (`before:$REFERENCE_DATE`)
* Gather **primary sources** first (official docs, standards bodies, journals, regulatory sources)
* Extract and **verify evidence** — record dates, versions, jurisdictions (all must predate `$REFERENCE_DATE` in Historical Mode)
* Grade evidence strength (High/Moderate/Low) with source attribution
* Note **policy/regulatory** implications and any **claim restrictions** (as they existed at `$REFERENCE_DATE`)
* Flag **SME involvement** if topic is regulated or high‑stakes (health, finance, legal, safety)
* List potential **quotes/data points** with dates (verify all dates are before `$REFERENCE_DATE` in Historical Mode)

**Save to:** `project/Articles/[ARTICLE-ID]/research-primary.md`

---

### Agent 2: Landscape Research (@researcher)

**@researcher — Focus on competitive landscape and differentiation:**

* Invoke `competitive-gap-analyzer` skill for full gap analysis (pass `$REFERENCE_DATE` for Historical Mode)
* Invoke `media-discovery` skill to find embeddable media (videos, social posts published before `$REFERENCE_DATE` in Historical Mode)
* Identify **unique angles** vs. existing coverage (what competitors missed at `$REFERENCE_DATE`)
* Capture **platform/channel considerations** (SEO updates, social algorithm notes as of `$REFERENCE_DATE`)
* Map the **content landscape** — saturation, format gaps, recency opportunities (relative to `$REFERENCE_DATE`)
* Identify **practical examples** and community insights (from before `$REFERENCE_DATE` in Historical Mode)
* Develop **differentiation strategy** — why our article will win (based on landscape at `$REFERENCE_DATE`)

**Save to:** `project/Articles/[ARTICLE-ID]/research-landscape.md`

---

**⚠️ PARALLEL EXECUTION NOTE:**
Both agents MUST be launched in a SINGLE message with multiple tool calls.
Do NOT wait for Agent 1 to complete before launching Agent 2.

---

## Phase 2.3: Keyword Research (Full Mode)

**After parallel research agents complete, invoke keyword research:**

```
Please use the keyword-researcher skill to perform full keyword analysis for article [ARTICLE-ID].
Primary Keyword: "[primary keyword from calendar entry]"
```

**Skill will:**
1. Validate primary keyword from calendar entry
2. Estimate search volume and difficulty
3. Classify search intent
4. Generate long-tail keyword expansion (10-15)
5. Create semantic keyword clusters (3-5)
6. Produce placement recommendations

**Output:** `project/Articles/[ARTICLE-ID]/keyword-research.md`

**Time:** 6-10 minutes

---

## Phase 2.4: Article Keyword Strategy (RECOMMENDED)

**After keyword-researcher completes, create strategic keyword plan:**

```
Please use the keyword-strategist skill in article-level mode for [ARTICLE-ID].
Primary Keyword: "[primary keyword from calendar entry]"
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

**If keyword strategy generated, pass to research-brief.md:**

```markdown
## Keyword Strategy Summary

### Primary Keyword
- Keyword: "[primary keyword]"
- Placement: Title (H1), first 100 words, at least one H2

### Secondary Keywords
| Keyword | Placement | Section |
|---------|-----------|---------|
| "[secondary 1]" | H2 heading | [Section] |
| "[secondary 2]" | Body text | [Section] |

### SERP Feature Targeting
- Format for snippet: [target format]
- PAA questions to answer: [list questions]

### Internal Linking
- Link TO this article from: [existing articles]
- Link FROM this article to: [target articles]

### Funnel Alignment
- Stage: [Awareness | Consideration | Decision]
- CTA: [how CTA connects to funnel position]
```

**If skipped (time-constrained):**
- Proceed with keyword-research.md only
- @writer uses basic placement recommendations from keyword-researcher

---

## Phase 2.5: Research Synthesis

**After BOTH research agents complete**, merge their outputs:

1. **Read both files:**
   - `project/Articles/[ARTICLE-ID]/research-primary.md`
   - `project/Articles/[ARTICLE-ID]/research-landscape.md`

2. **Create unified research brief** combining:
   - Executive summary (synthesize both perspectives)
   - Key findings from primary research (evidence table, verified facts)
   - Competitive landscape from landscape research (gap analysis, differentiation)
   - Recommended media embeds from landscape research
   - Unique insights (merge both agent findings)
   - SME requirements (union of both agent flags)
   - Recommended article structure

3. **Resolve conflicts:**
   - If agents disagree on SME requirements → use more conservative (require SME)
   - If agents find conflicting facts → flag for verification, note both sources
   - If different differentiation angles → include top 2-3 angles

4. **Run quick fact-check:**
   - Invoke `fact-checker` skill in quick mode on merged brief
   - Save audit to `project/Articles/[ARTICLE-ID]/claim-audit-quick.md`

5. **Save unified brief to:** `project/Articles/[ARTICLE-ID]/research-brief.md`

**Files preserved for traceability:**
- `research-primary.md` — Primary source research
- `research-landscape.md` — Competitive/media research
- `research-brief.md` — Merged final brief (used by @writer)

---

## Phase 3: Create Outline

Pick a template based on format (edit as needed):

**Explainer / Guide**

```markdown
# [Clear, benefit‑led title with keyword]

## Introduction (120–180 words)
- Context, why now, what readers will gain

## Background / Definitions
- Plain‑English terms, cite primary sources

## Main Sections (3–5)
### Point 1: [Subtopic]
### Point 2: [Subtopic]
### Point 3: [Subtopic]

## Practical Takeaways
- 3–5 actionable steps aligned to persona & funnel stage

## Conclusion + CTA
```

**Case Study / Success Story (B2B/Nonprofit/Program)**

```markdown
# [Outcome‑focused title]

## Customer/Beneficiary Context
## Challenge
## Approach / Intervention
## Results (with metrics & timeframes)
## Lessons & Next Steps
## CTA (aligned to goal/KPI)
```

**Interview / Q&A**

```markdown
# [Compelling pull‑quote for title]

## Introduction
## Q1–Q6 (mix of strategy + practical)
## Key Takeaways
## CTA
```

**Data / Trends Summary**

```markdown
# [Trend with timeframe]

## Methodology (sources/date ranges)
## Trend 1 … Trend 3
## Implications by Persona/Funnel Stage
## CTA
```

**News / Announcement**

```markdown
# [Newsworthy headline]

## What’s new + Date
## Why it matters (for whom)
## Quotes (approved)
## How to act (CTA)
## Boilerplate (brand/program)
```

**Buyer’s Guide / Comparison**

```markdown
# [Task‑focused title]

## Who this is for
## Criteria (weighted)
## Options compared (table)
## Recommendations by use case/budget
## CTA
```

**Myth‑Buster / FAQ**

```markdown
# [Myth vs. Fact title]

## Top Myths (3–5) with citations
## How to evaluate claims
## CTA
```

**How‑to / Tutorial** (general, not dev‑only)

```markdown
# [Actionable title]

## Prerequisites (tools/materials/permissions)
## Step‑by‑step (5–7 steps)
## Troubleshooting / Safety / Compliance notes
## Conclusion + CTA
```

> Ensure headings are descriptive, scannable, and inclusive. Keep reading level per config.

---

## Phase 4: Write Draft (@writer)

**@writer — Produce the article** using the outline, config, and research.

* Match **voice & reading level**; localize spelling
* Use **plain language**; avoid personalized medical/financial/legal advice
* Include **disclaimers** where required
* Add **alt text** for all images/figures; ensure table headers & captions
* Provide **internal link suggestions** and **external primary citations** with dates
* Maintain word count or runtime targets

Save to: `project/Articles/[ARTICLE-ID]/draft.md`

---

## Phase 4.5: Media Enhancement Review

**Review draft for media embedding opportunities**

**Step 1: Check Research Brief**
* Review `project/Articles/[ARTICLE-ID]/research-brief.md` for "Recommended Media Embeds" section
* Note embed suggestions from @researcher (platform, URL, relevance, placement)

**Step 2: Content Type Assessment**
Determine if article would benefit from embeds:
* **Tutorials/How-tos** → High priority for demonstration videos
* **Expert analysis** → High priority for authority social posts (Twitter/X, LinkedIn)
* **Case studies** → High priority for real-world visual examples (Instagram, TikTok)
* **Product reviews** → Moderate priority for official announcements
* **News/announcements** → Low priority (time-sensitive, text usually sufficient)
* **Text-only analysis** → Low priority (no visual demonstration value)

**Step 3: Identify Embed Opportunities**
If article could benefit from embeds:
* Scan draft for sections that would benefit from:
  - Video demonstrations (complex processes, visual concepts)
  - Expert commentary (validating key points, adding credibility)
  - Real-world examples (showing concepts in practice)
  - Official sources (product demos, announcements)

**Step 4: Add Embeds (if valuable)**
If embeds add unique value (1-3 maximum):
* Use HTML comment syntax: `<!-- embed:[type] url="[URL]" caption="[context]" -->`
* Place embeds AFTER introducing concepts in text
* Add descriptive captions explaining WHY relevant (not just WHAT)
* Ensure embeds don't convey critical information (text should stand alone)

**Supported platforms**: YouTube, Twitter/X, Instagram, LinkedIn, TikTok

**Step 5: Document Decision**
* If embeds added: Note count and types in draft
* If NO embeds: Document reason ("Text-only appropriate" or "No visual value for this topic")

> **Note**: Embeds will be validated by @editor in Phase 6.5

---

## Phase 5: SEO & Discovery

* Meta title (≤ 60 chars) & description (150–160 chars)
* Primary keyword placement (title, H1, first 100 words, H2/H3, URL slug)
* Structured data suggestion (**JSON‑LD**: `Article`, `NewsArticle`, `HowTo`, or `FAQPage` when relevant)
* Internal linking map (3–5 targets) and contextual anchor copy
* **E‑E‑A‑T** cues (author bio, credentials, quotes, citations)
* Local SEO (if applicable): NAP, region terms, local schema

---

## Phase 6: Editorial & Compliance Review (@editor)

**@editor — Validate and refine:**

* Source verification; date‑check facts & stats
* **Compliance**: claims policy, privacy, equity & safety notes
* **Accessibility**: alt text quality, contrast guidance, heading order, link clarity
* **DEI**: inclusive phrasing, representative examples
* Brand voice & terminology consistency
* Confirm **CTA** and next‑step journey
* **Media Embeds** (if present): Validate embed URLs, fetch metadata, check accessibility compliance
* Determine export format(s) per CMS (Gutenberg/HTML/Markdown)

**Media Embed Validation** (Phase 6.5, if embeds present):
* Scan article for HTML comment embed syntax: `<!-- embed:[type] url="..." caption="..." -->`
* Invoke media-embedding skill to validate URLs and fetch metadata
* Check accessibility (captions, ARIA labels, keyboard navigation)
* Convert embeds to platform-specific code for HTML export
* Update meta.yml with embed metadata

**YAML Frontmatter (MANDATORY):**
The final `article.md` MUST include YAML frontmatter at the top with these fields:
```yaml
---
title: "[Article Title]"
description: "[Meta description - 150-160 chars]"
slug: "[url-slug]"
author: "[Author Name]"
pubDate: "YYYY-MM-DD"
category: "[Theme/Pillar]"
tags: ["tag1", "tag2", "tag3"]
---
```
See `@editor` agent documentation for complete frontmatter requirements.

Save final to: `project/Articles/[ARTICLE-ID]/article.md`
If needed, export HTML to: `project/Articles/[ARTICLE-ID]/article.html`

---

## Phase 7: Metadata

Create `project/Articles/[ARTICLE-ID]/meta.yml`:

```yaml
---
################################################################################
# ARTICLE METADATA
# Generated: YYYY-MM-DD
# Article ID: [ARTICLE-ID]
################################################################################

# =============================================================================
# 1. ARTICLE IDENTIFICATION
# =============================================================================
article_id: "[ARTICLE-ID]"
calendar_source: "[Path to calendar file]"
format: "explainer" # or how-to, case-study, interview, data-trends, opinion, news, buyers-guide, comparison, faq
funnel_stage: "awareness" # awareness, consideration, decision

# =============================================================================
# 2. PUBLICATION DETAILS
# =============================================================================
title: "[Article Title]"
slug: "[url-slug]"
publish_date: "YYYY-MM-DD"
author: "[Author Name]"
brand: "[BRAND_NAME]"
category: "[Theme/Pillar]"
category_slug: "[/category-slug/]"
locale: "en-GB" # from config
region: "[country/market]"

# =============================================================================
# 3. CONTENT SUMMARY
# =============================================================================
excerpt: "[100-150 character excerpt for WordPress excerpt field]"

word_count: 0
word_count_target: "[X-Y words]"
word_count_note: "[explain if over/under target]"

audience_personas:
  - "[persona A]"
  - "[persona B]"

primary_cta: "[CTA text]"

# =============================================================================
# 4. SEO METADATA
# =============================================================================
meta_title: "[SEO title 50-60 chars]"
meta_title_length: 0

meta_description: "[155-156 characters with keyword]"
meta_description_length: 0

keywords:
  - "[primary keyword]"
  - "[secondary keyword]"
  - "[tertiary keyword]"

seo_analysis:
  primary_keyword: "[primary keyword phrase]"
  keyword_placement:
    h1: true
    first_100_words: true
    h2: true
    read_aloud_test: "passed"
  keyword_density: "1-2%"
  meta_optimization: "excellent|good|needs-work"
  url_slug_optimized: true
  internal_linking_opportunities: 0
  structured_data_recommended: "Article|HowTo|FAQPage|etc"

tags:
  platform_tags:
    - "[Platform 1]"
    - "[Platform 2]"
  concept_tags:
    - "[Concept 1]"
    - "[Concept 2]"
  use_case_tags:
    - "[Use Case 1]"
    - "[Use Case 2]"

# =============================================================================
# 5. LINKS & CITATIONS
# =============================================================================
internal_links:
  - title: "[Existing Article Title]"
    url: "[/internal-path/]"
    status: "verified|pending_verification"

external_citations:
  - title: "[Source Title]"
    url: "https://example.com"

# =============================================================================
# 6. COMPLIANCE & LEGAL
# =============================================================================
compliance_flags:
  regulated: false
  legal_review_required: false
  legal_review_scope: "[section requiring review]"
  privacy_considerations: false

disclaimer_text: "[Legal disclaimer text if needed]"

disclaimer_placement:
  - "[Location 1 - e.g., top of regulated section]"
  - "[Location 2 - e.g., bottom of regulated section]"

# =============================================================================
# 7. ACCESSIBILITY
# =============================================================================
accessibility_checklist:
  alt_text: "complete|pending_diagram_creation"
  heading_hierarchy: true
  link_clarity: true
  reading_level: "[Beginner|Intermediate|Advanced]"
  code_explanations: true
  table_headers: true

accessibility_notes: "[Any pending accessibility work]"

# =============================================================================
# 8. VISUAL ASSETS
# =============================================================================
featured_image:
  path: "project/Articles/[ARTICLE-ID]/featured-image.png"
  status: "complete|pending_creation"
  alt_text: "[Descriptive alt text]"
  description: "[Visual description]"
  ai_prompt: "[Prompt for image generation if needed]"

visual_assets:
  - id: 1
    type: "diagram|screenshot|chart|table"
    line: 0
    description: "[Asset description]"
    status: "complete|pending_creation"
    alt_text: "[Descriptive alt text]"

# =============================================================================
# 9. CODE EXAMPLES
# =============================================================================
code_examples:
  - id: 1
    language: "[php|javascript|python|etc]"
    line: 0
    description: "[What the code does]"
    status: "verified_production_ready|draft|needs_testing"

# =============================================================================
# 10. EMBEDS & MEDIA
# =============================================================================
embeds:
  count: 0
  note: "[Reason for 0 embeds, or list of embeds]"
  # If embeds exist:
  # - id: 1
  #   line: 0
  #   type: "youtube|twitter|instagram|linkedin|tiktok"
  #   url: "https://..."
  #   status: "valid|invalid"
  #   caption: "[Context description]"
  #   metadata:
  #     title: "[Fetched title]"
  #     author: "[Fetched author]"
  #     thumbnail: "[Thumbnail URL]"
  #   warning: "[Accessibility issues if any]"

# =============================================================================
# 11. SOCIAL & DISTRIBUTION
# =============================================================================
social_pack:
  linkedin: "[Hook + CTA for LinkedIn - 150-250 chars]"

  x: "[Hook + hashtag for X/Twitter - 280 chars max]"

  newsletter_snippet: "[Compelling summary for email - 50-100 words]"

exports:
  cms_platform: "[WordPress (Gutenberg editor)|Ghost|Hugo|Other]"
  html_export: true
  html_export_status: "complete|pending"
  gutenberg_blocks: true
  markdown: true

# =============================================================================
# 12. COMPETITIVE ANALYSIS
# =============================================================================
competitive_analysis:
  opportunity_score: 0.0
  tier: "[Tier 1|Tier 2|Tier 3]"
  primary_gap: "[Coverage|Depth|Format|Recency]"
  differentiation: "[How this article stands out]"
  blue_ocean: false
  blue_ocean_note: "[X/Y competitors address this topic]"
  pre_analysis_reference: "[path to gap analysis file]"

# =============================================================================
# 13. SEO PERFORMANCE EXPECTATIONS
# =============================================================================
expected_serp_performance:
  primary_keyword: "[Top 3|Top 5|Top 10|Top 20]"
  secondary_keywords: "[Top 10|Top 20|Top 50]"
  featured_snippet_potential: "[High|Medium|Low]"

traffic_forecast:
  month_1_3: "[X-Y organic visits/month]"
  month_4_6: "[X-Y organic visits/month]"
  month_7_12: "[X-Y organic visits/month]"

# =============================================================================
# 14. FACT-CHECKING & VERIFICATION
# =============================================================================
fact_check_status:
  quick_audit: "PASS|WARN|FAIL"
  quick_audit_file: "claim-audit-quick.md"
  comprehensive_audit: "PASS|WARN|FAIL"
  comprehensive_audit_file: "claim-audit-full.md"
  verification_rate: "[X% (HIGH + MODERATE)]"
  claims_analyzed: 0
  claims_verified_high: 0
  claims_verified_moderate: 0
  claims_unverified: 0

eeat_notes: "[E-E-A-T signals: expertise, authoritativeness, trustworthiness]"

# =============================================================================
# 15. EDITORIAL REVIEW
# =============================================================================
editorial_review:
  status: "PENDING|APPROVED|REVISIONS_NEEDED"
  reviewer: "@editor agent"
  review_date: "YYYY-MM-DD"
  review_file: "editorial-review.md"
  overall_quality_rating: "[A|B|C|D]"
  brand_voice_compliance: "[Perfect|Good|Needs Work]"
  compliance_status: "[Clear|Legal review required|Issues found]"
  accessibility_status: "[Complete|Pending work]"

  blockers:
    - type: "[legal_review|visual_assets|internal_links|other]"
      scope: "[What needs to be done]"
      priority: "MANDATORY|REQUIRED|OPTIONAL"
      status: "pending|in_progress|complete"

# =============================================================================
# 16. PUBLICATION READINESS
# =============================================================================
publication_readiness:
  status: "READY|READY (pending blockers)|NOT READY"
  confidence_level: "VERY HIGH|HIGH|MODERATE|LOW"
  estimated_timeline: "[Target date]"
  recommendation: "APPROVE FOR PUBLICATION|REVISIONS NEEDED|HOLD"

  strengths:
    - "[Strength 1]"
    - "[Strength 2]"

  required_actions:
    - "[Action 1]"
    - "[Action 2]"

# =============================================================================
# 17. PERFORMANCE TRACKING
# =============================================================================
performance_metrics:
  target_kpi: "[Primary goals: traffic, engagement, conversions, etc]"
  measurement_plan: "[How to track success]"

  success_indicators:
    - "[Indicator 1]"
    - "[Indicator 2]"

# =============================================================================
# 18. FILE INVENTORY
# =============================================================================
file_inventory:
  research_brief: "research-brief.md"
  media_discovery: "media-discovery.md"
  claim_audit_quick: "claim-audit-quick.md"
  outline: "outline.md"
  draft: "draft.md"
  seo_optimization: "seo-optimization.md"
  claim_audit_full: "claim-audit-full.md"
  editorial_review: "editorial-review.md"
  article_final: "article.md"
  metadata: "meta.yml"
  summary_report: "summary.md"
  html_export: "article.html"

# =============================================================================
# 19. WORKFLOW METADATA
# =============================================================================
workflow_metadata:
  generated_by: "Claude Sonnet 4.5 (write-article command)"
  workflow_version: "v1.0"
  total_phases: 9
  start_date: "YYYY-MM-DD"
  completion_date: "YYYY-MM-DD"
  total_production_time: "[Estimated X-Y hours]"

  agent_collaboration:
    - "@researcher: Research brief, media discovery, quick fact-check"
    - "@writer: Draft article with brand voice and SEO compliance"
    - "@editor: Comprehensive fact-check, compliance review, final approval"

# =============================================================================
# 20. PRODUCTION NOTES
# =============================================================================
notes:
  - "[Production note 1]"
  - "[Production note 2]"
---
```

---

## Phase 8: Exports & Packaging

* **Markdown**: default authoring format
* **HTML / Gutenberg**: format per CMS config (add block markup if requested)
* **JSON‑LD**: optional schema snippet for SEO
* **Social pack**: channel‑ready hooks for LinkedIn/X/newsletter

---

## Phase 9: Summary Report

Produce a final report `project/Articles/[ARTICLE-ID]/summary.md`:

```markdown
## Article Generation Complete ✅

**Article ID:** [ARTICLE-ID]
**Topic:** [Topic]
**Format:** [format]
**Word Count:** XXXX (target: X–Y)
**Keyword:** [primary]
**Unique Angle:** [one‑liner]

### Files Created
- research-brief.md
- draft.md
- article.md
- article.html (if requested)
- featured-image.png
- meta.yml
- summary.md

### Validation
- ✅ Voice & reading level
- ✅ Accessibility checklist
- ✅ SEO/E‑E‑A‑T
- ✅ Compliance & disclaimers
- ✅ Internal links & CTAs

**Status:** Ready for next review step (e.g., legal/SME)
```

---

## Error Handling

If any phase fails, report the exact step, probable cause, and suggested fix; allow resume from last successful phase.

---

## Directory Structure

```
project-root/
├── .claude/
│   └── commands/
│       ├── content-calendar.md
│       └── write-article.md
├── requirements.md
├── project/Calendar/
│   └── 2025/
│       └── October/
│           └── content-calendar.md
└── project/Articles/
    └── ART-202510-001/
        ├── research-primary.md      # Agent 1: Primary sources
        ├── research-landscape.md    # Agent 2: Landscape analysis
        ├── research-brief.md        # Merged research brief
        ├── media-discovery.md
        ├── gap-analysis-report.md
        ├── claim-audit-quick.md
        ├── draft.md
        ├── article.md
        ├── article.html
        ├── featured-image.png
        ├── meta.yml
        └── summary.md
```
