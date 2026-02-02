---
name: seo-optimization
description: Optimize content for SEO including keyword placement, meta descriptions, internal linking, and content structure. Use when finalizing articles, creating meta descriptions, or structuring content for search engines.
---

# SEO Optimization Skill

## Purpose
Ensure content meets SEO best practices based on requirements.md configuration.

## When to Use
- Finalizing article drafts
- Creating meta descriptions
- Structuring headers and content
- Planning internal links

## Configuration-Driven Approach

**Before optimizing, load configuration using requirements-extractor:**

```markdown
Please use the requirements-extractor skill to load validated configuration from project/requirements.md.
```

**Extract the following from the structured output:**

1. **Topic & Platform**:
   - From `project.industry` → Target domain
   - From `project.platform` → Specific platform

2. **Audience**:
   - From `audience.primary_roles` → Target audience
   - From `audience.skill_level` → Audience level

3. **Official Sources** (for external linking):
   - From `project.official_docs` → Primary documentation URLs
   - From `project.official_blogs` → Official blog URLs
   - From `project.authoritative_sources` → Other authoritative sources

4. **SEO Strategy**:
   - From `seo.intent` → SEO strategy and target queries
   - From `seo.internal_linking` → Internal linking patterns
   - From `seo.primary_cta` → Primary call-to-action

**Use these extracted values throughout the optimization process. The requirements-extractor provides validated, structured configuration.**

---

## Optimization Checklist

### 1. Keyword Strategy
- Primary keyword in H1 (title)
- Primary keyword in first 100 words
- Natural keyword density (1-2%)
- LSI keywords throughout
- Keywords in H2/H3 headers

### 2. Content Structure
- Clear H1 (one per page)
- Logical H2/H3 hierarchy
- Short paragraphs (2-3 sentences)
- Bullet points for scannability
- Image alt text with keywords

### 3. Meta Elements
- Title: 50-60 characters
- Meta description: 150-160 characters
- Both include primary keyword
- Compelling call-to-action

### 4. Internal Linking
- 3-5 relevant internal links
- Descriptive anchor text
- Link to pillar content
- Topic cluster connections

### 5. External Linking
- 2-4 authoritative external links per article
- Link to official documentation (WordPress.org, WooCommerce.com)
- Cite research sources and statistics
- Reference reputable news/industry sources
- Use descriptive anchor text (not "click here")
- Add rel="nofollow" for sponsored/untrusted links
- Verify all links are functional before publishing

### 6. Readability
- Flesch Reading Ease: 60-70
- Average sentence length: 15-20 words
- Active voice preferred
- Transition words for flow

## Output Format
Provide:
- Optimized meta title and description
- Suggested internal links with anchor text
- Suggested external links to authoritative sources
- **SEO score (0-100) with minimum threshold gate (NEW)**
- SEO score checklist
- Improvement recommendations

---

## SEO Scoring System (NEW)

**Objective:** Calculate quantitative SEO readiness score with minimum publication threshold

**Scoring Breakdown (100 points total):**

### Core Elements (70 points)

**Primary Keyword Placement (30 points):**
- [10 pts] Primary keyword in H1 (title)
- [10 pts] Primary keyword in first 100 words
- [10 pts] Primary keyword in at least one H2 heading

**Keyword Density (10 points):**
- [10 pts] Keyword density 1-2% (optimal)
- [6 pts] Keyword density 0.5-1% or 2-2.5% (acceptable)
- [0 pts] Keyword density <0.5% or >2.5% (poor)

**Meta Elements (20 points):**
- [10 pts] Meta title ≤60 chars with primary keyword
- [10 pts] Meta description 150-160 chars with keyword + CTA

**Internal Links (10 points):**
- [10 pts] 3-5 internal links (tier-adjusted)
- [6 pts] 2 internal links
- [3 pts] 1 internal link
- [0 pts] 0 internal links

### Structure & Quality (30 points)

**Heading Hierarchy (10 points):**
- [10 pts] Logical H1→H2→H3 hierarchy with no skips
- [6 pts] Minor hierarchy issues
- [0 pts] Major hierarchy problems

**Readability (10 points):**
- [10 pts] Short paragraphs (2-4 sentences), good scannability
- [6 pts] Some long paragraphs (5-6 sentences)
- [0 pts] Dense walls of text

**External Links (5 points):**
- [5 pts] 2-4 authoritative external links
- [3 pts] 1 external link
- [0 pts] 0 external links

**URL Slug (5 points):**
- [5 pts] Optimized slug with primary keyword
- [3 pts] Decent slug
- [0 pts] Poor slug (random characters, too long)

---

**Total Possible:** 100 points

**Minimum Threshold:** 75 points (configurable)

---

### Scoring Output Format

