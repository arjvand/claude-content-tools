# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

---

## Repository Overview

This is a Claude Code plugin marketplace containing the `content-generator` plugin - a topic-agnostic content generation system using AI agents (researcher, writer, editor).

**Key Distinction:**
- This CLAUDE.md: Plugin development and repository architecture
- `plugins/content-generator/CLAUDE.md`: Content generation usage and workflows

---

## Repository Structure

```
Content-generator/                         # Repository root (plugin marketplace)
├── .claude-plugin/
│   └── marketplace.json                   # Marketplace configuration
├── plugins/
│   └── content-generator/                 # Main plugin
│       ├── .claude-plugin/
│       │   └── plugin.json                # Plugin manifest
│       ├── CLAUDE.md                      # Content generation guide
│       ├── agents/                        # 16 agents (4 persona + 12 skill-specific)
│       ├── commands/                      # 5 slash commands (orchestrators)
│       ├── docs/                          # Architecture documentation
│       ├── skills/                        # 15+ specialized skills
│       └── examples/                      # 7 pre-configured templates
├── project/                               # User content (git-ignored)
│   ├── requirements.md                    # Active configuration
│   ├── Calendar/                          # Monthly content calendars
│   └── Articles/                          # Generated articles
├── README.md                              # User-facing documentation
└── CLAUDE.md                              # This file (development guide)
```

**Git Structure:**
- **Tracked**: Plugin code, documentation, templates
- **Ignored**: `project/` directory (user content)

---

## Plugin Development Commands

### Local Testing
```bash
# Add this marketplace to Claude Code
/plugin marketplace add ./

# Install the plugin locally
/plugin install content-generator@claude-content-tools

# Validate plugin structure
/plugin validate .
```

### Development Workflow
1. Edit plugin files in `plugins/content-generator/`
2. Test changes locally using commands above
3. Validate structure before committing
4. User content automatically goes to `project/` (git-ignored)

---

## Architecture Principles

### Configuration-Driven Design
- **Single Source of Truth**: `project/requirements.md` controls all agent behavior
- **Topic-Agnostic**: Same system works for technology, finance, psychology, entertainment, etc.
- **Switch Topics Instantly**: `cp examples/requirements-react.md project/requirements.md`

All agents, commands, and skills read `requirements.md` at runtime for:
- Industry/niche and focus areas
- Official documentation sources
- Brand voice and tone
- Target audience and skill level
- Content strategy (formats, length, topic mix)
- SEO strategy and distribution channels

### Parallel Execution Pattern
- **Research Phase**: 2 agents run simultaneously
  - Agent 1: Primary sources and evidence verification
  - Agent 2: Competitive landscape and gap analysis
- **Gap Analysis**: Batch parallel mode analyzes 10-15 topics concurrently
- **Result**: Faster content production without sacrificing quality

### Plugin Component Architecture

**16 Agents** (4 persona + 12 skill-specific):

*Persona Agents* (who does the work):
- `@researcher` - Multi-domain research, source verification, gap analysis
- `@writer` - Draft creation with brand voice compliance
- `@editor` - Fact-checking, compliance review, final approval
- `@signal-researcher` - Trend detection and topic discovery

*Skill-Specific Agents* (isolated execution, wrap skills):
- `requirements-loader` - Load and validate config
- `keyword-planner` - Strategic keyword planning
- `keyword-analyst` - Keyword research and validation
- `gap-analyst` - Competitive gap analysis
- `gsc-analyst` - GSC search performance analysis (4 modes)
- `topic-deduplicator` - Check for duplicate topics
- `theme-indexer` - Build theme index
- `fact-checker` - Claim verification
- `media-discoverer` - Find embeddable media
- `seo-optimizer` - SEO recommendations
- `cms-exporter` - CMS-specific export
- `sme-assessor` - SME requirement assessment

**15+ Skills** (specialized tools):
- `competitive-gap-analyzer` - 3 modes: Full, Pre-Analysis, Batch
- `content-research` - Domain-aware source prioritization
- `fact-checker` - Quick (post-research) + Comprehensive (post-writing)
- `gsc-analyzer` - GSC CSV analysis (4 modes: Full, Calendar, Article, Dashboard)
- `media-discovery` - Embeddable media search
- `seo-optimization` - Keywords, meta descriptions, internal linking
- `requirements-validator` - Validate against requirements.md
- `cms-formatter` - Export to Gutenberg/Ghost/Medium/HTML
- Plus more specialized skills

