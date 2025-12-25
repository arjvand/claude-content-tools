# Configuration-Driven Architecture

How the system adapts to any topic through `requirements.md` configuration.

---

## How It Works

All agents, commands, and skills read `requirements.md` at runtime to extract:

| Configuration | Purpose |
|---------------|---------|
| Topic/Platform | What you're writing about |
| Official Documentation | Where authoritative sources are |
| Brand Voice | How content should sound |
| Target Audience | Who you're writing for |
| Content Strategy | What formats and mix to use |

**Result:** Change one file to completely reconfigure the entire system.

---

## Quick Start

### 1. Copy the template

```bash
cp requirements-template.md project/requirements.md
```

### 2. Fill in project details

- Industry/Niche
- Platform/Product
- Official Documentation Sources
- Brand Identity
- Focus Areas

### 3. Run the workflow

```bash
/content-calendar October 2025
/write-article Calendar/2025/October/content-calendar.md ART-202510-001
```

---

## Available Example Configurations

| Example | Domain | File |
|---------|--------|------|
| WordPress/WooCommerce | Technical web development | `examples/requirements-wordpress.md` |
| React.js | Frontend framework tutorials | `examples/requirements-react.md` |
| Python | Data science and automation | `examples/requirements-python.md` |
| Personal Finance | Investment and retirement | `examples/requirements-finance.md` |
| Psychology | Clinical practice guidance | `examples/requirements-psychology.md` |
| Entertainment | Film and TV criticism | `examples/requirements-entertainment.md` |

---

## Switching Topics

```bash
# View available configurations
ls examples/

# Switch to React.js
cp examples/requirements-react.md project/requirements.md

# Switch to Finance
cp examples/requirements-finance.md project/requirements.md

# All subsequent generation uses new config
/content-calendar November 2025
```

---

## Configuration Dimensions

### Example Comparison

| Dimension | WordPress | React.js | Python |
|-----------|-----------|----------|--------|
| **Niche** | Plugins, e-commerce | Components, patterns | Data, ML, automation |
| **Audience** | Site owners, devs (beginner-intermediate) | JS devs (intermediate) | Data pros (beginner-advanced) |
| **Brand Voice** | Friendly, practical | Clear, example-driven | Rigorous, educational |
| **Content Mix** | Tutorials 40-60%, analysis 20-40% | Tutorials 60-80%, deep-dives 20-40% | Tutorials 50%, cases 30%, theory 20% |
| **Length** | 700-2,200 words | 1,000-3,000 words | 1,500-4,000 words |
| **Examples** | Code snippets, plugin configs | CodeSandbox, GitHub repos | Jupyter notebooks, datasets |
| **CTA** | Newsletter subscribe | GitHub star, newsletter | Course enrollment, newsletter |

---

## Universal vs. Platform-Specific Components

### Universal (Topic-Agnostic)

These adapt to any topic via configuration:

- **Agents**: researcher, writer, editor
- **Commands**: content-calendar, write-article
- **Skills**: competitive-gap-analyzer, content-research, seo-optimization, requirements-validator

### Platform-Specific

Tied to specific platforms:

| Skill | Platform | Configuration |
|-------|----------|---------------|
| `gutenberg-formatter` | WordPress | Set `CMS Platform: WordPress (Gutenberg editor)` |

For non-WordPress projects, set `HTML Formatter Skill: none`

---

## Parallel Execution Pattern

The system uses **parallel agent execution** for performance optimization while maintaining quality.

### Research Phase Parallelization

**Pattern:** `/write-article` runs 2x `@researcher` agents concurrently, then merges results

```
┌─────────────────────────────┐
│   /write-article command    │
└──────────┬──────────────────┘
           │
           ├─────────────────┬─────────────────┐
           │                 │                 │
           v                 v                 v
    ┌────────────┐    ┌────────────┐    Wait for both
    │ Agent 1:   │    │ Agent 2:   │    to complete
    │ Primary    │    │ Landscape  │
    │ Sources    │    │ Analysis   │
    └─────┬──────┘    └─────┬──────┘
          │                 │
          │                 │
          └────────┬────────┘
                   │
                   v
           ┌──────────────┐
           │  Agent 3:    │
           │  Merge       │
           │  Coordinator │
           └──────────────┘
```

**Agent 1 - Primary Sources** (5-7 min):
- Official documentation research
- Fact verification and technical accuracy
- Code examples and technical requirements
- SME requirement assessment
- Output: `research-primary.md`

**Agent 2 - Competitive Landscape** (5-7 min):
- Competitive gap analysis (8-10 competitors)
- Differentiation opportunity identification
- Media embed discovery
- Market positioning insights
- Output: `research-landscape.md`, `gap-analysis-report.md`, `media-discovery.md`

**Agent 3 - Merge Coordinator** (2-3 min):
- Merge research-primary.md + research-landscape.md
- Conflict resolution (technical accuracy vs. market positioning)
- Verification checklist validation
- Output: `research-brief.md`

### Benefits

- **Speed**: ~10-12 minutes total vs. ~15-20 minutes sequential (40-45% faster)
- **Quality**: Separate agents focus on different expertise areas
- **Validation**: Merge step cross-validates findings

### Merge Strategy

