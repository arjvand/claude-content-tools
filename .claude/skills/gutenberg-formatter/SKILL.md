---
description: Convert markdown articles to Gutenberg-compatible HTML for seamless copy-paste into WordPress block editor
allowed-tools: Read, Write, Bash(pandoc:*)
---

# Gutenberg Formatter Skill

Convert markdown articles to native Gutenberg block HTML that pastes directly into WordPress without requiring "Convert to blocks".

## Purpose

WordPress Gutenberg uses a specific HTML comment syntax to define blocks. This skill converts markdown articles into properly formatted Gutenberg blocks that WordPress recognizes immediately when pasted.

## When to Use

- After the @editor agent finalizes an article in `project/Articles/[ARTICLE-ID]/`
- Before publishing to WordPress
- Automatically triggered during the article generation workflow

## Gutenberg Block Format

**Critical:** Each element MUST be wrapped with block comment markers:

```html
<!-- wp:block-type {"optional":"attributes"} -->
<html-element class="wp-block-class">Content</html-element>
<!-- /wp:block-type -->
```

## Conversion Rules

### Headings
```markdown
## H2 Section
```
→
```html
<!-- wp:heading {"level":2} -->
<h2 class="wp-block-heading">H2 Section</h2>
<!-- /wp:heading -->
```

### Paragraphs
```markdown
Regular text paragraph.
```
→
```html
<!-- wp:paragraph -->
<p>Regular text paragraph.</p>
<!-- /wp:paragraph -->
```

### Links (inline within paragraphs)

**CRITICAL:** Link handling depends on link type. External links MUST open in new tabs.

#### External Links (URLs starting with `http://` or `https://`)
```markdown
Check out [this link](https://example.com) for more.
```
→
```html
<!-- wp:paragraph -->
<p>Check out <a href="https://example.com" target="_blank" rel="noopener noreferrer">this link</a> for more.</p>
<!-- /wp:paragraph -->
```

**All external links MUST include:**
- `target="_blank"` — Opens in new tab (required for external URLs)
- `rel="noopener noreferrer"` — Security protection against reverse tabnapping

#### Internal Links (URLs starting with `/`)
```markdown
See our [pricing page](/pricing) for details.
```
→
```html
<!-- wp:paragraph -->
<p>See our <a href="/pricing">pricing page</a> for details.</p>
<!-- /wp:paragraph -->
```

**Internal links do NOT need `target="_blank"`** — they stay within the site for better UX.

### Unordered Lists
```markdown
- Item 1
- Item 2
- Item 3
```
→
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

### Ordered Lists
```markdown
1. First
2. Second
3. Third
```
→
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

### Code Blocks
````markdown
```php
$code = 'example';
```
````
→
```html
<!-- wp:code -->
<pre class="wp-block-code"><code class="language-php">$code = 'example';</code></pre>
<!-- /wp:code -->
```

### Images
```markdown
![Alt text](https://example.com/image.jpg)
```
→
```html
<!-- wp:image -->
<figure class="wp-block-image"><img src="https://example.com/image.jpg" alt="Alt text"/></figure>
<!-- /wp:image -->
```

### Images with Captions
```html
<!-- wp:image -->
<figure class="wp-block-image"><img src="https://example.com/image.jpg" alt="Alt text"/><figcaption class="wp-element-caption">Caption text</figcaption></figure>
<!-- /wp:image -->
```

### Emphasis (inline)
```markdown
**bold** and *italic* text
```
→
```html
<!-- wp:paragraph -->
<p><strong>bold</strong> and <em>italic</em> text</p>
<!-- /wp:paragraph -->
```

### Inline Code
```markdown
Use `code` here
```
→
```html
<!-- wp:paragraph -->
<p>Use <code>code</code> here</p>
<!-- /wp:paragraph -->
```

### Blockquotes
```markdown
> This is a quote
```
→
```html
<!-- wp:quote -->
<blockquote class="wp-block-quote"><!-- wp:paragraph -->
<p>This is a quote</p>
<!-- /wp:paragraph --></blockquote>
<!-- /wp:quote -->
```

### Tables
```markdown
| Header 1 | Header 2 |
|----------|----------|
| Cell 1   | Cell 2   |
```
→
```html
<!-- wp:table -->
<figure class="wp-block-table"><table class="has-fixed-layout"><thead><tr><th>Header 1</th><th>Header 2</th></tr></thead><tbody><tr><td>Cell 1</td><td>Cell 2</td></tr></tbody></table></figure>
<!-- /wp:table -->
```

### Horizontal Rules / Separators
```markdown
---
```
→
```html
<!-- wp:separator -->
<hr class="wp-block-separator has-alpha-channel-opacity"/>
<!-- /wp:separator -->
```

### Media Embeds (YouTube, Twitter, Instagram, etc.)

**YouTube:**
```html
<!-- embed:youtube url="https://www.youtube.com/watch?v=VIDEO_ID" caption="Description" -->
```
→
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
→
```html
<!-- wp:embed {"url":"https://twitter.com/user/status/TWEET_ID","type":"rich","providerNameSlug":"twitter","responsive":true} -->
<figure class="wp-block-embed is-type-rich is-provider-twitter wp-block-embed-twitter"><div class="wp-block-embed__wrapper">
https://twitter.com/user/status/TWEET_ID
</div><figcaption class="wp-element-caption">Caption text</figcaption></figure>
<!-- /wp:embed -->
```

**Supported embed types:** youtube, twitter, instagram, linkedin, tiktok

## Implementation

### Step 1: Read the Markdown Article
```bash
cat project/Articles/[ARTICLE-ID]/article.md
```

### Step 2: Convert to Gutenberg Block HTML

