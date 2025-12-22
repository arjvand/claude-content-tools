# Media Embed Syntax Reference

Complete reference guide for embedding YouTube videos and social media posts in articles.

## General Syntax

```html
<!-- embed:[type] url="[URL]" caption="[context description]" -->
```

**Components:**
- `[type]` - Platform identifier (youtube, twitter, instagram, linkedin, tiktok)
- `[URL]` - Full URL to the content
- `[caption]` - Context description explaining why the embed is relevant (optional but recommended)

**Placement Rules:**
- Must be on its own line
- Blank lines before and after for proper markdown parsing
- Maximum 1-3 embeds per article

---

## Platform-Specific Syntax

### YouTube

**Supported URL Formats:**
```
https://youtube.com/watch?v=VIDEO_ID
https://youtu.be/VIDEO_ID
https://youtube.com/embed/VIDEO_ID
```

**Type Identifiers:** `youtube`, `yt`

**Examples:**
```html
<!-- embed:youtube url="https://youtube.com/watch?v=dQw4w9WgXcQ" caption="Tutorial demonstrating the pricing framework discussed above" -->

<!-- embed:yt url="https://youtu.be/dQw4w9WgXcQ" caption="Expert walkthrough of value-based rate calculation" -->
```

**Best Practices:**
- Use for tutorial videos, expert explanations, process demonstrations
- Caption should explain how video relates to article content
- Prefer official channels and authoritative creators

---

### X (Twitter)

**Supported URL Formats:**
```
https://twitter.com/USERNAME/status/TWEET_ID
https://x.com/USERNAME/status/TWEET_ID
```

**Type Identifiers:** `twitter`, `tweet`, `x`

**Examples:**
```html
<!-- embed:twitter url="https://twitter.com/CreatorEconomy/status/1234567890123456789" caption="Industry leader shares insights on transparent pricing trends" -->

<!-- embed:x url="https://x.com/DesignStudio/status/9876543210987654321" caption="Real-world example of successful creator-client collaboration" -->
```

**Best Practices:**
- Use for expert commentary, industry insights, real-time discussions
- Verify tweet author is credible and relevant
- Caption should explain why this perspective matters
- Avoid embedding controversial or divisive content

---

### Instagram

**Supported URL Formats:**
```
https://instagram.com/p/POST_ID/
https://instagram.com/reel/REEL_ID/
https://www.instagram.com/p/POST_ID/
```

**Type Identifiers:** `instagram`, `ig`, `insta`

**Examples:**
```html
<!-- embed:instagram url="https://instagram.com/p/ABC123xyz/" caption="Behind-the-scenes look at creator workflow and collaboration setup" -->

<!-- embed:ig url="https://instagram.com/reel/XYZ789abc/" caption="Quick visual demonstration of the co-op pricing model in action" -->
```

**Best Practices:**
- Use for visual examples, behind-the-scenes content, creator showcases
- Ensure post/reel is from public account (not private)
- Caption should provide context for visual content
- Verify post aligns with brand voice and values

---

### LinkedIn

**Supported URL Formats:**
```
https://linkedin.com/posts/USERNAME_activity-ACTIVITY_ID
https://www.linkedin.com/posts/USERNAME_activity-1234567890
```

**Type Identifiers:** `linkedin`, `li`

**Examples:**
```html
<!-- embed:linkedin url="https://linkedin.com/posts/creativeagency_activity-7123456789012345678" caption="Professional perspective on evolving agency collaboration models" -->

<!-- embed:li url="https://linkedin.com/posts/brandstrategy_activity-7987654321098765432" caption="Client testimonial highlighting transparent pricing benefits" -->
```

**Best Practices:**
- Use for professional insights, industry analysis, B2B perspectives
- Prefer posts from verified professionals or established organizations
- Caption should explain professional relevance
- Note: LinkedIn embeds have limited styling compared to other platforms

---

### TikTok

**Supported URL Formats:**
```
https://tiktok.com/@USERNAME/video/VIDEO_ID
https://www.tiktok.com/@USERNAME/video/1234567890123456789
```

**Type Identifiers:** `tiktok`, `tt`

**Examples:**
```html
<!-- embed:tiktok url="https://tiktok.com/@creativetips/video/7123456789012345678" caption="60-second breakdown of value-based pricing essentials" -->

<!-- embed:tt url="https://tiktok.com/@designhacks/video/7987654321098765432" caption="Quick visual guide to setting creator rates with confidence" -->
```

**Best Practices:**
- Use for short-form, engaging content summaries
- Prefer educational or informative TikToks over entertainment-only
- Caption should bridge TikTok content to article topic
- Verify creator has credible expertise in the subject

---

## Caption Guidelines

### Good Captions (Provide Context)

✅ "Industry leader explains the shift toward transparent pricing models in creative work"
✅ "Tutorial demonstrating the rate calculation framework discussed in the previous section"
✅ "Real creator example showing monthly usage rights pricing in action"
✅ "Expert commentary on ethical collaboration practices from SXSW 2025 panel"

### Bad Captions (Too Vague or Redundant)

❌ "Great video about pricing"
❌ "Check this out"
❌ "How to Price Your Creative Services" (just repeating the video title)
❌ "Interesting take"

### Caption Best Practices

**DO:**
- Explain WHY the embed is relevant to the article
- Provide context that isn't obvious from the title/thumbnail
- Keep under 200 characters
- Use plain, descriptive language
- Connect embed to surrounding article content

