# Implementation Plan: Topic-Agnostic Content Generation System

**Date:** 2025-10-29
**Project:** Blog2 Content Generation System
**Goal:** Make the system fully adaptable to any blog topic by simply modifying requirements.md

---

## Executive Summary

**Good News:** The system is already 90% topic-agnostic! All agents and commands read `requirements.md` dynamically and extract configuration at runtime.

**What Needs Work:**
1. Remove remaining hardcoded references to WordPress/WooCommerce
2. Create a reusable template (`requirements-template.md`)
3. Provide example configurations for different topics
4. Update a few skills with hardcoded assumptions
5. Enhance documentation to emphasize the configuration-first approach

**Effort Estimate:** 2-3 hours of focused work

---

## Current State Analysis

### ✅ Already Working Well

**All 3 Agents** (researcher, writer, editor):
- ✅ Have "Phase 0: Load Project Configuration" that reads requirements.md
- ✅ Extract configuration variables dynamically
- ✅ Use placeholders like `[PLATFORM from config]` throughout
- ✅ Include topic-agnostic examples

**Both Commands** (content-calendar, write-article):
- ✅ Read requirements.md at the start
- ✅ Extract configuration variables (Platform, Audience, Content Mix, etc.)
- ✅ Pass configuration to agents
- ✅ Include examples for multiple platforms

**Skills**:
- ✅ content-research: Fully configuration-driven
- ⚠️ seo-optimization: Mostly good, one hardcoded reference
- ⚠️ requirements-validator: Some hardcoded checks
- ✅ gutenberg-formatter: Platform-specific by design (WordPress only)

---

## Issues Found

### 🔴 Critical Issues (Must Fix)

1. **seo-optimization skill** (line 8)
   - Current: "Ensure content meets SEO best practices for WordPress/WooCommerce audience."
   - Fix: "Ensure content meets SEO best practices based on requirements.md configuration."

2. **requirements-validator skill** (lines 29-32)
   - Current: Hardcoded audience roles: "site owners, devs, agencies, content managers"
   - Fix: Extract from requirements.md: `**Primary Roles**:` section

### 🟡 Important Issues (Should Fix)

3. **No requirements-template.md**
   - Users need a clear template to start new projects
   - Should include placeholders and examples for all fields

4. **No example configurations**
   - Need examples for: React.js, Python, Psychology, Finance, Entertainment
   - Would demonstrate the system's versatility

5. **Documentation improvements**
   - CLAUDE.md should lead with "Configuration-Driven Architecture"
   - README.md needs update to explain how to switch topics

### 🟢 Nice-to-Have (Optional)

6. **CLAUDE.md organization**
   - Move "Configuration-Driven Architecture" section to the top
   - Add "Quick Start for New Projects" section
   - Include examples of different topic configurations

---

## Implementation Plan

### Phase 1: Fix Hardcoded References (30 minutes)

**Task 1.1: Update seo-optimization skill**
- **File**: `.claude/skills/seo-optimization/SKILL.md`
- **Changes**:
  ```diff
  - ## Purpose
  - Ensure content meets SEO best practices for WordPress/WooCommerce audience.
  + ## Purpose
  + Ensure content meets SEO best practices based on requirements.md configuration.
  ```
- **Add configuration loading section**:
  ```markdown
  ## Configuration-Driven Approach

  **Before optimizing, read requirements.md to understand the topic:**

  ```bash
  !cat requirements.md
  ```

  Extract:
  - **Industry/Niche**: Target domain
  - **Platform/Product**: Specific platform
  - **Primary Roles**: Target audience
  - **Official Sources**: For external linking validation
  ```

**Task 1.2: Update requirements-validator skill**
- **File**: `.claude/skills/requirements-validator/SKILL.md`
- **Changes**:
  - Add Phase 0: Load Configuration (like other agents)
  - Extract audience roles dynamically instead of hardcoding
  - Extract all validation criteria from requirements.md

