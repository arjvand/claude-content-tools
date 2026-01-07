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

## Workflow Overview

This command orchestrates multiple skill-specific agents in sequence:

```
Phase 1: Setup
├── requirements-loader → Validate config
├── Parse calendar entry → Extract article details
└── Establish $REFERENCE_DATE and $HISTORICAL_MODE

Phase 2: Research (Parallel)
├── @researcher (Agent 1) → Primary sources
├── @researcher (Agent 2) → Landscape analysis
├── keyword-analyst → Keyword research
└── fact-checker (quick) → Verify research claims

Phase 3: Writing
├── @writer → Draft article
├── media-discoverer → Find embeddable media
└── seo-optimizer → SEO optimization

Phase 4: Review & Export
├── @editor → Editorial review
├── fact-checker (comprehensive) → Full claim verification
└── cms-exporter → CMS-ready export
```

---

## Phase 1: Setup & Configuration

### Step 1A: Load Configuration

**Invoke `requirements-loader` agent:**

```
Invoke requirements-loader agent for full config extraction.
```

**Expected Output:**
- Validated config JSON
- Brand voice, audience, compliance settings
- CMS platform configuration

**Blocking Gate:** If validation errors → STOP and report to user.

---

### Step 1B: Parse Calendar Entry

1. Read calendar file: `$1`
2. Extract details for Article ID: `$2`
   - Title, format, primary keyword
   - Funnel stage, publish date, CTA
   - SME requirements

3. Establish reference date:
   - Parse `publish_date` → `$REFERENCE_DATE`
   - If `$REFERENCE_DATE < TODAY` → `$HISTORICAL_MODE = true`

4. Create article directory:
   ```bash
   mkdir -p "project/Articles/[ARTICLE-ID]"
   ```

**Time:** <1 minute

---

## Phase 2: Research (Parallel Execution)

### Step 2A: Parallel Research Agents

**Launch BOTH @researcher agents IN PARALLEL:**

**Agent 1 - Primary Research (@researcher):**
```
Invoke @researcher agent for primary sources.
Article ID: [ARTICLE-ID]
Focus: Authoritative sources, evidence verification
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
Output: project/Articles/[ARTICLE-ID]/research-primary.md
```

**Agent 2 - Landscape Research (@researcher):**
```
Invoke @researcher agent for landscape analysis.
Article ID: [ARTICLE-ID]
Focus: Competitive landscape, gap analysis, media discovery
Reference Date: $REFERENCE_DATE
Historical Mode: $HISTORICAL_MODE
Output: project/Articles/[ARTICLE-ID]/research-landscape.md
```

**⚠️ PARALLEL NOTE:** Both agents MUST be launched in a SINGLE message.

**Time:** 10-15 minutes (parallel)

---

### Step 2B: Keyword Analysis

**Invoke `keyword-analyst` agent:**

```
Invoke keyword-analyst agent in full mode.
Article ID: [ARTICLE-ID]
Primary Keyword: "[primary keyword from calendar entry]"
```

**Expected Output:**
- Volume, difficulty, intent classification
- Long-tail keyword expansion (10-15)
- Semantic keyword clusters (3-5)
- `project/Articles/[ARTICLE-ID]/keyword-research.md`

**Time:** 6-10 minutes

---

### Step 2C: Research Synthesis

**After parallel research completes:**

1. Merge `research-primary.md` + `research-landscape.md`
2. Create unified `research-brief.md`
3. Resolve conflicts (use conservative SME requirements)

---

### Step 2D: Quick Fact-Check

**Invoke `fact-checker` agent (quick mode):**

```
Invoke fact-checker agent in quick mode.
Article ID: [ARTICLE-ID]
Source: project/Articles/[ARTICLE-ID]/research-brief.md
```

**Expected Output:**
- Claim verification status
- `project/Articles/[ARTICLE-ID]/claim-audit-quick.md`

**Blocking Gate:** If FAIL → address critical claims before proceeding.

**Time:** 2-3 minutes

---

## Phase 3: Writing & Enhancement

### Step 3A: Write Draft

**Invoke `@writer` agent:**

```
Invoke @writer agent.
Article ID: [ARTICLE-ID]
Research Brief: project/Articles/[ARTICLE-ID]/research-brief.md
Keyword Research: project/Articles/[ARTICLE-ID]/keyword-research.md
Format: [format from calendar]
```

**@writer responsibilities:**
- Match voice & reading level from config
- Use plain language; include disclaimers where required
- Add alt text for images; ensure table headers
- Maintain word count targets

**Output:** `project/Articles/[ARTICLE-ID]/draft.md`

**Time:** 15-25 minutes

---

### Step 3B: Media Discovery

**Invoke `media-discoverer` agent:**

```
Invoke media-discoverer agent.
Topic: "[article topic/keyword]"
Content Type: [format from calendar]
Article ID: [ARTICLE-ID]
```

**Expected Output:**
- Ranked embed candidates (0-3)
- Placement recommendations
- `project/Articles/[ARTICLE-ID]/media-discovery.md`

**Time:** 3-5 minutes

---

### Step 3C: SEO Optimization

**Invoke `seo-optimizer` agent:**

```
Invoke seo-optimizer agent.
Article: project/Articles/[ARTICLE-ID]/draft.md
Primary Keyword: "[primary keyword]"
```

