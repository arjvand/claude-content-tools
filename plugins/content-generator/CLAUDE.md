# CLAUDE.md

Topic-agnostic content generation system using Claude AI agents (researcher, writer, editor) with custom skills for SEO and validation. Adapts to any topic via `requirements.md` configuration.

---

## Commands

```bash
# Generate monthly content calendar (8-10 articles)
/content-calendar October 2025

# Generate article from calendar entry
/write-article Calendar/2025/October/content-calendar.md ART-202510-001

# Generate X (Twitter) thread from article
/generate-x-post ART-202510-001

# Generate Nano Banana JSON prompt for featured image
/generate-featured-image ART-202510-001
```

## Skills

| Skill | Purpose |
|-------|---------|
| `competitive-gap-analyzer` | Analyze competitors, identify differentiation opportunities |
| `content-research` | Research topic with official documentation sources |
| `fact-checker` | Verify claims via source audit (quick) or web search (comprehensive) |
| `gsc-analyzer` | Analyze Google Search Console CSV exports (4 modes: full, calendar, article, dashboard) |
| `keyword-researcher` | Research keywords for volume, difficulty, intent, and long-tail expansion |
| `keyword-strategist` | Strategic keyword planning (clusters, funnel mapping, competitive positioning) |
| `media-discovery` | Discover embeddable media (videos, social posts) with quality filtering |
| `seo-optimization` | Keywords, meta descriptions, internal linking |
| `requirements-validator` | Validate against requirements.md |
| `cms-formatter` | Convert to CMS-specific formats (Gutenberg, Ghost, Medium, HTML) |
| `x-thread-generator` | Generate X (Twitter) threads from articles |
| `featured-image-generator` | Generate Nano Banana JSON prompts for featured images |
| `theme-index-builder` | Build theme index from past calendars for deduplication (12-month lookback, dynamic theme generation) |
| `topic-deduplicator` | Check topic candidates against past content (6-month hard-block, similarity scoring, differentiation analysis) |

---

## File Paths

**CRITICAL: All content files MUST use `project/` prefix.**

```
project/
├── requirements.md                           # Configuration (source of truth)
├── Calendar/{Year}/{Month}/
│   ├── content-calendar.md                   # Monthly calendar
│   ├── keyword-strategy.md                   # Strategic keyword plan (monthly)
│   ├── gsc-calendar-signals.md               # GSC demand signals (if GSC configured)
│   ├── gap-pre-analysis/{ID}-summary.md      # Pre-analysis summaries
│   └── keyword-pre-validation/{ID}-keyword.md # Keyword pre-validation
├── Articles/{ARTICLE-ID}/
│   ├── research-primary.md                   # Agent 1: Primary sources (parallel)
│   ├── research-landscape.md                 # Agent 2: Landscape analysis (parallel)
│   ├── research-brief.md                     # Merged research output
│   ├── keyword-research.md                   # Keyword analysis (full mode)
│   ├── keyword-strategy.md                   # Article keyword strategy
│   ├── media-discovery.md                    # Embed candidates (post-research)
│   ├── gap-analysis-report.md                # Competitive analysis
│   ├── gsc-article-data.md                   # GSC ranking context (if GSC configured)
│   ├── claim-audit-quick.md                  # Quick fact-check (post-research)
│   ├── draft.md                              # Writer output
│   ├── claim-audit-full.md                   # Comprehensive fact-check (post-writing)
│   ├── article.md                            # Final article
│   ├── article.html                          # HTML export (if configured)
│   ├── x-thread.md                           # X (Twitter) thread
│   ├── featured-image-prompt.json            # Nano Banana image prompt
│   └── meta.yml                              # Metadata
└── GSC/                                      # GSC data (if configured)
    ├── {site}-Performance-on-Search-{date}/  # GSC CSV export folder
    │   ├── Queries.csv, Pages.csv, Chart.csv # Core CSVs
    │   ├── Devices.csv, Countries.csv        # Optional CSVs
    │   └── Search appearance.csv, Filters.csv
    ├── url-mapping.json                      # Optional: manual URL-to-article-ID map
    └── reports/                              # Generated GSC analysis reports
```

**Article ID Format:** `ART-YYYYMM-NNN` (e.g., `ART-202510-001`)

---

## Configuration

All agents read `requirements.md` at runtime for:
- Topic/Platform, Official Documentation Sources
- Brand Voice, Target Audience, Content Mix
- Word Count Range, CTA, CMS Platform
- Search Analytics (optional): GSC export path, analysis modes, filters

**New to configuration?** See `examples/requirements-ANNOTATED-TEMPLATE.md` for comprehensive documentation:
- Field-by-field explanations with `[REQUIRED]` vs `[OPTIONAL]` tags
- Impact levels and which agents use each field
- Troubleshooting guide for common configuration issues
- Configuration validation checklist

**Switch topics:**
```bash
cp examples/requirements-react.md project/requirements.md
```

Available examples: `generic` (recommended), `wordpress`, `react`, `python`, `finance`, `psychology`, `entertainment`

---

## Agents

### Persona Agents (Who does the work)

| Agent | Role |
|-------|------|
| `@researcher` | Verify originality, gather sources, run gap analysis, produce research brief |
| `@writer` | Create draft following brand voice and differentiation strategy |
| `@editor` | Review for accuracy, SEO, compliance; generate HTML export; final approval |
| `@signal-researcher` | Trend detection, topic discovery, signal analysis |

### Skill-Specific Agents (Isolated execution)

