# Content Requirements Configuration

This file configures the content generation system. Agents read this file at runtime to adapt their behavior to Python Path.

---

## PROJECT CONFIGURATION

### Primary Topic & Focus

* **Industry/Niche**: Python programming, data science, automation, and web development
* **Focus Areas**: Data analysis and visualization, web development (Django/FastAPI), automation scripts, testing and debugging, performance optimization, async programming, package management

### Official Documentation Sources

* **Primary Documentation**: [https://docs.python.org/3/](https://docs.python.org/3/)
* **Community Forums**: Stack Overflow (python, django, pandas tags) • Reddit r/Python r/learnpython • Python Discord •  Python Forum (discuss.python.org)
* **Official Blogs**: Python.org Blog • PyCoder's Weekly • Real Python • Django News
* **Repository**: [https://github.com/python/cpython](https://github.com/python/cpython) • Various package repos (Django, pandas, etc.)
* **Other Authoritative Sources**: PEPs (Python Enhancement Proposals) • PyPI documentation • Read the Docs

---

## AUDIENCE

### Target Readers

* **Primary Roles**: Python developers, data scientists, data engineers, backend engineers, DevOps engineers, automation engineers, data analysts transitioning to programming
* **Skill Level**: Beginner to intermediate (with some advanced topics)
* **Primary Segment**: Professionals using Python for web development, data analysis, or automation; bootcamp graduates; self-taught developers leveling up

---

## BRAND IDENTITY

### Brand Information

* **Brand Name**: Python Path

### Brand Voice

* **Traits**: Approachable, educational, practical, example-driven, welcoming to beginners while respecting intermediate/advanced readers

#### Brand Voice Guidelines

**DO (On-Brand):**

* "Here's how to optimize your pandas DataFrame operations for better performance..."
* "This pattern makes your Django views more testable and maintainable..."
* "Let's walk through building a REST API with FastAPI step by step..."
* "Understanding the difference between lists and generators helps you write more efficient Python..."

**DON'T (Off-Brand):**

* "Python will DOMINATE all other languages!"
* "The ONLY way to do data science!"
* "You're doing Python wrong if you're not using X!" (prescriptive/judgmental)
* "This is simple and easy." (dismissive of complexity; prefer "straightforward with practice")

---

## CONTENT STRATEGY

### Content Objectives

* **Objective**: Educate Python developers on best practices, modern tooling, and practical applications; build a community of learners; attract developers seeking production-ready Python knowledge
* **Primary KPI**: Organic search traffic to Python tutorials; newsletter subscriptions; code snippet engagement; tutorial completion rates; returning visitors

### Content Formats

* **Formats**: Step-by-step tutorials, practical guides, library comparisons, code pattern examples, debugging walkthroughs, project-based learning
* **Content Mix**: Tutorials (50%), Practical guides (30%), Library/tool reviews (15%), News and ecosystem updates (5%)
* **Depth**: Beginner to intermediate (60%), Intermediate to advanced (40%)
* **Length**: Tutorials: 1,000-2,000 words; In-depth guides: 2,000-3,000 words; Quick tips: 500-800 words

### Topic Pillars

* **Primary Pillar**: Python Best Practices & Modern Development
* **Secondary Pillars**:
  * Data Analysis & Visualization (pandas, matplotlib, seaborn)
  * Web Development (Django, FastAPI, Flask)
  * Automation & Scripting
  * Testing & Debugging
  * Performance & Optimization

### SEO & Distribution

* **SEO Intent**: Target "python tutorial", "how to [task] in python", "pandas vs numpy", "django best practices", "python for data science" queries; build topic clusters around data science, web dev, and automation
* **Internal Linking**: Link tutorials in progressive sequences (beginner → intermediate); cross-link related libraries and techniques
* **Primary CTA**: Subscribe to Python Path newsletter; download Python cheat sheets; join community Discord
* **Distribution Channels**: Newsletter/RSS, Dev.to, Reddit r/Python, Python Weekly, Twitter, LinkedIn, YouTube code walkthroughs

### Quality & Review Process

* **SME Involvement**: Required for advanced topics (async programming, performance optimization, complex pandas operations); optional for beginner tutorials
* **Review Workflow**: Draft → Code testing (all examples run successfully) → Technical review → Editorial → Publish
* **Cadence**: 2-3 posts/week (1 tutorial + 1 practical guide + occasional quick tip)
* **Product Announcements Scope**: Cover major Python releases (3.12, 3.13, etc.), significant framework updates (Django 5.x, FastAPI), popular library releases

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

---

## CONTENT DELIVERY

### Publication Platform

* **CMS Platform**: Markdown files (static site with MkDocs or Hugo)
* **Export Format**: markdown

### Visual Standards

* **Image Style**: Code screenshots with syntax highlighting; terminal output examples; data visualization examples (matplotlib/seaborn plots); architecture diagrams for web apps; minimal decorative images
* **Featured Images**: Required; Python-themed abstract visuals or code snippets
* **Code Snippets**: Syntax-highlighted Python; include full imports; show expected output; provide notebook links for data science tutorials; GitHub repo with runnable examples
* **Downloads**: Jupyter notebooks, cheat sheets (PDF), project starter templates, requirements.txt files

---

## LOCALIZATION

### Language & Region

* **Language**: en
* **Regions**: Global
* **Spelling**: US English
* **Accessibility**: Alt text for all plots and diagrams; code examples explained in prose; keyboard-accessible examples

---

## ADDITIONAL NOTES

### Target Audience Insights & Pain Points

* Beginners overwhelmed by Python's flexibility—too many ways to do the same thing
* Data scientists struggle with pandas performance issues and confusing DataFrame operations
* Web developers uncertain about Django vs. FastAPI choice, when to use each
* Need practical, real-world examples beyond toy datasets or "Hello World" apps
* Testing often skipped—need approachable testing tutorials
* Package/dependency management confusion (pip, conda, poetry, uv)

### Editorial Guardrails

* All code examples must be tested with specified Python version (note version requirements)
* Include requirements.txt or pyproject.toml for dependencies
* Show actual output/results, not just code
* Link to official Python docs and PEPs when discussing language features
* For data science tutorials, use realistic datasets or provide links to sample data
* Avoid framework wars; present objective comparisons with use-case guidance
* Include error handling examples—show what goes wrong and how to fix it

### Sample Article Ideas (non-promotional)

1. **Python 3.13 New Features: What You Need to Know** — performance improvements, new syntax, migration guide
2. **Pandas Performance: 10 Ways to Speed Up DataFrame Operations** — vectorization, query(), categorical data, chunking
3. **Building a REST API with FastAPI: Complete Tutorial** — endpoints, validation, async, testing, deployment
4. **Python Testing with pytest: From Basics to Fixtures** — test organization, parametrize, conftest.py, mocking
5. **Understanding Python Decorators: Practical Examples** — function decorators, class decorators, @property, custom decorators
6. **Django vs. FastAPI: Choosing the Right Framework** — use cases, performance, ecosystem, learning curve
7. **Async Python: From Fundamentals to Real-World Use Cases** — asyncio basics, aiohttp, concurrent tasks, pitfalls
8. **Data Visualization with Matplotlib and Seaborn** — plot types, styling, subplots, saving figures
9. **Python Virtual Environments: venv, conda, and Poetry** — when to use each, best practices, reproducible environments
10. **List Comprehensions vs. Generator Expressions** — memory efficiency, readability, when to use each
11. **Debugging Python: PDB, Logging, and Modern Tools** — interactive debugging, logging best practices, VS Code debugger
12. **Automating Excel with Python: pandas and openpyxl** — reading/writing Excel, formatting, formulas
13. **Python Type Hints: Practical Guide** — mypy, typing module, generics, gradual typing strategy
14. **Building Command-Line Tools with Click** — arguments, options, subcommands, configuration
15. **SQLAlchemy ORM: Beginner to Intermediate** — models, queries, relationships, sessions, migrations
16. **Error Handling in Python: Best Practices** — try/except patterns, custom exceptions, context managers
17. **Python Context Managers: Beyond with open()** — writing custom context managers, @contextmanager, use cases
18. **Web Scraping with BeautifulSoup and Scrapy** — parsing HTML, handling pagination, respectful scraping
19. **Python Packaging: Creating Your First Package** — setup.py vs. pyproject.toml, versioning, publishing to PyPI
20. **NumPy Broadcasting: Understanding and Using** — array operations, shape compatibility, performance

### KPIs & Measurement Details

* Track: Organic traffic for Python keywords; newsletter conversion rate; code snippet copy events; Jupyter notebook downloads; GitHub stars on example repos
* Quality signals: Time on page (target 4+ minutes for tutorials), scroll depth, code example engagement, returning visitors, comments/questions
* Community: Discord joins, newsletter open rates, social media shares, tutorial completion rates (if tracking via platform)

### Maintenance

* Review all Python version-specific tutorials after new Python releases
* Update library tutorials when major versions release (pandas 2.x, Django 5.x)
* Quarterly review of "vs" comparison articles (Django vs FastAPI, etc.) for accuracy
* Test all code examples semi-annually to ensure compatibility with latest library versions
* Add version warnings when features are deprecated
