# Content Production Workflow

Detailed documentation of the content production workflow phases.

---

## Overview

```
Planning → Research → Writing → SEO → Review → Publish
```

---

## Phase 1: Planning

**Command:** `/content-calendar [Month] [Year]`

**Process:**
1. **Candidate Generation**: Create 10-15 topic ideas based on trends/signals
2. **Gap Pre-Analysis**: For each candidate (2-3 min each):
   - Analyze 5-8 top competitors
   - Calculate gap scores: Coverage, Depth, Format, Recency (1-5 stars)
   - Generate Opportunity Score (weighted average)
   - Identify primary differentiation angle
   - Assess feasibility (High/Medium/Low)
3. **Topic Prioritization**:
   - **Tier 1** (4.0-5.0): High-opportunity (strategic priority)
   - **Tier 2** (3.0-3.9): Moderate-opportunity (good candidates)
   - **Tier 3** (2.0-2.9): Low-opportunity (only if strategic value)
   - **Tier 4** (<2.0): Saturated (exclude)
4. **Selection**: Choose 8-12 topics with minimum 60% Tier 1

**Output:**
- `project/Calendar/{Year}/{Month}/content-calendar.md`
- `project/Calendar/{Year}/{Month}/gap-pre-analysis/{ARTICLE-ID}-summary.md`

**Time:** 40-50 minutes total

---

## Phase 2: Research

**Agent:** `@researcher`

**Process:**
1. Check for pre-analysis from calendar phase
2. Verify topic originality via web search
3. Run full competitive gap analysis (8-10 competitors)
4. Gather information from official documentation sources
5. Identify unique content angles
6. Search for relevant media embeds (3-5 candidates)
7. Produce research brief with:
   - Sources and confidence levels
   - Differentiation strategy (Priority 1-3 tactics)
   - Unique value proposition
   - Recommended media embeds
   - SME flags if needed

**Output:**
- `project/Articles/{ARTICLE-ID}/research-brief.md`
- `project/Articles/{ARTICLE-ID}/gap-analysis-report.md`

**Time:** 5-10 minutes

---

## Phase 3: Writing

**Agent:** `@writer`

**Process:**
1. Read `requirements.md` for brand voice and guidelines
2. Review research brief and differentiation strategy
3. Implement Priority 1 tactics (must), Priority 2 (should), Priority 3 (if time)
4. Create draft following article format (Tutorial/Analysis/News)
5. Add media embeds using HTML comment syntax
6. Self-edit for clarity and brand voice
7. Verify word count with `wc -w`

**Output:**
- `project/Articles/{ARTICLE-ID}/draft.md`

**Word Count:** Verify against requirements.md range

---

## Phase 4: SEO Optimization

**Skill:** `seo-optimization`

**Checklist:**
- Primary keyword in H1, first 100 words, and one H2
- Keyword density: 1-2%
- Meta description: 150-160 chars with keyword + CTA
- Title tag: 50-60 chars
- 3-5 internal links with descriptive anchor text
- Short paragraphs (2-4 sentences)
- Logical H1/H2/H3 hierarchy

---

## Phase 5: Editorial Review

**Agent:** `@editor`

**Process:**
1. Load `requirements.md` for validation
2. Review for brand voice compliance
3. Verify technical accuracy (request SME if uncertain)
4. Validate differentiation tactics implemented:
   - Priority 1: Must be present (critical)
   - Priority 2: Should be present or justified absence
5. Check SEO elements
6. Validate media embeds (URLs, accessibility, relevance)
7. Flag legal/compliance issues (benchmarks, claims, comparisons)
8. Generate HTML export if CMS platform configured
9. Create metadata file
10. Final approval decision

**Output:**
- `project/Articles/{ARTICLE-ID}/article.md`
- `project/Articles/{ARTICLE-ID}/article.html` (if configured)
- `project/Articles/{ARTICLE-ID}/meta.yml`

---

## Phase 6: Legal/Compliance (External)

**When Required:**
- Performance benchmarks
- Comparative claims
- Product recommendations
- Medical/financial advice
- Data citations

**Process:** Manual review by appropriate professional

---

## Phase 7: Publication

**Distribution Channels** (varies by domain):
- Newsletter, RSS feed
- Social media
- Package registries (technical)
- Industry publications

**Primary KPI:** Brand lift/impressions (or domain-specific metrics)

---

## Workflow Diagram

```
┌─────────────────┐
│ /content-calendar│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Gap Pre-Analysis │
│ (10-15 topics)  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Select 8-12     │
│ (60%+ Tier 1)   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ /write-article  │
│ ART-YYYYMM-NNN  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ @researcher     │
│ • Verify topic  │
│ • Gap analysis  │
│ • Research brief│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ @writer         │
│ • Draft article │
│ • Add embeds    │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ seo-optimization│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ @editor         │
│ • Review        │
│ • HTML export   │
│ • Final approval│
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Publish         │
└─────────────────┘
```
