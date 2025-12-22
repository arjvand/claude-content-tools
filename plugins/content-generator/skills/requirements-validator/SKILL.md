---
description: Validate content against requirements.md specifications. Use when reviewing articles to ensure they meet brand voice, audience level, length, and format requirements.
allowed-tools: Bash(cat:project/requirements.md), Bash(wc:*)
---

# Requirements Validator Skill

## Purpose
Ensure articles comply with editorial requirements and brand standards based on requirements.md configuration.

## When to Use
- Before finalizing any article
- During editorial review
- When checking word count or format

## Configuration-Driven Validation

### Phase 0: Load Configuration (ALWAYS FIRST)

**Before validating any article**, read requirements.md to extract validation criteria:

```bash
!cat project/requirements.md
```

**Extract the following configuration variables:**

1. **Brand Voice**:
   - Look for: `**Traits**:` → [Extract voice characteristics]
   - Look for: **DO** examples → [Extract on-brand language patterns]
   - Look for: **DON'T** examples → [Extract off-brand patterns]

2. **Audience**:
   - Look for: `**Primary Roles**:` → [Extract target audience roles]
   - Look for: `**Skill Level**:` → [Extract level: beginner/intermediate/advanced]
   - Look for: `**Primary Segment**:` → [Extract segment details]

3. **Content Specs**:
   - Look for: `**Length**:` → [Extract word count range]
   - Look for: `**Formats**:` → [Extract allowed formats]
   - Look for: `**Depth**:` → [Extract depth level]
   - Look for: `**Spelling**:` → [Extract US/UK English]

4. **Distribution**:
   - Look for: `**Primary CTA**:` → [Extract CTA requirement]
   - Look for: `**SEO Intent**:` → [Extract SEO strategy]

**Use these extracted values for all validation checks below.**

---

## Validation Checklist

### 1. Read Requirements
```bash
!cat project/requirements.md
```

### 2. Brand Voice Check (from extracted configuration)
- ✅ Matches extracted voice **Traits** from config
- ✅ Follows **DO** examples from config
- ❌ Avoids **DON'T** patterns from config
- ✅ Consistent tone throughout article

### 3. Audience Fit (from extracted configuration)
- Appropriate for extracted **Skill Level** (from config)
- Relevant to extracted **Primary Roles** (from config)
- Serves extracted **Primary Segment** (from config)

### 4. Content Specs (from extracted configuration)
- **Length**: Within extracted word count range (check with `wc -w`)
- **Format**: Matches one of the extracted **Formats** from config
- **Depth**: Matches extracted **Depth** level from config
- **Language**: Follows extracted **Spelling** style from config

### 5. SEO Requirements (from extracted configuration)
- Follows extracted **SEO Intent** strategy from config
- Topic cluster alignment (if configured)
- Internal linking opportunities identified

### 6. Distribution Ready (from extracted configuration)
- Extracted **Primary CTA** included (from config)
- RSS-friendly format
- Clear meta description
- Ready for extracted **Distribution Channels** (from config)

## Output Format
Provide validation report:
- ✅ Passes / ❌ Fails for each requirement
- Word count actual vs target
- Required revisions
- Ready for publication: Yes/No