1. **Source Verification**: Agent 1's official sources authoritative, Agent 2's competitive findings validate
2. **Differentiation**: Agent 2's gap analysis primary, Agent 1's depth enhances
3. **Media Embeds**: Agent 2's discovery validated by Agent 1's credibility checks
4. **Conflicts**: Technical accuracy → Agent 1 precedence; Market positioning → Agent 2 precedence

### Failure Modes

- **Agent failure**: Fall back to single-agent research
- **Merge conflicts**: Escalate to @editor with conflict log
- **Verification failure**: Manual review by @editor

See `docs/workflow.md` Phase 2 for complete documentation.

---

## Configuration Access Pattern (MANDATORY)

**All agents and skills MUST use `requirements-extractor` for configuration access.**

### ✅ CORRECT Pattern

```markdown
Please use the requirements-extractor skill to load and validate configuration from project/requirements.md.
```

The skill returns structured JSON with validated configuration including:
- `project.industry`, `project.platform`, `project.official_docs`, etc.
- `audience.primary_roles`, `audience.skill_level`
- `brand.voice.traits`, `brand.voice.guidelines`
- `content.formats`, `content.objectives`, `content.length`
- `seo.intent`, `seo.internal_linking`, `seo.primary_cta`
- `cms.platform`, `cms.export_format`

**Benefits:**
- **Validation**: Configuration errors caught upfront (not 20 minutes into workflow)
- **Consistency**: All components parse config identically
- **Structured Output**: JSON schema prevents field name typos
- **Maintainability**: Single parsing implementation to update

### ❌ WRONG Pattern (Anti-Pattern)

```bash
# DO NOT DO THIS
!cat project/requirements.md
# Then manually parse with grep/awk/sed
```

**Why this is wrong:**
- No validation - malformed config causes late failures
- Inconsistent parsing - different components extract differently
- Error-prone - field name changes break multiple files
- Hard to debug - ad-hoc parsing logic scattered everywhere

### Enforcement

**Plugin Validation Check:**
```bash
# Detect anti-pattern usage (should return 0 results)
grep -r "cat.*requirements\.md" plugins/content-generator/agents/ plugins/content-generator/skills/
```

**Updated Components (Priority 4):**
- ✅ `agents/researcher.md` - Uses requirements-extractor
- ✅ `agents/writer.md` - Uses requirements-extractor
- ✅ `agents/editor.md` - Uses requirements-extractor
- ✅ `skills/content-research/` - Uses requirements-extractor
- ✅ `skills/seo-optimization/` - Uses requirements-extractor
- ✅ `skills/cms-formatter/` - Uses requirements-extractor
- ✅ `skills/media-discovery/` - Uses requirements-extractor

**Already Compliant:**
- ✅ `agents/signal-researcher.md` - Uses requirements-extractor
- ✅ `commands/content-calendar.md` - Uses requirements-extractor
- ✅ `skills/sme-complexity-assessor/` - Uses requirements-extractor
- ✅ `skills/requirements-validator/` - Uses requirements-extractor (self-referential)

---

## Adding Platform-Specific Skills

1. Create skill in `.claude/skills/[platform]-[feature]/`
2. Document in `requirements-template.md`
3. Add conditional logic in commands if needed

---

## Cross-Domain Examples

### Technical Tutorial (React.js)

```
Topic: "React Server Components: When to Use Them"
Research: Official React docs + RFC discussions + community patterns
Differentiation: Comparison matrix of CSR/SSR/RSC tradeoffs
Content: Tutorial with CodeSandbox examples + decision flowchart
Word Count: 2,400 words
```

### Non-Technical Analysis (Finance)

```
Topic: "Tax-Loss Harvesting: A Complete Guide for 2025"
Research: IRS regulations + academic studies + platform docs
Differentiation: Worked examples with actual tax calculations
Content: Step-by-step guide with decision trees
Word Count: 1,800 words
```

**Observation:** Same workflow (research → gap analysis → write → review), different execution based on domain.

---

## Directory Structure

```
project/
├── .claude/
│   ├── agents/
│   │   ├── researcher.md
│   │   ├── writer.md
│   │   └── editor.md
│   ├── commands/
│   │   ├── content-calendar.md
│   │   └── write-article.md
│   └── skills/
│       ├── competitive-gap-analyzer/
│       ├── content-research/
│       ├── seo-optimization/
│       ├── requirements-validator/
│       └── gutenberg-formatter/
├── requirements.md           # Active configuration
├── requirements-template.md  # Template for new projects
├── examples/                 # Pre-configured examples
├── Calendar/                 # Monthly calendars
└── Articles/                 # Article folders
```

---

## Distribution Channels by Domain

| Domain | Channels |
|--------|----------|
| Blog/Content Sites | Newsletter, RSS, social media |
| Technical Documentation | npm, PyPI, GitHub, API docs |
| Video Tutorials | YouTube, Vimeo, Udemy |
| Research/Academic | Journals, arXiv, conferences |
| Business/Finance | LinkedIn, industry publications |

---

## Quality Metrics

| Metric | Measurement |
|--------|-------------|
| Editorial compliance | Review pass rate |
| SEO performance | Keyword rankings |
| Engagement | Subscriptions, shares, downloads |
| Accuracy | Validation rate, corrections needed |
