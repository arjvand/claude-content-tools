# Content Requirements Configuration - ANNOTATED TEMPLATE

**PURPOSE**: This template explains every configuration field with inline annotations showing:
- `[REQUIRED]` or `[OPTIONAL]` - Whether the field must be filled
- **Impact Level**: HIGH/MEDIUM/LOW - How much this affects agent behavior
- **Used By**: Which agents and skills read this field
- **Examples**: Valid values and formats

Copy this file to `project/requirements.md` and customize for your project.

---

## PROJECT CONFIGURATION

### Primary Topic & Focus

**[REQUIRED]** - **Impact: HIGH** - Used by: `@signal-researcher`, `@researcher`, `content-research`

* **Industry/Niche**: [Your industry/topic]
  - **What it controls**: Primary domain for content generation and signal discovery
  - **Examples**: "WordPress development", "React.js", "Personal finance", "Clinical psychology"
  - **Impact**: Determines which industry-specific sources agents search

* **Focus Areas**: [Specific topics within your niche]
  - **What it controls**: Sub-topics and content themes
  - **Examples**: "State management, hooks, performance", "Retirement planning, index investing, tax optimization"
  - **Impact**: Shapes topic candidates and research focus
  - **Format**: Comma-separated list, 3-6 focus areas recommended

**Configuration Impact Matrix**:
| Field | Agents Affected | Skills Affected | What Changes |
|-------|----------------|-----------------|--------------|
| Industry/Niche | @signal-researcher (signal types), @researcher (source selection) | content-research (domain-aware sources), competitive-gap-analyzer (competitor selection) | Signal discovery patterns, authoritative source prioritization |
| Focus Areas | @signal-researcher (topic clustering), @writer (angle selection) | competitive-gap-analyzer (differentiation strategies) | Topic relevance scoring, content angle recommendations |

---

### Official Documentation Sources

**[REQUIRED]** - **Impact: HIGH** - Used by: `@researcher`, `content-research`

This section tells agents WHERE to find authoritative information for your topic.

* **Primary Documentation**: [Main official docs URL or N/A]
  - **What it controls**: Primary source for technical accuracy and official information
  - **Examples**:
    - "https://react.dev" (React)
    - "https://developer.wordpress.org" (WordPress)
    - "N/A" (no single primary source)
  - **Impact**: If provided, agents prioritize this source above all others for fact verification
  - **When to use N/A**: General topics without a single official source (e.g., "technology trends")

* **Community Forums**: [Where your community discusses this topic]
  - **What it controls**: Community signal sources and real-world problem discovery
  - **Examples**: "Reddit r/reactjs • Discord server • Stack Overflow [react] tag"
  - **Impact**: Used by @signal-researcher for trend detection and pain point identification
  - **Format**: Bullet-separated (•) list of forum names

* **Official Blogs**: [Authoritative blog sources]
  - **What it controls**: News, announcements, and thought leadership sources
  - **Examples**: "Official React Blog • Vercel Blog • Kent C. Dodds Blog"
  - **Impact**: Used by @researcher for latest developments and expert perspectives

* **Repository**: [GitHub/GitLab repo URL or N/A]
  - **What it controls**: Source code reference and issue tracking
  - **Examples**: "https://github.com/facebook/react", "N/A"
  - **Impact**: Used by @researcher for technical details, changelog, and known issues

* **Other Authoritative Sources**: [Research institutions, industry analysts, etc.]
  - **What it controls**: Third-party authoritative sources for data and analysis
  - **Examples**: "Gartner • Forrester • Pew Research • Academic journals"
  - **Impact**: Used for claims requiring independent verification

**Troubleshooting**:
- **Agent not finding right sources?** → Check that Primary Documentation and Official Blogs are populated
- **Topics too generic?** → Add more specific Community Forums and Official Blogs
- **Research lacks depth?** → Add authoritative third-party sources

---

## AUDIENCE

### Target Readers

**[REQUIRED]** - **Impact: HIGH** - Used by: `@writer`, `@editor`, `requirements-validator`

This section defines WHO you're writing for, which controls writing style and technical depth.

* **Primary Roles**: [Job titles/roles of your readers]
  - **What it controls**: Examples, use cases, and problem framing
  - **Examples**: "Frontend developers, React developers, technical leads"
  - **Impact**: Determines assumed knowledge and technical terminology usage
  - **Format**: Comma-separated list of specific roles