**Example Addition**:
```markdown
### Phase 0: Load Configuration (ALWAYS FIRST)

Before validating, read requirements.md:

```bash
!cat requirements.md
```

Extract the following:
- **Primary Roles**: `**Primary Roles**:` → [audience roles]
- **Skill Level**: `**Skill Level**:` → [beginner/intermediate/advanced]
- **Length**: `**Length**:` → [word count range]
- **Spelling**: `**Spelling**:` → [US/UK English]
- **Primary CTA**: `**Primary CTA**:` → [newsletter/download/etc]
- **Brand Voice Traits**: `**Traits**:` → [voice characteristics]

Use these extracted values for all validation checks.
```

---

### Phase 2: Create Requirements Template (45 minutes)

**Task 2.1: Create requirements-template.md**
- **File**: `requirements-template.md`
- **Purpose**: Blank template for starting new projects
- **Structure**:

```markdown
# Content Requirements Configuration

This file configures the content generation system. Copy this template and fill in your project details.

---

## PROJECT CONFIGURATION

### Primary Topic & Focus

* **Industry/Niche**: [Your industry - e.g., "Frontend development", "Personal finance", "Psychology"]
* **Specific Platform/Product**: [Your platform - e.g., "React.js", "Investment strategies", "Cognitive behavioral therapy"]
* **Focus Areas**: [Your content focus - e.g., "Hooks, state management, performance", "Retirement planning, tax optimization", "Anxiety treatment, mindfulness"]
* **Technology Stack**: [If technical - e.g., "JavaScript, TypeScript, Node.js" or "N/A for non-technical"]

### Official Documentation Sources

* **Primary Documentation**: [Main docs URL - e.g., "https://react.dev/"]
* **Community Forums**: [Forums/communities - e.g., "Stack Overflow react tag, r/reactjs"]
* **Official Blogs**: [Official news sources - e.g., "React.dev blog"]
* **Repository**: [Code repos if applicable - e.g., "facebook/react"]
* **Other Authoritative Sources**: [Standards, research sources]

---

## AUDIENCE

### Target Readers

* **Primary Roles**: [Who reads this - e.g., "Frontend developers, React developers, tech leads"]
* **Skill Level**: [Beginner/Intermediate/Advanced - e.g., "Intermediate to advanced"]
* **Primary Segment**: [Specific segment - e.g., "Developers building modern web applications"]

---

## BRAND IDENTITY

### Brand Information

* **Brand Name**: [Your brand name]
* **Brand Colors**: [Color palette - e.g., "Primary: #2563EB, Accent: #22C55E, Neutral: #0F172A"]

### Brand Voice

* **Traits**: [Voice characteristics - e.g., "Professional, clear, code-focused, practical"]

#### Brand Voice Guidelines

**DO (On-Brand):**
* [Example 1]
* [Example 2]
* [Example 3]

**DON'T (Off-Brand):**
* [Anti-example 1]
* [Anti-example 2]
* [Anti-example 3]

---

## CONTENT STRATEGY

### Content Objectives

* **Objective**: [Your content goals]
* **Primary KPI**: [What you measure - e.g., "Organic search traffic, newsletter signups"]

### Content Formats

* **Formats**: [Types of content - e.g., "Tutorials, deep dives, code recipes"]
* **Content Mix**: [Percentage breakdown - e.g., "Tutorials (60%), Analysis (30%), News (10%)"]
* **Depth**: [Depth level - e.g., "Intermediate to advanced"]
* **Length**: [Word count range - e.g., "900-2,000 words"]

### Topic Pillars

* **Primary Pillar**: [Main topic area]
* **Secondary Pillars**:
  * [Pillar 1]
  * [Pillar 2]
  * [Pillar 3]

### SEO & Distribution

* **SEO Intent**: [SEO strategy - e.g., "Target 'how to' queries, code examples, best practices"]
* **Internal Linking**: [Linking strategy]
* **Primary CTA**: [Main call-to-action - e.g., "Subscribe to newsletter"]
* **Distribution Channels**: [Where you publish - e.g., "Newsletter, RSS, LinkedIn"]

### Quality & Review Process

* **SME Involvement**: [When needed - e.g., "Required for advanced tutorials"]
* **Review Workflow**: [Your workflow - e.g., "Draft → Technical review → Editorial → Publish"]
* **Cadence**: [Publishing frequency - e.g., "2 posts/week"]
* **Product Announcements Scope**: [How you handle news]

---

## CONTENT DELIVERY

### Publication Platform

* **CMS Platform**: [Platform - e.g., "WordPress (Gutenberg editor)", "Markdown files", "Ghost"]
* **HTML Formatter Skill**: [Formatter to use - e.g., "gutenberg-formatter", "none"]

### Visual Standards

* **Image Style**: [Image requirements]
* **Featured Images**: [Featured image policy]
* **Code Snippets**: [If applicable - code style]
* **Downloads**: [If applicable - downloadable resources]

---

## LOCALIZATION

### Language & Region

* **Language**: [Language code - e.g., "en"]
* **Regions**: [Geographic focus - e.g., "North America & Europe", "Global"]
* **Spelling**: [Spelling style - e.g., "US English", "UK English"]
* **Accessibility**: [Accessibility requirements]

---

## ADDITIONAL NOTES

### Target Audience Insights & Pain Points

[Describe your audience's main challenges and what they're looking for]

### Editorial Guardrails

[Your editorial standards and constraints]

### Sample Article Ideas

1. [Idea 1]
2. [Idea 2]
3. [Idea 3]
...

### KPIs & Measurement Details

[How you measure success]

### Maintenance

[How you keep content current]
```

