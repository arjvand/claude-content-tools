# Content Requirements Configuration

This file configures the content generation system. **Copy this template and fill in your project details to adapt the system to any topic.**

All agents, commands, and skills read this file at runtime to extract configuration variables. Change this file to completely reconfigure your content generation system.

---

## PROJECT CONFIGURATION

### Primary Topic & Focus

* **Industry/Niche**: [Your industry or domain - e.g., "Frontend development", "Personal finance", "Psychology", "WordPress development"]
* **Focus Areas**: [Your main content focus areas - list 3-5 topics. e.g., "Hooks, state management, performance optimization" OR "Retirement planning, tax optimization, portfolio management" OR "Anxiety treatment, mindfulness techniques, cognitive restructuring"]

### Official Documentation Sources

* **Primary Documentation**: [Main official documentation URL - e.g., "https://react.dev/" OR "https://developer.wordpress.org/" OR "https://www.apa.org/" for psychology. This is where agents will look for authoritative information]
* **Community Forums**: [Community discussion platforms - e.g., "Stack Overflow react tag • r/reactjs • React Discord" OR "WordPress Support Forums • Stack Overflow wordpress tag • r/WordPress"]
* **Official Blogs**: [Official news/update sources - e.g., "React.dev Blog • React GitHub Blog" OR "WordPress News • WooCommerce Developer Blog"]
* **Repository**: [Code repositories if applicable - e.g., "facebook/react on GitHub" OR "wordpress/wordpress on GitHub" OR "N/A" for non-technical content]
* **Other Authoritative Sources**: [Additional trusted sources - e.g., "MDN Web Docs • W3C specs" OR "APA journals • NIH publications • PubMed" OR "SEC.gov • IRS.gov" for finance]

---

## AUDIENCE

### Target Readers

* **Primary Roles**: [Who reads your content - e.g., "Frontend developers, React developers, tech leads" OR "Individual investors, financial advisors, retirement planners" OR "Mental health professionals, psychology students, therapists"]
* **Skill Level**: [Reader expertise level - e.g., "Beginner", "Intermediate", "Advanced", "Intermediate to advanced", "Beginner to intermediate"]
* **Primary Segment**: [Most important audience segment - e.g., "Developers building modern web applications" OR "Individual investors planning for retirement" OR "Licensed therapists treating anxiety disorders"]

---

## BRAND IDENTITY

### Brand Information

* **Brand Name**: [Your brand/site name - e.g., "Summix", "ReactMastery", "WealthGuide", "MindfulPractice"]

### Brand Voice

* **Traits**: [Voice characteristics - 3-5 adjectives/phrases describing your brand voice. e.g., "Professional, clear, code-focused, practical" OR "Friendly, approachable, precise, no hype" OR "Evidence-based, compassionate, professional, accessible"]

#### Brand Voice Guidelines

Provide 3-4 examples of on-brand language and 3-4 examples of off-brand language:

**DO (On-Brand):**
* [Example 1 - e.g., "Here's how to optimize your React component for better performance..."]
* [Example 2 - e.g., "This pattern solves a common problem when managing state..."]
* [Example 3 - e.g., "Let's walk through the implementation step by step..."]

**DON'T (Off-Brand):**
* [Anti-example 1 - e.g., "The ULTIMATE React guide you absolutely NEED!"]
* [Anti-example 2 - e.g., "This will REVOLUTIONIZE your code!"]
* [Anti-example 3 - e.g., "Simply add this code and you're done." (dismissive of complexity)]

---

## CONTENT STRATEGY

### Content Objectives

* **Objective**: [Your content goals - e.g., "Educate developers on React best practices and attract qualified traffic" OR "Help investors make informed retirement planning decisions" OR "Provide evidence-based guidance for mental health professionals"]
* **Primary KPI**: [What you measure - e.g., "Organic search traffic, time on page, newsletter signups" OR "Article engagement, download rates, returning visitors"]

### Content Formats

