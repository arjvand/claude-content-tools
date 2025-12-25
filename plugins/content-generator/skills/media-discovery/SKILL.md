---
name: media-discovery
description: Systematically discover high-quality, embeddable media assets (videos, social posts, expert commentary) during research phase. Outputs ranked candidates with placement suggestions.
---

# Media Discovery Skill

## Purpose

Automate the discovery of relevant video tutorials, expert commentary, and visual examples that enhance articles. Replaces manual embed searching with a structured, repeatable process that ensures quality, credibility, and embeddability.

## When to Use

- **Automatically:** During research phase for new articles (invoked by @researcher agent after gap analysis)
- **Manually:** When refreshing older content that needs updated media
- **Strategically:** When assessing visual content opportunities for pillar content

## Configuration-Driven Approach

**Before discovery, load configuration using requirements-extractor:**

```markdown
Please use the requirements-extractor skill to load validated configuration from project/requirements.md.
```

**Extract the following from structured output:**

1. **Preferred Platforms** from `media.preferred_platforms`: Platform list for media discovery

2. **Recency Filter** from `media.recency_filter`: Time window for recent media

3. **Credibility Requirements** from `media.credibility_requirements`: Quality criteria

4. **Max Embeds** from `media.max_embeds_per_article`: Embed limit per article

5. **Visual Standards** from `visual_standards.image_style` and `visual_standards.featured_images`: Visual preferences and constraints

**Use these extracted values throughout the discovery process. The requirements-extractor provides validated, structured configuration.**

---

## Process

### Phase 0: Load Configuration (1 minute)

**Use previously loaded configuration from requirements-extractor:**

Extract from structured output:
- Preferred platforms from `media.preferred_platforms`
- Recency filter from `media.recency_filter`
- Credibility requirements from `media.credibility_requirements`
- Max embeds per article from `media.max_embeds_per_article`
- Visual standards from `visual_standards`

---

### Phase 1: Assess Visual Need (1 minute)

**Objective:** Determine how much visual content this article needs

**Based on content type from article brief:**

| Content Type | Visual Need | Priority Focus |
|--------------|-------------|----------------|
| Tutorial/How-To | HIGH | Demonstration videos, step-by-step visuals |
| Expert Analysis | MEDIUM | Authority commentary, expert opinions |
| Case Study | MEDIUM | Real-world examples, before/after visuals |
| News/Announcement | LOW | Official announcements only if impactful |
| POV Essay | LOW | Supporting commentary if adds credibility |

**Document assessment:**
```markdown
**Visual Need Assessment:** HIGH / MEDIUM / LOW
**Rationale:** [Why this content type benefits from embeds]
**Target Embed Count:** [1-3 based on need and configured max]
```

---

### Phase 2: Platform-Specific Search (3-5 minutes)

**Objective:** Search configured platforms for relevant embeddable content

**Search Strategy by Content Type:**

#### For Tutorials/How-Tos (HIGH visual need):
```
Primary: "[topic]" tutorial site:youtube.com
Secondary: "[topic]" walkthrough OR demo site:youtube.com
Tertiary: "[topic]" how to site:youtube.com
```

#### For Expert Analysis (MEDIUM visual need):
```
Primary: "[topic]" expert OR analysis site:twitter.com
Secondary: "[topic]" insight OR opinion site:linkedin.com
Tertiary: "[topic]" commentary site:youtube.com
```

#### For Case Studies (MEDIUM visual need):
```
Primary: "[topic]" case study OR example site:linkedin.com
Secondary: "[topic]" real example site:instagram.com
Tertiary: "[topic]" before after site:youtube.com
```

#### For News/Announcements (LOW visual need):
```
Primary: "[product/company]" announcement official site:youtube.com
Secondary: "[product/company]" official site:twitter.com
```

**Execute searches using WebSearch:**
```
WebSearch: [constructed query]
```

**For each search result, record:**
- URL
- Title
- Platform
- Creator/Channel name
- Publish date (if visible)
- Relevance assessment

---

### Phase 3: Quality Filtering (2 minutes)

**Objective:** Filter candidates through credibility, recency, and relevance checks

#### Credibility Filter

**PASS criteria:**
- ✅ Verified account or official channel
- ✅ Recognized industry expert (>10K followers or known authority)
- ✅ Official product/company channel
- ✅ Established media outlet

**FAIL criteria:**
- ❌ Unknown creator with <1K followers
- ❌ Promotional/sponsored content (unless disclosed and relevant)
- ❌ Content farm or aggregator
- ❌ Outdated or abandoned channel

#### Recency Filter

**PASS criteria:**
- ✅ Published within configured recency window (default: 12 months)
- ✅ Older content IF foundational/evergreen (document reason)
- ✅ Content still accurate for current versions

**FAIL criteria:**
- ❌ Outdated information (old versions, deprecated features)
- ❌ Superseded by newer authoritative content

