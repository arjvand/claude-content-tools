# Competitive Gap Analysis

The Competitive Gap Analyzer transforms content strategy from reactive ("write about trending topics") to proactive ("write strategically superior content").

---

## Overview

Instead of just checking "does this topic exist?", the system analyzes "how can we create demonstrably superior content?"

**Two-Phase Approach:**
1. **Pre-Analysis** (Calendar): Strategic topic selection
2. **Full Analysis** (Research): Tactical implementation guidance

---

## Content Analysis Dimensions

### 1. Coverage
What topics/subtopics are covered or missing?

**Gap Indicator:** 0-2 competitors address the subtopic

### 2. Depth
How deep is the detail?

| Domain | Depth Indicators |
|--------|------------------|
| Technical | Code examples, troubleshooting, implementation details |
| Business/Finance | Case studies, calculations, worked examples |
| Psychology/Health | Clinical examples, research citations, methodology |
| Analysis | Data, comparative metrics, source documentation |

**Gap Indicator:** <200 words, no practical demonstrations

### 3. Format
What content formats are used?

- Video walkthroughs
- Interactive examples
- Downloadable resources
- Tables/comparison matrices
- Infographics

**Gap Indicator:** 0-1 competitors have the format

### 4. Recency
How current is the information?

- Version numbers
- Recent features/updates
- Current best practices

**Gap Indicator:** Old versions, missing recent features

---

## Phase 1: Pre-Analysis (Calendar)

**When:** During `/content-calendar` generation

**Purpose:** Choose topics where we can win

**Process:**
1. Analyze 5-8 top competitors per topic (2-3 min each)
2. Score each gap dimension (1-5 stars)
3. Calculate Opportunity Score (weighted average)
4. Assign tier:
   - **Tier 1** (4.0-5.0): Strategic priority
   - **Tier 2** (3.0-3.9): Good candidates
   - **Tier 3** (2.0-2.9): Low opportunity
   - **Tier 4** (<2.0): Exclude

**Output:**
```
project/Calendar/{Year}/{Month}/gap-pre-analysis/{ARTICLE-ID}-summary.md
```

**Summary Contents:**
- Opportunity score and tier
- Gap breakdown (4 dimensions)
- Top 3 opportunities
- Primary differentiation angle
- Feasibility assessment
- Recommendation (include/consider/exclude)

---

## Phase 2: Full Analysis (Research)

**When:** During `/write-article` research phase

**Purpose:** Detailed implementation tactics

**Process:**
1. Check if pre-analysis exists
2. Analyze 8-10 top competitors (complete coverage)
3. Deep analysis of all 4 dimensions
4. Generate 3-tier prioritized differentiation strategy
5. Create unique value proposition
6. If pre-analysis exists, note competitive landscape changes

**Output:**
```
project/Articles/{ARTICLE-ID}/gap-analysis-report.md
```

**Report Contents:**
- Competitor landscape table (8-10 competitors)
- Detailed gap analysis (all 4 dimensions)
- 3-tier prioritized differentiation strategy
- Specific implementation details
- Competitive positioning assessment

---

## Differentiation Strategy

### Priority Tiers

| Priority | Label | Action |
|----------|-------|--------|
| 1 | Must Implement | Critical gaps with highest impact |
| 2 | Should Implement | High-value opportunities |
| 3 | Nice-to-Have | Optional enhancements if time permits |

### Unique Value Proposition

One sentence describing the article's unique competitive advantage.

**Example:**
> "The only cart abandonment guide that covers Platform 8.2 feature compatibility with working implementation examples and mobile-specific recovery tactics"

---

## Example Analysis

**Topic:** E-commerce cart abandonment recovery

**Competitive Landscape:** 8 competitors, avg 2,400 words, mostly tool-focused

**Gaps Identified:**

| Gap Type | Finding | Competitors Addressing |
|----------|---------|----------------------|
| Coverage | Mobile-specific recovery tactics | 0/8 |
| Depth | Working implementation examples | 0/8 |
| Recency | Platform 8.2 compatibility | 0/8 |
| Format | Video walkthroughs | 0/8 |

**Differentiation Strategy:**

- **Priority 1**: Add 600-word section on Platform 8.2 features (first-mover)
- **Priority 2**: Include 5 working implementation examples (depth)
- **Priority 3**: Add mobile-specific tactics section (coverage)

**Result:** Demonstrably superior in coverage, depth, and recency.

---

## Agent Integration

### @researcher (Phase 3A)
- Invokes `competitive-gap-analyzer` skill
- Reviews gap analysis report
- Validates feasibility of Priority 1-2 tactics
- Incorporates strategy into research brief

### @writer
- Receives differentiation strategy in research brief
- Implements Priority 1 (must), Priority 2 (should), Priority 3 (if time)
- Uses unique value proposition as article's core angle

### @editor (Phase 2A)
- Validates Priority 1 tactics were implemented
- Verifies Priority 2 present or justified absence
- Confirms unique value proposition delivered
- Flags missing critical differentiation

---

## When Gap Analysis Runs

**Automatic:**
- Every article via `/write-article`

**Manual:**
```bash
Skill: competitive-gap-analyzer
# Provide keyword when prompted
```

**Skipped:**
- Truly novel topics (no competitors)
- Breaking news (timeliness is inherent differentiation)
- User explicitly requests skip

---

## Configuration

The analyzer reads `requirements.md` to adapt:
- **Target Audience**: Determines appropriate depth
- **Content Formats**: Prioritizes matching format gaps
- **Word Count Range**: Informs depth recommendations
- **Focus Areas**: Weights gap priorities

No configuration changes needed - works automatically.

---

## Expected Impact

| Metric | Improvement |
|--------|-------------|
| Traffic per article | +30% vs non-analyzed |
| Backlink acquisition | 2x rate |
| Conversion rate | +25% |
