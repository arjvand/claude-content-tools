# WordPress/WooCommerce Content Generation System

An AI-powered content generation and editorial workflow system built with Claude Code for producing high-quality WordPress and WooCommerce blog content.

## Overview

This project automates the content creation process for a WordPress/WooCommerce-focused blog, from initial content calendar planning through article research, writing, SEO optimization, and editorial review. The system uses Claude AI agents with specialized skills to ensure consistent brand voice, technical accuracy, and SEO best practices.

## Features

- **Automated Content Calendar Generation**: Creates monthly content calendars with original, timely, and SEO-optimized topics
- **Multi-Phase Article Production**: Complete workflow from research to publication-ready content
- **Specialized AI Agents**: Dedicated agents for research, writing, and editing with domain expertise
- **SEO Optimization**: Built-in SEO analysis and optimization for better search visibility
- **Requirements Validation**: Automated checks against brand voice, audience level, and editorial standards
- **Flexible Content Formats**: Supports tutorials/how-tos, industry analysis/opinion pieces, and product announcements

## Project Structure

```
Blog2/
├── .claude/                    # Claude Code configuration
│   ├── agents/                 # Specialized AI agents
│   │   ├── researcher.md       # Research agent for gathering information
│   │   ├── writer.md          # Writing agent for content creation
│   │   └── editor.md          # Editorial review agent
│   ├── commands/               # Custom slash commands
│   │   ├── content-calendar.md # Generate monthly content calendars
│   │   └── write-article.md    # Create complete articles
│   ├── skills/                 # Specialized skills
│   │   ├── requirements-validator/  # Validate against requirements.md
│   │   └── seo-optimization/       # SEO analysis and optimization
│   └── settings.local.json    # Local configuration
├── Articles/                   # Generated content
│   ├── Drafts/                # Work-in-progress articles
│   └── Ready/                 # Publication-ready articles
├── Calendar/                   # Content calendars
│   └── 2025/
│       └── October/
│           └── content-calendar.md
└── requirements.md            # Editorial requirements and brand guidelines
```

## Content Requirements

The system follows strict editorial requirements defined in [requirements.md](requirements.md):

- **Niche**: WordPress plugins (performance, security, ecommerce, editorial workflow)
- **Target Audience**: Site owners, freelance developers, agencies, content managers (beginner to intermediate)
- **Brand Voice**: Friendly, approachable, practical, precise, no hype
- **Focus**: WooCommerce-first, then general WordPress
- **Content Mix**: Tutorials (40-60%), industry analysis (20-40%), product announcements (0-20%)
- **Length**: 700-2,200 words (quality-first approach)
- **Language**: US English
- **SEO Strategy**: Keyword-first, topic clusters/pillars, trend/opportunistic

## Usage

### Prerequisites

- Claude Code (VS Code Extension or CLI)
- Access to Claude Sonnet 4.5 model

### Generate a Content Calendar

Create a monthly content calendar with 8-10 original, timely article ideas:

```bash
/content-calendar October 2025
```

The command will:
1. Research recent WooCommerce/WordPress developments
2. Verify topic originality through web searches
3. Generate a content calendar table with keywords, formats, and priorities
4. Save to `Calendar/{Year}/{Month}/content-calendar.md`

### Generate an Article

Create a complete, publication-ready article from a calendar entry:

```bash
/write-article Calendar/2025/October/content-calendar.md 1
```

The workflow includes:
1. **Research Phase**: Gather recent updates, verify uniqueness, identify angles
2. **Outline Creation**: Structure content based on format (tutorial/analysis)
3. **Draft Writing**: Create content following brand voice guidelines
4. **SEO Optimization**: Optimize metadata, keywords, and internal linking
5. **Editorial Review**: Validate requirements, technical accuracy, and readability
6. **Metadata Generation**: Create publication metadata file

Output files:
- Draft: `Articles/Drafts/YYYY-MM-DD-[slug].md`
- Final: `Articles/Ready/YYYY-MM-DD-[slug].md`
- Metadata: `Articles/Ready/YYYY-MM-DD-[slug]-meta.yml`

## Custom Skills

### Requirements Validator
Validates content against specifications in [requirements.md](requirements.md) including brand voice, audience level, length, and format requirements.

### SEO Optimization
Optimizes content for search engines with keyword placement, meta descriptions, internal linking suggestions, and content structure improvements.

## Workflow

### Content Production Pipeline

1. **Planning** → Generate monthly content calendar
2. **Research** → Verify originality and gather information
3. **Writing** → Create draft following brand guidelines
4. **SEO** → Optimize for search visibility
5. **Review** → Editorial QA and validation
6. **Ready** → Legal/compliance review (external)
7. **Publish** → Schedule and distribute

### Review Requirements

- All posts require legal/compliance review
- Extra scrutiny for claims, benchmarks, comparisons
- SME involvement required for technical tutorials
- Author self-publish after approvals

## Distribution Channels

- Newsletter (primary CTA)
- RSS feed

## Quality Standards

- **Originality**: Every topic verified for uniqueness through web research
- **Timeliness**: Content tied to recent releases, updates, or emerging trends
- **Audience Fit**: Appropriate skill level (beginner to intermediate)
- **SEO Excellence**: Keyword-optimized with proper internal linking
- **Brand Consistency**: Friendly, practical, precise voice with no hype
- **Technical Accuracy**: SME-reviewed where required

## Configuration

### Local Settings

Custom configuration in [.claude/settings.local.json](.claude/settings.local.json)

### Modifying Requirements

Edit [requirements.md](requirements.md) to adjust:
- Target audience
- Brand voice traits
- Content strategy
- Editorial policies
- Distribution channels

## Key Metrics

- **Primary KPI**: Brand lift/impressions
- **Content Quality**: Assessed via editorial review
- **SEO Performance**: Keyword rankings, organic traffic
- **Engagement**: Newsletter subscriptions, community feedback

## License

This project is proprietary content generation system for WordPress/WooCommerce content.

## Support

For issues or questions about using this system, refer to Claude Code documentation or contact the editorial team.