#### Relevance Filter

**PASS criteria:**
- ✅ Directly addresses article topic
- ✅ Adds value text cannot provide (demonstration, visual example, authority validation)
- ✅ Appropriate depth for target audience

**FAIL criteria:**
- ❌ Tangentially related (mentions topic but isn't about it)
- ❌ Decorative only (no substantive value)
- ❌ Wrong audience level (too basic or too advanced)

**Document filtering:**
```markdown
Candidate: [Title]
- Credibility: PASS / FAIL ([reason])
- Recency: PASS / FAIL ([reason])
- Relevance: PASS / FAIL ([reason])
- Overall: INCLUDE / EXCLUDE
```

---

### Phase 4: Embeddability Validation (2 minutes)

**Objective:** Verify candidates can actually be embedded

**For each passing candidate, use WebFetch to check:**

```
WebFetch: [candidate URL]
Prompt: Check if this content is publicly accessible and embeddable. Look for:
1. Is the content public (not private/unlisted)?
2. Is embedding enabled (no embed restrictions)?
3. Is it geo-restricted?
4. What is the exact title and creator?
5. What is the publish date?
6. For videos: what is the duration?
```

**Embeddability criteria:**
- ✅ Public visibility
- ✅ Embedding enabled
- ✅ Not geo-restricted
- ✅ Content loads without login

**Document validation:**
```markdown
Candidate: [Title]
- Public: ✅ Yes / ❌ No
- Embeddable: ✅ Yes / ❌ No ([reason if no])
- Geo-restricted: ❌ No / ✅ Yes ([regions])
- Final Status: VALID / INVALID
```

---

### Phase 5: Ranking & Recommendations (2 minutes)

**Objective:** Rank validated candidates and suggest placements

**Ranking Criteria (weighted):**

| Factor | Weight | Score 1-5 |
|--------|--------|-----------|
| Relevance to article | 35% | How directly it supports article content |
| Credibility of source | 25% | Authority and trustworthiness |
| Production quality | 20% | Professional presentation |
| Recency | 10% | How current the content is |
| Uniqueness | 10% | Value beyond what text provides |

**Calculate score for each candidate:**
```
Score = (Relevance × 0.35) + (Credibility × 0.25) + (Quality × 0.20) + (Recency × 0.10) + (Uniqueness × 0.10)
```

**Suggest placement for top candidates:**

Based on article structure from research brief:
- Tutorial demo → After "Getting Started" or "Implementation" section
- Expert commentary → Support for "Why This Matters" or key argument
- Case example → After theoretical explanation, before conclusion
- Official announcement → Near introduction or news hook

---

### Phase 6: Report Generation (1 minute)

**Objective:** Generate structured discovery report

Save to: `project/Articles/[ARTICLE-ID]/media-discovery.md`

---

## Output Format

```markdown
# Media Discovery: [ARTICLE-ID]

**Topic:** [Article topic/keyword]
**Content Type:** Tutorial / Analysis / Case Study / News / POV Essay
**Visual Need Assessment:** HIGH / MEDIUM / LOW
**Date:** YYYY-MM-DD

---

## Recommended Embeds

### 1. [Title] ⭐ PRIMARY RECOMMENDATION
- **Platform:** YouTube / Twitter / LinkedIn / Instagram
- **URL:** [full URL]
- **Creator:** [name] (verified/official/[follower count])
- **Published:** YYYY-MM-DD
- **Duration:** X:XX (if video)
- **Score:** X.X/5.0
- **Relevance:** [1-2 sentences on why this enhances the article]
- **Suggested Placement:** After "[Section Name]" section
- **Embed Syntax:** `<!-- embed:youtube url="[URL]" caption="[suggested caption]" -->`

### 2. [Title]
- **Platform:** [platform]
- **URL:** [full URL]
- **Creator:** [name] ([credentials])
- **Published:** YYYY-MM-DD
- **Score:** X.X/5.0
- **Relevance:** [Why this adds value]
- **Suggested Placement:** [Section suggestion]
- **Embed Syntax:** `<!-- embed:[type] url="[URL]" caption="[caption]" -->`

### 3. [Title]
[... continue for up to 5 candidates]

---

## Discovery Summary

| Metric | Value |
|--------|-------|
| Platforms Searched | [list] |
| Search Queries Used | [count] |
| Total Candidates Found | XX |
| Passed Quality Filter | X |
| Passed Embeddability Check | X |
| Final Recommendations | X |

### Filtered Out
- **X** outdated (published >12 months ago)
- **X** not embeddable (private/restricted/disabled)
- **X** low credibility (unverified/low authority)
- **X** not relevant (tangential to topic)

---

## Recommendation

**Primary Selection:** Embed #1 - [Title]
**Rationale:** [2-3 sentences explaining why this is the best choice]

**Secondary Selection:** Embed #[N] - [Title]
**Rationale:** [Why to include as second embed if space allows]

**If Primary Unavailable:** Use Embed #[N] as alternative

**Final Embed Count Recommendation:** [1-3] embeds
**Reasoning:** [Based on visual need assessment and content type]

---

## Search Queries Used

1. `[query 1]` → [X results, Y relevant]
2. `[query 2]` → [X results, Y relevant]
3. `[query 3]` → [X results, Y relevant]

---

## Notes for @writer

- **Placement guidance:** [Specific section recommendations]
- **Caption guidance:** [What the caption should emphasize]
- **Accessibility:** [Any caption/transcript requirements]
- **Alternative approach:** [What to do if embeds don't fit final draft]

---

**Discovery Completed:** YYYY-MM-DD HH:MM
**Skill Version:** media-discovery v1.0
```

---

## Integration with @researcher

### Trigger Point

**Phase 3C** in researcher workflow, after:
- Phase 3A: Competitive Gap Analysis
- Phase 3B: Manual Media Discovery (existing)

### Invocation

```markdown
Skill: media-discovery

Inputs:
- Topic/keyword: [from article brief/calendar entry]
- Content type: Tutorial / Analysis / Case Study / News / POV Essay
- Article ID: [ARTICLE-ID]
- Research brief: project/Articles/[ARTICLE-ID]/research-brief.md (for structure context)
```

### Output Location

```
project/Articles/[ARTICLE-ID]/media-discovery.md
```

### Handoff to @writer

Research brief should include summary:
```markdown
### Recommended Media Embeds

See `media-discovery.md` for full discovery report.

**Top Recommendations:**
1. [Title] (YouTube) - [relevance] → Place after [Section]
2. [Title] (Twitter) - [relevance] → Place in [Section]

**Embed Guidelines:**
- Use embed syntax: `<!-- embed:[type] url="[URL]" caption="[caption]" -->`
- Max embeds: [configured limit]
- Ensure captions describe WHY relevant, not just WHAT
```

---

## Quality Guidelines

### DO:
- Search multiple platforms to find best-fit content
- Prioritize official/verified sources over user-generated content
- Validate embeddability before recommending
- Provide specific placement suggestions with section names
- Include ready-to-use embed syntax
- Document why candidates were filtered out

### DON'T:
- Recommend content that can't be embedded
- Include promotional/sponsored content without disclosure note
- Suggest more embeds than configured maximum
- Recommend tangentially related content just to hit a quota
- Skip embeddability validation

---

## Error Handling

### Scenario 1: No Relevant Content Found

**Response:**
- Document search queries attempted
- Note in report: "No high-quality embeddable content found for this topic"
- Recommend: "Article can proceed without embeds; text-only appropriate"
- Suggest alternative: "Consider creating original visual content"

### Scenario 2: Content Exists But Not Embeddable

**Response:**
- Document the content that was found
- Note restriction reason (private, embedding disabled, geo-blocked)
- Recommend: "Link to content instead of embedding"
- Provide fallback: Screenshot with attribution (if appropriate)

### Scenario 3: Only Low-Quality Options Available

**Response:**
- Document options with quality concerns
- Note in report: "Available content does not meet credibility standards"
- Recommend: "Skip embeds for this article" or "Use with caveat"
- Suggest: "Monitor for better content in future updates"

### Scenario 4: Too Many Good Options

**Response:**
- Rank all candidates by score
- Select top [configured max] recommendations
- Include "Honorable Mentions" section for close alternatives
- Note: "Additional options available if primary selections don't fit"

---

## Platform-Specific Notes

### YouTube
- Verify channel is not terminated/suspended
- Check for age restrictions
- Note video duration (long videos may not be ideal)
- Prefer videos with captions/transcripts enabled

### Twitter/X
- Verify account is not suspended
- Check tweet is not deleted
- Note if tweet is part of a thread
- Prefer tweets with images/videos over text-only

### LinkedIn
- Verify post is public (not connections-only)
- Note if from company page vs personal profile
- Prefer posts with visual content

### Instagram
- Verify account is public
- Note if post or reel
- Check for carousel posts (may embed differently)

---

## Success Metrics

### Discovery Quality
- **Recommendation acceptance rate:** 80%+ of recommended embeds used by @writer
- **Embed validity:** 100% of recommended embeds are actually embeddable
- **Relevance accuracy:** 90%+ of recommendations rated "relevant" by @editor

### Process Efficiency
- **Discovery time:** 5-8 minutes per article
- **Search efficiency:** Find viable candidates in first 2 queries 70% of time
- **False positive rate:** <10% of recommendations fail embeddability check

### Content Impact
- **Engagement lift:** Articles with discovered embeds show higher time-on-page
- **Quality consistency:** Embed quality consistent across articles
- **Coverage:** 70%+ of articles where visual need is HIGH include embeds