**Expected Output:**
- Meta title (≤60 chars), meta description (150-160 chars)
- Keyword placement audit
- Internal linking recommendations (3-5)
- E-E-A-T cues
- `project/Articles/[ARTICLE-ID]/seo-audit.md`

**Time:** 2-3 minutes

---

## Phase 4: Review & Export

### Step 4A: Editorial Review

**Invoke `@editor` agent:**

```
Invoke @editor agent.
Article ID: [ARTICLE-ID]
Draft: project/Articles/[ARTICLE-ID]/draft.md
SEO Audit: project/Articles/[ARTICLE-ID]/seo-audit.md
Media Discovery: project/Articles/[ARTICLE-ID]/media-discovery.md
```

**@editor responsibilities:**
- Source verification, date-check facts
- Compliance: claims policy, privacy, accessibility
- Brand voice consistency
- Media embed validation (if present)
- Add YAML frontmatter

**Output:** `project/Articles/[ARTICLE-ID]/article.md`

**Time:** 10-15 minutes

---

### Step 4B: Comprehensive Fact-Check

**Invoke `fact-checker` agent (comprehensive mode):**

```
Invoke fact-checker agent in comprehensive mode.
Article ID: [ARTICLE-ID]
Source: project/Articles/[ARTICLE-ID]/article.md
```

**Expected Output:**
- Full claim verification with web search
- `project/Articles/[ARTICLE-ID]/claim-audit-full.md`

**Blocking Gate:** If FAIL → revisions required before export.

**Time:** 5-10 minutes

---

### Step 4C: CMS Export

**Invoke `cms-exporter` agent:**

```
Invoke cms-exporter agent.
Article: project/Articles/[ARTICLE-ID]/article.md
Format: [from config - gutenberg | ghost | medium | html]
```

**Expected Output:**
- CMS-ready export file
- `project/Articles/[ARTICLE-ID]/article.html` (or format-specific)

**Time:** 30-60 seconds

---

## Phase 5: Finalization

### Step 5A: Generate Metadata

Create `project/Articles/[ARTICLE-ID]/meta.yml` with 20 sections:

1. Article Identification (ID, format, funnel stage)
2. Publication Details (title, slug, date, author)
3. Content Summary (excerpt, word count, personas)
4. SEO Metadata (meta title, description, keywords)
5. Links & Citations (internal, external)
6. Compliance & Legal (disclaimers, flags)
7. Accessibility (checklist, notes)
8. Visual Assets (featured image, diagrams)
9. Code Examples (language, status)
10. Embeds & Media (count, metadata)
11. Social & Distribution (LinkedIn, X, newsletter)
12. Competitive Analysis (scores, differentiation)
13. SEO Performance Expectations (SERP, traffic)
14. Fact-Checking Status (quick, comprehensive)
15. Editorial Review (status, blockers)
16. Publication Readiness (recommendation)
17. Performance Tracking (KPIs)
18. File Inventory (all generated files)
19. Workflow Metadata (agents, timing)
20. Production Notes

**Time:** 2-3 minutes

---

### Step 5B: Generate Summary Report

Create `project/Articles/[ARTICLE-ID]/summary.md`:

```markdown
## Article Generation Complete ✅

**Article ID:** [ARTICLE-ID]
**Topic:** [Topic]
**Format:** [format]
**Word Count:** XXXX (target: X–Y)
**Keyword:** [primary]

### Files Created
- research-brief.md, draft.md, article.md
- article.html, meta.yml, summary.md

### Validation
- ✅ Voice & reading level
- ✅ Accessibility checklist
- ✅ SEO/E‑E‑A‑T
- ✅ Compliance & disclaimers

**Status:** Ready for publication
```

---

## Output Files

| File | Description |
|------|-------------|
| `research-primary.md` | Primary sources (parallel Agent 1) |
| `research-landscape.md` | Landscape analysis (parallel Agent 2) |
| `research-brief.md` | Merged research brief |
| `keyword-research.md` | Keyword analysis |
| `media-discovery.md` | Embed candidates |
| `claim-audit-quick.md` | Quick fact-check |
| `draft.md` | Writer output |
| `seo-audit.md` | SEO recommendations |
| `claim-audit-full.md` | Comprehensive fact-check |
| `article.md` | Final article |
| `article.html` | CMS export |
| `meta.yml` | Full metadata (20 sections) |
| `summary.md` | Production summary |

---

## Time Estimate

| Phase | Duration |
|-------|----------|
| Phase 1: Setup | 1-2 minutes |
| Phase 2: Research (parallel) | 15-25 minutes |
| Phase 3: Writing & Enhancement | 20-35 minutes |
| Phase 4: Review & Export | 15-25 minutes |
| Phase 5: Finalization | 5-10 minutes |
| **Total** | **55-95 minutes** |

---

## Error Handling

If any phase fails:
1. Report exact step and probable cause
2. Suggest fix
3. Allow resume from last successful phase

---

## Quick Reference

```bash
# Generate article
/write-article project/Calendar/2025/October/content-calendar.md ART-202510-001

# Check output
ls project/Articles/ART-202510-001/

# Verify word count
wc -w project/Articles/ART-202510-001/article.md
```