* **Skill Level**: [Beginner/Intermediate/Advanced]
  - **What it controls**: Technical depth, assumed knowledge, explanation detail level
  - **Examples**:
    - "Beginner to intermediate" → More explanations, simpler examples
    - "Intermediate to advanced" → Less hand-holding, complex examples
  - **Impact**: Critical for @writer's tone and @editor's readability checks
  - **HIGH IMPACT**: Wrong skill level = content too simple or too complex

* **Primary Segment**: [Detailed persona description]
  - **What it controls**: Motivations, pain points, goals referenced in content
  - **Examples**: "Professionals evaluating technology solutions; need to justify decisions to stakeholders"
  - **Impact**: Shapes content angles and problem framing

**Skill Level Guide**:
- **Beginner**: Define all terms, step-by-step instructions, avoid assumptions
- **Intermediate**: Some assumed knowledge, moderate technical depth, practical focus
- **Advanced**: Expert terminology OK, deep technical details, edge cases

---

## BRAND IDENTITY

### Brand Information

**[REQUIRED]** - **Impact: MEDIUM** - Used by: `@writer`, `@editor`, `featured-image-generator`

* **Brand Name**: [Your brand/publication name]
  - **What it controls**: How the brand is referenced in content (if needed)
  - **Examples**: "TechInsight", "DevHub", "The Finance Guide"
  - **Impact**: Used in meta references, not in every sentence

---

### Brand Voice

**[REQUIRED]** - **Impact: HIGH** - Used by: `@writer`, `@editor`, `requirements-validator`

This is one of the MOST IMPORTANT sections - it controls the entire writing style.

* **Traits**: [3-7 adjectives describing your brand voice]
  - **What it controls**: Sentence structure, word choice, tone, perspective
  - **Examples**:
    - "Informative, balanced, practical, forward-looking" (analytical)
    - "Friendly, encouraging, hands-on, accessible" (tutorial-focused)
    - "Professional, evidence-based, ethical, compassionate" (healthcare)
  - **Impact**: @writer uses these traits in EVERY sentence
  - **Format**: Comma-separated adjectives

#### Brand Voice Guidelines

**[REQUIRED]** - **Impact: CRITICAL** - Used by: `@writer`, `@editor`

**DO (On-Brand):**

Provide 4-6 examples of sentences/phrases that match your brand voice:

* "Here's how this technology can solve real business challenges..." ← [Practical, solution-focused]
* "Let's break down the pros and cons of this approach..." ← [Balanced, analytical]
* "Consider these factors before making your decision..." ← [Thoughtful, decision-support]
* "The data suggests a more nuanced picture than the hype..." ← [Evidence-based, skeptical of hype]

**WHY THIS MATTERS**: @writer uses these as TEMPLATES for sentence construction. More examples = better voice consistency.

**DON'T (Off-Brand):**

Provide 4-6 examples of sentences/phrases that violate your brand voice:

* "This is the ONLY solution you need!" ← [Too absolute, salesy]
* "Everyone should switch immediately!" ← [Pressure tactics, not balanced]
* "This technology is dead." ← [Too absolute, not forward-looking]
* "Just trust this vendor's claims." ← [Not evidence-based]

**HOW @EDITOR USES THIS**: These examples are used as red flags during review. If draft contains similar language, it's flagged for revision.

**Best Practices**:
- Make DO examples specific to your domain (not just "be clear", show HOW)
- Make DON'T examples actual phrases you want to avoid
- Cover different scenarios: introductions, comparisons, recommendations, technical explanations

---

## CONTENT STRATEGY

### Content Objectives

**[REQUIRED]** - **Impact: MEDIUM** - Used by: `@signal-researcher`, `@editor`

* **Objective**: [Why this content exists; what it achieves]
  - **What it controls**: Content angle selection and success criteria
  - **Examples**: "Educate professionals on technology decisions; build trust through evidence-based analysis"
  - **Impact**: Guides topic selection and content purpose

* **Primary KPI**: [How you measure success]
  - **What it controls**: Content optimization priorities (SEO vs engagement vs conversions)
  - **Examples**: "Organic traffic, newsletter subscriptions", "Social shares, returning visitors"
  - **Impact**: Influences @editor's optimization recommendations

---

### Content Formats