---

### Phase 3: Create Example Configurations (60 minutes)

**Task 3.1: Create examples/ directory**
```bash
mkdir -p examples/
```

**Task 3.2: Create example configurations**

Create these files in `examples/`:

1. **examples/requirements-wordpress.md**
   - Copy current requirements.md (Summix WordPress/WooCommerce)
   - This becomes the reference example

2. **examples/requirements-react.md**
   - Industry/Niche: Frontend development
   - Platform: React.js
   - Focus Areas: Hooks, state management, performance optimization
   - Audience: Intermediate to advanced React developers
   - Official Docs: react.dev
   - Content Mix: Tutorials (60%), Deep dives (30%), News (10%)

3. **examples/requirements-python.md**
   - Industry/Niche: Data science and Python programming
   - Platform: Python
   - Focus Areas: Data analysis, machine learning, automation
   - Audience: Data scientists, Python developers
   - Official Docs: docs.python.org
   - Content Mix: Tutorials (50%), Analysis (30%), Libraries/tools (20%)

4. **examples/requirements-psychology.md**
   - Industry/Niche: Mental health and psychology
   - Platform: N/A (non-technical)
   - Focus Areas: Cognitive behavioral therapy, mindfulness, anxiety treatment
   - Audience: Mental health professionals, psychology students
   - Official Sources: APA, NIH, academic journals
   - Content Mix: Research summaries (40%), Practical guides (40%), Case studies (20%)

5. **examples/requirements-finance.md**
   - Industry/Niche: Personal finance and investing
   - Platform: N/A (non-technical)
   - Focus Areas: Retirement planning, tax optimization, investment strategies
   - Audience: Individual investors, financial advisors
   - Official Sources: SEC.gov, IRS.gov, reputable finance publications
   - Content Mix: How-to guides (50%), Market analysis (30%), News (20%)

6. **examples/requirements-entertainment.md**
   - Industry/Niche: Film and television
   - Platform: N/A (non-technical)
   - Focus Areas: Movie reviews, TV series analysis, industry trends
   - Audience: Film enthusiasts, entertainment industry professionals
   - Official Sources: Industry publications, film databases
   - Content Mix: Reviews (50%), Analysis (30%), News (20%)

**Each example should**:
- Fill in all sections from the template
- Show how the configuration adapts to that topic
- Include relevant official documentation sources
- Demonstrate appropriate brand voice for that niche
- Show realistic sample article ideas

---

### Phase 4: Update Documentation (45 minutes)

