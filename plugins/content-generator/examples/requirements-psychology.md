# Content Requirements Configuration

This file configures the content generation system. Agents read this file at runtime to adapt their behavior to MindfulPractice.

---

## PROJECT CONFIGURATION

### Primary Topic & Focus

* **Industry/Niche**: Mental health, clinical psychology, and evidence-based therapeutic practices
* **Focus Areas**: Cognitive-behavioral therapy (CBT), anxiety disorders, depression treatment, mindfulness-based interventions, therapeutic techniques, client assessment, treatment planning, professional development for therapists

### Official Documentation Sources

* **Primary Documentation**: [https://www.apa.org/](https://www.apa.org/) (American Psychological Association)
* **Community Forums**: PsychCentral Professional Forums • Reddit r/psychotherapy • APA Division forums
* **Official Blogs**: APA Journals Blog • Society for Clinical Psychology • NIMH Director's Blog
* **Repository**: N/A
* **Other Authoritative Sources**: NIH/NIMH [https://www.nimh.nih.gov/](https://www.nimh.nih.gov/) • PubMed for research studies • SAMHSA • Evidence-Based Practice guidelines

---

## AUDIENCE

### Target Readers

* **Primary Roles**: Licensed therapists (LCSW, LPC, LMFT, PhD, PsyD), clinical psychology graduate students, mental health counselors, clinical social workers, psychiatric nurses
* **Skill Level**: Intermediate to advanced practitioners; some beginner content for students/new clinicians
* **Primary Segment**: Practicing therapists seeking evidence-based techniques and professional development; graduate students preparing for clinical practice

---

## BRAND IDENTITY

### Brand Information

* **Brand Name**: MindfulPractice

### Brand Voice

* **Traits**: Evidence-based, compassionate, professional, accessible, research-informed, ethically grounded

#### Brand Voice Guidelines

**DO (On-Brand):**

* "Research shows that cognitive restructuring techniques can effectively reduce anxiety symptoms..."
* "Here's an evidence-based approach to addressing negative automatic thoughts..."
* "Consider this intervention for clients experiencing treatment-resistant depression..."
* "Let's review the ethical considerations when working with this population..."

**DON'T (Off-Brand):**

* "This ONE technique will cure all your clients' anxiety!"
* "Traditional therapy is DEAD—this method is revolutionary!"
* "Just tell your clients to think positive thoughts." (oversimplification)
* "Forget evidence—here's what really works..." (dismissing research)

---

## CONTENT STRATEGY

### Content Objectives

* **Objective**: Provide evidence-based clinical guidance for mental health professionals; promote best practices in psychological treatment; support professional development; maintain ethical standards
* **Primary KPI**: Newsletter subscriptions from licensed professionals; downloads of clinical worksheets/assessment tools; time-on-page for case study articles; returning professional visitors

### Content Formats

* **Formats**: Clinical guides, research summaries, case study analyses, therapeutic technique tutorials, ethical dilemma discussions, treatment planning frameworks, assessment tool reviews
* **Content Mix**: Clinical guides (40%), Research summaries (30%), Case studies (20%), Professional development (10%)
* **Depth**: Primarily intermediate to advanced clinical content
* **Length**: Clinical guides: 1,500-2,500 words; Research summaries: 1,000-1,800 words; Case studies: 2,000-3,000 words

### Topic Pillars

* **Primary Pillar**: Evidence-Based Treatment for Anxiety and Depression
* **Secondary Pillars**:
  * Cognitive-Behavioral Therapy Techniques
  * Mindfulness-Based Interventions
  * Client Assessment and Treatment Planning
  * Therapeutic Relationship and Ethics
  * Trauma-Informed Care

### SEO & Distribution

* **SEO Intent**: Target "CBT techniques for anxiety", "treating treatment-resistant depression", "mindfulness interventions", "clinical assessment tools", "therapy case conceptualization"; build topic clusters around specific disorders and therapeutic modalities
* **Internal Linking**: Link related disorders, techniques, and assessment tools; connect theory articles to practical application guides
* **Primary CTA**: Subscribe to professional newsletter; download clinical worksheets; join continuing education webinars
* **Distribution Channels**: Professional newsletter, LinkedIn, psychology podcasts, continuing education platforms, APA resource lists

### Quality & Review Process

* **SME Involvement**: REQUIRED for all clinical content—must be reviewed by licensed psychologist or equivalent
* **Review Workflow**: Draft → Clinical accuracy review by licensed professional → Ethical/legal review → Editorial → Compliance check → Publish
* **Cadence**: 1-2 posts/week (quality over quantity for professional audience)
* **Product Announcements Scope**: Cover DSM updates, significant research findings, new evidence-based protocols, changes to ethical guidelines

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

* **CMS Platform**: WordPress (Gutenberg editor)
* **Export Format**: gutenberg

### Visual Standards

* **Image Style**: Professional, calming imagery; clinical diagrams (thought records, CBT triangles); charts showing research data; minimal stock photography
* **Featured Images**: Required; abstract calming visuals consistent with mental health professionalism
* **Code Snippets**: N/A
* **Downloads**: Clinical worksheets (PDF), assessment tools, therapy handouts, treatment planning templates

---

## LOCALIZATION

### Language & Region

* **Language**: en
* **Regions**: United States (with consideration for international readers)
* **Spelling**: US English
* **Accessibility**: Alt text for all images; clear language for complex psychological concepts; accessible PDFs for downloads

---

## ADDITIONAL NOTES

### Target Audience Insights & Pain Points

* Therapists struggle to keep up with latest research while maintaining full caseload
* Need practical, immediately applicable techniques—not just theory
* Ethical dilemmas arise regularly; need guidance on complex cases
* Treatment-resistant clients require advanced interventions
* Documentation and treatment planning time-consuming
* Balancing evidence-based practice with individualized client care

### Editorial Guardrails

* All clinical claims must be supported by peer-reviewed research—cite sources
* Include disclaimers that content is for professional education, not direct client advice
* Respect client confidentiality—case examples must be heavily disguised or composite
* Note when treatments are experimental vs. empirically supported
* Include ethical considerations for sensitive topics
* Comply with HIPAA and professional ethical guidelines (APA Ethics Code)
* Avoid diagnosing or offering treatment recommendations for specific individuals

### Sample Article Ideas (non-promotional)

1. **Cognitive Restructuring for Generalized Anxiety: Step-by-Step Guide** — identifying cognitive distortions, evidence gathering, alternative thoughts
2. **Evidence-Based Interventions for Treatment-Resistant Depression** — behavioral activation, interpersonal therapy, consideration of referrals
3. **Conducting Effective CBT Homework Assignments** — designing between-session tasks, addressing non-compliance, measuring progress
4. **Mindfulness-Based Stress Reduction: Clinical Applications** — when to use MBSR, teaching techniques, integrating with CBT
5. **Case Conceptualization in CBT: A Practical Framework** — identifying core beliefs, behavioral patterns, treatment targets
6. **Addressing Negative Automatic Thoughts in Session** — Socratic questioning, thought records, real-time interventions
7. **Ethical Dilemmas in Telehealth: Navigating Digital Practice** — confidentiality, boundaries, technology issues, state licensing
8. **Therapeutic Alliance: Research and Practical Strategies** — rupture and repair, difficult clients, measuring alliance
9. **Exposure Therapy for Anxiety Disorders: Best Practices** — hierarchy development, in vivo vs. imaginal exposure, safety behaviors
10. **Motivational Interviewing Techniques for Ambivalent Clients** — rolling with resistance, change talk, decisional balance
11. **Assessing Suicide Risk: Structured Approaches** — validated assessment tools, safety planning, documentation, referral criteria
12. **Treating Social Anxiety: Evidence-Based Protocols** — cognitive preparation, graduated exposure, post-event processing
13. **Emotion Regulation Skills for Borderline Personality Disorder** — DBT techniques, distress tolerance, mindfulness applications
14. **Cultural Considerations in Psychotherapy** — adapting evidence-based treatments, avoiding microaggressions, cultural humility
15. **Trauma-Informed Care: Principles and Practice** — safety, trustworthiness, choice, collaboration, empowerment
16. **Sleep Interventions in Therapy: CBT-I Basics** — sleep restriction, stimulus control, sleep hygiene beyond the basics
17. **Managing Countertransference in Clinical Practice** — recognizing reactions, consultation, maintaining boundaries
18. **Brief Interventions for Acute Stress** — crisis intervention, grounding techniques, safety assessment
19. **Termination in Therapy: Planned and Ethical Endings** — preparing clients, addressing dependency, relapse prevention
20. **Integrating Positive Psychology into Clinical Practice** — strengths-based approaches, gratitude, savoring, when appropriate

### KPIs & Measurement Details

* Track: Newsletter subscriptions from professionals; worksheet downloads; time-on-page for clinical guides; returning visitors; CE webinar registrations
* Quality signals: Depth of engagement (scroll depth, time on complex articles), inbound links from professional organizations, citations in graduate programs
* Professional engagement: Comments from practitioners, case consultation requests, workshop inquiries

### Maintenance

* Review all treatment protocol articles when major research findings published or guidelines updated
* Update DSM-related content when new editions release
* Quarterly review of ethical guidance articles for changes in APA Ethics Code or state regulations
* Annual review of assessment tools for new validation studies
* Add updates/corrections when significant new research contradicts previous recommendations
