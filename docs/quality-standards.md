# Quality Standards

Article structure requirements, brand voice guidelines, and domain-specific considerations.

---

## Article Formats

### Tutorial/How-To

```
1. Hook (problem statement + why it matters)
2. Prerequisites (versions, dependencies, time, skill level)
3. Step-by-Step Instructions (with explanations of WHY)
4. Verification (how to confirm success)
5. Next Steps + Configured CTA
```

### Analysis/Opinion

```
1. Current State (set the scene)
2. Analysis (arguments with evidence)
3. Practical Impact (action items)
4. Forward Look (predictions, preparation)
```

### Announcement/News

```
1. The News (factual announcement)
2. Why It Matters (impact)
3. How to Use/Apply (implementation)
4. Resources (documentation, references)
```

---

## Brand Voice Guidelines

### General Principles (All Domains)

| Do | Don't |
|----|-------|
| Be clear and specific | Use vague "optimize," "improve," "enhance" |
| Explain WHY, not just what | Skip context and reasoning |
| Acknowledge complexity | Oversimplify nuanced topics |
| Use practical examples | Make abstract claims |

| Avoid | Why |
|-------|-----|
| "Revolutionary," "game-changing," "ultimate" | Marketing fluff |
| "You NEED to do this NOW!" | Pressure tactics |
| "Simply do X" | Dismissive of complexity |
| Excessive exclamation points | Unprofessional tone |

### Technical Content (React.js example)

**Do:**
- "Here's how to manage state with React hooks..."
- "This pattern solves the prop-drilling problem..."

**Don't:**
- "The ULTIMATE React hooks guide!"
- "You NEED to use this pattern NOW!"

### Non-Technical Content (Personal Finance example)

**Do:**
- "Here's how to rebalance your portfolio quarterly..."
- "This strategy helps you manage risk systematically..."

**Don't:**
- "Get RICH QUICK with this revolutionary strategy!"
- "Simply invest in index funds" (dismissive)

---

## Originality Requirements

Every topic must be verified through web search:

- [ ] No identical or very similar articles exist
- [ ] Content addresses a genuine gap in existing coverage
- [ ] Unique angle or perspective is identified
- [ ] Timeliness (tied to releases/updates within last 3 months)

---

## SEO Checklist

| Element | Requirement |
|---------|-------------|
| Primary keyword | In H1, first 100 words, and one H2 |
| Keyword density | 1-2% |
| Meta description | 150-160 chars with keyword + CTA |
| Title tag | 50-60 chars |
| Internal links | 3-5 with descriptive anchor text |
| Paragraphs | Short (2-4 sentences) |
| Heading hierarchy | Logical H1/H2/H3 structure |

---

## Domain-Specific Considerations

### Academic/Research Content

| Requirement | Details |
|-------------|---------|
| Citations | Proper format (APA, MLA, Chicago) |
| Peer Review | Flag for expert review before publication |
| Methodology | Document research methods and data sources |
| Reproducibility | Provide data/code for reproducible results |

### Legal/Medical/Health Content

| Requirement | Details |
|-------------|---------|
| Compliance | Legal review for all medical claims/advice |
| Disclaimers | Standard disclaimers (consult professionals) |
| Credentials | Author credentials, licensed professional review |
| Evidence | Link to peer-reviewed studies, not blog posts |

### Technical Documentation

| Requirement | Details |
|-------------|---------|
| Versioning | Exact version numbers for all software/APIs |
| Deprecation | Flag outdated methods with migration paths |
| Breaking Changes | Clearly highlight compatibility issues |
| Code Testing | All examples must be tested and functional |

### Financial/Investment Content

| Requirement | Details |
|-------------|---------|
| Regulatory | SEC regulations, fiduciary standards |
| Risk Disclosures | Required disclaimers for investment advice |
| Data Sources | Cite reputable financial data providers |
| Specificity | Tax years, regulation dates, market timestamps |

---

## Practical Examples by Domain

| Domain | Example Types |
|--------|---------------|
| Technical | Code snippets with before/after explanations |
| Business/Finance | Case studies, calculations, real-world scenarios |
| Psychology/Health | Clinical examples, anonymized case studies |
| Analysis/Opinion | Data visualizations, comparative tables |

---

## Validation Commands

```bash
# Check word count
wc -w project/Articles/ART-202510-001/draft.md

# Verify US English spelling (check for UK)
grep -E "(optimise|colour|centre|analyse)" project/Articles/ART-202510-001/article.md

# Verify UK English spelling (check for US)
grep -E "(optimize|color|center|analyze)" project/Articles/ART-202510-001/article.md
```

---

## Legal/Compliance Flags

Flag for external review when content contains:

- [ ] Performance benchmarks
- [ ] Comparative claims against competitors
- [ ] Product recommendations
- [ ] Medical or financial advice
- [ ] Data citations requiring verification