**DON'T:**
- Just repeat the video/post title
- Use vague language like "great," "awesome," "must-watch"
- Include marketing hype or promotional language
- Exceed 200 characters
- Use clickbait phrasing

---

## Accessibility Requirements

All embeds must include:

1. **Descriptive Caption** - Explains relevance and context
2. **Title/ARIA Label** - Added automatically by media-embedding skill
3. **Keyboard Navigation** - Native iframe support (automatic)
4. **Transcript Link** - For video content when available
5. **Fallback Content** - Text link if embed fails to load

**Accessibility Checklist:**
- [ ] Caption describes context, not just content
- [ ] Caption is under 200 characters
- [ ] Video embeds link to platform page (for transcript access)
- [ ] Critical information is also in article text (not embed-only)

---

## Validation Rules

### URL Validation

**YouTube:**
- Pattern: `(youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([a-zA-Z0-9_-]{11})`
- Video ID: Exactly 11 characters
- Embeddability: Must be enabled by video owner

**Twitter/X:**
- Pattern: `(twitter\.com|x\.com)/[^/]+/status/(\d+)`
- Tweet ID: Numeric only (typically 19 digits)
- Visibility: Must be from public account

**Instagram:**
- Pattern: `instagram\.com/(p|reel)/([a-zA-Z0-9_-]+)`
- Post ID: Alphanumeric with dashes/underscores
- Privacy: Must be from public account

**LinkedIn:**
- Pattern: `linkedin\.com/posts/[^/]+_activity-(\d+)`
- Activity ID: Numeric only
- Visibility: Must be public post

**TikTok:**
- Pattern: `tiktok\.com/@[^/]+/video/(\d+)`
- Video ID: Numeric only (typically 19 digits)
- Privacy: Must be public video

---

## Common Errors and Solutions

### Error: Invalid URL Format

**Problem:**
```html
<!-- embed:youtube url="youtube.com/watch?v=abc123" -->
```

**Issue:** Missing protocol (https://)

**Solution:**
```html
<!-- embed:youtube url="https://youtube.com/watch?v=abc123" caption="..." -->
```

---

### Error: Missing Caption

**Problem:**
```html
<!-- embed:twitter url="https://twitter.com/user/status/123456" -->
```

**Issue:** No caption provided (reduces accessibility)

**Solution:**
```html
<!-- embed:twitter url="https://twitter.com/user/status/123456" caption="Expert insights on creator pricing transparency" -->
```

---

### Error: Video Not Embeddable

**Problem:**
```
YouTube video ID abc123
Issue: Video owner disabled embedding
```

**Solution:**
- Contact video owner to request embed permission
- Link to video instead of embedding: `[Watch tutorial](https://youtube.com/watch?v=abc123)`
- Find alternative embeddable video on same topic

---

### Error: Private/Deleted Content

**Problem:**
```
Instagram post XYZ789
Issue: Post is private or has been deleted
```

**Solution:**
- Remove embed from article
- Replace with screenshot (if terms allow) with proper attribution
- Find alternative public post demonstrating same concept

---

## Testing Embeds

### Manual Testing Checklist

Before finalizing article:
- [ ] All embed URLs load in browser
- [ ] All embeds are from public sources
- [ ] All captions provide context
- [ ] Embeds display correctly on mobile
- [ ] Article text makes sense without embeds (embeds are supplementary)

### Automated Validation

The media-embedding skill automatically validates:
- ✅ URL format and protocol
- ✅ Platform-specific ID extraction
- ✅ Embeddability status (via oEmbed APIs)
- ✅ Content availability (not deleted/private)
- ✅ Metadata fetching (titles, authors, thumbnails)

---

## WordPress Gutenberg Output

When articles are exported to WordPress, embeds are converted to Gutenberg embed blocks:

**YouTube Example:**
```html
<!-- wp:embed {"url":"https://youtube.com/watch?v=VIDEO_ID","type":"video","providerNameSlug":"youtube","responsive":true} -->
<figure class="wp-block-embed is-type-video is-provider-youtube">
  <div class="wp-block-embed__wrapper">
    https://youtube.com/watch?v=VIDEO_ID
  </div>
  <figcaption class="wp-element-caption">Caption text</figcaption>
</figure>
<!-- /wp:embed -->
```

**Twitter Example:**
```html
<!-- wp:embed {"url":"https://twitter.com/user/status/TWEET_ID","type":"rich","providerNameSlug":"twitter","responsive":true} -->
<figure class="wp-block-embed is-type-rich is-provider-twitter">
  <div class="wp-block-embed__wrapper">
    https://twitter.com/user/status/TWEET_ID
  </div>
  <figcaption class="wp-element-caption">Caption text</figcaption>
</figure>
<!-- /wp:embed -->
```

---

## Quick Reference Table

| Platform | Type IDs | URL Pattern | Caption Required |
|----------|----------|-------------|------------------|
| YouTube | `youtube`, `yt` | `youtube.com/watch?v=` or `youtu.be/` | Recommended |
| Twitter/X | `twitter`, `tweet`, `x` | `twitter.com/.../status/` or `x.com/.../status/` | Recommended |
| Instagram | `instagram`, `ig`, `insta` | `instagram.com/p/` or `instagram.com/reel/` | Recommended |
| LinkedIn | `linkedin`, `li` | `linkedin.com/posts/..._activity-` | Recommended |
| TikTok | `tiktok`, `tt` | `tiktok.com/@.../video/` | Recommended |

---

**Version:** 1.0
**Last Updated:** 2025-01-12
**Maintained by:** TBM Content System
