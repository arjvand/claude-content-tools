---
name: fact-checker
description: Verify factual claims via source audit (quick mode) or web search with authoritative cross-referencing (comprehensive mode). Outputs claim registry with confidence grades and escalation flags.
---

# Fact-Checker Skill

## Purpose

Systematically verify factual claims in research briefs and articles to ensure accuracy before publication. Supports two modes: quick audit against existing sources and comprehensive verification with active web search.

## When to Use

- **Quick Mode (Post-Research):** Automatically invoked by @researcher after completing research brief, before handoff to writer
  - Validates claims in research-brief.md against cited sources
  - Catches unverified or weakly-sourced claims early
  - Time: 2-5 minutes

- **Comprehensive Mode (Post-Writing):** Automatically invoked by @editor during editorial review
  - Full audit of all claims in draft.md or article.md
  - Active web search verification against authoritative sources
  - Time: 10-15 minutes

- **Manual Invocation:** When updating older content or spot-checking specific claims

## Configuration-Driven Approach

**Before fact-checking, read requirements.md to extract configuration:**

```bash
!cat project/requirements.md
```

**Extract the following configuration:**

1. **Claim Types to Verify**:
   - Look for: `**Required Verification**:` → [Extract claim types that must be verified]
   - Look for: `**Optional Verification**:` → [Extract claim types to warn if unverified]

2. **Verification Standards**:
   - Look for: `**Minimum Confidence for Publication**:` → [Extract threshold]
   - Look for: `**Maximum Unverified Required Claims**:` → [Extract limit]
   - Look for: `**Maximum Unverified Optional Claims**:` → [Extract limit]
   - Look for: `**Recency Window**:` → [Extract time limit for current-state claims]

3. **Escalation Rules**:
   - Look for: `**SME Review Required**:` → [Extract triggers]
   - Look for: `**Legal Review Required**:` → [Extract triggers]
   - Look for: `**Auto-Reject**:` → [Extract automatic rejection criteria]

4. **Authoritative Sources** (for verification):
   - Look for: `**Authoritative Research Sources**` section → [Extract trusted sources list]
   - Look for: `**Official Documentation Sources**` section → [Extract primary sources]

**Use these extracted values throughout the fact-checking process.**

---

## Claim Classification System

### Categories

| Code | Category | Description | Examples |
|------|----------|-------------|----------|
| **STAT** | Statistics & Numerical Data | Percentages, counts, measurements, financial figures | "80% of companies prefer...", "costs $X per month" |
| **COMP** | Comparative Claims | Superlatives, benchmarks, product comparisons | "fastest", "most popular", "67% faster than..." |
| **LEGAL** | Legal/Medical/Security | Regulatory references, compliance claims, health/safety | "GDPR-compliant", "FDA approved", "secure by default" |
| **QUOTE** | Expert Quotes & Attributions | Direct quotes, cited opinions, attributed statements | "According to McKinsey...", "John Doe, CEO, said..." |
| **FEAT** | Product Feature Claims | Capability assertions, version-specific features | "WordPress 6.4 supports...", "includes 3 templates" |
| **HIST** | Historical/Timeline Assertions | Dates, sequences, version histories, event timing | "Released in September 2025", "founded in 2018" |

### Confidence Grading

| Grade | Criteria | Publication Status |
|-------|----------|-------------------|
| **HIGH** | Verified via 2+ authoritative sources; sources are primary/official | Ready for publication |
| **MODERATE** | Verified via 1 authoritative source OR 2+ secondary sources | Proceed with caution; consider hedging |
| **LOW** | Single secondary source OR conflicting information found | Needs attention; hedge or strengthen |
| **UNVERIFIED** | Cannot verify from available sources | Block publication (required claims) or flag (optional) |

### Status Indicators

| Status | Meaning | Action |
|--------|---------|--------|
| `VERIFIED` | Claim confirmed with HIGH confidence | Proceed |
| `LIKELY` | Claim confirmed with MODERATE confidence | Consider hedging language |
| `NEEDS-REVIEW` | Claim has LOW confidence | Requires editorial attention |
| `UNVERIFIED` | Cannot verify | Requires source or removal |
| `ESCALATE` | Requires SME/legal review | Route to appropriate reviewer |
| `CONFLICT` | Found contradicting information | Investigate and resolve |
| `CITATION-MISMATCH` | Claim doesn't appear in cited source | Requires source correction |

---

## Process

### Phase 0: Load Configuration (1 minute)

```bash
!cat project/requirements.md
```

Extract:
- Claim types to verify (required vs optional)
- Verification thresholds
- Escalation rules
- Authoritative sources list

---

### Phase 1: Claim Extraction (2-3 minutes)

**Objective:** Identify all verifiable claims in the target document