**[REQUIRED]** - **Impact: HIGH** - Used by: `@writer`, `@signal-researcher`, `competitive-gap-analyzer`

* **Formats**: [Types of content you create]
  - **What it controls**: Available article structures and templates
  - **Examples**: "Tutorials, deep dives, patterns, news commentary"
  - **Impact**: @writer selects from these format templates
  - **Format**: Comma-separated list

* **Content Mix**: [Percentage breakdown of formats]
  - **What it controls**: Calendar topic distribution
  - **Examples**: "Tutorials (55%), Deep dives (30%), Patterns (10%), News (5%)"
  - **Impact**: @signal-researcher uses these targets when generating calendar
  - **Validation**: Should add up to 100%

* **Depth**: [How deep content goes]
  - **What it controls**: Content detail level and scope
  - **Examples**: "Accessible to non-technical readers; intermediate depth with clear explanations"
  - **Impact**: Guides @writer's detail level and explanation thoroughness

* **Length**: [Word count targets per format]
  - **What it controls**: Target word counts for each format type
  - **Examples**: "Analysis: 1,200-2,000 words; How-tos: 1,000-1,500 words; News: 500-800 words"
  - **Impact**: @writer targets these ranges; @editor validates compliance
  - **Format**: Format name: min-max words
  - **CRITICAL**: @writer strictly enforces maximum word count (with justification for 10% overage)

---

### Topic Pillars

**[REQUIRED]** - **Impact: HIGH** - Used by: `@signal-researcher`, `competitive-gap-analyzer`

* **Primary Pillar**: [Main content theme]
  - **What it controls**: Primary topic area for all content
  - **Examples**: "Technology Decision-Making", "React Patterns & Architecture"

* **Secondary Pillars**: [Supporting themes]
  - **What it controls**: Topic diversification and content clusters
  - **Examples**: "Productivity & Automation Tools", "Digital Transformation Strategies"
  - **Impact**: @signal-researcher ensures content mix across pillars
  - **Format**: Bulleted list, 3-5 pillars recommended

---

### SEO & Distribution

**[OPTIONAL]** - **Impact: MEDIUM** - Used by: `seo-optimization`, `@editor`

* **SEO Intent**: [Search queries you target]
  - **What it controls**: Keyword targeting and search optimization
  - **Examples**: "Target 'best [tool] for [use case]', 'how to [task]', '[X] vs [Y]' queries"
  - **Impact**: Used by seo-optimization skill for keyword selection
  - **When OPTIONAL**: Set to "N/A" if not doing SEO optimization

* **Internal Linking**: [Linking strategy]
  - **What it controls**: How articles link to each other
  - **Examples**: "Cluster model; link comparisons to tool reviews; link strategy to guides"
  - **Impact**: seo-optimization skill uses this pattern

* **Primary CTA**: [Call-to-action]
  - **What it controls**: What action you want readers to take
  - **Examples**: "Subscribe to newsletter", "Download decision guide", "Try free trial"
  - **Impact**: @writer includes this CTA at article end

* **Distribution Channels**: [Where content is shared]
  - **What it controls**: Platform-specific optimization hints
  - **Examples**: "Newsletter, RSS, LinkedIn, Twitter/X, Medium"
  - **Impact**: cms-formatter and x-thread-generator use these

---

### Quality & Review Process

**[REQUIRED]** - **Impact: MEDIUM** - Used by: `@editor`

* **SME Involvement**: [When subject matter expert review is needed]
  - **What it controls**: When to escalate for expert review
  - **Examples**:
    - "Required for all clinical psychology content" (healthcare)
    - "Required for in-depth technical comparisons; optional for news" (technology)
    - "Optional" (general content)
  - **Impact**: @editor flags articles needing SME review

* **Review Workflow**: [Review steps]
  - **What it controls**: Editorial process stages
  - **Examples**: "Draft → Fact-check → Editorial review → Publish"
  - **Impact**: Documentation only; doesn't change agent behavior

* **Cadence**: [Publishing frequency]
  - **What it controls**: Content velocity expectations
  - **Examples**: "2 posts/week", "Daily", "Weekly"

* **Product Announcements Scope**: [How to handle news/announcements]
  - **What it controls**: News coverage criteria
  - **Examples**: "Cover major technology announcements affecting business users; maintain vendor-neutral perspective"

---

