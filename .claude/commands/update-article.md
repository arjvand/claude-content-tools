---

description: Update an existing article with edits, content changes, or structural modifications while maintaining quality standards
argument-hint: [article-id] [update-description] (e.g., "ART-202511-001 Fix the broken link in prerequisites and update WordPress version to 6.7")
---

# Update Article (Cross-Industry)

Update an existing publication-ready article while maintaining brand voice, SEO optimization, and quality standards. Supports minor fixes, moderate adjustments, and major structural changes.

## Usage

```bash
/update-article ART-202511-001 Fix the broken link in the prerequisites section
/update-article ART-202511-002 Update the WordPress version references from 6.5 to 6.7
/update-article ART-202511-003 Add a new section about accessibility best practices after the main content
```

* First argument: Article ID (e.g., ART-202511-001)
* Second argument: Natural language description of the update request

---

## Phase 0: Load Configuration & Locate Article

### Step 0A: Load Project Configuration

Read the configuration to ensure updates maintain brand voice and quality:

```bash
!cat project/requirements.md
```

**Extract and store these values:**

* **Brand Voice** (tone, style guide, DO/DON'T examples)
* **Audience segments & reading level**
* **Content specs** (word count range, formats, depth)
* **SEO requirements** (keyword density, meta length, internal linking rules)
* **Compliance & Disclaimers** (claims policy, regulatory notes)
* **CMS platform** (WordPress/Gutenberg export preferences)

### Step 0B: Locate and Verify Article

**Verify article directory exists:**

```bash
ls -la "project/Articles/$1/"
```

**Error handling:** If article not found:
```markdown
## Article Not Found

Article ID `$1` does not exist.

**Available articles:**
[List all article IDs from project/Articles/]

Please verify the article ID and try again.
```

### Step 0C: Load Existing Article Files

Read the current article state:

```bash
# Current article content
!cat "project/Articles/$1/article.md"

# Article metadata
!cat "project/Articles/$1/meta.yml"

# Research sources (for fact-checking context)
!cat "project/Articles/$1/research-brief.md"
```

### Step 0D: Display Current Article State

Present article summary before proceeding:

```markdown
## Current Article State

**Article ID:** $1
**Title:** [from meta.yml]
**Status:** [from meta.yml]
**Word Count:** [current count]
**Last Updated:** [from meta.yml or publish_date]
**Category:** [from meta.yml]

**Update Request:** $2
```

---

## Phase 1: Classify Update Request

Analyze the update request `$2` and auto-classify into one of three tiers.

### Classification Decision Tree

**MINOR Updates** (Direct edit, no agents):
- Keywords: "fix", "typo", "typos", "spelling", "grammar", "broken link", "formatting", "punctuation"
- Scope: Surface-level corrections that don't change meaning
- Examples:
  - "Fix the typo in paragraph 3"
  - "Update the broken link to WordPress docs"
  - "Fix grammar in the introduction"

**MODERATE Updates** (@editor review + formal report):
- Keywords: "update", "change", "modify", "tweak", "adjust", "add example", "remove example", "clarify", "rephrase", "SEO"
- Scope: Content adjustments within existing structure
- Examples:
  - "Update the version number from 6.5 to 6.7"
  - "Add a code example to the troubleshooting section"
  - "Clarify the explanation of caching mechanisms"
  - "Update the meta description for better CTR"

**MAJOR Updates** (@writer + @editor + formal reports):
- Keywords: "add section", "new section", "remove section", "restructure", "rewrite", "reorder", "expand", "significant"
- Scope: Structural changes or substantial content additions
- Examples:
  - "Add a new section about performance optimization"
  - "Restructure the article to lead with benefits"
  - "Rewrite the introduction to be more engaging"
  - "Remove the outdated comparison table and add a new one"

### Determine Validation Requirements

Based on classification, set validation flags:

```markdown
## Update Classification: [MINOR/MODERATE/MAJOR]

**Detected indicators:** [list matching keywords/patterns]

### Validation Plan

| Check | Required | Reason |
|-------|----------|--------|
| Word count | Yes | Always verify final count |
| Spelling/style | [Yes/No] | [If content changed] |
| Link validation | [Yes/No] | [If links changed/added] |
| Fact-checker | [Yes/No] | [If new claims/stats added] |
| SEO optimization | [Yes/No] | [If significant content or meta changes] |
| Requirements validation | [Yes/No] | [MAJOR updates only] |
| @editor review | [Yes/No] | [MODERATE and MAJOR only] |

**Proceeding with [TIER] update workflow...**
```

---

## Phase 2: Apply Changes

Route to appropriate change workflow based on classification.

### For MINOR Updates

Apply changes directly without agent involvement:

1. **Identify specific changes** from update request
2. **Make targeted edits** to `article.md`
3. **Show diff preview** of changes made

```markdown
## Changes Applied (MINOR)

**File:** project/Articles/$1/article.md

### Diff Preview
[Show before/after for each change]

**Changes made:**
- [Change 1 summary]
- [Change 2 summary]
```

4. **Skip to Phase 4** (Update Metadata)

---

### For MODERATE Updates

Apply changes with Claude's direct editing, then route to @editor:

1. **Analyze update request** for specific changes needed
2. **Review existing content** for context
3. **Make targeted edits** to `article.md`
4. **Show diff preview** of changes

```markdown
## Changes Applied (MODERATE)

**File:** project/Articles/$1/article.md

### Diff Preview
[Show before/after for each change]

**Changes made:**
- [Change 1 summary]
- [Change 2 summary]

**Proceeding to validation...**
```

5. **Continue to Phase 3** for validation

---

### For MAJOR Updates

Invoke @writer agent for content changes:

```markdown
## Major Update: Delegating to @writer

**@writer — Modify the article according to the update request.**

### Inputs
- **Current article:** project/Articles/$1/article.md
- **Research brief:** project/Articles/$1/research-brief.md
- **Gap analysis:** project/Articles/$1/gap-analysis-report.md (if exists)
- **Update request:** $2

### Requirements
1. **Maintain brand voice** — Follow requirements.md voice guidelines
2. **Preserve existing structure** — Only modify sections explicitly requested
3. **Keep differentiation tactics** — Maintain unique value from gap analysis
4. **Follow content specs** — Word count, reading level, format rules
5. **Cite sources** — Any new claims must reference research brief or new sources

### Output
Save updated article to: `project/Articles/$1/article.md`

**Note any new claims or statistics added for fact-checking.**
```

After @writer completes:

```markdown
## @writer Update Complete

**Changes applied:**
- [Summary of structural changes]
- [New sections added]
- [Sections modified]

**New claims requiring verification:**
- [List any new factual claims for fact-checker]

**Proceeding to validation...**
```

---

## Phase 3: Validation Suite

Run validations based on classification and change content.

### 3A: Word Count Check (ALWAYS)

```bash
wc -w "project/Articles/$1/article.md"
```

**Validation:**
- Compare against word count range from requirements.md
- Flag if outside configured range (e.g., 900-2000 words)

```markdown
### Word Count Validation

| Metric | Value |
|--------|-------|
| Previous | [old count] words |
| Current | [new count] words |
| Target Range | [min]-[max] words |
| Status | [PASS/WARN] |
```

---

### 3B: Spelling and Style Check (if content changed)

**Check for:**
- UK/US spelling consistency per requirements.md
- No introduced typos
- Brand terminology compliance

```bash
# Check for UK spelling in US-configured project (or vice versa)
grep -E "(optimise|colour|centre|analyse|behaviour)" "project/Articles/$1/article.md"
```

---

### 3C: Link Validation (if links changed)

**For internal links:**
- Verify paths exist in project structure
- Check anchor text is descriptive

**For external links:**
- Note URLs for manual verification
- Flag any suspicious or outdated domains

---

### 3D: Fact-Checker Skill (if new claims detected)

**Invoke only if update introduces:**
- New statistics or numerical data
- New comparative claims
- New product/feature assertions
- Updated version numbers or dates
- New expert quotes or attributions

```markdown
**Invoking fact-checker skill (comprehensive mode)**

Skill: fact-checker

Inputs:
- Target file: project/Articles/$1/article.md
- Mode: comprehensive
- Focus: [Specific new claims from update]

**Checking:**
1. [New claim 1] — Source verification
2. [New claim 2] — Source verification
...
```

**Output:** Update or create `project/Articles/$1/claim-audit-full.md`

**Decision tree:**
- **PASS**: All claims verified HIGH/MODERATE confidence → Continue
- **WARN**: Some MODERATE claims → Document, proceed with caution flags
- **FAIL**: Unverified required claims → Block, request user verification

---

### 3E: SEO Optimization Check (if significant changes)

**Invoke if:**
- Meta description changed
- New sections added
- Keyword density may be affected
- Title or H1/H2 headers modified

```markdown
**Invoking seo-optimization skill**

Skill: seo-optimization

Inputs:
- Target file: project/Articles/$1/article.md
- Configuration: project/requirements.md
- Focus areas: [Areas affected by update]

**Checking:**
- Primary keyword density (target: 1-2%)
- Keyword placement in headers
- Meta description length (150-160 chars)
- Internal linking opportunities
```

**Output:** Update `project/Articles/$1/seo-optimization-report.md`

---

### 3F: Requirements Validation (MAJOR updates only)

```markdown
**Invoking requirements-validator skill**

Skill: requirements-validator

Inputs:
- Target file: project/Articles/$1/article.md
- Configuration: project/requirements.md

**Full checklist:**
- Brand voice compliance
- Audience fit (reading level, terminology)
- Content specs (length, format, depth)
- SEO requirements
- Distribution readiness
- Compliance flags
```

---

### 3G: Editor Review (MODERATE and MAJOR)

```markdown
## Editorial Review Required

**@editor — Review the updated article for quality and consistency.**

### Context
- **Article ID:** $1
- **Update Type:** [MODERATE/MAJOR]
- **Update Description:** $2
- **Changes Applied:** [Summary from Phase 2]

### Review Focus
1. **Accuracy** — Changes are factually correct
2. **Consistency** — No contradictions with existing content
3. **Voice** — Brand voice maintained throughout
4. **Flow** — Changes integrate smoothly
5. **Regressions** — No quality loss from original

### Inputs
- **Updated article:** project/Articles/$1/article.md
- **Original research:** project/Articles/$1/research-brief.md
- **Gap analysis:** project/Articles/$1/gap-analysis-report.md
- **Previous meta:** project/Articles/$1/meta.yml
- **Configuration:** project/requirements.md

### Output
Save editorial review to: `project/Articles/$1/editorial-review-report.md`

**Decision:**
- **APPROVED** — Ready for publication
- **MINOR REVISIONS** — Small fixes needed (apply and re-validate)
- **MAJOR REVISIONS** — Significant issues (escalate to user)
```

---

## Phase 4: Update Metadata

Update `meta.yml` with change tracking.

### 4A: Update Core Fields

```yaml
# Update these fields in meta.yml
last_updated: "YYYY-MM-DD"
word_count: [new count from wc -w]
status: "updated"
```

### 4B: Add Changelog Entry

**Append to changelog array in meta.yml:**

```yaml
changelog:
  - date: "YYYY-MM-DD"
    type: "minor|moderate|major"
    description: "[Brief description from $2]"
    changes:
      - file: article.md
        summary: "[What was changed]"
      - file: meta.yml
        summary: "Updated word count and changelog"
```

**Example:**

```yaml
changelog:
  - date: "2025-12-06"
    type: "minor"
    description: "Fixed broken link in Prerequisites section"
    changes:
      - file: article.md
        summary: "Updated WordPress.org documentation link from /docs/6.5 to /docs/6.7"
```

### 4C: Update Validation Status (if applicable)

If validations were run, update:

```yaml
validation_status:
  requirements_compliance: [passed/failed]
  brand_voice: [compliant/needs_review]
  seo_optimization: [strong/moderate/weak]
  factual_accuracy: [verified/pending/needs_review]
  last_validated: "YYYY-MM-DD"
```

---

## Phase 5: Regenerate Exports (if configured)

### 5A: HTML Export (if WordPress/Gutenberg configured)

Check `meta.yml` for export configuration:

```yaml
exports:
  cms_platform: "WordPress"
  html_export: true
  gutenberg_blocks: true
```

**If HTML export enabled:**

```markdown
**Invoking gutenberg-formatter skill**

Skill: gutenberg-formatter

Inputs:
- Source: project/Articles/$1/article.md
- Configuration: project/requirements.md

Output: project/Articles/$1/article.html
```

---

## Phase 6: Summary Report

Generate completion report for user.

```markdown
## Article Update Complete

**Article ID:** $1
**Title:** [from meta.yml]
**Update Type:** [Minor/Moderate/Major]
**Date:** YYYY-MM-DD

---

### Update Request
> $2

---

### Changes Applied
- [Change 1 summary]
- [Change 2 summary]
- [Change 3 summary]

---

### Validation Results

| Check | Status | Notes |
|-------|--------|-------|
| Word Count | [PASS/WARN] | [X] words (target: [min]-[max]) |
| Spelling/Style | [PASS/SKIP] | [US/UK] English consistent |
| Link Validation | [PASS/SKIP] | [N] links verified |
| Fact-Check | [PASS/SKIP/WARN] | [N] claims verified |
| SEO | [PASS/SKIP] | Keyword density [X]% |
| Requirements | [PASS/SKIP] | [Notes] |
| Editor Review | [APPROVED/SKIP] | [Quality rating] |

---

### Files Modified
- `project/Articles/$1/article.md` — Content updated
- `project/Articles/$1/meta.yml` — Changelog added
- `project/Articles/$1/editorial-review-report.md` — [Created/Updated] (MODERATE/MAJOR only)
- `project/Articles/$1/article.html` — Regenerated (if configured)

---

### Changelog Entry Added

```yaml
- date: "YYYY-MM-DD"
  type: "[tier]"
  description: "[summary]"
```

---

**Status:** Ready for republication
```

---

## Error Handling

### Article Not Found

```markdown
## Error: Article Not Found

Article ID `$1` does not exist in project/Articles/.

**Available articles:**
[List all available article IDs]

**Usage:**
```bash
/update-article [article-id] [update-description]
```
```

### Validation Failure (Non-Critical)

```markdown
## Warning: Validation Issue

The following validation(s) flagged concerns:

| Check | Issue | Recommendation |
|-------|-------|----------------|
| [Check] | [Issue description] | [Suggested fix] |

**Options:**
1. Proceed anyway (add note to changelog)
2. Address issues and re-run update
3. Abort update
```

### Validation Failure (Critical)

```markdown
## Error: Critical Validation Failure

Cannot proceed with update due to:

| Issue | Details | Required Action |
|-------|---------|-----------------|
| [Issue] | [Details] | [What user must do] |

**Update blocked.** Please resolve the issues above and try again.
```

### Fact-Check Failure

```markdown
## Error: Unverified Claims

The following new claims could not be verified:

| Claim | Source Status | Required Action |
|-------|---------------|-----------------|
| "[Claim text]" | Unverified | Provide authoritative source |

**Options:**
1. Provide sources for verification
2. Remove/modify unverified claims
3. Abort update
```

---

## Quick Reference: Common Update Patterns

### Fix a Typo (MINOR)
```bash
/update-article ART-202511-001 Fix the typo "recieve" in paragraph 2
```

### Update a Link (MINOR)
```bash
/update-article ART-202511-001 Update the broken WordPress docs link to the 6.7 documentation
```

### Update a Version Number (MODERATE)
```bash
/update-article ART-202511-001 Update all WordPress version references from 6.5 to 6.7
```

### Add an Example (MODERATE)
```bash
/update-article ART-202511-001 Add a code example showing error handling in the troubleshooting section
```

### Update SEO Metadata (MODERATE)
```bash
/update-article ART-202511-001 Update the meta description to include "2025" and improve CTR
```

### Add a New Section (MAJOR)
```bash
/update-article ART-202511-001 Add a new section about accessibility best practices after the main content
```

### Restructure Article (MAJOR)
```bash
/update-article ART-202511-001 Restructure the article to lead with benefits before explaining the technical details
```

---

## Directory Structure

```
project/Articles/
└── ART-202511-001/
    ├── article.md              # Updated content
    ├── meta.yml                # Updated with changelog
    ├── research-brief.md       # Reference (unchanged)
    ├── gap-analysis-report.md  # Reference (unchanged)
    ├── editorial-review-report.md  # Created/Updated (MODERATE/MAJOR)
    ├── claim-audit-full.md     # Updated (if new claims)
    ├── seo-optimization-report.md  # Updated (if SEO changes)
    └── article.html            # Regenerated (if configured)
```
