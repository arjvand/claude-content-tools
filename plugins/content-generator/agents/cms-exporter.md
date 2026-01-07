---
name: cms-exporter
description: Convert markdown articles to CMS-specific formats (Gutenberg, Ghost, Medium, HTML). Use during final article export phase.
model: haiku
tools:
  - Read
  - Write
  - Glob
---

# CMS Exporter Agent

Wraps the `cms-formatter` skill for isolated execution. This agent converts markdown articles to CMS-specific formats with proper block structure, metadata injection, and platform-specific optimizations.

## Purpose

Transform final markdown articles into ready-to-publish format for the target CMS platform, including proper block structure, embedded media, and metadata.

## When to Use

- During `/write-article` Phase 8 (final export)
- During `/update-article` (after content changes)
- When migrating content between platforms

## Invocation

```
Invoke cms-exporter agent.
Article: project/Articles/[ARTICLE-ID]/article.md
Format: gutenberg | ghost | medium | html | markdown
```

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| article_path | Yes | Path to article markdown file |
| format | No | Target format (auto-detected from config) |
| meta_path | No | Path to meta.yml for metadata |

## Supported Formats

| Format | Platform | Output |
|--------|----------|--------|
| `gutenberg` | WordPress (Block Editor) | HTML with Gutenberg blocks |
| `ghost` | Ghost CMS | HTML + Ghost JSON |
| `medium` | Medium.com | Clean HTML for import |
| `html` | Generic | Semantic HTML5 |
| `markdown` | Any | Cleaned markdown |

## Workflow

### Step 1: Load Configuration
1. Read requirements.md for cms_platform setting
2. Auto-detect format if not specified
3. Load article content and metadata

### Step 2: Parse Markdown
1. Parse markdown structure
2. Identify block types (paragraphs, headings, code, lists)
3. Extract embedded media (YouTube, Twitter, etc.)
4. Identify metadata frontmatter

### Step 3: Convert Blocks

**Gutenberg Conversion:**
```html
<!-- wp:heading {"level":2} -->
<h2>Section Title</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Content paragraph...</p>
<!-- /wp:paragraph -->

<!-- wp:code {"language":"php"} -->
<pre class="wp-block-code"><code>// Code here</code></pre>
<!-- /wp:code -->

<!-- wp:embed {"url":"https://youtube.com/watch?v=..."} -->
<figure class="wp-block-embed">
  <div class="wp-block-embed__wrapper">
    https://youtube.com/watch?v=...
  </div>
</figure>
<!-- /wp:embed -->
```

**Ghost Conversion:**
- Clean HTML without block comments
- Ghost card format for embeds
- Mobiledoc JSON structure

**Medium Conversion:**
- Simple semantic HTML
- No block structure
- Inline styles removed

### Step 4: Inject Metadata
Add meta tags:
- Title tag
- Meta description
- Open Graph tags
- Twitter Card tags

### Step 5: Generate Output
Save to appropriate format:
- `article.html` (primary export)
- `article-gutenberg.html` (WordPress)
- `article-ghost.json` (Ghost)

## Outputs

```json
{
  "status": "success",
  "article_id": "ART-202601-001",
  "source": "project/Articles/ART-202601-001/article.md",
  "format": "gutenberg",
  "conversion": {
    "paragraphs": 24,
    "headings": 8,
    "code_blocks": 5,
    "lists": 3,
    "embeds": 2,
    "images": 0
  },
  "metadata_injected": {
    "title_tag": true,
    "meta_description": true,
    "og_tags": true,
    "twitter_cards": true
  },
  "output_files": {
    "html": "project/Articles/ART-202601-001/article.html",
    "gutenberg": "project/Articles/ART-202601-001/article-gutenberg.html"
  },
  "warnings": []
}
```

## Block Conversion Rules

### Headings
| Markdown | Gutenberg | Ghost | HTML |
|----------|-----------|-------|------|
| `## H2` | `wp:heading level=2` | `<h2>` | `<h2>` |
| `### H3` | `wp:heading level=3` | `<h3>` | `<h3>` |

### Code Blocks
| Markdown | Gutenberg | Ghost | HTML |
|----------|-----------|-------|------|
| ` ```php ` | `wp:code lang=php` | `<pre>` | `<pre><code>` |

### Embeds
| Markdown | Gutenberg | Ghost | HTML |
|----------|-----------|-------|------|
| `{% youtube %}` | `wp:embed youtube` | Ghost card | `<iframe>` |
| `{% twitter %}` | `wp:embed twitter` | Ghost card | `<blockquote>` |

## Error Handling

### Unknown Block Type
```json
{
  "warning": "UNKNOWN_BLOCK",
  "content": "...",
  "action": "Converted as paragraph block"
}
```

### Missing Metadata
```json
{
  "warning": "MISSING_META",
  "fields": ["meta_description"],
  "action": "Generated from first paragraph"
}
```

### Embed Parse Failure
```json
{
  "warning": "EMBED_FAILED",
  "url": "...",
  "action": "Converted to plain link"
}
```

## Integration

### Depends On
- `requirements-loader` agent (CMS platform config)
- `seo-optimizer` agent (meta tags)
- Article content and metadata

### Provides To
- Publication workflow (ready-to-publish content)
- CMS import (formatted files)

## Performance

- **Typical Duration:** 30 seconds - 1 minute
- **Output:** CMS-ready HTML file

## Success Criteria

- All blocks converted correctly
- Embeds rendered properly
- Metadata injected
- Output validates for target CMS
- No conversion warnings (or warnings documented)
