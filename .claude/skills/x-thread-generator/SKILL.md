---
description: Generate optimized X (Twitter) threads from article content
---

# X Thread Generator Skill

Generate engaging 7-tweet X (Twitter) threads from published articles, optimized for engagement and brand voice.

---

## Purpose

Transform article content into a structured X thread that:
- Maximizes engagement through proven thread structure
- Maintains brand voice consistency
- Stays within platform character limits
- Includes proper CTAs and hashtags

---

## Character Counting on X

**CRITICAL: X counts characters differently than plain text.**

| Element | Character Count |
|---------|-----------------|
| Regular text | 1 char each |
| Newline (`\n`) | **1 char each** |
| Emoji | 2 chars each (most) |
| URL | 23 chars (auto-shortened) |
| Arrow (→) | 1 char |

**Common mistakes:**
- Forgetting newlines count as characters
- Multi-line lists consume 1 char per line break
- Blank lines = 2 extra chars (newline + newline)

**Example counting:**
```
Hello world
Line 2
```
= 11 + 1 (newline) + 6 = **18 chars** (not 17)

**Safe limits per tweet type:**

| Tweet | Budget | Notes |
|-------|--------|-------|
| Hook | ≤200 | Leave room for engagement |
| Framework | ≤260 | Numbered lists need compression |
| Evidence | ≤275 | Some flexibility |
| Before/After | ≤270 | ❌/✅ each = 2 chars |
| Standards | ≤275 | Bullet points need care |
| Audit | ≤270 | Checkmarks + text |
| CTA | ≤270 | Must fit link placeholder + hashtags |

---

## When to Use

**Automatic triggers:**
- After article completion in `/write-article` (Phase 8: Exports & Packaging)
- During `@editor` final review for distribution prep

**Manual triggers:**
- Via `/generate-x-post` command for any published article
- When preparing social distribution for existing content

---

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| Article ID | Command argument | Yes |
| Article content | `project/Articles/[ARTICLE-ID]/article.md` | Yes |
| Article metadata | `project/Articles/[ARTICLE-ID]/meta.yml` | Yes |
| Brand configuration | `project/requirements.md` | Yes |

### Required Fields from meta.yml

- `title` - Article headline
- `slug` - URL slug for links
- `target_keyword` - Primary hashtag source
- `secondary_keywords` - Additional hashtag options
- `primary_cta` - Call-to-action text

### Optional Fields from meta.yml

- `meta_description` - Condensed summary (backup for hook)
- `differentiation_tactics` - Unique angles to emphasize
- `audience` - Target audience for tone adjustment

---

## Process

### Step 1: Load Configuration

Read `project/requirements.md` and extract:
- Brand voice traits
- DO/DON'T examples
- Primary CTA patterns
- Brand name and positioning

### Step 2: Load Article Sources

Read both files:
```bash
cat "project/Articles/[ARTICLE-ID]/article.md"
cat "project/Articles/[ARTICLE-ID]/meta.yml"
```

### Step 3: Content Extraction

Scan article for tweetable content:

| Tweet Position | What to Find | Search Pattern |
|----------------|--------------|----------------|
| **Tweet 1: Hook** | Opening question or bold statement | First paragraph, TL;DR section |
| **Tweet 2: Framework** | Numbered list (4-5 items) | `## N Things/Steps/Signals`, numbered lists |
| **Tweet 3: Evidence** | Statistics with attribution | Percentages, bold numbers, data claims |
| **Tweet 4: Before/After** | Transformation example | Teardown sections, contrast patterns |
| **Tweet 5: Standards** | Current requirements | `## 2025`, `## What Changed`, timely updates |
| **Tweet 6: Audit** | Checklist items | `## Quick Audit`, `### Checklist`, bullet lists |
| **Tweet 7: CTA** | Call-to-action | Final section, conclusion |

**Extraction priorities:**
- Content with specific metrics (percentages, timeframes, counts)
- Before/after patterns with clear contrast
- Frameworks with 4-5 items (not too few, not overwhelming)
- Timely angles (2025 standards, recent changes)

### Step 4: Thread Generation

Generate 7 tweets following this structure:

---

#### Tweet 1: Hook

**Purpose:** Stop the scroll, create curiosity

```
[Provocative question OR bold statement from article intro]

[Brief promise of value / what they'll learn]

🧵
```

**Guidelines:**
- Open with a question that challenges assumptions OR make a bold, specific claim
- Keep under 200 chars to leave room for engagement

---