* **Formats**: [Types of content you create - e.g., "Tutorials, deep dives, code recipes, case studies" OR "How-to guides, analysis, product reviews, news" OR "Research summaries, clinical guides, case studies"]
* **Content Mix**: [Percentage breakdown of formats - must add up to 100%. e.g., "Tutorials (60%), Deep dives (30%), News (10%)" OR "How-to guides (50%), Market analysis (30%), News (20%)"]
* **Depth**: [Content depth level - e.g., "Primarily intermediate to advanced" OR "Beginner to intermediate" OR "Advanced only"]
* **Length**: [Word count range - e.g., "900-2,000 words; long-form guides 2,500-4,000 words" OR "700-2,200 words, quality-first"]

### Topic Pillars

List your main content themes. One primary pillar, 3-5 secondary pillars:

* **Primary Pillar**: [Main content theme - e.g., "React Performance Optimization" OR "Retirement Planning Strategies" OR "Anxiety Treatment Methods"]
* **Secondary Pillars**:
  * [Pillar 1 - e.g., "State Management Patterns" OR "Tax-Advantaged Investing" OR "Cognitive Behavioral Therapy Techniques"]
  * [Pillar 2 - e.g., "Component Architecture" OR "Portfolio Diversification" OR "Mindfulness-Based Interventions"]
  * [Pillar 3 - e.g., "Testing & Debugging" OR "Estate Planning" OR "Client Assessment Tools"]
  * [Add 2-3 more secondary pillars]

### SEO & Distribution

* **SEO Intent**: [SEO strategy - e.g., "Target 'how to' queries and 'best practices' searches; focus on problem/solution patterns" OR "Target long-tail informational queries; build topic clusters"]
* **Internal Linking**: [Linking strategy - e.g., "Cluster/pillar model; each article links to its hub + 2-3 related articles" OR "Chain related tutorials together; link to glossary for key terms"]
* **Primary CTA**: [Main call-to-action - e.g., "Subscribe to newsletter" OR "Download cheat sheet" OR "Join community" OR "Book consultation"]
* **Distribution Channels**: [Where you publish/promote - e.g., "Newsletter, RSS, LinkedIn, Dev.to, YouTube" OR "Newsletter, RSS, Twitter, Medium"]

### Quality & Review Process

* **SME Involvement**: [When subject matter experts are needed - e.g., "Required for advanced tutorials and architecture deep dives" OR "Required for clinical content and research summaries" OR "Optional for news/opinion pieces"]
* **Review Workflow**: [Your editorial workflow - e.g., "Draft → Technical review → Editorial → Publish" OR "Draft → SME review → Editorial → Legal → Publish"]
* **Cadence**: [Publishing frequency - e.g., "2 posts/week" OR "3 posts/week (1 long-form + 2 short recipes)" OR "1-2 posts/week"]
* **Product Announcements Scope**: [How you handle news/announcements - e.g., "Only major ecosystem changes; remain vendor-neutral" OR "Cover all major releases" OR "N/A - no product coverage"]

### Competitive Analysis Preferences

**Note:** The competitive gap analyzer runs in TWO phases: (1) Pre-Analysis during calendar generation for strategic topic selection, (2) Full Analysis during article research for detailed implementation tactics. These settings control both phases.

#### Pre-Analysis Settings (Calendar Generation)

* **Run Pre-Analysis During Calendar Generation**: [Default: Yes - e.g., "Yes" (recommended) OR "No" (skip pre-analysis, faster calendar)]
* **Topic Candidate Count**: [Default: 10-15 - e.g., "12" OR "15" (thorough) OR "10" (faster)]
* **Pre-Analysis Competitor Count**: [Default: 5-8 - e.g., "8" OR "5" (faster) OR "10" (thorough)]
* **Minimum Opportunity Score for Inclusion**: [Default: 3.0★ - e.g., "3.0" (Tier 2+) OR "4.0" (Tier 1 only) OR "2.5" (include some Tier 3)]
* **Required Tier 1 Percentage**: [Default: 60% - e.g., "60%" (recommended) OR "70%" (very selective) OR "50%" (more variety)]

