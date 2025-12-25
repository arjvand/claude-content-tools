---
name: cms-formatter
description: Convert markdown articles to CMS-specific formats for seamless publishing (Gutenberg, Ghost, Medium, HTML, Markdown)
allowed-tools: Read, Write, Bash(pandoc:*)
---

# CMS Formatter Skill

Convert markdown articles to CMS-specific output formats for seamless publishing across different platforms.

## Purpose

Different CMS platforms require different HTML formats. This skill detects the target format from `requirements.md` and applies appropriate conversion rules.

## Supported Formats

| Format | Platform | Output |
|--------|----------|--------|
| `gutenberg` | WordPress | Gutenberg block HTML with `<!-- wp:* -->` comments |
| `ghost` | Ghost | Clean semantic HTML |
| `medium` | Medium, Dev.to | Simple semantic HTML |
| `html` | Any web platform | Generic semantic HTML5 |
| `markdown` | Static sites (Hugo, Jekyll, Astro) | Passthrough (no conversion) |

## When to Use

- After the @editor agent finalizes an article in `project/Articles/[ARTICLE-ID]/`
- Before publishing to your CMS
- Automatically triggered during the article generation workflow

## Format Detection

**Step 1: Load configuration using requirements-extractor and extract Export Format:**

```markdown
Please use the requirements-extractor skill to load validated configuration from project/requirements.md.
```

**Extract from structured output:**
- **Export Format** from `cms.export_format` (preferred)
- **CMS Platform** from `cms.platform` (fallback for legacy configs)

**Format Resolution:**
1. If `cms.export_format` is specified, use that value
2. Else if `cms.platform` contains "WordPress" or "Gutenberg", use `gutenberg`
3. Else if `cms.platform` contains "Ghost", use `ghost`
4. Else if `cms.platform` contains "Medium", use `medium`
5. Else default to `markdown` (passthrough, no HTML conversion)

The requirements-extractor provides validated, structured configuration eliminating parsing errors.

---

## Format: Gutenberg (WordPress)

WordPress Gutenberg uses a specific HTML comment syntax to define blocks. This format converts markdown into properly formatted Gutenberg blocks that WordPress recognizes immediately when pasted.

### Gutenberg Block Format

**Critical:** Each element MUST be wrapped with block comment markers:

```html
<!-- wp:block-type {"optional":"attributes"} -->
<html-element class="wp-block-class">Content</html-element>
<!-- /wp:block-type -->
```

### Gutenberg Conversion Rules

#### Headings
```markdown
## H2 Section
```
->
```html
<!-- wp:heading {"level":2} -->
<h2 class="wp-block-heading">H2 Section</h2>
<!-- /wp:heading -->
```

#### Paragraphs
```markdown
Regular text paragraph.
```
->
```html
<!-- wp:paragraph -->
<p>Regular text paragraph.</p>
<!-- /wp:paragraph -->
```

#### Links (inline within paragraphs)

**CRITICAL:** Link handling depends on link type. External links MUST open in new tabs.

**External Links (URLs starting with `http://` or `https://`):**
```markdown
Check out [this link](https://example.com) for more.
```
->
```html
<!-- wp:paragraph -->
<p>Check out <a href="https://example.com" target="_blank" rel="noopener noreferrer">this link</a> for more.</p>
<!-- /wp:paragraph -->
```

**All external links MUST include:**
- `target="_blank"` - Opens in new tab (required for external URLs)
- `rel="noopener noreferrer"` - Security protection against reverse tabnapping

**Internal Links (URLs starting with `/`):**
```markdown
See our [pricing page](/pricing) for details.
```
->
```html
<!-- wp:paragraph -->
<p>See our <a href="/pricing">pricing page</a> for details.</p>
<!-- /wp:paragraph -->
```

**Internal links do NOT need `target="_blank"`** - they stay within the site for better UX.