**Actions:**
1. Read target document:
   - Quick mode: `project/Articles/[ARTICLE-ID]/research-brief.md`
   - Comprehensive mode: `project/Articles/[ARTICLE-ID]/draft.md` or `article.md`

2. Scan for claim patterns:
   - Numbers, percentages, statistics (STAT)
   - Superlatives, comparisons, benchmarks (COMP)
   - Regulatory, compliance, safety statements (LEGAL)
   - Quoted or attributed statements (QUOTE)
   - Feature or capability assertions (FEAT)
   - Dates, timelines, version references (HIST)

3. For each claim, record:
   - Line number in document
   - Category (STAT/COMP/LEGAL/QUOTE/FEAT/HIST)
   - Exact claim text
   - Cited source (if any)
   - Required vs Optional (from configuration)

**Output:** Claim inventory list

---

### Phase 2: Verification (Mode-Dependent)

#### Quick Mode (2-5 minutes total)

For each claim:

1. **Check source citation:**
   - Is a source cited for this claim?
   - If no source: Mark as UNVERIFIED

2. **Validate source URL:**
   - Is the URL valid and accessible?
   - Does the URL lead to the claimed content?

3. **Fetch and verify cited source content (REQUIRED):**
   - Use WebFetch to retrieve the cited URL
   - Search page content for the exact claim/statistic
   - Verify the specific number, percentage, or fact appears
   - Check context matches (not just the number, but what it refers to)
   - If claim NOT found in cited source:
     - Mark as `CITATION-MISMATCH`
     - Search for actual source of the claim
     - Flag for correction

4. **Cross-reference claim:**
   - Does the source actually support this claim?
   - Is the claim accurately represented?

5. **Assess source quality:**
   - Is source authoritative (from configured list)?
   - Is source current (within recency window)?

6. **Grade confidence:**
   - Authoritative + current = HIGH
   - Secondary or older = MODERATE
   - Weak or questionable = LOW
   - No source = UNVERIFIED

---

#### Comprehensive Mode (10-15 minutes total)

All Quick Mode steps PLUS:

1. **Source content verification (REQUIRED - do this FIRST):**
   ```
   For each claim with a cited URL:
   - Use WebFetch to retrieve the cited URL
   - Search page content for exact claim text/statistics
   - Confirm claim exists in that specific source
   - If not found: Mark CITATION-MISMATCH, search for actual source
   ```
   - This step catches citation errors before web search validation
   - Do NOT skip this step or rely solely on web search

2. **Active verification search:**
   ```
   Use WebSearch for: "[claim keywords] site:[authoritative domain]"
   ```
   - Search authoritative sources from configuration
   - Look for corroborating evidence

3. **Cross-reference multiple sources:**
   - Seek 2+ independent sources for HIGH confidence
   - Check for conflicting information
   - Note discrepancies

4. **Recency check:**
   - Are dates/versions still current?
   - Has information changed since publication?
   - Flag stale claims

5. **Contradiction scan:**
   - Search for counter-evidence
   - Note any conflicting claims found
   - Assess which source is more authoritative

6. **Enhanced grading:**
   - 2+ authoritative sources = HIGH
   - 1 authoritative or 2+ secondary = MODERATE
   - Conflicts or weak sources = LOW
   - Cannot verify = UNVERIFIED
   - Citation mismatch = CITATION-MISMATCH (regardless of web search results)

---

### Phase 3: Escalation Assessment (2 minutes)

Apply escalation rules from configuration:

**SME Review Triggers:**
- LEGAL category claims lacking authoritative backing
- Technical claims outside documented expertise
- Claims graded LOW in critical categories

**Legal Review Triggers:**
- Competitor comparisons with performance data
- Benchmark claims with business implications
- Regulatory or compliance assertions

**Auto-Reject Triggers:**
- Unverifiable statistics cited as fact
- Comparative claims without any source
- LEGAL claims with UNVERIFIED status

**Document escalations** with:
- Claim text and location
- Reason for escalation
- Recommended reviewer
- Urgency level

---

### Phase 4: Registry Generation (2 minutes)

Generate claim registry table and summary report.

---

## Output Format

### Output Files

**Quick Mode:**
```
project/Articles/[ARTICLE-ID]/claim-audit-quick.md
```

**Comprehensive Mode:**
```
project/Articles/[ARTICLE-ID]/claim-audit-full.md
```

---

### Claim Audit Report Template