**Task 4.1: Restructure CLAUDE.md**
- Move "Configuration-Driven Architecture" to the top (after Overview)
- Add "Quick Start for New Projects" section
- Update examples to emphasize topic-agnostic nature
- Add "Switching Between Topics" section

**Suggested Structure**:
```markdown
# CLAUDE.md

## Project Overview
[Brief description]

## Configuration-Driven Architecture
[Explain how requirements.md drives everything]

### How It Works
[Explain the configuration extraction process]

### Quick Start for New Projects
1. Copy requirements-template.md → requirements.md
2. Fill in your project details
3. Run /content-calendar
4. Run /write-article
[Everything adapts automatically]

### Example Configurations
- WordPress/WooCommerce blog (examples/requirements-wordpress.md)
- React.js tutorial site (examples/requirements-react.md)
- Python programming tutorials (examples/requirements-python.md)
- Psychology blog (examples/requirements-psychology.md)
- Finance blog (examples/requirements-finance.md)
- Entertainment blog (examples/requirements-entertainment.md)

## Primary Commands
[Existing content]

## Architecture
[Existing content]

## Switching Between Topics
```bash
# View available examples
ls examples/

# Switch to React.js
cp examples/requirements-react.md requirements.md

# Switch to Psychology
cp examples/requirements-psychology.md requirements.md

# All subsequent content generation uses the new config
/content-calendar November 2025
```
```

**Task 4.2: Update README.md**
- Add "Topic-Agnostic Content Generation" section at the top
- Show quick examples of switching between topics
- Link to requirements-template.md and examples/

**Task 4.3: Add inline documentation**
- Ensure all agents mention they're "topic-agnostic" in their descriptions
- Already done for researcher and writer
- Update editor.md description if needed

---

## Testing & Validation

### Test Plan

**Test 1: React.js Configuration**
1. Copy `examples/requirements-react.md` → `requirements.md`
2. Run `/content-calendar December 2025`
3. Verify: Topics are React-focused, not WordPress
4. Verify: Official sources point to react.dev
5. Verify: Brand voice adapts to React audience

**Test 2: Psychology Configuration**
1. Copy `examples/requirements-psychology.md` → `requirements.md`
2. Run `/content-calendar December 2025`
3. Verify: Topics are psychology-focused
4. Verify: Official sources point to APA, NIH
5. Verify: Non-technical content style
6. Verify: No code examples suggested

**Test 3: Finance Configuration**
1. Copy `examples/requirements-finance.md` → `requirements.md`
2. Run `/content-calendar December 2025`
3. Verify: Topics are finance-focused
4. Verify: Official sources point to SEC.gov, financial publications
5. Verify: Appropriate disclaimers in brand voice

**Test 4: Full Article Generation**
1. Use any example configuration
2. Run `/write-article [calendar] [article-id]`
3. Verify: Research brief references correct official docs
4. Verify: Draft uses correct platform/product terminology
5. Verify: Editor validates against correct brand voice
6. Verify: HTML export generated only if configured

**Test 5: Validation**
1. Run requirements-validator skill
2. Verify: All checks use dynamically extracted values
3. Verify: No hardcoded references to WordPress/WooCommerce

---

## Implementation Checklist

### Phase 1: Fix Hardcoded References ✅
- [ ] Update seo-optimization/SKILL.md (line 8, add configuration section)
- [ ] Update requirements-validator/SKILL.md (add Phase 0, dynamic extraction)
- [ ] Search entire .claude/ directory for remaining "WordPress" or "WooCommerce" references
- [ ] Verify all hardcoded audience references removed

