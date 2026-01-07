---
name: update-article
description: Update an existing article with edits, content changes, or structural modifications while maintaining quality standards
argument-hint: [article-id] [update-description] (e.g., "ART-202511-001 Fix the broken link in prerequisites and update WordPress version to 6.7")
---

# Update Article (Cross-Industry)

Update an existing publication-ready article while maintaining brand voice, SEO optimization, and quality standards. Supports minor fixes, moderate adjustments, and major structural changes.

## Usage

```bash
/update-article ART-202511-001 Fix the broken link in the prerequisites section
/update-article ART-202511-002 Update the WordPress version references from 6.5 to 6.7
/update-article ART-202511-003 Add a new section about accessibility best practices
```

* First argument: Article ID (e.g., ART-202511-001)
* Second argument: Natural language description of the update request

---

## Workflow Overview

This command routes updates through appropriate validation based on complexity:

```
Phase 1: Setup
├── requirements-loader → Validate config
├── Locate article → Verify exists
└── Classify update → MINOR | MODERATE | MAJOR

Phase 2: Apply Changes (by tier)
├── MINOR → Direct edit (no agents)
├── MODERATE → Direct edit → @editor
└── MAJOR → @writer → @editor

Phase 3: Validation (by tier)
├── MINOR → Word count only
├── MODERATE → fact-checker (if new claims) → seo-optimizer
└── MAJOR → fact-checker → seo-optimizer → cms-exporter

Phase 4: Finalization
├── Update meta.yml changelog
└── Generate summary report
```

---

## Phase 1: Setup & Classification

### Step 1A: Load Configuration

**Invoke `requirements-loader` agent:**

```
Invoke requirements-loader agent for full config extraction.
```

**Blocking Gate:** If validation errors → STOP.

---

### Step 1B: Locate Article

```bash
ls -la "project/Articles/$1/"
```

**Error handling:** If not found, list available articles and exit.

---

### Step 1C: Classify Update Request

Analyze `$2` and auto-classify:

| Tier | Keywords | Scope | Agent Workflow |
|------|----------|-------|----------------|
| **MINOR** | fix, typo, spelling, grammar, broken link, formatting | Surface-level | Direct edit only |
| **MODERATE** | update, change, modify, add example, clarify, SEO | Content within structure | @editor review |
| **MAJOR** | add section, restructure, rewrite, expand | Structural changes | @writer + @editor |

**Time:** <1 minute

---

## Phase 2: Apply Changes

### For MINOR Updates

Apply changes directly:

1. Identify specific changes from update request
2. Make targeted edits to `article.md`
3. Show diff preview
4. **Skip to Phase 4** (metadata update)

**Time:** 2-5 minutes

---

### For MODERATE Updates

Apply changes with editor review:

1. Make targeted edits to `article.md`
2. Show diff preview

**Invoke `@editor` agent:**

```
Invoke @editor agent.
Article ID: [ARTICLE-ID]
Draft: project/Articles/[ARTICLE-ID]/article.md
Update Type: MODERATE
Update Description: $2
```

**Time:** 10-15 minutes

---

### For MAJOR Updates

**Invoke `@writer` agent:**

```
Invoke @writer agent.
Article ID: [ARTICLE-ID]
Current Article: project/Articles/[ARTICLE-ID]/article.md
Research Brief: project/Articles/[ARTICLE-ID]/research-brief.md
Update Request: $2
Mode: Update (preserve existing structure except for requested changes)
```

**Then invoke `@editor` agent:**

```
Invoke @editor agent.
Article ID: [ARTICLE-ID]
Draft: project/Articles/[ARTICLE-ID]/article.md
Update Type: MAJOR
Update Description: $2
```

**Time:** 20-30 minutes

---

## Phase 3: Validation Suite

### Step 3A: Word Count Check (ALWAYS)

```bash
wc -w "project/Articles/$1/article.md"
```

Compare against configured range.

---

### Step 3B: Fact-Checker (if new claims)

**Invoke `fact-checker` agent (if MODERATE/MAJOR with new claims):**

```
Invoke fact-checker agent in comprehensive mode.
Article ID: [ARTICLE-ID]
Source: project/Articles/[ARTICLE-ID]/article.md
Focus: [Specific new claims from update]
```

**Blocking Gate:** If FAIL → block, request user verification.

**Time:** 5-10 minutes

---

### Step 3C: SEO Optimization (MODERATE/MAJOR)

**Invoke `seo-optimizer` agent:**

```
Invoke seo-optimizer agent.
Article: project/Articles/[ARTICLE-ID]/article.md
Primary Keyword: "[from meta.yml]"
```

**Time:** 2-3 minutes

---

### Step 3D: CMS Export (MAJOR only)

**Invoke `cms-exporter` agent:**

```
Invoke cms-exporter agent.
Article: project/Articles/[ARTICLE-ID]/article.md
Format: [from config]
```

**Time:** 30-60 seconds

---

## Phase 4: Finalization

### Step 4A: Update Metadata

Update `meta.yml` with:

```yaml
last_updated: "YYYY-MM-DD"
word_count: [new count]
status: "updated"

changelog:
  - date: "YYYY-MM-DD"
    type: "minor|moderate|major"
    description: "[Brief description from $2]"
    changes:
      - file: article.md
        summary: "[What was changed]"
```

---

### Step 4B: Summary Report

```markdown
## Article Update Complete

**Article ID:** $1
**Title:** [from meta.yml]
**Update Type:** [Minor/Moderate/Major]
**Date:** YYYY-MM-DD

### Update Request
> $2

### Changes Applied
- [Change 1 summary]
- [Change 2 summary]

### Validation Results
| Check | Status | Notes |
|-------|--------|-------|
| Word Count | [PASS/WARN] | [X] words |
| Fact-Check | [PASS/SKIP] | [N] claims verified |
| SEO | [PASS/SKIP] | Keyword density [X]% |
| Editor Review | [APPROVED/SKIP] | [Quality rating] |

**Status:** Ready for republication
```

---

## Time Estimate

| Update Type | Duration |
|-------------|----------|
| MINOR | 2-5 minutes |
| MODERATE | 15-25 minutes |
| MAJOR | 30-45 minutes |

---

## Error Handling

| Error | Response |
|-------|----------|
| Article not found | List available articles |
| Validation warning | Show options: proceed, fix, abort |
| Unverified claims | Block until sources provided |

---

## Quick Reference

```bash
# Fix typo (MINOR)
/update-article ART-202511-001 Fix the typo "recieve" in paragraph 2

# Update version (MODERATE)
/update-article ART-202511-001 Update WordPress version from 6.5 to 6.7

# Add section (MAJOR)
/update-article ART-202511-001 Add new section about accessibility best practices
```

---

## Output Files

| File | Updated When |
|------|--------------|
| `article.md` | Always |
| `meta.yml` | Always (changelog) |
| `claim-audit-full.md` | If new claims (MODERATE/MAJOR) |
| `seo-audit.md` | MODERATE/MAJOR |
| `article.html` | MAJOR only |
