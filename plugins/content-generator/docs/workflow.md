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

## Phase 2: Research (Parallel Execution)

**Agents:** 2x `@researcher` (parallel for speed)

This phase uses **parallel research execution** to optimize research time while ensuring comprehensive coverage.

### Phase 2.1: Parallel Research (5-7 minutes each, concurrent)

**Agent 1: Primary Sources Research**
- Gather information from official documentation sources
- Verify facts and technical accuracy
- Identify code examples and technical depth requirements
- Assess SME requirements
- Output: `project/Articles/{ARTICLE-ID}/research-primary.md`

**Agent 2: Competitive Landscape Analysis**
- Run full competitive gap analysis (8-10 competitors)
- Identify differentiation opportunities and unique angles
- Calculate gap scores: Coverage, Depth, Format, Recency
- Search for relevant media embeds (3-5 candidates)
- Output: `project/Articles/{ARTICLE-ID}/research-landscape.md`

**Why Parallel**: Running both agents simultaneously reduces total research time from ~15 minutes to ~7 minutes.

### Phase 2.2: Research Merge (2-3 minutes, sequential after parallel completion)

**Performed by:** `@researcher` agent (third invocation - merge coordinator)

**Merge Strategy:**

1. **Source Verification Section:**
   - Use Agent 1's official sources as authoritative base
   - Cross-reference Agent 2's competitive findings for validation
   - Flag any contradictions for manual SME review
   - Priority: Agent 1's sources take precedence for technical accuracy

2. **Differentiation Strategy:**
   - Use Agent 2's gap analysis as primary input for differentiation tactics
   - Enhance with Agent 1's technical depth findings
   - Prioritize tactics: P1 (must implement), P2 (should implement), P3 (nice-to-have)

3. **Media Embeds:**
   - Use Agent 2's media discovery results
   - Validate against Agent 1's credibility and relevance standards
   - Keep only embeds that pass both quality and technical accuracy checks

4. **Conflict Resolution:**
   - **Technical accuracy conflicts**: Agent 1 (official sources) takes precedence
   - **Market positioning conflicts**: Agent 2 (competitive analysis) takes precedence
   - **Unresolvable conflicts**: Flag for SME review in research brief with both perspectives noted

**Verification Checklist:**
- [ ] All Agent 1 official sources included in final brief
- [ ] All Agent 2 gap tactics addressed in differentiation strategy
- [ ] No unresolved contradictions (conflicts noted if present)
- [ ] Media embeds validated for both quality and accuracy
- [ ] SME flags consolidated (no duplicate flags)

**Failure Modes & Recovery:**
- **Agent 1 or 2 fails**: Fall back to single-agent research (traditional workflow)
- **Merge produces conflicts**: Include conflict log in brief; escalate to @editor for manual merge
- **Verification fails**: Escalate to @editor with both research files for manual review

### Phase 2.3: Quick Fact-Check (1-2 minutes)

**Skill:** `fact-checker` (quick mode)

- Source audit of claims in merged research brief
- Validate confidence levels: HIGH/MODERATE/LOW/UNVERIFIED
- Flag any claims requiring deeper verification

**Output:**
- `project/Articles/{ARTICLE-ID}/claim-audit-quick.md`

### Final Output:
- `project/Articles/{ARTICLE-ID}/research-primary.md` (Agent 1)
- `project/Articles/{ARTICLE-ID}/research-landscape.md` (Agent 2)
- `project/Articles/{ARTICLE-ID}/research-brief.md` (merged)
- `project/Articles/{ARTICLE-ID}/gap-analysis-report.md` (from Agent 2)
- `project/Articles/{ARTICLE-ID}/media-discovery.md` (from Agent 2)
- `project/Articles/{ARTICLE-ID}/claim-audit-quick.md` (post-merge validation)

**Total Time:** ~10-12 minutes (vs ~15-20 minutes sequential)

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
