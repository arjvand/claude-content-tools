# Content Requirements Configuration

This file configures the content generation system. Agents read this file at runtime to adapt their behavior to Summix.

---

## PROJECT CONFIGURATION

### Primary Topic & Focus

* **Industry/Niche**: WordPress content operations, data integration, and marketing automation
* **Focus Areas**: Content portability (Markdown workflows), editorial/backup practices, WordPress ↔ CRM/ESP data synchronization, customer lifecycle automation, data quality & governance, privacy/compliance, reliability & performance of integrations

### Official Documentation Sources

* **Primary Documentation**: [https://developer.wordpress.org/](https://developer.wordpress.org/)
* **Community Forums**: [https://wordpress.org/support/](https://wordpress.org/support/) • Stack Overflow (wordpress, woocommerce, gravity-forms, memberpress, hubspot, campaign-monitor tags) • Relevant Reddit communities (r/WordPress, r/woocommerce)
* **Official Blogs**: WordPress.org News • WooCommerce Developer Blog • HubSpot Developer/Engineering Blog • Campaign Monitor Blog • Gravity Forms/MemberPress blogs
* **Repository**: Public examples or gists accompanying articles (GitHub organization or author repos as appropriate)
* **Other Authoritative Sources**: MDN Web Docs • OAuth 2.0 (RFC 6749) • GDPR/EDPB guidance • W3C and WHATWG specs where relevant

---

## AUDIENCE

### Target Readers

* **Primary Roles**: WordPress implementers (plugin/theme devs), agencies/freelancers delivering WP sites, technical marketers/marketing ops, RevOps, eCommerce managers (WooCommerce), membership/community managers (MemberPress), content operations managers
* **Skill Level**: Intermediate–advanced technical practitioners; secondary persona: non‑developer marketers comfortable with WordPress admin and basic automation concepts
* **Primary Segment**: Prospective buyers/influencers researching vendor‑agnostic solutions for content portability and data sync/marketing automation; agency evaluators who recommend tooling to clients

---

## BRAND IDENTITY

### Brand Information

* **Brand Name**: Summix

### Brand Voice

* **Traits**: Practitioner‑first, concise, friendly but precise, transparent about trade‑offs, no hype, solutions‑oriented, code-and-diagram heavy

#### Brand Voice Guidelines

**DO (On‑Brand):**

* “Here’s a reliable way to export content to Markdown and preserve taxonomy.”
* “This mapping pattern prevents duplicate contacts when syncing forms to your CRM.”
* “Let’s instrument retries and idempotency with clear logs and alerts.”

**DON’T (Off‑Brand):**

* “The ULTIMATE guide you absolutely need right now!”
* “This is a game‑changer that replaces your entire stack.”
* Vague claims without reproducible steps, code, or references

---

## CONTENT STRATEGY

### Content Objectives

* **Objective**: Educate practitioners on robust content portability and data integration patterns; establish Summix as a trusted authority; attract qualified traffic around integration workflows and operations
* **Primary KPI**: Organic search traffic to integration/ops topics; newsletter signups; downloads of templates/checklists; time‑on‑page for technical guides

### Content Formats

* **Formats**: Tutorials/how‑tos, integration playbooks, architecture deep dives, troubleshooting guides, field‑mapping templates, data quality checklists, implementation case studies (anonymized), Q&A explainers, short code recipes
* **Content Mix**: Tutorials & Playbooks (60–70%), Deep‑dive Analysis (15–25%), Case Studies (10–15%), News/Trends (0–5%)
* **Depth**: Primarily intermediate to advanced; occasional 101 primers that funnel into deeper resources
* **Length**: Quality‑first; typical 900–2,000 words; long‑form playbooks 2,500–4,000 words with diagrams and downloadable assets

### Topic Pillars

* **Primary Pillar**: Content Portability & Editorial Workflows (Markdown, versioning, backups, migration)
* **Secondary Pillars**:

  * WordPress ↔ CRM/ESP Integrations (forms, contacts, events, consent)
  * eCommerce Lifecycle & Personalization (WooCommerce data to marketing systems)
  * Membership & Subscription Operations (MemberPress events, renewals, churn)
  * Data Quality, Governance & Compliance (GDPR/CCPA, consent, auditing)
  * Reliability & Observability of Integrations (queues, retries, rate limits, logging)

### SEO & Distribution

* **SEO Intent**: Topic clusters around “WordPress Markdown workflows”, “form/checkout → CRM/ESP”, “field mapping”, “webhooks & rate limits”, “identity resolution/deduplication”, “consent & compliance”. Prioritize problem/solution queries and long‑tail how‑tos.
* **Internal Linking**: Cluster/pillar interlinking; each post links up to its hub and 2–3 siblings; add glossary entries for recurring terms (idempotency, contact key, double opt‑in).
* **Primary CTA**: Subscribe to newsletter; download templates/checklists; join community updates. (No product pitches.)
* **Distribution Channels**: Newsletter/RSS, LinkedIn, X (Twitter), Dev.to, relevant WordPress/marketing communities, conference talk recaps on the blog, YouTube code/diagram walk‑throughs (vendor‑agnostic)

### Quality & Review Process

* **SME Involvement**: Required for tutorials/playbooks and anything involving compliance or advanced architecture
* **Review Workflow**: Author draft → Technical review → Editorial QA (clarity, tone, SEO) → Legal/privacy sanity check (if applicable) → Publish
* **Cadence**: Target 2 posts/week (1 tutorial/playbook + 1 shorter recipe/analysis)
* **Product Announcements Scope**: Only major ecosystem changes that materially affect the above topics; keep vendor‑neutral

---

## CONTENT DELIVERY

### Publication Platform

* **CMS Platform**: WordPress (Gutenberg editor)
* **Export Format**: gutenberg

### Visual Standards

* **Image Style**: Minimal, clean diagrams (data‑flow, sequence, and mapping tables), occasional annotated screenshots of generic WordPress admin (no third‑party UI promos), sparing use of photography
* **Featured Images**: Required for each post; abstract data/ops visuals aligned to brand palette
* **Code Snippets**: Syntax‑highlighted full blocks preferred; include WP‑CLI, PHP, JS, and occasional Node/Python scripts; provide sample payloads (JSON/CSV/Markdown)
* **Downloads**: Provide checklists, CSV/JSON samples, and mapping templates as attachments or GitHub gists

---

## LOCALIZATION

### Language & Region

* **Language**: en
* **Regions**: Global (focus: North America & Europe)
* **Spelling**: US English
* **Accessibility**: Alt text required; diagrams must include text equivalents

---

## ADDITIONAL NOTES

### Target Audience Insights & Pain Points

* Agencies/freelancers: repeatable processes, client portability, dependable integrations that reduce support tickets
* Technical marketers/RevOps: reliable contact syncing, deduplication, consent capture, segmentation data that actually arrives
* eCommerce managers: lifecycle triggers (abandonment, post‑purchase), SKU/variant accuracy, revenue attribution
* Membership/community managers: signup/renewal events, entitlement changes, churn/retention signals
* Content ops: Markdown export/versioning, migration/archival, collaboration with Git‑based workflows

### Editorial Guardrails

* Vendor‑agnostic and pattern‑first; when naming platforms (e.g., HubSpot), remain neutral and focus on implementation details
* Avoid direct product promotion or comparisons; emphasize use cases, trade‑offs, and reproducible steps
* Include diagrams and edge‑case callouts; link to official docs for specs/limits/rate‑limits

### Sample Article Ideas (non‑promotional)

1. **Exporting WordPress to Markdown Without Losing Taxonomies** — preserving categories, tags, and custom fields
2. **Git‑Based Editorial Workflows for WordPress** — versioning posts, diffs, and approvals
3. **Building a Content Backup & Archival Plan for WordPress** — retention, offsite storage, and restores
4. **Designing a Reliable Webhook Pipeline for WordPress** — retries, idempotency keys, and dead‑letter queues
5. **Field Mapping 101: Gravity Forms → CRM Contacts** — required fields, enums, and validation
6. **Consent & Double Opt‑In: A Practical Guide for WordPress Forms** — lawful bases, auditing, and proof of consent
7. **Identity Resolution for Marketing Contacts** — email as key, secondary keys, and merge strategies
8. **WooCommerce Lifecycle Triggers for Email & SMS** — events, segmentation, and personalization data
9. **RFM Segmentation from WooCommerce Orders** — basic SQL/export recipes and ESP targeting
10. **Member Lifecycle Events with MemberPress** — onboarding, renewal nudges, dunning, and win‑back flows
11. **Avoiding Duplicate Contacts in CRM Syncs** — race conditions, replays, and upsert patterns
12. **Working with CRM Rate Limits** — backoff strategies and throughput planning
13. **Observability for Marketing Data Pipelines** — logs, metrics, alerts, dashboards
14. **When to Use iPaaS vs. Build Native Integrations** — decision matrix and total cost of ownership
15. **Data Quality Checklist for WordPress → ESP** — required properties, enums, and validation
16. **Schema Design for Events & Properties** — naming conventions, versioning, and governance
17. **Abandoned Cart Emails the Right Way** — data needed, timing, and compliance considerations
18. **Migrating WordPress Content to Static Sites** — Markdown front matter, image paths, and redirects
19. **Disaster Recovery for Marketing Integrations** — replay logs, backfills, and incident runbooks
20. **The Privacy‑First Marketer’s Guide to WordPress** — data minimization, consent UX, and data subject requests

### KPIs & Measurement Details

* Track: organic clicks/impressions to target clusters, newsletter conversions, asset downloads, and assisted conversions from integration‑related sessions
* Quality signals: scroll depth, copy‑paste events on code blocks, time‑to‑first‑diagram, returning visitors on technical posts

### Maintenance

* Review integration posts quarterly for API/rate‑limit changes; annotate deprecations and provide update notes
* Maintain a public changelog for templates/assets referenced in posts
