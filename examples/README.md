# Example Requirements Configurations

This directory contains working example configurations demonstrating how the content generation system adapts to different topics, industries, and content types.

---

## How to Use These Examples

1. **Browse the examples** to see how different projects are configured
2. **Copy an example** that's closest to your project:
   ```bash
   cp examples/requirements-react.md requirements.md
   ```
3. **Customize** the configuration for your specific needs
4. **Generate content** using the commands:
   ```bash
   /content-calendar November 2025
   /write-article Calendar/2025/November/content-calendar.md ART-202511-001
   ```

---

## Available Examples

### 1. requirements-wordpress.md
**WordPress/WooCommerce Content Operations Blog**

* **Industry**: WordPress development, data integration, marketing automation
* **Audience**: WordPress developers, agencies, technical marketers, RevOps professionals
* **Content Mix**: Tutorials (60-70%), Analysis (15-25%), Case studies (10-15%)
* **Technical Level**: Intermediate to advanced
* **Key Features**:
  - Technical content with code examples
  - Integration patterns and architecture
  - CMS Platform: WordPress (Gutenberg)
  - HTML export enabled

**Use this example for**: Technical blogs about web development platforms, integration guides, developer documentation

---

### 2. requirements-react.md
**React.js Frontend Development Blog**

* **Industry**: Frontend web development
* **Platform**: React.js, Next.js, modern JavaScript ecosystem
* **Audience**: Frontend developers, React developers, technical leads
* **Content Mix**: Tutorials (55%), Deep dives (30%), Patterns (10%), News (5%)
* **Technical Level**: Intermediate to advanced
* **Key Features**:
  - Code-first with TypeScript examples
  - Performance optimization focus
  - Static site (Markdown files)
  - Component pattern libraries

**Use this example for**: Technical programming blogs, framework-specific content, developer education platforms

---

### 3. requirements-python.md
**Python Programming and Data Science Blog**

* **Industry**: Python development, data science, automation
* **Platform**: Python 3.10+, Django, FastAPI, pandas, NumPy
* **Audience**: Python developers, data scientists, automation engineers
* **Content Mix**: Tutorials (50%), Guides (30%), Reviews (15%), News (5%)
* **Technical Level**: Beginner to intermediate (60%), Intermediate to advanced (40%)
* **Key Features**:
  - Educational and approachable tone
  - Jupyter notebook examples
  - Practical, runnable code
  - Package and library comparisons

**Use this example for**: Programming education, data science tutorials, automation guides, library documentation

---

### 4. requirements-psychology.md
**Clinical Psychology and Mental Health Blog**

* **Industry**: Mental health, clinical psychology
* **Focus**: Evidence-based therapeutic practices, CBT, anxiety treatment
* **Audience**: Licensed therapists, clinical psychology students, mental health professionals
* **Content Mix**: Clinical guides (40%), Research (30%), Case studies (20%), Professional development (10%)
* **Technical Level**: Intermediate to advanced practitioners
* **Key Features**:
  - **Non-technical content** (no code)
  - Evidence-based, research-cited
  - Professional, ethical tone
  - Clinical worksheets and tools
  - CMS Platform: WordPress (Gutenberg)
  - Strict review requirements (SME + legal)

**Use this example for**: Professional healthcare content, evidence-based practice guides, clinical education, therapy resources

---

### 5. requirements-finance.md
**Personal Finance and Investing Blog**

* **Industry**: Personal finance, retirement planning, investing
* **Focus**: Retirement accounts, tax optimization, index investing, FIRE movement
* **Audience**: Individual investors, high-income professionals, early retirees
* **Content Mix**: Planning guides (45%), Investment education (30%), Tax strategies (20%), News (5%)
* **Technical Level**: Beginner to intermediate finance literacy
* **Key Features**:
  - **Non-technical content** (financial concepts, not programming)
  - Educational and empowering tone
  - Disclaimers required (not financial advice)
  - Calculator/spreadsheet tools
  - Annual maintenance schedule (tax updates)
  - Static site (Markdown files)

**Use this example for**: Finance education, investment guides, tax optimization content, retirement planning resources

---

### 6. requirements-entertainment.md
**Film and Television Criticism Blog**

