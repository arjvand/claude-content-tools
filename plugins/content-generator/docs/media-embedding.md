# Media Embedding Strategy

Proactive integration of multimedia embeds (videos, social posts) to enhance article quality and engagement.

---

## When Embedding Happens

### 1. Research Phase (Discovery)
- `@researcher` searches for relevant embeds during Phase 3B
- Identifies 3-5 embed candidates
- Adds "Recommended Media Embeds" section to research brief
- Provides URL, platform, relevance, and suggested placement

### 2. Writing Phase (Integration)
- `@writer` reviews embed recommendations from research brief
- Considers embed opportunities during self-edit
- Adds 1-3 embeds using HTML comment syntax
- Documents decision if embeds not added

### 3. Editorial Phase (Validation)
- `@editor` runs Media Embed Review & Validation
- If embeds present: Validates URLs, fetches metadata, checks accessibility
- If NO embeds: Assesses if article should have them
- Flags articles that would benefit from embeds

---

## Embed Strategy by Content Type

| Content Type | Priority | Recommended Types |
|-------------|----------|-------------------|
| Tutorials/How-tos | High | Demonstration videos (YouTube) |
| Expert analysis | High | Authority commentary (Twitter/X, LinkedIn) |
| Case studies | High | Real-world examples (Instagram, TikTok, LinkedIn) |
| Product reviews | Moderate | Official announcements, demos |
| News/announcements | Low | Text usually sufficient |
| Text-only analysis | Low | No visual demonstration value |

---

## Supported Platforms

| Platform | Use Cases |
|----------|-----------|
| **YouTube** | Tutorial videos, product demos, conference talks |
| **Twitter/X** | Expert commentary, industry discussions, announcements |
| **Instagram** | Visual examples, case studies, before/after |
| **LinkedIn** | Professional commentary, thought leadership |
| **TikTok** | Quick tutorials, real-world examples |

---

## HTML Comment Syntax

```html
<!-- embed:youtube url="https://youtube.com/watch?v=..." caption="Expert demonstrates the three-step optimization process" -->

<!-- embed:twitter url="https://twitter.com/user/status/..." caption="Industry leader explains the shift toward transparent pricing" -->

<!-- embed:instagram url="https://instagram.com/p/..." caption="Real-world example of successful implementation" -->
```

---

## Quality Criteria

All embeds must meet these standards:

| Criterion | Requirement |
|-----------|-------------|
| Source | Credible (verified accounts, official channels, recognized experts) |
| Relevance | Directly relevant to article topic (not tangential) |
| Value | Adds value text can't provide (demonstration, visual example) |
| Recency | Within 1-2 years (unless timeless/foundational) |
| Accessibility | Captions, ARIA labels, embeddable |
| Limit | 1-3 per article maximum |

---

## Caption Guidelines

- Describe WHY relevant (not just WHAT it shows)
- Under 200 characters
- Provides context that enriches the article

**Good:** "Expert demonstrates the three-step optimization process"
**Bad:** "Video about optimization"

---

## Validation Process

The `media-embedding` skill automatically:
1. Validates embed URLs and checks embeddability
2. Fetches metadata (titles, descriptions, thumbnails, author info)
3. Checks accessibility compliance
4. Converts to platform-specific embed code for HTML export
5. Updates meta.yml with embed metadata

---

## When NOT to Use Embeds

Skip embeds when:
- Breaking news/announcements (time-sensitive, text sufficient)
- Purely analytical/text-based content (no visual value)
- Topic has no relevant multimedia available
- Embeds would be decorative rather than valuable

Document decision: "Embeds not applicable - text-only appropriate"

---

## Expected Impact

| Metric | Improvement |
|--------|-------------|
| Time-on-page | +20-30% for articles with embeds |
| Engagement metrics | +15-25% vs text-only |
| Perceived value | Higher authority and comprehensiveness |
