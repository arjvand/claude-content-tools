---
name: media-embedding
description: Validate and convert media embeds (YouTube, Twitter, Instagram) from HTML comment syntax to platform-specific embed code with metadata fetching and accessibility compliance.
---

# Media Embedding Skill

## Purpose

Validate and convert media embeds (YouTube videos, social media posts) from HTML comment syntax to platform-specific embed code with full metadata fetching and accessibility compliance.

## Scope

This skill is invoked during article creation to:
1. **Validate** embed URLs and check embeddability
2. **Fetch metadata** (titles, descriptions, thumbnails, author info)
3. **Convert** HTML comments to platform-specific blocks (WordPress Gutenberg, generic iframe)
4. **Ensure accessibility** (captions, ARIA labels, keyboard navigation)
5. **Generate responsive** embed code with lazy loading

## Supported Platforms

| Platform | Embed Type | Metadata Fetched |
|----------|-----------|------------------|
| **YouTube** | Video player | Title, channel, duration, thumbnail, description |
| **X (Twitter)** | Tweet card | Author, text, timestamp, engagement metrics |
| **Instagram** | Post/Reel | Author, caption, media type, timestamp |
| **LinkedIn** | Post | Author, text, timestamp, engagement |
| **TikTok** | Video | Author, description, video ID, thumbnail |

## HTML Comment Syntax

### General Format
```html
<!-- embed:[type] url="[URL]" caption="[optional caption]" -->
```

### Platform-Specific Examples

**YouTube:**
```html
<!-- embed:youtube url="https://www.youtube.com/watch?v=VIDEO_ID" caption="Tutorial: Setting Up Your First Campaign" -->
<!-- embed:youtube url="https://youtu.be/VIDEO_ID" -->
```

**X (Twitter):**
```html
<!-- embed:twitter url="https://twitter.com/username/status/1234567890" caption="Industry expert weighs in on creator economy trends" -->
<!-- embed:tweet url="https://x.com/username/status/1234567890" -->
```

**Instagram:**
```html
<!-- embed:instagram url="https://www.instagram.com/p/POST_ID/" caption="Behind-the-scenes look at creator workflow" -->
<!-- embed:ig url="https://www.instagram.com/reel/REEL_ID/" -->
```

**LinkedIn:**
```html
<!-- embed:linkedin url="https://www.linkedin.com/posts/username_activity-1234567890" caption="Professional insights on pricing transparency" -->
```

**TikTok:**
```html
<!-- embed:tiktok url="https://www.tiktok.com/@username/video/1234567890" caption="Quick tip: Value-based pricing in 60 seconds" -->
```

### Syntax Rules

1. **Type identifiers** (case-insensitive):
   - YouTube: `youtube`, `yt`
   - X/Twitter: `twitter`, `tweet`, `x`
   - Instagram: `instagram`, `ig`, `insta`
   - LinkedIn: `linkedin`, `li`
   - TikTok: `tiktok`, `tt`

2. **URL format**: Must be valid platform URL (full or short form)

3. **Caption**: Optional, but recommended for accessibility
   - Should describe why the embed is relevant (not just repeat title)
   - Max 200 characters
   - Use plain language

4. **Placement**: Must be on its own line with blank lines before/after

## Implementation Process

### Phase 1: Discovery (2-3 minutes)

**Objective:** Find all embed comments in the article

**Steps:**
1. Read the article markdown file (draft.md or article.md)
2. Scan for HTML comment patterns matching `<!-- embed:`
3. Extract all embed comments with line numbers
4. Parse each comment to extract:
   - Platform type
   - URL
   - Caption (if present)
   - Any additional attributes

**Output:**
```
Found [N] embeds:
1. Line 45: YouTube video (https://youtube.com/watch?v=...)
2. Line 120: Twitter post (https://twitter.com/.../status/...)
3. Line 203: Instagram post (https://instagram.com/p/...)
```

### Phase 2: Validation (3-5 minutes per embed)

**Objective:** Verify URLs are valid and embeddable

**For Each Embed:**