```markdown
# Claim Audit Report: [ARTICLE-ID]

**Article:** [Title]
**Mode:** Quick / Comprehensive
**Date:** YYYY-MM-DD
**Auditor:** fact-checker skill

---

## Executive Summary

**Overall Status:** PASS / WARN / FAIL

| Metric | Count |
|--------|-------|
| Total Claims Analyzed | X |
| Verified (HIGH) | X |
| Likely (MODERATE) | X |
| Needs Review (LOW) | X |
| Unverified | X |
| Escalations | X |

**Verification Rate:** X% HIGH confidence
**Publication Ready:** Yes / Yes with caveats / No

---

## Claim Registry

| # | Line | Cat | Claim Text | Source | Conf | Status | Notes |
|---|------|-----|------------|--------|------|--------|-------|
| 1 | XX | STAT | "[claim]" | [source] | HIGH | VERIFIED | [notes] |
| 2 | XX | COMP | "[claim]" | [source] | MOD | LIKELY | [notes] |
| 3 | XX | LEGAL | "[claim]" | (none) | -- | ESCALATE | [notes] |

---

## Escalation Items

### 1. [Claim Category] (Line XX)
**Claim:** "[exact claim text]"
**Issue:** [Why this needs escalation]
**Action Required:** [Specific action needed]
**Escalation Level:** SME Review / Legal Review / Editorial Judgment

---

## Verification Notes

### Sources Validated
- [Source 1]: [Status and notes]
- [Source 2]: [Status and notes]

### Sources Requiring Follow-Up
- [Source]: [Issue and recommended action]

### Conflicting Information Found
- [Claim]: [Conflict description and resolution]

---

## Recommendations

1. **Line XX**: [Specific recommendation]
2. **Line XX**: [Specific recommendation]

---

## Audit Decision

**Status:** PASS / WARN / FAIL

**PASS Criteria:**
- All required claims verified (HIGH/MODERATE)
- No UNVERIFIED required claims
- All escalations resolved or documented

**WARN Criteria:**
- Some claims have MODERATE confidence
- Pending escalations that don't block publication
- Optional claims unverified

**FAIL Criteria:**
- Unverified required claims present
- Critical escalations unresolved
- LEGAL/COMP claims without sources

**Next Step:** [Proceed to writing / Proceed with caveats / Revise and re-audit]

---

**Audit Completed:** YYYY-MM-DD HH:MM UTC
**Skill Version:** fact-checker v1.0
```

---

## Integration with Agents

### With @researcher (Quick Mode)

**Trigger:** After completing research-brief.md, before handoff to @writer

**Invocation:**
```markdown
Skill: fact-checker (quick mode)

Inputs:
- Target file: project/Articles/[ARTICLE-ID]/research-brief.md
- Mode: quick
```

**Decision Tree:**
- **PASS:** All required claims verified → Proceed to writing phase
- **WARN:** Some MODERATE/LOW claims → Document in brief, proceed with caution flags
- **FAIL:** UNVERIFIED required claims → Revise research brief before handoff

**Handoff includes:**
- Research brief with claim verification status
- Quick audit report (if WARN status)
- Flagged claims for writer awareness

---

### With @editor (Comprehensive Mode)

**Trigger:** During Phase 2B (Evidence & Citation Audit) of editorial review

**Invocation:**
```markdown
Skill: fact-checker (comprehensive mode)

Inputs:
- Target file: project/Articles/[ARTICLE-ID]/draft.md (or article.md)
- Mode: comprehensive
- Research brief: project/Articles/[ARTICLE-ID]/research-brief.md (for comparison)
- Quick audit (if exists): project/Articles/[ARTICLE-ID]/claim-audit-quick.md
```

**Decision Tree:**
- **PASS:** All required claims verified with HIGH confidence → Proceed to approval
- **WARN:** Some MODERATE claims or pending escalations → Editorial judgment (accept, hedge, or send back)
- **FAIL:** UNVERIFIED required claims present → Send back to @writer/@researcher for revision

**Quality Gate Integration:**
Add to editor's "Before Approving for Publication" checklist:
```markdown
Fact-Check Audit: ✅ / ❌
- [ ] All required claims verified (HIGH/MODERATE)
- [ ] No UNVERIFIED required claims
- [ ] Escalations resolved or documented
- [ ] MODERATE claims hedged appropriately
- [ ] claim-audit-full.md generated and reviewed
```

---

## Quality Guidelines