### Novelty Controls

**[OPTIONAL]** - **Impact: HIGH** - Used by: `@signal-researcher`, `topic-deduplicator`

This section controls real-time saturation feedback during topic generation. Enables early pivots when topics are blocked.

#### Saturation Sensitivity

**What it controls**: How aggressively to avoid similar topics

* **Level**: balanced
  - **Options**: `lenient`, `balanced`, `strict`
  - **lenient**: Only hard-block core themes (6-month rule), allow borderline candidates
  - **balanced**: Hard-block core themes + pivot on borderline (default, recommended)
  - **strict**: Hard-block + pivot on borderline + avoid 0.40-0.59 similarity range
  - **Impact**: Affects how many topic candidates get pivoted to alternative angles
  - **Recommended**: `balanced` for most projects

#### Alternative Angle Preference

**What it controls**: When a topic is blocked, which alternative angle type to prefer

* **Depth angles**: 60%
  - **What it means**: Favor technical depth differentiation (e.g., "Performance Benchmarking" vs "Migration Guide")
  - **Impact**: 60% of pivots will try depth angle first, 40% will try use-case angle first
  - **Recommended**: 60/40 split for technical content; adjust to 40/60 for business content

* **Use-case angles**: 40%
  - **What it means**: Favor niche application differentiation (e.g., "for High-Volume Stores" vs general guide)
  - **Impact**: 40% of pivots will try use-case angle first
  - **Recommended**: Increase to 60% for broad audience content

**Example Pivot Flow:**
```
Primary: "WooCommerce HPOS Migration Guide"
→ Quick-check: BLOCKED (core theme "data-migration" saturated)
→ Generate depth angle: "HPOS Performance Benchmarking: Query Optimization"
→ Quick-check depth: AVAILABLE
→ Use depth angle as final candidate
```

#### Multi-Angle Generation

**[OPTIONAL but RECOMMENDED]** - **Impact: VERY HIGH** - Used by: `@signal-researcher`, `angle-generator`

This section enables multi-variant topic generation with composite scoring. **Highly recommended** for Phase 2 novelty improvements (88-92% novelty vs 80-85% with Phase 1).

**What it controls**: Generate 3 angle variants per signal and select the best via data-driven scoring

* **Enabled**: true
  - **Options**: `true` | `false`
  - **true**: Use multi-variant workflow (Phase 2, recommended)
  - **false**: Use single-angle with pivot workflow (Phase 1, fallback)
  - **Impact**: Determines topic generation strategy
  - **Recommended**: `true` for maximum novelty and differentiation

* **Variant types**: [coverage, depth, use-case]
  - **What it means**: Which angle templates to use when generating variants
  - **coverage**: Breadth-focused comprehensive guides
  - **depth**: Technical deep-dives on specific aspects
  - **use-case**: Niche application for specific audience segments
  - **Impact**: All 3 types maximize differentiation opportunities
  - **Recommended**: Keep all 3 types enabled

* **Selection criteria**: Composite scoring weights
  - **What it controls**: How variants are scored and selected
  - **Novelty weight**: 0.40 (default)
    - Higher = prioritize unique topics
    - Lower = allow more similar topics if they score well on other dimensions
  - **Opportunity weight**: 0.35 (default)
    - Higher = prioritize topics with high competitive gaps
    - Lower = care less about gap size
  - **Feasibility weight**: 0.25 (default)
    - Higher = prioritize topics easy to create (resources available)
    - Lower = willing to tackle difficult topics
  - **Impact**: Weights must sum to 1.0; affects which variant is selected
  - **Recommended**: Default weights (0.40/0.35/0.25) work well for most projects

**Example Multi-Variant Selection:**
```
Signal: "WooCommerce 8.5 HPOS 2.0 Release"

Variants Generated:
  1. Coverage: "Complete HPOS 2.0 Guide" → AVAILABLE (novelty: 0.60, feasibility: 1.0)
  2. Depth: "HPOS Performance Benchmarking" → BLOCKED (saturated)
  3. Use-Case: "HPOS for High-Volume Stores" → AVAILABLE (novelty: 0.75, feasibility: 0.94)

Composite Scores:
  Variant 1: (0.60 × 0.40) + (0.50 × 0.35) + (1.0 × 0.25) = 0.665
  Variant 3: (0.75 × 0.40) + (0.50 × 0.35) + (0.94 × 0.25) = 0.710 ← SELECTED

Result: Use-case variant selected (highest composite score)
```