#### Tweet 2: Framework

**Purpose:** Deliver structured value

**Budget:** ≤260 chars (tight due to list format)

```
[N] [things] [audience] [should know]:
1. Item→brief why
2. Item→brief why
3. Item→brief why
4. Item→brief why
```

**Guidelines:**
- **Max 4 items** (not 5-6) to stay within budget
- No blank line between intro and list
- Use `→` without spaces (saves 2 chars per item)
- Keep items short: `Skill Level→senior = fewer revisions` not `Skill Level → a senior produces fewer revisions`
- If over budget: cut to 3 items or shorten descriptions

---

#### Tweet 3: Evidence

**Purpose:** Build credibility with data

```
[Key insight or statistic from article]

[Supporting evidence with attribution/source]

[Implication for reader / why it matters]
```

**Guidelines:**
- Include specific numbers (percentages, timeframes)
- Attribute sources when possible
- Connect data to reader's situation

---

#### Tweet 4: Before/After

**Purpose:** Show transformation

```
Before/After:

❌ "[Generic/wrong way]"
✅ "[Specific/right way]"

[Why the after version works]
```

**Guidelines:**
- Use clear contrast indicators (❌/✅)
- Keep examples specific and relatable
- Explain the transformation value

---

#### Tweet 5: Current Standards

**Purpose:** Add timeliness and urgency

```
[Year] [standards/requirements/updates]:

• [Item 1]
• [Item 2]
• [Item 3]
• [Item 4]

[Call to stay current / urgency statement]
```

**Guidelines:**
- Reference current year (2025)
- Include regulatory/industry standards when relevant
- Create urgency without hype

---

#### Tweet 6: Quick Audit

**Purpose:** Drive self-assessment engagement

```
Quick audit: [Does your X signal Y?]

[Item 1] ✓
[Item 2] ✓
[Item 3] ✓
[Item 4] ✓
[Item 5] ✓

[Score interpretation / urgency statement]
```

**Guidelines:**
- Make it immediately actionable
- Use checkmarks (✓) for visual scanning
- Include a score/threshold interpretation

---

#### Tweet 7: CTA

**Purpose:** Convert interest to action

```
Full [guide/article/resource] with [specific value]:

[LINK]

[Brand mention] — [brand positioning statement]

#[Hashtag1] #[Hashtag2] #[Hashtag3]
```

**Guidelines:**
- Mention specific value in the full article
- Include `[LINK]` placeholder for UTM-tracked URL
- Add 2-4 relevant hashtags (derived from keywords)
- End with brand mention and positioning

---

### Step 5: Quality Validation

**Per-tweet checks:**

| Check | Requirement | Action if Fail |
|-------|-------------|----------------|
| Character count | **≤280 chars INCLUDING newlines** | Trim content, remove blank lines, cut items |
| Standalone value | Each tweet works alone | Add context if needed |
| Brand voice | Matches requirements.md | Revise tone (no hype, plain-spoken) |
| Thread flow | Logical progression | Reorder if needed |

**⚠️ Character counting verification:**
1. Count all visible characters
2. **Add 1 for each line break** (including at end of lines)
3. Add 2 for each emoji
4. If result >280, compress until compliant

**Thread-level checks:**

| Check | Requirement |
|-------|-------------|
| Hook compelling | Opens with question or bold statement (≤200 chars) |
| Framework clear | **Max 4 items**, no blank lines (≤260 chars) |
| Evidence attributed | Source/data cited |
| Before/After specific | Clear transformation shown |
| Standards current | References current year |
| Audit actionable | Can be done immediately |
| CTA clear | Link placeholder + brand + hashtags |