### DO:
- Verify claims against authoritative sources from configuration
- Cross-reference with multiple independent sources for HIGH confidence
- Check recency of time-sensitive claims (versions, dates, current state)
- Document uncertainty and escalate appropriately
- Provide specific, actionable recommendations
- **Fetch and read cited sources to verify exact claims exist there (don't rely on web search alone)**
- **Flag citation mismatches when a source doesn't contain the attributed claim**

### DON'T:
- Accept sources at face value without checking
- Skip escalation for sensitive claim categories (LEGAL, COMP)
- Mark claims as verified without actual verification
- Ignore conflicting information
- Apply one-size-fits-all verification to all claim types
- **Mark claims as verified based on web search alone without checking the cited source**
- **Assume a cited source contains a claim without fetching and verifying**

---

## Error Handling

### Scenario 1: Source URL Broken/Inaccessible

**Response:**
- Mark source as inaccessible in registry
- Attempt to find alternative source via web search
- If alternative found: Update source, note change
- If not found: Mark as NEEDS-REVIEW or UNVERIFIED

### Scenario 2: Conflicting Information Found

**Response:**
- Document both sources in registry
- Assess which source is more authoritative (primary > secondary)
- Check recency (newer > older for current-state claims)
- Recommend resolution in notes
- If unresolvable: ESCALATE for editorial judgment

### Scenario 3: Claim Type Not in Configuration

**Response:**
- Default to optional verification (warn if unverified)
- Note in report: "Claim type not explicitly configured"
- Suggest adding to configuration if recurring

### Scenario 4: No Authoritative Sources Exist

**Response:**
- Document search attempts
- Mark as UNVERIFIED with note: "No authoritative sources found"
- Recommend: Remove claim, hedge heavily, or cite limitations

### Scenario 5: Claim Not Found in Cited Source

**Response:**
- Mark as `CITATION-MISMATCH` in registry
- Use WebSearch to find the actual source of the claim
- If found elsewhere: Note correct source, recommend citation update
- If claim is misquoted/misattributed: Flag for removal or correction
- Add to escalations with specific recommendation

**Example:**
```
Claim: "82% of consumers say speed impacts purchasing" (citing Queue-it)
Issue: Queue-it article does not contain this statistic
Action: WebSearch finds actual source is Unbounce (~70% general, 82% NY only)
Recommendation: Update to "Nearly 70% of consumers" with Unbounce citation
```

---

## Workflow Integration Diagram

```
┌─────────────────────────────────────────────────────────────┐
│                                                             │
│  @researcher completes research-brief.md                    │
│     │                                                       │
│     ▼                                                       │
│  ┌──────────────────────────────────────┐                  │
│  │ FACT-CHECKER (Quick Mode)            │                  │
│  │ • Verify claims in research brief    │                  │
│  │ • 2-5 minutes                        │                  │
│  │ • Output: claim-audit-quick.md       │                  │
│  └──────────────────────────────────────┘                  │
│     │                                                       │
│     ├── PASS → Proceed to @writer                          │
│     ├── WARN → Proceed with flags for @writer              │
│     └── FAIL → @researcher revises brief                   │
│     ▼                                                       │
│  @writer creates draft.md                                   │
│     │                                                       │
│     ▼                                                       │
│  @editor begins review                                      │
│     │                                                       │
│     ▼                                                       │
│  ┌──────────────────────────────────────┐                  │
│  │ FACT-CHECKER (Comprehensive Mode)    │                  │
│  │ • Verify all claims in article       │                  │
│  │ • WebSearch + authoritative sources  │                  │
│  │ • 10-15 minutes                      │                  │
│  │ • Output: claim-audit-full.md        │                  │
│  └──────────────────────────────────────┘                  │
│     │                                                       │
│     ├── PASS → Proceed to approval                         │
│     ├── WARN → Editorial judgment                          │
│     └── FAIL → Send back for revision                      │
│     ▼                                                       │
│  Publication                                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Example Usage

### Example 1: Quick Mode After Research

```markdown
@researcher has completed research brief for ART-202511-001

Invoke: fact-checker skill (quick mode)
Target: project/Articles/ART-202511-001/research-brief.md

Results:
- 8 claims identified
- 6 verified (HIGH)
- 2 need attention (MODERATE)
- 0 unverified

Status: WARN
Action: Proceed to @writer with flags for the 2 MODERATE claims
Output: project/Articles/ART-202511-001/claim-audit-quick.md
```

### Example 2: Comprehensive Mode During Editing

```markdown
@editor reviewing draft for ART-202511-001

Invoke: fact-checker skill (comprehensive mode)
Target: project/Articles/ART-202511-001/draft.md

Results:
- 12 claims identified (4 new since research brief)
- 10 verified (HIGH)
- 1 likely (MODERATE) - recommend hedging
- 1 escalation (LEGAL claim needs review)

Status: WARN
Action: Hedge MODERATE claim, resolve escalation before approval
Output: project/Articles/ART-202511-001/claim-audit-full.md
```

---

## Success Metrics

### Skill Performance
- **Accuracy:** 95%+ claims correctly categorized and verified
- **Coverage:** 100% of configured claim types identified
- **Efficiency:** Quick mode <5 min, Comprehensive mode <15 min

### Content Quality Impact
- **Pre-publication catch rate:** 90%+ factual issues caught before publication
- **Post-publication corrections:** <2% of published articles require corrections
- **Escalation accuracy:** 95%+ escalations are valid (not false positives)

### Process Improvement
- **Writer efficiency:** Fewer revision cycles due to fact-checking issues
- **Editor confidence:** Clear evidence basis for approval decisions
- **Reader trust:** Higher credibility through verified claims
