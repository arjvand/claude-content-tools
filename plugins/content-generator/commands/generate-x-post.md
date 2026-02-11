---
name: generate-x-post
description: Generate a full X (Twitter) thread from a published article
argument-hint: [article-id] (e.g., "ART-202511-001")
allowed-tools: Read, Write, Bash, Glob, Grep
---

# Generate X Thread from Article

Generate a 7-tweet X (Twitter) thread from an existing article, optimized for engagement and brand voice.

## Usage

```bash
/generate-x-post ART-202511-001
```

* Argument: Article ID (e.g., ART-202511-001)

---

## Phase 0: Validate Article

### Step 1: Verify Article Exists

```bash
ls -la "project/Articles/$1/"
```

**Required files:**
- `article.md` (final article content)
- `meta.yml` (article metadata)

**BLOCKING CHECKPOINT:** If article directory doesn't exist or required files are missing, STOP and report error:

```
ERROR: Article not found at project/Articles/[ARTICLE-ID]/
ACTION: Verify article ID and ensure article has been generated via /write-article
```

---

## Phase 1: Generate Thread

**Invoke the `x-thread-generator` skill:**

```
Please use the x-thread-generator skill to generate an X thread.

**Inputs:**
- Article ID: $1
- Article path: project/Articles/$1/article.md
- Metadata path: project/Articles/$1/meta.yml

**Output:** project/Articles/$1/x-thread.md
```

The skill will:
1. Load brand configuration from `project/requirements.md`
2. Extract tweetable content from the article
3. Generate a 7-tweet thread (hook → framework → evidence → before/after → standards → audit → CTA)
4. Validate character limits and brand voice
5. Save output to `project/Articles/[ARTICLE-ID]/x-thread.md`

---

## Phase 2: Summary Report

After the skill completes, output summary:

```markdown
## X Thread Generated

**Article ID:** [ARTICLE-ID]
**Article:** [Title from meta.yml]
**Thread Length:** 7 tweets
**Total Characters:** [sum] / 1,960 max

### Validation
- ✅ All tweets under 280 characters
- ✅ Brand voice compliant
- ✅ Hashtags: [count] (2-4 recommended)
- ✅ CTA present in Tweet 7
- ✅ Link placeholder included

### File Created
- `project/Articles/[ARTICLE-ID]/x-thread.md`

### Next Steps
1. Replace `[LINK]` with UTM-tracked URL
2. Schedule thread posting
3. Monitor engagement and respond to replies
```

---

## Error Handling

### Article Not Found
```
ERROR: Article directory not found at project/Articles/[ARTICLE-ID]/
ACTION: Verify article ID and ensure article has been generated via /write-article
```

### Missing Required Files
```
ERROR: Required file missing: [article.md|meta.yml]
ACTION: Ensure article is complete with both article.md and meta.yml
```

### Skill Errors

If the `x-thread-generator` skill reports errors, display them and suggest remediation.