---

### Competitive Analysis Preferences

**[OPTIONAL but RECOMMENDED]** - **Impact: HIGH** - Used by: `competitive-gap-analyzer`

This section configures how gap analysis works. Highly recommended to include for best results.

#### Pre-Analysis Settings (Calendar Generation)

**What it controls**: Topic candidate evaluation during calendar generation

* **Run Pre-Analysis During Calendar Generation**: Yes/No
  - **Impact**: If "Yes", runs gap pre-analysis for all topic candidates (adds 15-20 min)
  - **Recommended**: Yes (identifies high-opportunity topics)

* **Topic Candidate Count**: [Number]
  - **Default**: 12
  - **Impact**: How many topics @signal-researcher generates before filtering

* **Pre-Analysis Competitor Count**: [Number]
  - **Default**: 8
  - **Impact**: How many competitors analyzed per topic during pre-analysis

* **Minimum Opportunity Score for Inclusion**: [1.0-5.0]
  - **Default**: 3.0
  - **Impact**: Topics below this score excluded from calendar
  - **Tier Guide**: 4.0+ = Tier 1 (high-opportunity), 3.0-3.9 = Tier 2 (moderate), <3.0 = low

* **Required Tier 1 Percentage**: [0-100%]
  - **Default**: 60%
  - **Impact**: Minimum % of calendar that must be Tier 1 topics
  - **Recommended**: 60-80% for competitive niches

**Opportunity Score Weights**: [How to calculate opportunity score]
- **Coverage Gap Weight**: 30% (default)
- **Depth Gap Weight**: 30% (default)
- **Format Gap Weight**: 20% (default)
- **Recency Gap Weight**: 20% (default)

**Customization**: Adjust these weights based on your strategy:
- Emphasize **Coverage** if you cover new topics competitors miss
- Emphasize **Depth** if you go deeper than competitors
- Emphasize **Format** if you use unique content formats (video, interactive)
- Emphasize **Recency** if fast-moving industry (news, tech updates)

#### Full Analysis Settings (Article Research)

**What it controls**: Detailed gap analysis for individual articles

* **Competitive Analysis Depth**:
  - **Number of Competitors to Analyze**: 10 (default)
    - **Impact**: More competitors = better gap understanding but slower research (5-10 min)
  - **Minimum Word Count Threshold**: 800 (default)
    - **Impact**: Ignores thin content competitors
  - **Recency Filter**: "Last 12 months preferred" (default)
    - **Impact**: Focuses on current competitors; older content deprioritized

* **Depth Scoring Weights**: [How to measure competitor depth]
  - **Technical Details**: 25% (default)
    - **Adjust**: Increase for technical content, decrease for beginner-friendly
  - **Code Examples**: 5-30%
    - **Guide**: 30% for programming tutorials, 5% for business content, 0% for non-technical
  - **Visual Aids**: 20-40%
    - **Guide**: 40% for design/visual content, 20% for text-heavy
  - **Troubleshooting**: 15% (default)
  - **Advanced Sections**: 10% (default)

* **Differentiation Priorities**: [Ranked list of differentiation tactics]
  1. Original research or unique data analysis
  2. Expert perspectives or industry quotes
  3. Practical decision frameworks
  4. Real-world use case examples
  5. Clear pros/cons comparisons

  **What it controls**: Which differentiation tactics @writer prioritizes
  **Impact**: Priority 1 tactics are MUST-HAVE in article draft

**Troubleshooting**:
- **All topics score low?** → Lower Minimum Opportunity Score or adjust weights
- **Topics don't match expectations?** → Review Topic Pillars and Focus Areas
- **Too many/too few Tier 1 topics?** → Adjust Required Tier 1 Percentage

---

### Search Analytics

**[OPTIONAL]** - **Impact: HIGH (when configured)** - Used by: `gsc-analyst`, `gsc-analyzer`, `competitive-gap-analyzer`, `seo-optimization`, `keyword-researcher`

This section configures Google Search Console (GSC) CSV export integration. When configured, real search performance data replaces estimation-based workflows across calendar planning, article writing, SEO optimization, and performance tracking.

**All GSC features are fully optional.** Existing workflows work unchanged without this section.