For each markdown element, apply the conversion rules above. **Every element must be wrapped with block comments.**

Process in order:
1. Convert headings with `<!-- wp:heading {"level":N} -->`
2. Convert code blocks with `<!-- wp:code -->`
3. Convert lists with `<!-- wp:list -->` and nested `<!-- wp:list-item -->`
4. Convert blockquotes with `<!-- wp:quote -->`
5. Convert images with `<!-- wp:image -->`
6. Convert tables with `<!-- wp:table -->`
7. Convert horizontal rules with `<!-- wp:separator -->`
8. Convert media embeds with `<!-- wp:embed -->`
9. Wrap remaining paragraphs with `<!-- wp:paragraph -->`
10. Apply inline formatting (bold, italic, links, code) within blocks

### Step 3: Validate Block Structure
- Every opening `<!-- wp:type -->` must have closing `<!-- /wp:type -->`
- Blocks should be separated by blank lines for readability
- Nested blocks (like list-items inside lists) must be properly indented
- No orphan HTML elements without block wrappers

### Step 4: Save HTML File
Save the converted HTML to:
```
project/Articles/[ARTICLE-ID]/article.html
```

### Step 5: Verification Checklist
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

## Output Format Example

```html
<!-- wp:heading {"level":2} -->
<h2 class="wp-block-heading">Introduction</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Welcome to this tutorial on optimizing your WooCommerce store. In this guide, you'll learn practical techniques to improve checkout performance.</p>
<!-- /wp:paragraph -->

<!-- wp:heading {"level":2} -->
<h2 class="wp-block-heading">Prerequisites</h2>
<!-- /wp:heading -->

<!-- wp:list -->
<ul class="wp-block-list"><!-- wp:list-item -->
<li>WooCommerce 8.0 or higher</li>
<!-- /wp:list-item -->

<!-- wp:list-item -->
<li>WordPress 6.4+</li>
<!-- /wp:list-item -->

<!-- wp:list-item -->
<li>Basic understanding of WordPress admin</li>
<!-- /wp:list-item --></ul>
<!-- /wp:list -->

<!-- wp:heading {"level":2} -->
<h2 class="wp-block-heading">Step 1: Configure Checkout Settings</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>Navigate to <strong>WooCommerce → Settings → Checkout</strong> to access the configuration panel.</p>
<!-- /wp:paragraph -->

<!-- wp:paragraph -->
<p>Here's the code you'll need:</p>
<!-- /wp:paragraph -->

<!-- wp:code -->
<pre class="wp-block-code"><code class="language-php">add_filter( 'woocommerce_checkout_fields', 'optimize_checkout_fields' );
function optimize_checkout_fields( $fields ) {
    unset( $fields['billing']['billing_company'] );
    return $fields;
}</code></pre>
<!-- /wp:code -->

<!-- wp:image -->
<figure class="wp-block-image"><img src="/wp-content/uploads/2025/checkout-settings.png" alt="WooCommerce checkout settings panel"/></figure>
<!-- /wp:image -->

<!-- wp:separator -->
<hr class="wp-block-separator has-alpha-channel-opacity"/>
<!-- /wp:separator -->

<!-- wp:heading {"level":2} -->
<h2 class="wp-block-heading">Conclusion</h2>
<!-- /wp:heading -->

<!-- wp:paragraph -->
<p>You've successfully optimized your checkout flow. <strong>Want more tips?</strong> <a href="/subscribe" target="_blank" rel="noopener noreferrer">Subscribe to our newsletter</a> for weekly tutorials.</p>
<!-- /wp:paragraph -->
```

## Usage Example

```bash
# After @editor finalizes article:
# 1. Read the markdown file
cat project/Articles/ART-202510-001/article.md

# 2. Apply gutenberg-formatter skill
# Converts to native Gutenberg block HTML

# 3. Save output
# project/Articles/ART-202510-001/article.html

# 4. Notify user:
"✅ Gutenberg-ready HTML created: project/Articles/ART-202510-001/article.html
Copy contents and paste directly into WordPress - blocks will appear immediately."
```

## Gutenberg Paste Instructions

1. Open the `.html` file
2. Copy all contents (Ctrl+A, Ctrl+C)
3. Open WordPress post editor (Gutenberg)
4. Paste (Ctrl+V)
5. Blocks appear immediately - no conversion needed
6. Review and publish

## Troubleshooting

**Problem:** "Convert to blocks" prompt appears
**Solution:** Check that every element has `<!-- wp:type -->` opening AND `<!-- /wp:type -->` closing comments

**Problem:** Code blocks not formatted correctly
**Solution:** Ensure `<!-- wp:code -->` wrapper and `class="wp-block-code"` on `<pre>`

**Problem:** Lists not recognized as blocks
**Solution:** Each `<li>` must have its own `<!-- wp:list-item -->` wrapper inside the `<!-- wp:list -->`

**Problem:** Images not recognized
**Solution:** Use `<figure class="wp-block-image">` wrapper with `<!-- wp:image -->` comments

**Problem:** Nested blockquote content broken
**Solution:** Paragraphs inside blockquotes need their own `<!-- wp:paragraph -->` wrappers

**Problem:** "Block contains unexpected or invalid content" for embeds
**Solution:** Gutenberg is whitespace-sensitive. Ensure no extra newlines inside embed blocks. The figure element must be on one line with the inner div and figcaption. Add provider-specific class (e.g., `wp-block-embed-youtube`).

**Problem:** External links don't open in new tab
**Solution:** Add `target="_blank" rel="noopener noreferrer"` to all `<a>` tags where the `href` starts with `http://` or `https://`. Internal links (starting with `/`) should NOT have these attributes.