* **Industry**: Entertainment, film, television, streaming
* **Focus**: Reviews, analysis, filmmaker spotlights, streaming guides
* **Audience**: Film enthusiasts, cinephiles, casual viewers, film students
* **Content Mix**: Reviews (50%), Analysis (30%), Lists/guides (15%), News (5%)
* **Technical Level**: Beginner to intermediate film literacy
* **Key Features**:
  - **Non-technical content** (entertainment criticism)
  - Thoughtful, analytical voice
  - Spoiler warnings required
  - Visual-heavy (film stills, posters)
  - CMS Platform: WordPress (Gutenberg)
  - Time-sensitive content (awards season)

**Use this example for**: Entertainment criticism, media analysis, pop culture blogs, arts and culture publications

---

## Topic Coverage

The examples demonstrate the system's versatility across:

**Technical Content**:
- WordPress/WooCommerce (web development)
- React.js (frontend frameworks)
- Python (programming and data science)

**Non-Technical Content**:
- Psychology (healthcare/clinical)
- Finance (education/planning)
- Entertainment (criticism/analysis)

**Content Depth**:
- Beginner-friendly (Python, Finance)
- Intermediate (All examples)
- Advanced (WordPress, React, Psychology)

**Platform Types**:
- WordPress with HTML export (WordPress, Psychology, Entertainment)
- Static sites with Markdown (React, Python, Finance)

---

## Key Configuration Differences

| Aspect | WordPress | React | Python | Psychology | Finance | Entertainment |
|--------|-----------|-------|--------|------------|---------|---------------|
| **Code Examples** | Yes (PHP, JS) | Yes (TS/JS) | Yes (Python) | No | No | No |
| **Technical Depth** | High | High | Medium-High | N/A | N/A | N/A |
| **SME Required** | Optional | Required | Optional | **REQUIRED** | Required | Optional |
| **Legal Review** | Sometimes | No | No | **REQUIRED** | **REQUIRED** | No |
| **HTML Export** | Yes | No | No | Yes | No | Yes |
| **Update Frequency** | Quarterly | After releases | Quarterly | After research | **Annual** | Weekly |
| **Disclaimers** | No | No | No | **REQUIRED** | **REQUIRED** | Spoiler warnings |

---

## Choosing the Right Example

**For technical programming content**:
- Choose **React** for frontend/JavaScript
- Choose **Python** for backend/data science
- Choose **WordPress** for CMS/integration content

**For professional services**:
- Choose **Psychology** for healthcare/clinical
- Choose **Finance** for financial services
- Modify either for legal, consulting, or B2B services

**For media and entertainment**:
- Choose **Entertainment** for film/TV/books
- Adapt for music, gaming, or arts criticism

**For education**:
- Choose **Python** for beginner-friendly technical education
- Choose **Finance** for non-technical education
- Adapt either for academic or professional training content

---

## Customization Tips

1. **Start with the closest example** to your topic
2. **Keep the structure** - all sections are important
3. **Customize these key areas**:
   - Industry/Niche and Platform
   - Official Documentation Sources (where agents research)
   - Brand Voice (DO/DON'T examples)
   - Content Mix percentages
   - Sample Article Ideas (be specific!)
4. **Adjust technical requirements**:
   - Set Technology Stack to "N/A" for non-technical content
   - Set Code Snippets to "N/A" if not applicable
   - Choose appropriate CMS Platform and HTML Formatter
5. **Set appropriate guardrails**:
   - Add disclaimers if required by your industry
   - Set SME requirements based on content complexity
   - Add legal review steps if needed

---

## Testing Your Configuration

After creating/customizing your requirements.md:

1. **Generate a test calendar**:
   ```bash
   /content-calendar TestMonth 2025
   ```

2. **Review the calendar topics**:
   - Are they relevant to your niche?
   - Do they reference the right platform/product?
   - Are official sources mentioned?

3. **Generate a test article**:
   ```bash
   /write-article Calendar/2025/TestMonth/content-calendar.md ART-202512-001
   ```

4. **Check the article**:
   - Does the brand voice match your DO/DON'T examples?
   - Is the audience level appropriate?
   - Are the right official sources cited?
   - Is the word count in your specified range?

5. **Iterate**: Adjust requirements.md and regenerate if needed

---

## Support and Feedback

Found an issue with an example or have questions? Check the main project documentation in `CLAUDE.md` or `IMPLEMENTATION_PLAN.md`.

Want to contribute additional examples? Examples for these topics would be valuable:
- SaaS product marketing
- E-commerce (non-WooCommerce)
- Healthcare (non-psychology)
- Legal services
- Real estate
- Education/EdTech
- Gaming
- B2B services