**Opportunity Score Weights** (For prioritizing topics during calendar generation):
- **Coverage Gap Weight**: [Default: 30% - e.g., "30%" OR "35%" if you want novel topics prioritized]
- **Depth Gap Weight**: [Default: 35% - e.g., "35%" OR "40%" for technical content OR "25%" for broad overviews]
- **Format Gap Weight**: [Default: 15% - e.g., "15%" OR "20%" if multimedia differentiation is important]
- **Recency Gap Weight**: [Default: 20% - e.g., "20%" OR "30%" if timeliness is critical OR "15%" for evergreen content]

*Note: Weights must total 100%*

#### Full Analysis Settings (Article Research)

* **Competitive Analysis Depth**:
  - **Number of Competitors to Analyze**: [Default: 10 - e.g., "10" OR "8" (faster) OR "12" (thorough)]
  - **Minimum Word Count Threshold**: [Default: 1000 - Filter for substantial content only]
  - **Recency Filter**: [Default: Last 12 months - e.g., "Last 12 months preferred" OR "Last 6 months" OR "Any date"]

* **Depth Scoring Weights** (How to prioritize technical depth):
  - **Technical Details**: [Default: 30% - e.g., "30%" (standard) OR "40%" (highly technical audience) OR "20%" (beginner focus)]
  - **Code Examples**: [Default: 25% - e.g., "25%" OR "35%" (developer-focused) OR "10%" (non-technical)]
  - **Visual Aids**: [Default: 20% - e.g., "20%" OR "30%" (visual learners) OR "15%" (text-focused)]
  - **Troubleshooting**: [Default: 15% - e.g., "15%" OR "25%" (support-focused) OR "10%" (overview content)]
  - **Advanced Sections**: [Default: 10% - e.g., "10%" OR "20%" (advanced users) OR "5%" (beginner tutorials)]

* **Differentiation Priorities** (What types of gaps to prioritize):
  1. [Default: "Original data/research (highest priority)" - e.g., "Original benchmarks" OR "Expert interviews" OR "Case studies"]
  2. [Default: "Expert interviews" - e.g., "Industry expert quotes" OR "User testimonials" OR "SME validation"]
  3. [Default: "Comprehensive troubleshooting" - e.g., "Common issues covered" OR "Edge cases addressed" OR "Debug guidance"]
  4. [Default: "Advanced use cases" - e.g., "Beyond basics" OR "Real-world scenarios" OR "Professional techniques"]
  5. [Default: "Visual/multimedia enhancements" - e.g., "Videos" OR "Interactive demos" OR "Diagrams" OR "Screenshots"]

**Example Configurations by Content Type:**

**Technical/Developer Focus:**
- Technical Details: 40%, Code Examples: 35%, Troubleshooting: 20%, Visual Aids: 15%, Advanced: 20%
- Priorities: Original benchmarks, Working code, Advanced use cases, Troubleshooting, Performance analysis

**Beginner/Educational Focus:**
- Technical Details: 20%, Code Examples: 15%, Visual Aids: 30%, Troubleshooting: 15%, Advanced: 5%
- Priorities: Clear explanations, Step-by-step guides, Visual aids, Examples, Prerequisites

**Analysis/Opinion Focus:**
- Original Data: High priority, Expert Interviews: High priority, Technical Details: 25%
- Priorities: Original research, Expert quotes, Industry insights, Unique perspectives, Data visualization

---

## CONTENT DELIVERY

### Publication Platform

* **CMS Platform**: [Your publishing platform - e.g., "WordPress (Gutenberg editor)", "Ghost", "Medium", "Markdown files (static site generator)"]
* **Export Format**: [Output format for final article - e.g., "gutenberg" for WordPress, "ghost" for Ghost, "medium" for Medium/Dev.to, "html" for generic HTML, "markdown" for static sites (default)]

### Visual Standards

