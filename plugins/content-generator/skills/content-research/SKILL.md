---
name: content-research
description: Research any topic based on requirements.md configuration. Searches for recent releases, official documentation, and community discussions. Topic-agnostic.
allowed-tools: Bash(curl:*), Bash(grep:*)
---

# Content Research Skill

## Purpose
Research and verify information for content based on `requirements.md` configuration. This skill adapts to any topic, platform, or industry.

## Configuration-Driven Approach

**Before researching, ALWAYS load configuration using requirements-extractor:**

```markdown
Please use the requirements-extractor skill to load validated configuration from project/requirements.md.
```

**Extract the following from the structured output:**
- **Industry/Niche** from `project.industry`: What domain are we researching?
- **Platform/Product** from `project.platform`: What specific platform/product?
- **Official Documentation** from `project.official_docs`: Where are authoritative sources?
- **Community Forums** from `project.community_forums`: Where does the community discuss?
- **Official Blogs** from `project.official_blogs`: Where are official updates published?
- **Repository** from `project.repository`: Where is the code/project hosted?
- **Focus Areas** from `project.focus_areas`: What topics should be prioritized?

Use these extracted values throughout the research process. The requirements-extractor provides validated, structured configuration eliminating parsing errors.

---

## When to Use
- Writing about the configured platform/product
- Researching releases or updates
- Verifying technical claims or benchmarks
- Finding community best practices

## Reference Date Context

When a `$REFERENCE_DATE` is provided (from calendar entry or command), all temporal calculations must use this date as "today" — NOT the current date.

**Historical Mode (`$REFERENCE_DATE` is in the past):**
- Only use sources published before `$REFERENCE_DATE`
- Use date-filtered searches: `[query] before:$REFERENCE_DATE`
- Calculate "recency" relative to `$REFERENCE_DATE`
- Do NOT include information about events after `$REFERENCE_DATE`

---

## Research Checklist

### 1. Official Sources First (from requirements.md)
- [ ] **Primary Documentation** (extracted from config)
- [ ] **Official Blog** (extracted from config)
- [ ] **Repository** changelogs (extracted from config)
- [ ] Release notes and version history (published before `$REFERENCE_DATE` in Historical Mode)

### 2. Verify Recency (relative to Reference Date)
- [ ] Check release dates are within 3 months of `$REFERENCE_DATE` (not current date)
- [ ] For historical dates: Only include releases/updates that existed before `$REFERENCE_DATE`
- [ ] Use date-filtered searches when `$REFERENCE_DATE` is in the past
- [ ] Confirm version numbers (only versions released before `$REFERENCE_DATE`)
- [ ] Validate deprecated features (as of `$REFERENCE_DATE`)
- [ ] Note breaking changes (that occurred before `$REFERENCE_DATE`)

### 3. Community Validation (from requirements.md)
- [ ] **Community Forums** (extracted from config)
- [ ] Stack Overflow/Stack Exchange (topic-specific tags)
- [ ] Developer blogs and discussions
- [ ] GitHub issues/discussions

### 4. Competition Check
- [ ] Search for similar existing articles
- [ ] Identify content gaps
- [ ] Find unique angles
- [ ] Note what competitors missed

## Output Format

Provide research findings with:
- **Source URLs and dates** (prioritize official sources from config)
- **Key facts with version numbers**
- **Unique angles** not covered elsewhere
- **Potential internal linking opportunities**
- **References to official documentation** (from config)

## Example Usage

**For WordPress/WooCommerce** (if configured):
- Official sources: wordpress.org, woocommerce.com
- Community: WordPress Stack Exchange
- Focus: WooCommerce releases, plugin updates

**For React.js** (if configured):
- Official sources: react.dev
- Community: Stack Overflow react tag, r/reactjs
- Focus: React hooks, state management, performance

**For Python** (if configured):
- Official sources: docs.python.org
- Community: Stack Overflow python tag, r/learnpython
- Focus: Python releases, library updates, best practices

The skill adapts to whatever is configured in requirements.md.