```markdown
## SEO Score: 87/100 ✅ PASS

**Score Breakdown:**

**Core Elements (62/70):**
- ✅ Primary keyword in H1: 10/10
- ✅ Primary keyword in first 100 words: 10/10
- ✅ Primary keyword in H2 heading: 10/10
- ✅ Keyword density 1.4%: 10/10
- ✅ Meta title (58 chars): 10/10
- ✅ Meta description (156 chars): 10/10
- ⚠️ Internal links (2 of 5 target): 6/10

**Structure & Quality (25/30):**
- ✅ Heading hierarchy: 10/10
- ✅ Readability (short paragraphs): 10/10
- ⚠️ External links (1 of 2-4 target): 3/5
- ✅ URL slug optimized: 5/5

**Publication Recommendation:** ✅ PASS (score ≥75)

**Improvement Opportunities:**
- Add 3 more internal links (currently 2/5)
- Add 1-3 more authoritative external links

**Next Steps:** Proceed to editorial review
```

---

### Quality Gate Integration

**Decision Logic:**

- **Score ≥75:** ✅ PASS → Proceed to publication
- **Score 65-74:** ⚠️ CONDITIONAL PASS → Editor judgment required
  - Minor improvements recommended but not blocking
  - Document decision in meta.yml
- **Score <65:** ❌ FAIL → Return to writer for optimization
  - Critical SEO gaps present
  - Must address before publication

**Add to meta.yml Section 13:**

```yaml
13. seo_expectations:
    seo_score: 87
    seo_status: "PASS"
    minimum_threshold: 75
    score_breakdown:
      core_elements: 62
      structure_quality: 25
    serp_position_target: "3-5"
    monthly_traffic_estimate: "500-1000"
    improvement_notes: "Add 3 internal links for optimal score"
```

---

### Score Calculation Example

```python
# Pseudo-code for SEO score calculation
def calculate_seo_score(article):
    score = 0

    # Primary keyword in H1 (10 pts)
    if primary_keyword in article.h1:
        score += 10

    # Primary keyword in first 100 words (10 pts)
    if primary_keyword in article.first_100_words:
        score += 10

    # Primary keyword in H2 (10 pts)
    if any(primary_keyword in h2 for h2 in article.h2_headings):
        score += 10

    # Keyword density (10 pts)
    density = calculate_keyword_density(article)
    if 1.0 <= density <= 2.0:
        score += 10
    elif 0.5 <= density < 1.0 or 2.0 < density <= 2.5:
        score += 6
    else:
        score += 0

    # Meta title (10 pts)
    if len(article.meta_title) <= 60 and primary_keyword in article.meta_title:
        score += 10

    # Meta description (10 pts)
    if 150 <= len(article.meta_description) <= 160 and primary_keyword in article.meta_description:
        score += 10

    # Internal links (10 pts, tier-adjusted)
    link_count = len(article.internal_links)
    tier_target = get_tier_target(article.tier)  # T1: 5-7, T2: 4-6, T3: 3-5, T4: 2-4
    if link_count >= tier_target:
        score += 10
    elif link_count >= tier_target - 1:
        score += 6
    elif link_count >= tier_target - 2:
        score += 3
    else:
        score += 0

    # Heading hierarchy (10 pts)
    if article.has_logical_hierarchy():
        score += 10
    elif article.has_minor_hierarchy_issues():
        score += 6
    else:
        score += 0

    # Readability (10 pts)
    if article.avg_paragraph_length <= 4:
        score += 10
    elif article.avg_paragraph_length <= 6:
        score += 6
    else:
        score += 0

    # External links (5 pts)
    ext_links = len(article.external_links)
    if 2 <= ext_links <= 4:
        score += 5
    elif ext_links == 1:
        score += 3
    else:
        score += 0

    # URL slug (5 pts)
    if article.url_slug_optimized():
        score += 5
    elif article.url_slug_decent():
        score += 3
    else:
        score += 0

    return score
```

## External Link Best Practices

### When to Link Externally

**Use previously loaded configuration from requirements-extractor:**

Extract from structured output:
- **Primary Documentation** from `project.official_docs`: Official docs URLs
- **Official Blogs** from `project.official_blogs`: Official news/blog URLs
- **Other Authoritative Sources** from `project.authoritative_sources`: Standards, community resources

Link to:
- Official documentation (from requirements.md: Primary Documentation)
- Official blogs (from requirements.md: Official Blogs)
- Research and statistics (cite sources from research brief)
- Standards organizations (relevant to platform/industry)
- Reputable industry news (topic-specific)
- Security advisories (CVE databases, vendor security pages)

**Example external link targets** (adapt based on your configuration):
- If Platform = "WordPress": Link to developer.wordpress.org, wordpress.org/support
- If Platform = "React.js": Link to react.dev, React GitHub discussions
- If Platform = "Python": Link to docs.python.org, PEPs, PyPI
- Always reference the official sources from your requirements.md configuration

### Link Attributes
- Default: `<a href="url">anchor text</a>` (standard follow link)
- Sponsored/affiliate: `<a href="url" rel="nofollow sponsored">anchor text</a>`
- Untrusted/UGC: `<a href="url" rel="nofollow">anchor text</a>`
- External resource: `<a href="url" target="_blank" rel="noopener">anchor text</a>` (optional)

### Quality Criteria
- Link to authoritative, trusted sources only
- Verify links work (no 404s)
- Use current URLs (not outdated or archived pages)
- Anchor text should describe destination clearly
- Balance external links with internal links (don't over-link externally)