### Phase 2: Create Requirements Template ✅
- [ ] Create requirements-template.md with comprehensive placeholders
- [ ] Add inline comments explaining each section
- [ ] Include examples for technical and non-technical content
- [ ] Add validation notes (what's required vs optional)

### Phase 3: Create Example Configurations ✅
- [ ] Create examples/ directory
- [ ] Create examples/requirements-wordpress.md (copy current)
- [ ] Create examples/requirements-react.md
- [ ] Create examples/requirements-python.md
- [ ] Create examples/requirements-psychology.md
- [ ] Create examples/requirements-finance.md
- [ ] Create examples/requirements-entertainment.md
- [ ] Verify each example has all required sections

### Phase 4: Update Documentation ✅
- [ ] Restructure CLAUDE.md (move config section to top)
- [ ] Add "Quick Start for New Projects" to CLAUDE.md
- [ ] Add "Switching Between Topics" section to CLAUDE.md
- [ ] Update README.md with topic-agnostic examples
- [ ] Update agent descriptions to emphasize topic-agnostic nature
- [ ] Add examples/README.md explaining each example configuration

### Phase 5: Testing & Validation ✅
- [ ] Test React.js configuration end-to-end
- [ ] Test Psychology configuration end-to-end
- [ ] Test Finance configuration end-to-end
- [ ] Test full article generation with different configs
- [ ] Verify requirements-validator uses dynamic extraction
- [ ] Verify no hardcoded assumptions remain
- [ ] Test HTML export conditional logic

---

## Migration Guide for Existing Projects

If you already have a working system with WordPress/WooCommerce:

**Option 1: Keep Current Setup**
- No changes needed
- Current requirements.md works as-is
- System already reads it dynamically

**Option 2: Start Fresh with New Topic**
1. Backup current requirements.md:
   ```bash
   cp requirements.md requirements-backup.md
   ```
2. Copy template:
   ```bash
   cp requirements-template.md requirements.md
   ```
3. Fill in new topic details
4. Start generating content for new topic

**Option 3: Maintain Multiple Configurations**
1. Save configurations as separate files:
   ```bash
   requirements-wordpress.md
   requirements-react.md
   requirements-psychology.md
   ```
2. Switch between them as needed:
   ```bash
   cp requirements-wordpress.md requirements.md
   # Or
   cp requirements-react.md requirements.md
   ```

---

## Success Criteria

### System is Successfully Topic-Agnostic When:

✅ **Configuration Validation**
- All agents read requirements.md on every run
- No hardcoded topic/platform assumptions in any agent
- All validation criteria extracted from requirements.md
- Skills adapt to configured platform

✅ **Template Validation**
- requirements-template.md covers all configuration needs
- Clear instructions for every field
- Works for technical and non-technical content

✅ **Example Validation**
- 6+ example configurations for diverse topics
- Each example fully functional
- Examples demonstrate system versatility

✅ **Documentation Validation**
- CLAUDE.md leads with configuration-first approach
- Clear "Quick Start" for new projects
- "Switching Topics" examples work correctly

✅ **End-to-End Testing**
- Can generate content calendar for any topic
- Can write complete article for any topic
- All agents adapt to configured brand voice
- HTML export conditional logic works

---

## Maintenance & Future Improvements

### Future Enhancements (Not in Current Scope)

1. **Interactive Configuration Setup**
   - CLI wizard to generate requirements.md
   - Validates required fields
   - Suggests defaults based on industry

2. **Configuration Validation Skill**
   - New skill to validate requirements.md structure
   - Checks for missing required fields
   - Warns about potential conflicts

3. **Multi-Configuration Support**
   - Support multiple projects in one repository
   - Switch configs via command argument: `/content-calendar October 2025 --config=react`

4. **Platform-Specific Skill Registry**
   - Dynamic skill loading based on CMS Platform
   - Automatic formatter selection
   - Plugin architecture for custom platforms

5. **More Example Configurations**
   - SaaS product marketing
   - E-commerce (non-WooCommerce)
   - Healthcare
   - Education/EdTech
   - Gaming

---

## Summary

The system is **already architected to be topic-agnostic**. This implementation plan focuses on:

1. **Cleaning up** the few remaining hardcoded references
2. **Documenting** the configuration-driven approach more clearly
3. **Providing** templates and examples to make topic-switching obvious
4. **Testing** to ensure the system works for diverse content types

**Total Effort:** ~3 hours
**Impact:** System becomes truly universal and easy to adapt to any blog topic

The architecture is solid. We just need to polish the edges and make the topic-agnostic nature more explicit to users.