#### Google Search Console (GSC)

* **Export Path**: [Absolute path to GSC export folder]
  - **What it controls**: Where the system looks for GSC CSV export files
  - **Examples**: "/home/user/Projects/mysite/project/GSC/mysite.com-Performance-on-Search-2026-02-01"
  - **Impact**: All GSC-powered features depend on this path containing valid CSV files
  - **Required files**: Queries.csv + Pages.csv (minimum); Chart.csv, Devices.csv, Countries.csv optional
  - **Folder naming**: GSC exports use the convention `{site}-Performance-on-Search-{YYYY-MM-DD}`
  - **Validation**: Path must exist and contain at minimum Queries.csv and Pages.csv

* **Site URL**: [Your site URL as registered in GSC]
  - **What it controls**: Used to validate that Pages.csv URLs match your site
  - **Examples**: "https://example.com", "https://www.myblog.com"
  - **Impact**: Site URL must match the base domain in Pages.csv URLs

* **Freshness Threshold (Days)**: [Number, default: 30]
  - **What it controls**: How old GSC data can be before triggering a staleness warning
  - **Examples**: 30 (recommended), 14 (strict), 60 (lenient)
  - **Impact**: Data older than this threshold produces a warning but analysis still runs
  - **Date source**: Parsed from export folder name date

* **Analysis Modes**:
  - **Query Opportunities**: true/false (default: true)
    - Discover queries with high impressions but no dedicated content
  - **Page Performance**: true/false (default: true)
    - Score pages by click/position performance
  - **Position Tracking**: true/false (default: true)
    - Track position data for target keywords
  - **Geographic Insights**: true/false (default: false)
    - Analyze performance by country (requires Countries.csv)

* **Filters**:
  - **Minimum Impressions**: [Number, default: 5]
    - Ignore queries below this threshold (removes noise)
  - **Minimum Position**: [Number, default: 100]
    - Maximum position to include (100 = include all)
  - **CTR Threshold**: [Number, default: 0.02]
    - CTR below this for a position signals underperformance
  - **Position Opportunity Range**: [min, max] (default: [5, 30])
    - Position range for "striking distance" opportunities

**Configuration Impact Matrix**:
| Field | Agents/Skills Affected | What Changes |
|-------|----------------------|--------------|
| Export Path | gsc-analyst, gsc-analyzer | Enables all GSC features |
| Site URL | gsc-analyzer | URL-to-article mapping validation |
| Freshness Threshold | gsc-analyzer | Staleness warnings |
| Analysis Modes | gsc-analyzer | Which analysis types run |
| Filters | gsc-analyzer, competitive-gap-analyzer, seo-optimization | Data filtering thresholds |

**Troubleshooting**:
- **GSC features not activating?** Verify Export Path exists and contains Queries.csv + Pages.csv
- **Stale data warnings?** Download a fresh GSC export from Google Search Console
- **URL mapping failing?** Check that Site URL matches Pages.csv URLs, or create `project/GSC/url-mapping.json`
- **Too much noise in query data?** Increase Minimum Impressions filter (try 10 or 25)

**Setup Guide**:
1. Go to Google Search Console > Performance > Export (top right)
2. Choose "Download CSV"
3. Extract the ZIP to `project/GSC/`
4. Set `Export Path` to the extracted folder path
5. Set `Site URL` to match your GSC property

---

## CONTENT DELIVERY

### Publication Platform

**[REQUIRED]** - **Impact: MEDIUM** - Used by: `cms-formatter`, `@editor`

* **CMS Platform**: [Where content is published]
  - **Valid values**:
    - "WordPress (Gutenberg)" → Exports to Gutenberg blocks
    - "Ghost" → Exports to Ghost-compatible markdown
    - "Medium" → Exports for Medium import
    - "Markdown files (static site)" → Pure markdown, no CMS-specific code
  - **Impact**: cms-formatter generates appropriate export format

* **Export Format**: [Output format]
  - **Valid values**: "gutenberg", "ghost", "medium", "html", "markdown"
  - **Impact**: Final article export format
  - **Must match CMS Platform**: WordPress → gutenberg, Static site → markdown

---

### Visual Standards

**[OPTIONAL]** - **Impact: LOW** - Used by: `media-discovery`, `@editor`

* **Image Style**: [Visual aesthetic]
  - **Examples**: "Clean product screenshots, comparison tables, infographics"
  - **Impact**: Guides media embed selection