* **Image Style**: [Image/diagram requirements - e.g., "Clean technical diagrams, code screenshots, minimal photography" OR "Professional photography, branded graphics" OR "Simple illustrations, data visualizations"]
* **Featured Images**: [Featured image policy - e.g., "Required for each post; abstract tech visuals aligned to brand palette" OR "Required; AI-generated themed images" OR "Optional"]
* **Code Snippets**: [If applicable - e.g., "Syntax-highlighted JavaScript/TypeScript; include before/after examples" OR "Full working examples with explanations" OR "N/A - no code content"]
* **Downloads**: [Downloadable resources - e.g., "Checklists, code templates, boilerplate repos" OR "Worksheets, calculators, templates" OR "N/A"]

---

## LOCALIZATION

### Language & Region

* **Language**: [Primary language code - e.g., "en" for English, "es" for Spanish, "fr" for French]
* **Regions**: [Geographic focus - e.g., "Global" OR "North America & Europe" OR "United States" OR "Latin America"]
* **Spelling**: [Spelling convention - e.g., "US English" OR "UK English" OR "Canadian English"]
* **Accessibility**: [Accessibility requirements - e.g., "Alt text required for all images; diagrams must include text equivalents" OR "WCAG AA compliance required"]

---

## ADDITIONAL NOTES

### Target Audience Insights & Pain Points

[Describe your audience's main challenges, what they're looking for, and what motivates them. 3-5 bullet points:]

* [Pain point 1 - e.g., "Developers struggle with React performance optimization and don't know where to start"]
* [Pain point 2 - e.g., "Need practical, battle-tested patterns, not just documentation rehashing"]
* [Pain point 3 - e.g., "Looking for examples that work in real-world production scenarios"]

### Editorial Guardrails

[Your editorial standards, constraints, and principles. 3-5 bullet points:]

* [Guardrail 1 - e.g., "Vendor-agnostic; focus on patterns over specific tools"]
* [Guardrail 2 - e.g., "All code examples must be tested and functional"]
* [Guardrail 3 - e.g., "Avoid hype; focus on trade-offs and realistic expectations"]
* [Guardrail 4 - e.g., "Always link to official documentation when referencing APIs/features"]

### Sample Article Ideas

[List 10-20 article ideas that exemplify your content strategy. Be specific:]

1. [Idea 1 - e.g., "Optimizing React useEffect: Common Performance Pitfalls and Fixes"]
2. [Idea 2 - e.g., "State Management in 2025: Comparing Redux, Zustand, and Context API"]
3. [Idea 3 - e.g., "Building a Custom React Hook: Step-by-Step Tutorial"]
4. [Idea 4]
5. [Idea 5]
6. [Idea 6]
7. [Idea 7]
8. [Idea 8]
9. [Idea 9]
10. [Idea 10]
[Add 10-20 ideas total]

### KPIs & Measurement Details

[How you measure success - specific metrics and targets:]

* [KPI 1 - e.g., "Organic search traffic: Track monthly growth and top-performing keywords"]
* [KPI 2 - e.g., "Newsletter conversion rate: Target 5% of readers subscribing"]
* [KPI 3 - e.g., "Time on page: Aim for 4+ minutes average for tutorials"]
* [KPI 4 - e.g., "Returning visitor rate: Track audience loyalty and engagement"]

### Maintenance

[How you keep content current and relevant:]

* [Maintenance plan - e.g., "Review all tutorials quarterly for API changes and deprecations"]
* [Update policy - e.g., "Add update notes to articles when major versions release"]
* [Archival policy - e.g., "Archive outdated content with redirects to updated versions"]

---

## Quick Start

After filling in this template:

1. Save this file as `requirements.md` in your project root
2. Run `/content-calendar [Month Year]` to generate your first content calendar
3. Run `/write-article [calendar-path] [article-id]` to generate your first article

All agents and commands will automatically adapt to your configuration!

---

## Examples

See the `examples/` directory for complete, working configurations:
- `examples/requirements-generic.md` - Technology & business blog (recommended starting point)
- `examples/requirements-wordpress.md` - WordPress/WooCommerce blog
- `examples/requirements-react.md` - React.js tutorial site
- `examples/requirements-python.md` - Python programming blog
- `examples/requirements-psychology.md` - Psychology/mental health blog
- `examples/requirements-finance.md` - Personal finance blog
- `examples/requirements-entertainment.md` - Film/TV entertainment blog
