---
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

**Before optimizing, read requirements.md to understand the project:**

```bash
!cat project/requirements.md
```

**Extract the following configuration:**

1. **Topic & Platform**:
   - Look for: `**Industry/Niche**:` → [Extract target domain]
   - Look for: `**Specific Platform/Product**:` → [Extract platform]

2. **Audience**:
   - Look for: `**Primary Roles**:` → [Extract target audience]
   - Look for: `**Skill Level**:` → [Extract level]

3. **Official Sources** (for external linking):
   - Look for: `**Primary Documentation**:` → [Extract URLs]
   - Look for: `**Official Blogs**:` → [Extract URLs]
   - Look for: `**Other Authoritative Sources**:` → [Extract sources]

4. **SEO Strategy**:
   - Look for: `**SEO Intent**:` → [Extract strategy]
   - Look for: `**Primary CTA**:` → [Extract CTA]

**Use these extracted values throughout the optimization process.**

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
- SEO score checklist
- Improvement recommendations

## External Link Best Practices

### When to Link Externally

**Read requirements.md first to identify official sources:**
```bash
!cat project/requirements.md
```

Extract:
- **Primary Documentation**: Official docs URLs
- **Official Blogs**: Official news/blog URLs
- **Other Authoritative Sources**: Standards, community resources

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