* **Featured Images**: [Requirement]
  - **Examples**: "Required; abstract tech visuals", "Optional"

* **Code Snippets**: [Code example requirements]
  - **Examples**:
    - "TypeScript with syntax highlighting" (programming blog)
    - "N/A" (non-technical content)
  - **Impact**: Tells @writer whether to include code examples

* **Downloads**: [Downloadable assets]
  - **Examples**: "Checklists, decision frameworks (PDF)", "N/A"

---

## LOCALIZATION

### Language & Region

**[REQUIRED]** - **Impact: MEDIUM** - Used by: `@writer`, `@editor`

* **Language**: [ISO language code]
  - **Examples**: "en", "es", "fr"
  - **Impact**: Content language (currently only "en" fully supported)

* **Regions**: [Geographic focus]
  - **Examples**: "Global", "North America", "Europe", "APAC"
  - **Impact**: Regional examples and references

* **Spelling**: [Spelling convention]
  - **Valid values**: "US English", "UK English", "Canadian English"
  - **Impact**: @writer uses specified spelling (colour vs color, optimise vs optimize)
  - **CRITICAL**: @editor validates spelling consistency

* **Accessibility**: [Accessibility requirements]
  - **Examples**: "Alt text required; clear heading structure; tables must have headers"
  - **Impact**: @editor checks accessibility compliance

---

## ADDITIONAL NOTES

### Target Audience Insights & Pain Points

**[OPTIONAL but HIGHLY RECOMMENDED]** - **Impact: HIGH** - Used by: `@writer`, `@signal-researcher`

List your audience's specific challenges, frustrations, and goals:

**Examples**:
* "Overwhelmed by technology choices; need clear, unbiased comparisons"
* "Want practical guidance, not just feature lists or marketing copy"
* "Need to justify technology decisions to stakeholders with data"

**Impact**:
- @signal-researcher uses these to identify relevant topic signals
- @writer frames problems and solutions around these pain points
- @editor validates that content addresses these challenges

**Best Practice**: List 4-8 specific pain points, not generic statements

---

### Editorial Guardrails

**[OPTIONAL but RECOMMENDED]** - **Impact: MEDIUM** - Used by: `@editor`

List content policies, compliance requirements, and editorial standards:

**Examples**:
* "Remain vendor-neutral; focus on use cases, not product promotion"
* "Disclose any affiliate relationships or sponsored content"
* "Cite sources for statistics and claims; link to original research"
* "Include disclaimers for financial/medical/legal content"

**Impact**: @editor uses these as compliance checklist

**Domain-Specific Examples**:
- **Healthcare**: "All clinical claims must cite peer-reviewed research; include standard disclaimers"
- **Finance**: "Include 'not financial advice' disclaimer; cite data sources for statistics"
- **Legal**: "Include jurisdiction-specific warnings; recommend consulting attorney"

---

### Sample Article Ideas

**[OPTIONAL but RECOMMENDED]** - **Impact: MEDIUM** - Used by: `@signal-researcher`

List 15-20 example article ideas in your domain:

**Why this matters**: @signal-researcher uses these as templates for topic generation. More specific examples = better topic candidates.

**Format**: **Title** — Brief description or angle

**Examples**:
1. **How to Choose the Right Project Management Tool for Your Team** — Asana vs Monday vs ClickUp vs Notion
2. **AI Writing Assistants: A Practical Comparison for Business Use** — capabilities, limitations, pricing
3. **5 Signs Your Business Needs a Digital Transformation Strategy** — assessment framework

**Best Practices**:
- Make titles specific, not generic ("How to use React hooks for state management" better than "React state")
- Include angle/approach in description
- Cover different formats: comparisons, how-tos, frameworks, analyses

---

### KPIs & Measurement Details

**[OPTIONAL]** - **Impact: LOW** - Documentation only

* Track: [Specific metrics]
* Quality signals: [Engagement metrics]
* Distribution: [Channel-specific metrics]

---

### Maintenance

**[OPTIONAL]** - **Impact: LOW** - Documentation only

* Content update schedule and policies

---

## CONFIGURATION VALIDATION CHECKLIST

Before using this configuration, verify:

