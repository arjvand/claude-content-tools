# Content Requirements Configuration

This file configures the content generation system. Agents read this file at runtime to adapt their behavior to TechInsight.

---

## PROJECT CONFIGURATION

### Primary Topic & Focus

* **Industry/Niche**: Technology trends, digital transformation, business software
* **Focus Areas**: SaaS tools evaluation, productivity automation, digital strategy, emerging tech (AI, automation), remote work, data-driven decision making

### Official Documentation Sources

* **Primary Documentation**: N/A (general technology coverage)
* **Community Forums**: Hacker News • Product Hunt • Relevant subreddits (r/SaaS, r/productivity, r/startups)
* **Official Blogs**: TechCrunch • The Verge • Wired • Ars Technica • MIT Technology Review
* **Repository**: N/A
* **Other Authoritative Sources**: Gartner • Forrester • McKinsey Digital • Harvard Business Review • Pew Research

---

## AUDIENCE

### Target Readers

* **Primary Roles**: Business professionals, IT decision-makers, tech enthusiasts, startup founders, product managers, operations leaders
* **Skill Level**: Beginner to intermediate
* **Primary Segment**: Professionals evaluating technology solutions for their organizations or personal productivity; decision-makers seeking balanced, vendor-neutral guidance

---

## BRAND IDENTITY

### Brand Information

* **Brand Name**: TechInsight

### Brand Voice

* **Traits**: Informative, balanced, practical, forward-looking, accessible, vendor-neutral

#### Brand Voice Guidelines

**DO (On-Brand):**

* "Here's how this technology can solve real business challenges..."
* "Let's break down the pros and cons of this approach..."
* "Consider these factors before making your decision..."
* "The data suggests a more nuanced picture than the hype..."

**DON'T (Off-Brand):**

* "This is the ONLY solution you need!"
* "Everyone should switch immediately!"
* "This technology is dead." (avoid absolute claims)
* "Just trust this vendor's claims." (always verify)

---

## CONTENT STRATEGY

### Content Objectives

* **Objective**: Educate professionals on technology trends and practical applications; provide actionable insights for technology decisions; build trust through balanced, evidence-based analysis
* **Primary KPI**: Organic traffic, newsletter subscriptions, time on page, social shares, returning visitors

### Content Formats

* **Formats**: Analysis pieces, how-to guides, tool comparisons, trend reports, case studies, decision frameworks
* **Content Mix**: Analysis (40%), How-to guides (35%), News commentary (15%), Case studies (10%)
* **Depth**: Accessible to non-technical readers; intermediate depth with clear explanations
* **Length**: Analysis: 1,200-2,000 words; How-tos: 1,000-1,500 words; News: 500-800 words

### Topic Pillars

* **Primary Pillar**: Technology Decision-Making
* **Secondary Pillars**:
  * Productivity & Automation Tools
  * Digital Transformation Strategies
  * Emerging Technology (AI, ML applications in business)
  * Remote Work & Collaboration
  * Data-Driven Business Practices

### SEO & Distribution

* **SEO Intent**: Target "best [tool] for [use case]", "how to [business task]", "[technology] vs [alternative]", "is [technology] worth it" queries; build topic clusters around tool categories and business problems
* **Internal Linking**: Cluster model; link comparisons to individual tool reviews; link strategy articles to tactical guides
* **Primary CTA**: Subscribe to newsletter; download decision guides
* **Distribution Channels**: Newsletter, RSS, LinkedIn, Twitter/X, Medium

### Quality & Review Process

* **SME Involvement**: Required for in-depth technical comparisons and emerging tech analysis; optional for news commentary and basic guides
* **Review Workflow**: Draft → Fact-check → Editorial review → Publish
* **Cadence**: 2 posts/week
* **Product Announcements Scope**: Cover major technology announcements affecting business users; maintain vendor-neutral perspective

### Novelty Controls

#### Saturation Sensitivity
* **Level**: balanced
  * Options: `lenient`, `balanced`, `strict`
  * **lenient**: Only hard-block core themes, allow borderline candidates
  * **balanced**: Hard-block core themes, pivot on borderline (default)
  * **strict**: Hard-block + pivot on borderline + avoid 0.40-0.59 similarity

#### Alternative Angle Preference
* **Depth angles**: 60% — Favor technical depth differentiation
* **Use-case angles**: 40% — Favor niche application differentiation

#### Multi-Angle Generation
* **Enabled**: true
  * Generate 3 angle variants per signal (coverage, depth, use-case)
  * Select best variant via composite scoring
  * Set to `false` to use Phase 1 single-angle workflow

* **Variant types**: [coverage, depth, use-case]
  * Which angle types to generate
  * All 3 types recommended for maximum differentiation

* **Selection criteria**:
  * **Novelty weight**: 0.40 — Prioritize unique topics
  * **Opportunity weight**: 0.35 — Favor high-gap topics
  * **Feasibility weight**: 0.25 — Ensure resource availability
  * Total weights must sum to 1.0

#### Trend Analysis (Phase 3)
* **Enabled**: true
  * Use 24-month time series for momentum detection
  * Avoid accelerating themes (prevent saturation)
  * Favor dormant themes (revival opportunities)
  * Set to `false` to disable momentum-adjusted scoring

* **Lookback months**: 24
  * Extended lookback for trend classification
  * Enables ACCELERATING/STABLE/DECLINING/DORMANT detection
  * Requires 24+ months of historical calendar data