**Hashtag guidelines:**
- Count: 2-4 hashtags in Tweet 7 only
- Sources: `target_keyword`, `secondary_keywords` from meta.yml
- Format: CamelCase (e.g., #FreelancePortfolio, #CreatorEconomy)
- Avoid: Generic hashtags (#Success, #Tips), excessive hashtags

### Step 6: Output Generation

Save to: `project/Articles/[ARTICLE-ID]/x-thread.md`

---

## Output Format

```markdown
# X Thread: [ARTICLE-ID]
## [Article Title]

**Article ID:** [ARTICLE-ID]
**Generated:** YYYY-MM-DD
**Source:** article.md, meta.yml
**Primary CTA:** [CTA from meta.yml]

---

## Thread (7 tweets)

### Tweet 1 (Hook)
**Characters:** [count]

[Tweet content]

---

### Tweet 2 (Framework)
**Characters:** [count]

[Tweet content]

---

### Tweet 3 (Evidence)
**Characters:** [count]

[Tweet content]

---

### Tweet 4 (Before/After)
**Characters:** [count]

[Tweet content]

---

### Tweet 5 (Current Standards)
**Characters:** [count]

[Tweet content]

---

### Tweet 6 (Quick Audit)
**Characters:** [count]

[Tweet content]

---

### Tweet 7 (CTA)
**Characters:** [count]
**Hashtags:** [count]

[Tweet content]

---

## Thread Summary

| Tweet | Type | Characters |
|-------|------|------------|
| 1 | Hook | [n] |
| 2 | Framework | [n] |
| 3 | Evidence | [n] |
| 4 | Before/After | [n] |
| 5 | Current Standards | [n] |
| 6 | Quick Audit | [n] |
| 7 | CTA | [n] |
| **Total** | | [sum] |

---

## Link Template

Replace `[LINK]` with UTM-tracked URL:

```
https://thebluemango.xyz/blog/[slug]?utm_source=twitter&utm_medium=social&utm_campaign=[article-id]
```

---

## Posting Notes

- Post as a thread (reply chain), not individual tweets
- Optimal posting: Weekdays 9-11am or 1-3pm (audience timezone)
- Monitor replies and engage within 24 hours
- Consider pinning high-performing threads

---

**Generation Status:** COMPLETE
**Ready for Posting:** Yes
```

---

## Quality Guidelines

### DO

- Extract the most specific, data-rich content from the article
- Use the exact statistics and metrics from the article (don't round or generalize)
- Match brand voice traits from requirements.md
- Verify each tweet works standalone (someone might see just one)
- Use platform-native formatting (line breaks, bullets, emojis sparingly)

### DON'T

- Exceed 280 characters per tweet **(remember: newlines count as characters!)**
- Use blank lines in multi-line tweets (wastes 2 chars each)
- Use more than 4 items in Framework tweets (use 3-4)
- Use more than 4 hashtags total
- Place hashtags anywhere except Tweet 7
- Use generic hashtags (#Success, #Motivation, #Tips)
- Include hype language or marketing fluff
- Create engagement bait that doesn't deliver value

---

## Error Handling

### Article Not Found
```
ERROR: Article directory not found at project/Articles/[ARTICLE-ID]/
ACTION: Verify article ID and ensure article has been generated
```

### Missing Required Files
```
ERROR: Required file missing: [article.md|meta.yml]
ACTION: Ensure article is complete with both files
```

### Insufficient Content
```
WARNING: Could not extract [content type] from article
ACTION: Using alternative content or placeholder
RECOMMENDATION: Review article structure
```

### Character Limit Exceeded
```
WARNING: Tweet [N] exceeds 280 characters ([count] chars including newlines)
ACTION: Trimming content to fit
RECOMMENDATION: Review trimmed tweet for clarity
```

**Common fixes for over-limit tweets:**
- Remove blank lines (saves 1-2 chars each)
- Reduce Framework items from 5→4 or 4→3
- Shorten item descriptions: `Item→why` not `Item → longer explanation`
- Remove spaces around arrows: `→` not ` → `
- Use shorter intro lines

---

## Integration

### From /generate-x-post Command

```markdown
**Invoke the `x-thread-generator` skill:**

Please use the x-thread-generator skill to generate an X thread.

**Inputs:**
- Article ID: [ARTICLE-ID]
- Article path: project/Articles/[ARTICLE-ID]/article.md
- Metadata path: project/Articles/[ARTICLE-ID]/meta.yml

**Output:** project/Articles/[ARTICLE-ID]/x-thread.md
```

### From /write-article Command (Phase 8)

```markdown
**Optional: Generate X Thread**

If social distribution is configured, invoke `x-thread-generator` skill:
- Input: Completed article from Phase 6
- Output: x-thread.md alongside article.md
```

### From @editor Agent

```markdown
**Distribution Prep:**

During final packaging, invoke `x-thread-generator` skill to prepare social content for approved articles.
```

---

## Adaptation Notes

This skill adapts to any topic configured in `requirements.md`:
- Brand voice applied to all tweets
- Audience considered for tone and examples
- Keywords used for hashtag generation
- CTA patterns matched to configured style

The thread structure works across content types:
- **How-to articles** → Framework as steps
- **Analysis/POV** → Framework as insights
- **Case studies** → Before/After emphasis
- **News/updates** → Current Standards emphasis