#### Unordered Lists
```markdown
- Item 1
- Item 2
- Item 3
```
->
```html
<!-- wp:list -->
<ul class="wp-block-list"><!-- wp:list-item -->
<li>Item 1</li>
<!-- /wp:list-item -->

<!-- wp:list-item -->
<li>Item 2</li>
<!-- /wp:list-item -->

<!-- wp:list-item -->
<li>Item 3</li>
<!-- /wp:list-item --></ul>
<!-- /wp:list -->
```

#### Ordered Lists
```markdown
1. First
2. Second
3. Third
```
->
```html
<!-- wp:list {"ordered":true} -->
<ol class="wp-block-list"><!-- wp:list-item -->
<li>First</li>
<!-- /wp:list-item -->

<!-- wp:list-item -->
<li>Second</li>
<!-- /wp:list-item -->

<!-- wp:list-item -->
<li>Third</li>
<!-- /wp:list-item --></ol>
<!-- /wp:list -->
```

#### Code Blocks
````markdown
```php
$code = 'example';
```
````
->
```html
<!-- wp:code -->
<pre class="wp-block-code"><code class="language-php">$code = 'example';</code></pre>
<!-- /wp:code -->
```

#### Images
```markdown
![Alt text](https://example.com/image.jpg)
```
->
```html
<!-- wp:image -->
<figure class="wp-block-image"><img src="https://example.com/image.jpg" alt="Alt text"/></figure>
<!-- /wp:image -->
```

#### Images with Captions
```html
<!-- wp:image -->
<figure class="wp-block-image"><img src="https://example.com/image.jpg" alt="Alt text"/><figcaption class="wp-element-caption">Caption text</figcaption></figure>
<!-- /wp:image -->
```

#### Emphasis (inline)
```markdown
**bold** and *italic* text
```
->
```html
<!-- wp:paragraph -->
<p><strong>bold</strong> and <em>italic</em> text</p>
<!-- /wp:paragraph -->
```

#### Inline Code
```markdown
Use `code` here
```
->
```html
<!-- wp:paragraph -->
<p>Use <code>code</code> here</p>
<!-- /wp:paragraph -->
```

#### Blockquotes
```markdown
> This is a quote
```
->
```html
<!-- wp:quote -->
<blockquote class="wp-block-quote"><!-- wp:paragraph -->
<p>This is a quote</p>
<!-- /wp:paragraph --></blockquote>
<!-- /wp:quote -->
```

#### Tables
```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
```
->
```html
<!-- wp:table -->
<figure class="wp-block-table"><table class="has-fixed-layout"><thead><tr><th>Header 1</th><th>Header 2</th></tr></thead><tbody><tr><td>Cell 1</td><td>Cell 2</td></tr></tbody></table></figure>
<!-- /wp:table -->
```

#### Horizontal Rules / Separators
```markdown
---
```
->
```html
<!-- wp:separator -->
<hr class="wp-block-separator has-alpha-channel-opacity"/>
<!-- /wp:separator -->
```

#### Media Embeds (YouTube, Twitter, Instagram, etc.)

**YouTube:**
```html
<!-- embed:youtube url="https://www.youtube.com/watch?v=VIDEO_ID" caption="Description" -->
```
->
```html
<!-- wp:embed {"url":"https://www.youtube.com/watch?v=VIDEO_ID","type":"video","providerNameSlug":"youtube","responsive":true,"className":"wp-embed-aspect-16-9 wp-has-aspect-ratio"} -->
<figure class="wp-block-embed is-type-video is-provider-youtube wp-block-embed-youtube wp-embed-aspect-16-9 wp-has-aspect-ratio"><div class="wp-block-embed__wrapper">
https://www.youtube.com/watch?v=VIDEO_ID
</div><figcaption class="wp-element-caption">Description</figcaption></figure>
<!-- /wp:embed -->
```

**Note:** Gutenberg is whitespace-sensitive for embeds. The figure, div, and figcaption must be on connected lines with no extra newlines between them.