#### Convergence Detection (Phase 3)
* **Enabled**: true
  * Detect cross-signal convergence patterns
  * Generate synthesis topics combining multiple signals
  * Set to `false` to disable convergence analysis

* **Min cluster size**: 3
  * Minimum signals required for convergence cluster
  * Higher values = stricter convergence criteria

* **Similarity threshold**: 0.40
  * Semantic similarity threshold for clustering
  * Range: 0.0-1.0 (higher = more similar signals required)

### Competitive Analysis Preferences

#### Pre-Analysis Settings (Calendar Generation)

* **Run Pre-Analysis During Calendar Generation**: Yes
* **Topic Candidate Count**: 12
* **Pre-Analysis Competitor Count**: 8
* **Minimum Opportunity Score for Inclusion**: 3.0
* **Required Tier 1 Percentage**: 60%

**Opportunity Score Weights:**
- **Coverage Gap Weight**: 30%
- **Depth Gap Weight**: 30%
- **Format Gap Weight**: 20%
- **Recency Gap Weight**: 20%

#### Full Analysis Settings (Article Research)

* **Competitive Analysis Depth**:
  - **Number of Competitors to Analyze**: 10
  - **Minimum Word Count Threshold**: 800
  - **Recency Filter**: Last 12 months preferred

* **Depth Scoring Weights:**
  - **Technical Details**: 25%
  - **Code Examples**: 5% (minimal code in business content)
  - **Visual Aids**: 30%
  - **Troubleshooting**: 15%
  - **Advanced Sections**: 10%

* **Differentiation Priorities:**
  1. Original research or unique data analysis
  2. Expert perspectives or industry quotes
  3. Practical decision frameworks
  4. Real-world use case examples
  5. Clear pros/cons comparisons

---

## CONTENT DELIVERY

### Publication Platform

* **CMS Platform**: Markdown files (static site generator)
* **Export Format**: markdown

### Visual Standards

* **Image Style**: Clean product screenshots, comparison tables, infographics, process diagrams; minimal stock photography
* **Featured Images**: Required; abstract tech visuals or custom branded graphics
* **Code Snippets**: N/A (non-technical content; occasional API examples in integration guides)
* **Downloads**: Comparison checklists, decision frameworks, evaluation templates (PDF)

---

## LOCALIZATION

### Language & Region

* **Language**: en
* **Regions**: Global (focus: North America, Europe)
* **Spelling**: US English
* **Accessibility**: Alt text required; clear heading structure; tables must have headers

---

## ADDITIONAL NOTES

### Target Audience Insights & Pain Points

* Overwhelmed by technology choices; need clear, unbiased comparisons
* Want practical guidance, not just feature lists or marketing copy
* Need to justify technology decisions to stakeholders with data
* Looking for balanced perspectives that acknowledge trade-offs
* Frustrated by outdated content that doesn't reflect current pricing/features

### Editorial Guardrails

* Remain vendor-neutral; focus on use cases, not product promotion
* Disclose any affiliate relationships or sponsored content
* Cite sources for statistics and claims; link to original research
* Avoid jargon without explanation; define technical terms
* Update pricing and feature information regularly
* Include publish date and last-updated date on all articles

### Sample Article Ideas

1. **How to Choose the Right Project Management Tool for Your Team** — Asana vs Monday vs ClickUp vs Notion
2. **AI Writing Assistants: A Practical Comparison for Business Use** — capabilities, limitations, pricing
3. **5 Signs Your Business Needs a Digital Transformation Strategy** — assessment framework
4. **Remote Work Tools That Actually Improve Productivity** — evidence-based recommendations
5. **Understanding SaaS Pricing Models: What to Watch For** — per-seat, usage-based, freemium traps
6. **Building a Data-Driven Culture: First Steps for Small Teams** — practical implementation
7. **When to Build vs Buy: A Decision Framework for Business Software** — criteria and examples
8. **The Hidden Costs of Free Tools: What "Freemium" Really Means** — total cost analysis
9. **Automation 101: Identifying Tasks Worth Automating** — ROI calculation framework
10. **Security Considerations When Adopting New Business Software** — evaluation checklist
11. **How to Evaluate AI Tools for Your Business** — beyond the hype, practical criteria
12. **Integration Platforms Compared: Zapier vs Make vs n8n** — use cases, pricing, limitations
13. **The Business Case for Accessibility in Digital Products** — ROI and compliance
14. **Measuring Technology ROI: Metrics That Actually Matter** — framework and examples
15. **Vendor Lock-In: Risks and Mitigation Strategies** — evaluation criteria
16. **Cloud Storage Solutions for Teams: Security, Collaboration, and Cost** — comparison guide
17. **Email Marketing Platforms in 2025: What's Changed** — feature evolution, new entrants
18. **No-Code Tools: Capabilities and Limitations for Business Users** — realistic expectations
19. **Creating Effective Technology Evaluation Criteria** — methodology guide
20. **The Productivity App Paradox: When More Tools Mean Less Work Done** — consolidation strategies

### KPIs & Measurement Details

* Track: Organic search traffic, newsletter conversion rate (target 3-5%), social shares, returning visitor rate
* Quality signals: Time on page (target 4+ minutes for guides), scroll depth, comment engagement
* Distribution: LinkedIn engagement, Medium reads, newsletter open rates

### Maintenance

* Review tool comparisons quarterly for pricing and feature changes
* Update statistics and market data annually
* Archive content for discontinued products with redirects
* Add "last updated" dates to all evergreen content
* Monitor for significant product changes and update affected articles within 2 weeks
