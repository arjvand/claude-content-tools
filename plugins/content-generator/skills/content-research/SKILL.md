---
name: content-research
description: Research any topic based on requirements.md configuration. Searches for recent releases, official documentation, and community discussions. Topic-agnostic.
allowed-tools: Bash(curl:*), Bash(grep:*)
---

# Content Research Skill

## Purpose
Research and verify information for content based on `requirements.md` configuration. This skill adapts to any topic, platform, or industry.

## Configuration-Driven Approach

**Before researching, ALWAYS read requirements.md:**

```bash
!cat project/requirements.md
```

**Extract the following:**
- **Industry/Niche**: What domain are we researching?
- **Platform/Product**: What specific platform/product?
- **Official Documentation**: Where are authoritative sources?
- **Community Forums**: Where does the community discuss?
- **Official Blogs**: Where are official updates published?
- **Repository**: Where is the code/project hosted?
- **Focus Areas**: What topics should be prioritized?

Use these extracted values throughout the research process.

---

## When to Use
- Writing about the configured platform/product
- Researching releases or updates
- Verifying technical claims or benchmarks
- Finding community best practices

## Research Checklist

### 1. Official Sources First (from requirements.md)
- [ ] **Primary Documentation** (extracted from config)
- [ ] **Official Blog** (extracted from config)
- [ ] **Repository** changelogs (extracted from config)
- [ ] Release notes and version history

### 2. Verify Recency (within 3 months)
- [ ] Check release dates
- [ ] Confirm version numbers
- [ ] Validate deprecated features
- [ ] Note breaking changes

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