**Twitter/X:**
```html
<!-- embed:twitter url="https://twitter.com/user/status/TWEET_ID" caption="Caption text" -->
```
->
```html
<!-- wp:embed {"url":"https://twitter.com/user/status/TWEET_ID","type":"rich","providerNameSlug":"twitter","responsive":true} -->
<figure class="wp-block-embed is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper">
https://twitter.com/user/status/TWEET_ID
</div><figcaption class="wp-element-caption">Caption text</figcaption></figure>
<!-- /wp:embed -->
```

**Supported embed types:** youtube, twitter, instagram, linkedin, tiktok

### Gutenberg Verification Checklist
- [ ] All headings wrapped with `<!-- wp:heading -->`
- [ ] All paragraphs wrapped with `<!-- wp:paragraph -->`
- [ ] All lists wrapped with `<!-- wp:list -->` and items with `<!-- wp:list-item -->`
- [ ] All code blocks wrapped with `<!-- wp:code -->`
- [ ] All images wrapped with `<!-- wp:image -->`
- [ ] All blockquotes wrapped with `<!-- wp:quote -->`
- [ ] All tables wrapped with `<!-- wp:table -->`
- [ ] All separators wrapped with `<!-- wp:separator -->`
- [ ] Media embeds have proper `<!-- wp:embed -->` structure
- [ ] **All external links (http/https) have `target="_blank" rel="noopener noreferrer"`**
- [ ] **Internal links (starting with `/`) do NOT have `target="_blank"`**
- [ ] No closing tag mismatches
- [ ] Pastes into Gutenberg without "Convert to blocks" prompt

---

## Format: Ghost

Ghost accepts clean semantic HTML. No special block comments needed.

### Ghost Conversion Rules

#### Headings
```markdown
## Section Title
```
->
```html
<h2>Section Title</h2>
```

#### Paragraphs
```markdown
Regular text paragraph.
```
->
```html
<p>Regular text paragraph.</p>
```

#### Links
```markdown
Check out [this link](https://example.com) for more.
```
->
```html
<p>Check out <a href="https://example.com">this link</a> for more.</p>
```

#### Lists
```markdown
- Item 1
- Item 2
```
->
```html
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
</ul>
```

#### Code Blocks
````markdown
```javascript
const x = 1;
```
````
->
```html
<pre><code class="language-javascript">const x = 1;</code></pre>
```

#### Images
```markdown
![Alt text](https://example.com/image.jpg)
```
->
```html
<figure>
  <img src="https://example.com/image.jpg" alt="Alt text">
  <figcaption>Alt text</figcaption>
</figure>
```

#### Blockquotes
```markdown
> This is a quote
```
->
```html
<blockquote>This is a quote</blockquote>
```

#### Horizontal Rules
```markdown
---
```
->
```html
<hr>
```

### Ghost Verification Checklist
- [ ] Clean semantic HTML without CMS-specific wrappers
- [ ] Code blocks have language class
- [ ] Images wrapped in `<figure>` with optional `<figcaption>`
- [ ] No orphan text outside of elements

---

## Format: Medium

Medium and Dev.to accept simple semantic HTML. Keep it minimal.

### Medium Conversion Rules

Use same rules as Ghost format with these restrictions:
- No custom classes or attributes
- No inline styles
- Code blocks use `<pre>` without language hints
- Simple `<img>` tags (no `<figure>` wrapper)

#### Code Blocks (Medium)
````markdown
```javascript
const x = 1;
```
````
->
```html
<pre>const x = 1;</pre>
```

#### Images (Medium)
```markdown
![Alt text](https://example.com/image.jpg)
```
->
```html
<img src="https://example.com/image.jpg" alt="Alt text">
```

### Medium Verification Checklist
- [ ] No custom classes
- [ ] No inline styles
- [ ] Simple HTML elements only
- [ ] Code blocks use plain `<pre>`

---

## Format: HTML (Generic)

Clean semantic HTML5 for any web platform.

### HTML Conversion Rules

Use standard HTML5 semantic elements:

#### Document Structure
```html
<article>
  <h1>Title</h1>
  <p>Introduction paragraph.</p>

  <h2>Section</h2>
  <p>Content with <a href="url">links</a>.</p>

  <figure>
    <img src="url" alt="description" loading="lazy">
    <figcaption>Caption</figcaption>
  </figure>
</article>
```