| Agent | Wraps Skill | Purpose |
|-------|-------------|---------|
| `requirements-loader` | requirements-extractor | Load and validate config |
| `keyword-planner` | keyword-strategist | Strategic keyword planning |
| `keyword-analyst` | keyword-researcher | Keyword research and validation |
| `gap-analyst` | competitive-gap-analyzer | Competitive gap analysis |
| `gsc-analyst` | gsc-analyzer | GSC search performance analysis (4 modes) |
| `topic-deduplicator` | topic-deduplicator | Check for duplicate topics |
| `theme-indexer` | theme-index-builder | Build theme index |
| `fact-checker` | fact-checker | Claim verification |
| `media-discoverer` | media-discovery | Find embeddable media |
| `seo-optimizer` | seo-optimization | SEO recommendations |
| `cms-exporter` | cms-formatter | CMS-specific export |
| `sme-assessor` | sme-complexity-assessor | SME requirement assessment |

**Architecture:** Commands orchestrate by invoking skill-specific agents in sequence. Each agent:
- Wraps a specific skill
- Operates in isolated context
- Returns structured output

**Parallel Research Pattern**: The `/write-article` workflow runs 2x `@researcher` agents in parallel:
- **Agent 1**: Primary sources and official documentation research
- **Agent 2**: Competitive landscape and gap analysis

See `docs/workflow.md` Phase 2 for complete parallel execution documentation.

---

## Critical Rules

### Path Rules
- **MUST** use `project/` prefix for all content files
- **MUST** use `Articles/{ARTICLE-ID}/` folder structure (not deprecated `Ready/` folder)
- **NEVER** create files in root directory

### Content Rules
- **MUST** read `requirements.md` before writing
- **MUST** verify topic originality via web search
- **MUST** run competitive gap analysis for every article
- **MUST** run fact-check audit (quick after research, comprehensive during editing)
- **MUST** check word count with `wc -w` before handoff
- **IMPORTANT**: Flag content requiring legal/compliance review (benchmarks, claims, comparisons)

### Quality Rules
- **MUST** include practical examples appropriate to domain
- **MUST** follow configured brand voice (no hype, no marketing fluff)
- **IMPORTANT**: All embeds must be from credible sources, directly relevant, max 1-3 per article

---

## Workflow Summary

1. **Planning**: `/content-calendar` → gap pre-analysis → select 8-12 high-opportunity topics
2. **Research** (parallel): 2x `@researcher` agents → primary sources + landscape analysis → merge → quick fact-check
3. **Writing**: `@writer` → implement differentiation strategy → draft
4. **SEO**: `seo-optimization` skill → keywords, meta, internal links
5. **Review**: `@editor` → comprehensive fact-check → validate requirements → HTML export → final approval
6. **Distribution**: `/generate-x-post` → X thread for social promotion
7. **Publish**: Schedule via newsletter/RSS

See `docs/workflow.md` for detailed phase documentation.

---

## Quick Reference

```bash
# Check word count
wc -w project/Articles/ART-202510-001/draft.md

# View article files
ls -la project/Articles/ART-202510-001/

# Find article across codebase
grep -r "ART-202510-001" project/

# Verify spelling (US English - check for UK)
grep -E "(optimise|colour|centre|analyse)" project/Articles/ART-202510-001/article.md

# View current config
cat project/requirements.md

# Generate X thread
/generate-x-post ART-202510-001

# Generate featured image prompt
/generate-featured-image ART-202510-001
```

---

## Article Formats

**Tutorial/How-To:** Hook → Prerequisites → Steps (with WHY) → Verification → Next Steps + CTA

**Analysis/Opinion:** Current State → Analysis + Evidence → Practical Impact → Forward Look

**Announcement/News:** The News → Why It Matters → How to Apply → Resources

---

## SEO Checklist

- Primary keyword in H1, first 100 words, and one H2
- Keyword density: 1-2%
- Meta description: 150-160 chars with keyword + CTA
- Title tag: 50-60 chars
- 3-5 internal links with descriptive anchor text
- Short paragraphs (2-4 sentences)
- Logical H1/H2/H3 hierarchy

---

## Extended Documentation

| Document | Content |
|----------|---------|
| `docs/workflow.md` | Detailed content production workflow |
| `docs/gap-analysis.md` | Competitive gap analysis process |
| `docs/media-embedding.md` | Media embedding strategy |
| `docs/quality-standards.md` | Article structure, brand voice, domain-specific rules |
| `docs/configuration.md` | Configuration-driven architecture details |

---

## Agents Directory

```
agents/
├── # Persona Agents (who does the work)
├── researcher.md           # Research and fact-checking
├── writer.md               # Content creation
├── editor.md               # Editorial review
├── signal-researcher.md    # Trend analysis
│
├── # Skill-Specific Agents (isolated execution)
├── requirements-loader.md  # Wraps requirements-extractor
├── keyword-planner.md      # Wraps keyword-strategist
├── keyword-analyst.md      # Wraps keyword-researcher
├── gap-analyst.md          # Wraps competitive-gap-analyzer
├── gsc-analyst.md          # Wraps gsc-analyzer
├── topic-deduplicator.md   # Wraps topic-deduplicator
├── theme-indexer.md        # Wraps theme-index-builder
├── fact-checker.md         # Wraps fact-checker skill
├── media-discoverer.md     # Wraps media-discovery
├── seo-optimizer.md        # Wraps seo-optimization
├── cms-exporter.md         # Wraps cms-formatter
└── sme-assessor.md         # Wraps sme-complexity-assessor
```

## Skills Directory

```
skills/
├── competitive-gap-analyzer/
├── content-research/
├── fact-checker/
├── gsc-analyzer/
├── keyword-researcher/
├── keyword-strategist/
├── media-discovery/
├── seo-optimization/
├── requirements-validator/
├── cms-formatter/
├── x-thread-generator/
├── featured-image-generator/
├── theme-index-builder/
├── topic-deduplicator/
└── sme-complexity-assessor/
```
