# Claude Content Tools

A Claude Code Plugin Marketplace for topic-agnostic content generation using AI agents (researcher, writer, editor).

## Installation

Add this marketplace to Claude Code:

```bash
/plugin marketplace add arjvand/claude-content-tools
```

Install the content-generator plugin:

```bash
/plugin install content-generator@claude-content-tools
```

## Features

- **AI Agents**: Specialized researcher, writer, and editor agents for content production
- **14 Skills**: Competitive gap analysis, fact-checking, SEO optimization, and more
- **5 Commands**: Generate content calendars, write articles, create X threads
- **Topic-Agnostic**: Configure for any niche via `requirements.md`
- **6 Example Templates**: WordPress, React, Python, Finance, Psychology, Entertainment

## Quick Start

1. **Install the plugin** (see above)

2. **Choose a topic template** (or use the generic default):
   ```bash
   # Generic technology/business blog (recommended starting point):
   cp plugins/content-generator/examples/requirements-generic.md project/requirements.md

   # Or choose a specialized template:
   # cp plugins/content-generator/examples/requirements-wordpress.md project/requirements.md
   ```

3. **Set up featured image configuration** (required for image generation):
   ```bash
   # Copy the graphic style template and customize with your brand colors:
   cp plugins/content-generator/examples/graphic-template.json project/graphic.json

   # Edit project/graphic.json to add your brand colors and visual style
   ```

4. **Generate a content calendar**:
   ```bash
   /content-generator:content-calendar October 2025
   ```

5. **Write an article**:
   ```bash
   /content-generator:write-article Calendar/2025/October/content-calendar.md ART-202510-001
   ```

## Commands

| Command | Description |
|---------|-------------|
| `/content-generator:content-calendar [Month] [Year]` | Generate monthly content calendar (8-10 articles) |
| `/content-generator:write-article [calendar-path] [article-id]` | Generate complete article from calendar entry |
| `/content-generator:generate-x-post [article-id]` | Generate X (Twitter) thread from article |
| `/content-generator:generate-featured-image [article-id]` | Generate featured image JSON prompt |
| `/content-generator:update-article [article-id]` | Update existing article with edits |

## Agents

| Agent | Role |
|-------|------|
| `@researcher` | Verify originality, gather sources, run gap analysis |
| `@writer` | Create drafts following brand voice and differentiation strategy |
| `@editor` | Review for accuracy, SEO, compliance; final approval |

## Skills

| Skill | Purpose |
|-------|---------|
| `competitive-gap-analyzer` | Analyze competitors, identify differentiation opportunities |
| `content-research` | Research topics with official documentation sources |
| `fact-checker` | Verify claims via source audit or web search |
| `keyword-researcher` | Validate keyword viability, difficulty, search intent |
| `media-discovery` | Discover embeddable media (videos, social posts) |
| `seo-optimization` | Keywords, meta descriptions, internal linking |
| `requirements-validator` | Validate against requirements.md |
| `cms-formatter` | Convert to CMS-specific formats (Gutenberg, Ghost, Medium, HTML) |
| `x-thread-generator` | Generate X (Twitter) threads |
| `featured-image-generator` | Generate image prompts |

## Configuration

All behavior is driven by `project/requirements.md`. Configure:

- **Topic/Platform**: Industry, focus areas, official docs
- **Brand Voice**: Traits, DO/DON'T examples
- **Target Audience**: Roles, skill level
- **Content Strategy**: Formats, word counts, topic pillars
- **SEO Strategy**: Keywords, CTA patterns

**New to configuration?** See `examples/requirements-ANNOTATED-TEMPLATE.md` for comprehensive field-by-field documentation with:
- `[REQUIRED]` vs `[OPTIONAL]` tags
- Impact levels (HIGH/MEDIUM/LOW)
- Which agents/skills use each field
- Troubleshooting guide for common issues

### Example Templates

Pre-built templates in `examples/`:

| Template | Use For |
|----------|---------|
| `requirements-generic.md` | Technology & business (recommended starting point) |
| `requirements-wordpress.md` | WordPress/WooCommerce content |
| `requirements-react.md` | React.js development |
| `requirements-python.md` | Python programming |
| `requirements-finance.md` | Personal finance |
| `requirements-psychology.md` | Psychology/mental health |
| `requirements-entertainment.md` | Entertainment/media |

## Workflow

```
/content-calendar October 2025
    |
    v
Keyword pre-validation (batch)
    |
    v
Gap pre-analysis (batch parallel)
    |
    v
/write-article Calendar/.../ART-202510-001
    |
    v
@researcher (parallel research)
    |
    v
fact-checker (quick mode)
    |
    v
@writer creates draft
    |
    v
@editor reviews
    |
    v
fact-checker (comprehensive)
    |
    v
seo-optimization
    |
    v
Final article + X thread + featured image
```

## Output Structure

```
project/
├── requirements.md                    # Your configuration
├── Calendar/{Year}/{Month}/
│   ├── content-calendar.md            # Monthly calendar
│   ├── keyword-pre-validation/        # Keyword analysis per topic
│   └── gap-pre-analysis/              # Competitive gap analysis
└── Articles/{ARTICLE-ID}/
    ├── research-brief.md              # Research output
    ├── keyword-research.md            # Full keyword analysis
    ├── draft.md                       # Writer output
    ├── article.md                     # Final article
    ├── x-thread.md                    # X thread
    └── featured-image-prompt.json     # Image prompt
```

## Local Development

To work on this plugin locally:

```bash
# Test locally without GitHub
/plugin marketplace add ./
/plugin install content-generator@claude-content-tools

# Validate marketplace structure
/plugin validate .
```

## License

MIT

## Author

Alireza Arjvand

## Links

- [Repository](https://github.com/arjvand/claude-content-tools)
- [Claude Code Docs](https://code.claude.com/docs)