#### Code Blocks
```html
<pre><code class="language-javascript">const x = 1;</code></pre>
```

#### Blockquotes
```html
<blockquote>
  <p>Quote text</p>
</blockquote>
```

### HTML Verification Checklist
- [ ] Valid HTML5 structure
- [ ] Semantic elements used appropriately
- [ ] Images have alt text and `loading="lazy"`
- [ ] Code blocks have language class

---

## Format: Markdown (Passthrough)

No conversion needed. The markdown file is the final output.

### When to Use
- Static site generators (Hugo, Jekyll, Astro, Eleventy)
- Documentation platforms (GitBook, Docusaurus)
- Any system that processes markdown directly

### Passthrough Behavior
1. Read `project/Articles/[ARTICLE-ID]/article.md`
2. No HTML conversion
3. `article.md` is the final deliverable
4. No `article.html` file created

---

## Implementation

### Step 1: Detect Format

**Use previously loaded configuration from requirements-extractor:**
- Extract `cms.export_format` or `cms.platform` from structured output
- Follow format resolution rules (see Format Detection section above)

### Step 2: Read the Markdown Article

```bash
cat project/Articles/[ARTICLE-ID]/article.md
```

### Step 3: Apply Format-Specific Conversion

Based on detected format, apply the conversion rules from the appropriate section above.

**Process order for HTML formats:**
1. Convert headings
2. Convert code blocks (preserve language hints)
3. Convert lists
4. Convert blockquotes
5. Convert images
6. Convert tables
7. Convert horizontal rules
8. Convert media embeds
9. Wrap remaining paragraphs
10. Apply inline formatting (bold, italic, links, code)

### Step 4: Save Output

**For Gutenberg/Ghost/Medium/HTML:**
```
project/Articles/[ARTICLE-ID]/article.html
```

**For Markdown (passthrough):**
No additional file - `article.md` is the final output.

### Step 5: Notify User

```
Gutenberg: "Gutenberg-ready HTML created: project/Articles/[ARTICLE-ID]/article.html
Copy contents and paste directly into WordPress - blocks will appear immediately."

Ghost: "Ghost-compatible HTML created: project/Articles/[ARTICLE-ID]/article.html
Paste into Ghost editor or import via API."

Medium: "Medium-compatible HTML created: project/Articles/[ARTICLE-ID]/article.html
Paste into Medium editor."

HTML: "HTML export created: project/Articles/[ARTICLE-ID]/article.html"

Markdown: "Article ready: project/Articles/[ARTICLE-ID]/article.md
No HTML conversion needed for your static site generator."
```

---

## Troubleshooting

### Gutenberg Issues

**Problem:** "Convert to blocks" prompt appears
**Solution:** Check that every element has `<!-- wp:type -->` opening AND `<!-- /wp:type -->` closing comments

**Problem:** Code blocks not formatted correctly
**Solution:** Ensure `<!-- wp:code -->` wrapper and `class="wp-block-code"` on `<pre>`

**Problem:** Lists not recognized as blocks
**Solution:** Each `<li>` must have its own `<!-- wp:list-item -->` wrapper inside the `<!-- wp:list -->`

**Problem:** "Block contains unexpected or invalid content" for embeds
**Solution:** Gutenberg is whitespace-sensitive. Ensure no extra newlines inside embed blocks.

**Problem:** External links don't open in new tab
**Solution:** Add `target="_blank" rel="noopener noreferrer"` to all external links.

### Ghost Issues

**Problem:** Content doesn't render correctly
**Solution:** Ensure clean HTML without extra attributes or classes

### Medium Issues

**Problem:** Formatting lost on paste
**Solution:** Use only basic HTML elements; remove any custom classes

### General Issues

**Problem:** Unknown format specified
**Solution:** Check `Export Format` value in requirements.md. Valid values: gutenberg, ghost, medium, html, markdown