**5 Commands** (user-facing orchestrators):
- `/content-generator:content-calendar` - Generate monthly calendar (8-12 articles)
- `/content-generator:write-article` - Full article production pipeline
- `/content-generator:update-article` - Update existing articles
- `/content-generator:generate-x-post` - Twitter/X thread generation
- `/content-generator:generate-featured-image` - Image prompt generation

**Architecture Pattern**: Commands orchestrate skill-specific agents in sequence. Each skill-specific agent wraps one skill with isolated context for modularity.

---

## Critical File Paths

### Marketplace Configuration
- `.claude-plugin/marketplace.json` - Marketplace metadata
  - Owner: Alireza Arjvand
  - Marketplace name: `claude-content-tools`
  - Version: 1.0.0

### Plugin Manifest
- `plugins/content-generator/.claude-plugin/plugin.json`
  - Plugin name: `content-generator`
  - Description, version, tags
  - Category: content

### Example Templates
Located in `plugins/content-generator/examples/`:
- `requirements-generic.md` - Technology & business (default)
- `requirements-wordpress.md` - WordPress/WooCommerce
- `requirements-react.md` - React.js development
- `requirements-python.md` - Python programming
- `requirements-finance.md` - Personal finance
- `requirements-psychology.md` - Psychology/mental health
- `requirements-entertainment.md` - Entertainment/media

### Architecture Documentation
Located in `plugins/content-generator/docs/`:
- `workflow.md` - Detailed production workflow (9 phases)
- `configuration.md` - Configuration-driven architecture
- `gap-analysis.md` - Competitive gap analysis methodology
- `media-embedding.md` - Media embedding strategy
- `quality-standards.md` - Article structure and brand voice

### Plugin Usage Guide
- `plugins/content-generator/CLAUDE.md` - Content generation workflows, commands, skills

---

## Local Development Setup

### First-Time Setup
```bash
# Clone repository
git clone https://github.com/arjvand/claude-content-tools.git
cd claude-content-tools

# Add marketplace locally
/plugin marketplace add ./

# Install plugin
/plugin install content-generator@claude-content-tools

# Copy a template to start
cp plugins/content-generator/examples/requirements-generic.md project/requirements.md
```

### Testing Plugin Changes
1. Make edits to files in `plugins/content-generator/`
2. Validate structure: `/plugin validate .`
3. Test commands: `/content-generator:content-calendar October 2025`
4. Verify output in `project/Calendar/` and `project/Articles/`

### Understanding Output Structure
All user content goes to `project/` (git-ignored):
```
project/
├── requirements.md                        # Configuration
├── Calendar/{Year}/{Month}/
│   ├── content-calendar.md
│   ├── gsc-calendar-signals.md            # GSC demand signals (if configured)
│   └── gap-pre-analysis/{ID}-summary.md
├── Articles/{ARTICLE-ID}/
│   ├── research-primary.md               # Parallel research agent 1
│   ├── research-landscape.md             # Parallel research agent 2
│   ├── research-brief.md                 # Merged research
│   ├── gap-analysis-report.md
│   ├── gsc-article-data.md               # GSC ranking context (if configured)
│   ├── media-discovery.md
│   ├── claim-audit-quick.md
│   ├── draft.md
│   ├── claim-audit-full.md
│   ├── article.md                        # Final article
│   ├── article.html
│   ├── x-thread.md
│   ├── featured-image-prompt.json
│   └── meta.yml                          # 20-section metadata
└── GSC/                                   # GSC data (if configured)
    ├── {site}-Performance-on-Search-{date}/ # GSC CSV exports
    ├── url-mapping.json                   # Optional URL-to-article map
    └── reports/                           # Generated GSC reports
```

---

## For Content Generation Usage

To use this plugin for content generation (not development), see:
- **`plugins/content-generator/CLAUDE.md`** - Complete usage guide
- **`README.md`** - Quick start and installation

This file focuses on plugin development and repository architecture.

---

## Key Architectural Insights

### Why Configuration-Driven?
- Zero hardcoded assumptions about topic or industry
- Single file change (`requirements.md`) reconfigures entire system
- Same workflow works for technical tutorials, financial analysis, entertainment reviews

### Why Parallel Execution?
- Research phase: 2 agents simultaneously = 50% faster
- Gap analysis: Batch mode for 10-15 topics with competitor caching
- Trade-off: Complexity vs speed (worth it for production workflows)

### Why Topic-Agnostic?
- Domain modules adapt to topic (technology, science, business, policy, health)
- Example templates show cross-domain application
- Competitive gap analysis works regardless of industry

### Why `project/` is Git-Ignored?
- User content is unique to each installation
- Repository tracks plugin code, not generated articles
- Clean separation: code (tracked) vs content (local)