- [ ] **Industry/Niche** is specific (not "technology" but "React.js development")
- [ ] **Official Documentation Sources** includes at least Primary Documentation OR Official Blogs
- [ ] **Skill Level** matches your actual audience (test with a sample reader)
- [ ] **Brand Voice DO/DON'T** has 4+ specific examples each
- [ ] **Content Mix** percentages add up to 100%
- [ ] **Word count ranges** are realistic for your content depth
- [ ] **CMS Platform** matches **Export Format** (WordPress → gutenberg, etc.)
- [ ] **Spelling** choice is consistent with your audience region
- [ ] **Sample Article Ideas** has 10+ specific examples

---

## TROUBLESHOOTING GUIDE

### Problem: Topics don't match my niche
**Check**: Industry/Niche, Focus Areas, Topic Pillars, Sample Article Ideas
**Fix**: Make these more specific. "Technology" → "React.js state management"

### Problem: Agent isn't finding the right sources
**Check**: Official Documentation Sources, especially Primary Documentation and Official Blogs
**Fix**: Add more specific sources. Generic "blogs" → "Official React Blog • Vercel Blog"

### Problem: Brand voice sounds wrong
**Check**: Brand Voice traits and DO/DON'T examples
**Fix**: Add more specific DO examples showing desired tone. Generic "be clear" → "Let's break down the 3 key factors..."

### Problem: All topics scoring low in gap analysis
**Check**: Minimum Opportunity Score, Opportunity Score Weights
**Fix**: Lower threshold to 2.5 or adjust weights to match your differentiation strategy

### Problem: Articles too long or too short
**Check**: Length targets in Content Formats
**Fix**: Adjust ranges. @writer targets these strictly.

### Problem: Wrong technical depth
**Check**: Skill Level, Target Readers Primary Roles
**Fix**: Make skill level match actual audience. Test with sample reader.

---

## ADVANCED: FIELD IMPACT MATRIX

Complete reference of which configuration fields affect which agents/skills:

| Configuration Section | @signal-researcher | @researcher | @writer | @editor | Skills Affected |
|----------------------|-------------------|-------------|---------|---------|-----------------|
| Industry/Niche | ✅ Signal types | ✅ Source selection | ✅ Examples | ✅ Validation | content-research, competitive-gap-analyzer |
| Official Documentation | ❌ | ✅ Primary source | ✅ Citation | ✅ Fact-check | content-research, fact-checker |
| Target Readers | ✅ Topic relevance | ❌ | ✅ Tone, depth | ✅ Readability | requirements-validator |
| Skill Level | ❌ | ❌ | ✅ Depth, jargon | ✅ Accessibility | requirements-validator |
| Brand Voice | ❌ | ❌ | ✅ Sentence style | ✅ Voice check | requirements-validator |
| Content Mix | ✅ Calendar distribution | ❌ | ❌ | ❌ | N/A |
| Topic Pillars | ✅ Topic selection | ❌ | ❌ | ❌ | N/A |
| SEO Intent | ❌ | ❌ | ✅ Keywords | ✅ SEO check | seo-optimization |
| Gap Analysis Weights | ✅ Topic scoring | ✅ Competitor analysis | ✅ Differentiation | ✅ Strategy validation | competitive-gap-analyzer |
| Search Analytics (GSC) | ✅ Demand signals | ✅ Ranking context | ✅ Query targeting | ✅ Performance data | gsc-analyzer, seo-optimization, keyword-researcher, competitive-gap-analyzer |
| CMS Platform | ❌ | ❌ | ❌ | ✅ Export format | cms-formatter |
| Spelling | ❌ | ❌ | ✅ Spelling rules | ✅ Spelling check | N/A |
| Editorial Guardrails | ❌ | ❌ | ❌ | ✅ Compliance | N/A |

---

## QUICK START

1. **Copy this template**:
   ```bash
   cp examples/requirements-ANNOTATED-TEMPLATE.md project/requirements.md
   ```

2. **Delete all annotations** (lines starting with "-", "**What it controls**", "**Impact**", tables, troubleshooting)

3. **Fill in your values** for each field

4. **Test your configuration**:
   ```bash
   /content-calendar TestMonth 2025
   ```

5. **Review generated calendar** - do topics match your expectations?

6. **Iterate** - adjust configuration and regenerate

---

**Version**: 1.0
**Last Updated**: 2025-01-20
**Plugin**: content-generator v1.0