**Step 1: URL Format Validation**
- Check URL matches expected platform pattern
- Verify protocol (https://)
- Extract platform-specific ID (video ID, tweet ID, post ID)

**Step 2: Platform-Specific Validation**

**YouTube:**
- Extract video ID from URL (supports youtube.com/watch?v=, youtu.be/, youtube.com/embed/)
- Check video embeddability via oEmbed API or HEAD request
- Verify video is not private/deleted
- **API Endpoint:** `https://www.youtube.com/oembed?url=[URL]&format=json`

**X (Twitter):**
- Extract tweet ID from URL
- Verify tweet exists and is public
- Check for deletions or account suspensions
- **API Endpoint:** `https://publish.twitter.com/oembed?url=[URL]`

**Instagram:**
- Extract post/reel ID from URL
- Verify post is public (not private account)
- Check for deletions
- **API Endpoint:** `https://api.instagram.com/oembed?url=[URL]` (requires access token)
- **Fallback:** Use web scraping or manual verification

**LinkedIn:**
- Extract activity ID from URL
- Verify post is public
- Note: LinkedIn embed support is limited; may require iframe fallback

**TikTok:**
- Extract video ID from URL
- Verify video is public
- **API Endpoint:** `https://www.tiktok.com/oembed?url=[URL]`

**Step 3: Fetch Metadata**

For each platform, fetch:
- **Title/Text content** (for caption if not provided)
- **Author information** (username, display name)
- **Thumbnail URL** (for preview images)
- **Duration** (for videos)
- **Timestamp** (publication date)
- **Engagement metrics** (optional: likes, views, shares)

**Step 4: Accessibility Check**
- Verify caption is present or can be generated from metadata
- Check for transcript availability (YouTube)
- Validate ARIA attributes will be added
- Ensure keyboard navigation support

**Output:** Validation report
```markdown
## Embed Validation Report

### Embed 1: YouTube Video (Line 45)
- **URL:** https://youtube.com/watch?v=abc123
- **Status:** ✓ Valid
- **Video ID:** abc123
- **Title:** "How to Price Your Creative Services"
- **Channel:** Creator Business School
- **Duration:** 12:34
- **Thumbnail:** https://i.ytimg.com/vi/abc123/maxresdefault.jpg
- **Embeddable:** Yes
- **Caption:** "Tutorial: Setting Up Your First Campaign" ✓
- **Accessibility:** ✓ Caption provided

### Embed 2: Twitter Post (Line 120)
- **URL:** https://twitter.com/user/status/1234567890
- **Status:** ✓ Valid
- **Tweet ID:** 1234567890
- **Author:** @CreatorEconomy
- **Text:** "Just launched transparent pricing guide for creators..."
- **Timestamp:** 2025-01-15
- **Engagement:** 234 likes, 45 retweets
- **Caption:** ⚠ Missing (recommend adding)
- **Accessibility:** ⚠ Add caption describing context

### Embed 3: Instagram Post (Line 203)
- **URL:** https://instagram.com/p/XYZ789/
- **Status:** ✗ Invalid
- **Error:** Post is private or deleted
- **Action Required:** Remove embed or replace with public alternative
```

### Phase 3: Conversion (2-4 minutes)

**Objective:** Convert HTML comments to platform-specific embed code

**Step 1: Determine Target Format**

Read CMS Platform configuration from requirements.md:
- **WordPress (Gutenberg editor)** → Generate Gutenberg blocks
- **Markdown-based** → Generate generic iframe HTML
- **Notion** → Generate Notion embed syntax
- **Other** → Use universal oEmbed format

**Step 2: Generate Platform-Specific Code**

**For WordPress Gutenberg:**

**YouTube:**
```html
<!-- wp:embed {"url":"https://youtube.com/watch?v=VIDEO_ID","type":"video","providerNameSlug":"youtube","responsive":true,"className":"wp-embed-aspect-16-9 wp-has-aspect-ratio"} -->
<figure class="wp-block-embed is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio">
  <div class="wp-block-embed__wrapper">
    https://youtube.com/watch?v=VIDEO_ID
  </div>
  <figcaption class="wp-element-caption">[Caption text]</figcaption>
</figure>
<!-- /wp:embed -->
```

**Twitter/X:**
```html
<!-- wp:embed {"url":"https://twitter.com/user/status/TWEET_ID","type":"rich","providerNameSlug":"twitter","responsive":true} -->
<figure class="wp-block-embed is-type-rich is-provider-twitter wp-block-embed-twitter">
  <div class="wp-block-embed__wrapper">
    https://twitter.com/user/status/TWEET_ID
  </div>
  <figcaption class="wp-element-caption">[Caption text]</figcaption>
</figure>
<!-- /wp:embed -->
```

**Instagram:**
```html
<!-- wp:embed {"url":"https://instagram.com/p/POST_ID/","type":"rich","providerNameSlug":"instagram","responsive":true} -->
<figure class="wp-block-embed is-type-rich is-provider-instagram wp-block-embed-instagram">
  <div class="wp-block-embed__wrapper">
    https://instagram.com/p/POST_ID/
  </div>
  <figcaption class="wp-element-caption">[Caption text]</figcaption>
</figure>
<!-- /wp:embed -->
```

**For Generic HTML (Markdown-based or fallback):**

**YouTube:**
```html
<figure class="embed embed-youtube">
  <div class="embed-wrapper" style="position: relative; padding-bottom: 56.25%; height: 0; overflow: hidden;">
    <iframe
      src="https://www.youtube.com/embed/VIDEO_ID"
      style="position: absolute; top: 0; left: 0; width: 100%; height: 100%;"
      frameborder="0"
      allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
      allowfullscreen
      loading="lazy"
      title="[Video Title]"
      aria-label="YouTube video: [Video Title]">
    </iframe>
  </div>
  <figcaption>[Caption text]</figcaption>
</figure>
```

**Twitter/X:**
```html
<figure class="embed embed-twitter">
  <blockquote class="twitter-tweet" data-lang="en" data-theme="light">
    <p>[Tweet text]</p>
    <a href="https://twitter.com/user/status/TWEET_ID">View on Twitter</a>
  </blockquote>
  <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>
  <figcaption>[Caption text]</figcaption>
</figure>
```

**Instagram:**
```html
<figure class="embed embed-instagram">
  <blockquote class="instagram-media"
    data-instgrm-permalink="https://instagram.com/p/POST_ID/"
    data-instgrm-version="14">
    <a href="https://instagram.com/p/POST_ID/" target="_blank" rel="noopener">View on Instagram</a>
  </blockquote>
  <script async src="//www.instagram.com/embed.js"></script>
  <figcaption>[Caption text]</figcaption>
</figure>
```

**LinkedIn:**
```html
<figure class="embed embed-linkedin">
  <iframe
    src="https://www.linkedin.com/embed/feed/update/urn:li:share:ACTIVITY_ID"
    height="400"
    width="100%"
    frameborder="0"
    allowfullscreen
    loading="lazy"
    title="LinkedIn Post">
  </iframe>
  <figcaption>[Caption text]</figcaption>
</figure>
```

**TikTok:**
```html
<figure class="embed embed-tiktok">
  <blockquote class="tiktok-embed"
    cite="https://www.tiktok.com/@username/video/VIDEO_ID"
    data-video-id="VIDEO_ID">
    <a href="https://www.tiktok.com/@username/video/VIDEO_ID" target="_blank" rel="noopener">View on TikTok</a>
  </blockquote>
  <script async src="https://www.tiktok.com/embed.js"></script>
  <figcaption>[Caption text]</figcaption>
</figure>
```

**Step 3: Add Accessibility Attributes**

For all embeds, ensure:
- `title` or `aria-label` attribute describes the content
- `figcaption` provides context (why this embed is relevant)
- `loading="lazy"` for performance
- `rel="noopener"` for security on external links
- Keyboard navigation support (native in iframes)

**Step 4: Create Replacement Map**

Generate a mapping of HTML comments to converted code:
```
Line 45: <!-- embed:youtube url="..." -->
  → [WordPress Gutenberg YouTube block]

Line 120: <!-- embed:twitter url="..." -->
  → [WordPress Gutenberg Twitter block]

Line 203: <!-- embed:instagram url="..." -->
  → [ERROR: Invalid URL - skip conversion]
```

### Phase 4: Output Generation (1-2 minutes)

**Objective:** Create embed-enhanced versions of articles

**Step 1: Update Article Files**

Create enhanced versions with embeds converted:
- **For article.md**: Keep HTML comments for markdown compatibility
- **For article.html**: Replace comments with full embed code

**Step 2: Update Metadata**

Add `embeds:` section to meta.yml:
```yaml
embeds:
  - id: 1
    line: 45
    type: youtube
    url: "https://youtube.com/watch?v=VIDEO_ID"
    video_id: "VIDEO_ID"
    title: "How to Price Your Creative Services"
    channel: "Creator Business School"
    duration: "12:34"
    thumbnail: "https://i.ytimg.com/vi/VIDEO_ID/maxresdefault.jpg"
    caption: "Tutorial: Setting Up Your First Campaign"
    status: valid

  - id: 2
    line: 120
    type: twitter
    url: "https://twitter.com/user/status/1234567890"
    tweet_id: "1234567890"
    author: "@CreatorEconomy"
    text: "Just launched transparent pricing guide..."
    timestamp: "2025-01-15"
    caption: null
    status: valid
    warning: "Missing caption - consider adding context"

  - id: 3
    line: 203
    type: instagram
    url: "https://instagram.com/p/XYZ789/"
    status: invalid
    error: "Post is private or deleted"
    action: "Remove embed or replace with public alternative"
```

**Step 3: Generate Embed Summary**

Create summary report for the article:
```markdown
## Media Embeds Summary

**Total Embeds:** 3
**Valid:** 2
**Invalid:** 1
**Platforms:** YouTube (1), Twitter (1), Instagram (1)

### Accessibility Compliance
- ✓ All valid embeds have captions or ARIA labels
- ⚠ Twitter embed missing caption (recommend adding)
- ✓ Responsive embed code with lazy loading
- ✓ Keyboard navigation supported

### Action Items
1. Add caption to Twitter embed (Line 120) describing why it's relevant
2. Remove or replace Instagram embed (Line 203) - post is private/deleted
3. Test embeds in target CMS platform before publishing
```

## Validation Rules

### URL Validation

**YouTube:**
- Pattern: `(youtube\.com/watch\?v=|youtu\.be/|youtube\.com/embed/)([a-zA-Z0-9_-]{11})`
- Video ID length: 11 characters

**Twitter/X:**
- Pattern: `(twitter\.com|x\.com)/[^/]+/status/(\d+)`
- Tweet ID: Numeric only

**Instagram:**
- Pattern: `instagram\.com/(p|reel)/([a-zA-Z0-9_-]+)`
- Post ID: Alphanumeric with dashes/underscores

**LinkedIn:**
- Pattern: `linkedin\.com/posts/[^/]+_activity-(\d+)`
- Activity ID: Numeric only

**TikTok:**
- Pattern: `tiktok\.com/@[^/]+/video/(\d+)`
- Video ID: Numeric only

### Caption Best Practices

**DO:**
- Describe why the embed is relevant to the article
- Provide context that isn't obvious from the title
- Keep under 200 characters
- Use plain language

**Examples:**
- "Industry leader explains the shift toward transparent pricing models"
- "Tutorial demonstrating the rate calculation framework discussed above"
- "Real creator example showing monthly usage rights pricing in action"

**DON'T:**
- Just repeat the video/post title
- Use vague descriptions like "Great video" or "Check this out"
- Include marketing language or hype
- Exceed 200 characters

### Accessibility Requirements

All embeds must include:
1. **Descriptive caption** explaining relevance
2. **Title/ARIA label** for screen readers
3. **Keyboard navigation** support (native in iframes)
4. **Transcript link** for video content (when available)
5. **Fallback content** if embed fails to load

## Error Handling

### Common Errors and Resolutions

**Error: Invalid URL format**
```
Line 45: <!-- embed:youtube url="youtube.com/video123" -->
Issue: Missing protocol (https://)
Resolution: Add https:// prefix
```

**Error: Video not embeddable**
```
Line 67: YouTube video ID abc123
Issue: Video owner disabled embedding
Resolution: Remove embed or link to video instead
```

**Error: Private/deleted content**
```
Line 120: Instagram post XYZ789
Issue: Post is private or has been deleted
Resolution: Remove embed or find alternative public post
```

**Error: Missing caption**
```
Line 203: <!-- embed:twitter url="..." -->
Issue: No caption provided, reduces accessibility
Resolution: Add caption="[context description]"
```

**Error: Unsupported platform**
```
Line 250: <!-- embed:facebook url="..." -->
Issue: Facebook not in supported platforms list
Resolution: Use generic iframe or expand platform support
```

### Validation Response Format

For each embed, return:
```json
{
  "line": 45,
  "type": "youtube",
  "url": "https://youtube.com/watch?v=VIDEO_ID",
  "status": "valid|invalid|warning",
  "metadata": {
    "title": "Video Title",
    "author": "Channel Name",
    "duration": "12:34",
    "thumbnail": "https://..."
  },
  "issues": [
    {
      "severity": "error|warning|info",
      "message": "Description of issue",
      "resolution": "Suggested fix"
    }
  ],
  "embed_code": {
    "wordpress": "<!-- wp:embed ... -->",
    "generic": "<figure class=\"embed\">..."
  }
}
```

## Integration with Article Workflow

### When to Invoke This Skill

**During Article Writing (@writer agent, Phase 3.5):**
- Writer adds HTML comment embeds to draft.md
- Embeds NOT validated during writing (allows creative flow)

**During Editorial Review (@editor agent, Phase 6.5):**
- Editor invokes media-embedding skill
- Full validation and metadata fetching
- Conversion to platform-specific code
- Accessibility compliance check

**During HTML Export (@editor agent, Phase 7):**
- Apply embed conversions to article.html
- Keep HTML comments in article.md for markdown compatibility
- Update meta.yml with embed metadata

### Workflow Integration Points

```
Phase 4: @writer creates draft.md
  → Adds HTML comment embeds
  → No validation yet (rapid drafting)

Phase 6: @editor reviews article.md
  → Phase 6.5: Invoke media-embedding skill
  → Validate all embeds
  → Fetch metadata
  → Check accessibility
  → Generate validation report

Phase 7: @editor creates HTML export
  → Apply embed conversions to article.html
  → Preserve HTML comments in article.md
  → Update meta.yml with embed data
  → Include embed summary in summary.md
```

## API Requirements

### YouTube oEmbed API
- **Endpoint:** `https://www.youtube.com/oembed`
- **Parameters:** `url`, `format=json`
- **No authentication required**
- **Rate limit:** Generous, no key needed for basic queries

### Twitter oEmbed API
- **Endpoint:** `https://publish.twitter.com/oembed`
- **Parameters:** `url`
- **No authentication required**
- **Rate limit:** 200 requests per 15 minutes per IP

### Instagram oEmbed API
- **Endpoint:** `https://api.instagram.com/oembed`
- **Parameters:** `url`, `access_token`
- **Authentication:** Requires Facebook app access token
- **Fallback:** Web scraping or manual verification if no token

### TikTok oEmbed API
- **Endpoint:** `https://www.tiktok.com/oembed`
- **Parameters:** `url`
- **No authentication required**
- **Rate limit:** Undocumented, conservative usage recommended

### LinkedIn
- **No public oEmbed API**
- **Fallback:** Use iframe embed with activity URL
- **Limitation:** Preview metadata not available programmatically

### Rate Limiting Strategy

1. Cache metadata locally after first fetch (store in meta.yml)
2. Batch API requests if multiple embeds from same platform
3. Implement exponential backoff on rate limit errors
4. Fall back to manual verification if APIs unavailable

## Testing and Validation

### Test Cases

Create example articles with:
1. Single YouTube video embed
2. Multiple Twitter posts with captions
3. Instagram reel with missing caption (test warning)
4. Invalid URL (test error handling)
5. Mix of all platforms (test multi-platform support)

### Validation Checklist

- [ ] All embed URLs validated and embeddable
- [ ] Metadata fetched for all valid embeds
- [ ] Captions present or warnings issued
- [ ] Platform-specific code generated correctly
- [ ] Accessibility attributes included (title, ARIA, figcaption)
- [ ] Responsive embed wrappers applied
- [ ] Lazy loading enabled
- [ ] meta.yml updated with embed data
- [ ] Embed summary generated
- [ ] Invalid embeds flagged with resolution steps

## Example Output Files

See `.claude/skills/media-embedding/examples/` for:
- `article-with-embeds.md` - Sample article with HTML comment embeds
- `article-with-embeds.html` - Converted WordPress Gutenberg version
- `validation-report.md` - Sample validation report
- `embed-metadata.yml` - Sample meta.yml embeds section

## Configuration

Read from requirements.md:
- **CMS Platform** → Determines embed code format (Gutenberg vs. generic)
- **Accessibility Requirements** → Validates caption/ARIA compliance
- **Brand Guidelines** → May influence embed styling (future enhancement)

## Future Enhancements

Potential additions (not in initial scope):
- Podcast embeds (Spotify, Apple Podcasts, SoundCloud)
- Interactive content (CodePen, JSFiddle, Figma)
- Video hosting (Vimeo, Wistia, Loom)
- Audio clips (SoundCloud, AudioBoom)
- Interactive data visualizations (Tableau, Datawrapper)
- GitHub gists and code snippets
- Custom embed templates per brand

---

**Version:** 1.0
**Last Updated:** 2025-01-12
**Maintained by:** Claude Code (TBM Content System)
