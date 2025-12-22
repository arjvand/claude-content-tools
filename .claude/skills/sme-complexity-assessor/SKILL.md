# SME Complexity Assessor Skill

## Purpose

Systematically assesses technical complexity, domain specificity, and risk levels for article topics to determine Subject Matter Expert (SME) requirements. Replaces ad-hoc, inconsistent SME flagging with a structured framework that specifies what expertise is needed, why, and for which sections.

## Problem Solved

**Before this skill:**
- SME flagging is manual and inconsistent
- No systematic framework for assessing complexity
- Risk of under-flagging (quality issues, misinformation) or over-flagging (unnecessary delays)
- Unclear SME requirements ("needs SME" vs. "needs Senior DevOps Engineer for production patterns")

**With this skill:**
- **Objective Scoring:** Systematic complexity assessment across 4 dimensions
- **Specific Profiles:** Clear expertise requirements (not vague "SME needed")
- **Risk Assessment:** Identifies accuracy, compliance, and security risks
- **Scoped Reviews:** Specifies which sections need expert validation (not "entire article")
- **Resource Planning:** Estimates review time for better scheduling

---

## When to Invoke

### Mandatory Invocation Points

**1. Content Calendar Generation**
- **When:** After topic candidates generated, before finalizing calendar
- **Purpose:** Flag SME requirements for resource planning
- **Time:** 1-2 minutes for 12 topics
- **Value:** Early identification of expert needs

**2. Article Research Phase**
- **When:** After @researcher completes research brief, before @writer starts
- **Purpose:** Validate SME assessment with detailed topic understanding
- **Time:** 30 seconds per article
- **Value:** Confirm or adjust SME requirements

**3. Ad-Hoc Complexity Questions**
- **When:** User uncertain about SME needs for a topic
- **Purpose:** Provide objective complexity assessment
- **Time:** 30 seconds
- **Value:** Data-driven SME decisions

### Invocation Syntax

**Batch Assessment (Calendar Generation):**
```
Please use the sme-complexity-assessor skill to assess all 12 topic candidates from topic-candidates.md.
```

**Single Topic Assessment:**
```
Please use the sme-complexity-assessor skill to assess ART-202511-001 (WooCommerce HPOS Migration).
```

---

## Skill Workflow

### Phase 1: Load Context (15 seconds)

**Step 1.1: Extract Configuration**

Invoke `requirements-extractor` skill for audience context:

```
Please use the requirements-extractor skill to load configuration.
```

**Extract:**
- `audience.skill_level` → Target technical depth (beginner/intermediate/advanced)
- `audience.primary_roles` → Who's reading (developers, site owners, etc.)
- `content.word_count_range` → Scope constraints
- `quality.sme_involvement` → Current SME policy

**Step 1.2: Load Topic Details**

For each topic to assess, extract:
- Article ID and title
- Target keyword
- Format (Tutorial, Playbook, Deep Dive, etc.)
- Topic description/rationale
- Differentiation tactics (from gap analysis if available)

---

### Phase 2: Complexity Scoring (30-60 seconds per topic)

Assess complexity across **4 dimensions**, each scored 1-5:

#### Dimension 1: Technical Depth

**Measures:** Code complexity, advanced concepts, edge cases

**Scoring Criteria:**

**⭐ (1 - Basic):**
- No code required
- Conceptual overview only
- Well-documented, mainstream topics
- Example: "What is WooCommerce?"

**⭐⭐ (2 - Introductory):**
- Simple code snippets (copy-paste ready)
- Basic configuration walkthroughs
- Official documentation covers 90%+
- Example: "Installing a WordPress Plugin"

**⭐⭐⭐ (3 - Intermediate):**
- Custom code required (functions, classes)
- Integration patterns, API usage
- Some edge cases to consider
- Requires testing in development environment
- Example: "Custom WooCommerce Checkout Fields"

**⭐⭐⭐⭐ (4 - Advanced):**
- Complex code (OOP, design patterns, async)
- Production considerations (error handling, performance, security)
- Multiple edge cases and failure modes
- Requires production testing
- Example: "WooCommerce HPOS Migration for Custom Queries"

**⭐⭐⭐⭐⭐ (5 - Expert):**
- System-level complexity (architecture, scalability)
- Performance-critical code (optimization required)
- Security-sensitive implementations
- Extensive edge case handling
- Example: "Building a Custom WooCommerce Payment Gateway"

**Threshold:** ≥4 stars → Likely needs SME

---

#### Dimension 2: Domain Specificity

**Measures:** Specialized knowledge beyond general platform familiarity

**Scoring Criteria:**

**⭐ (1 - General Knowledge):**
- Common knowledge within industry
- No specialized expertise required
- Example: "WordPress Dashboard Overview"

**⭐⭐ (2 - Platform Familiarity):**
- Requires platform experience (1-2 years)
- Core concepts well-documented
- Example: "Using WordPress Custom Post Types"

**⭐⭐⭐ (3 - Platform Expertise):**
- Requires deep platform knowledge (3+ years)
- Advanced features, internals, architecture
- Example: "WordPress REST API Custom Endpoints"

**⭐⭐⭐⭐ (4 - Multi-Domain):**
- Requires expertise across multiple domains
- Integration knowledge, cross-system patterns
- Example: "WordPress + Salesforce CRM Integration"

**⭐⭐⭐⭐⭐ (5 - Specialized Expert):**
- Requires niche specialization (legal, medical, security)
- Professional certification may be relevant
- High consequences of misinformation
- Example: "HIPAA-Compliant WordPress Medical Forms"

**Threshold:** ≥4 stars → Likely needs SME

---

#### Dimension 3: Risk Level

**Measures:** Potential for misinformation, security issues, compliance problems

**Scoring Criteria:**

**⭐ (1 - Minimal Risk):**
- Informational content, no implementation
- Opinion/editorial with no factual claims
- Example: "Trends in WordPress Development"

**⭐⭐ (2 - Low Risk):**
- Basic implementations, low stakes
- Errors cause inconvenience, not damage
- Example: "Customizing WordPress Theme Colors"

**⭐⭐⭐ (3 - Medium Risk):**
- Production implementations
- Errors could cause downtime or data issues
- Best practices important but not critical
- Example: "WordPress Database Backup Strategies"

**⭐⭐⭐⭐ (4 - High Risk):**
- Security-sensitive implementations
- Performance claims or benchmarks
- Compliance considerations (GDPR, PCI, accessibility)
- Errors could cause security vulnerabilities or legal issues
- Example: "Securing WooCommerce Payment Processing"

**⭐⭐⭐⭐⭐ (5 - Critical Risk):**
- Legal/medical/financial advice
- Security architecture recommendations
- Regulatory compliance guidance
- Errors could cause severe harm (financial loss, legal liability, health risks)
- Example: "GDPR Data Retention Policies for WordPress"

**Threshold:** ≥4 stars → SME Required

---

#### Dimension 4: Verification Requirements

**Measures:** Hands-on testing, lab validation, production verification needs

**Scoring Criteria:**

**⭐ (1 - No Testing):**
- Purely conceptual, no implementation
- Example: "WordPress Ecosystem Overview"

**⭐⭐ (2 - Basic Testing):**
- Simple functionality tests
- Local development environment sufficient
- Example: "Creating WordPress Shortcodes"

**⭐⭐⭐ (3 - Development Testing):**
- Feature testing in dev environment
- Multiple scenarios to validate
- Example: "WordPress Custom Taxonomy Queries"

**⭐⭐⭐⭐ (4 - Staging Testing):**
- Production-like environment required
- Performance testing, edge case validation
- Integration testing across systems
- Example: "WooCommerce + CRM Data Synchronization"

**⭐⭐⭐⭐⭐ (5 - Production Testing):**
- Must verify in actual production environment
- Live system validation required
- Real-world data, actual user flows
- Example: "WooCommerce High-Traffic Optimization"

**Threshold:** ≥4 stars → Likely needs SME (for production testing)

---

### Phase 3: SME Profile Matching (15 seconds per topic)

**Step 3.1: Calculate Composite Score**

**Formula:**
```
Composite Score = (
  Technical Depth × 0.35 +
  Domain Specificity × 0.30 +
  Risk Level × 0.25 +
  Verification Requirements × 0.10
)
```

**Weighted rationale:**
- Technical Depth (35%): Primary driver of SME need
- Domain Specificity (30%): Specialized knowledge requirement
- Risk Level (25%): Critical for avoiding errors/harm
- Verification (10%): Important but can sometimes be outsourced

**Composite Score Ranges:**
- **1.0-2.4:** Low Complexity
- **2.5-3.4:** Medium Complexity
- **3.5-4.4:** High Complexity
- **4.5-5.0:** Expert Complexity

**Step 3.2: Determine SME Requirement Level**

Based on composite score and dimension-specific thresholds:

#### ✅ **No SME Required (Score <2.5, No dimension ≥4)**

**Profile:** General content writer with platform familiarity
**Review Scope:** Standard editorial review (@editor agent)
**Examples:**
- "WordPress Plugin Installation Guide"
- "WooCommerce Product Setup Tutorial"

---

#### ⚠️ **SME Recommended (Score 2.5-3.9, Any dimension =4)**

**Profile:** Experienced practitioner (3+ years in platform)
**Review Scope:** Technical accuracy review of key sections
**Estimated Time:** 30-60 minutes
**Examples:**
- "Custom WooCommerce Checkout Fields"
- "WordPress REST API Integration"

**Typical SME Profiles:**
- Senior WordPress Developer (5+ years)
- WooCommerce Specialist (3+ years)
- Web Performance Engineer (if performance-focused)

---

#### 🚨 **SME Required (Score ≥4.0 OR Risk Level ≥4)**

**Profile:** Domain expert with specialized credentials/experience
**Review Scope:** Full article review with hands-on validation
**Estimated Time:** 1-3 hours (depending on topic)
**Examples:**
- "Building Custom WooCommerce Payment Gateways"
- "HIPAA-Compliant WordPress Medical Forms"
- "WordPress Security Hardening for Enterprise"

**Typical SME Profiles:**
- Principal Engineer (payment processing, security architecture)
- Compliance Specialist (GDPR, HIPAA, PCI)
- Performance Architect (high-traffic optimization)
- Security Researcher (vulnerability assessment)

---

**Step 3.3: Specify Required Expertise**

For SME Required and SME Recommended topics, specify:

**Core Expertise Needed:**
- Platform/technology: "WordPress core development", "WooCommerce architecture"
- Domain knowledge: "Payment gateway integration", "CRM data modeling"
- Certifications (if applicable): "CISSP", "AWS Solutions Architect", "GDPR certification"

**Review Scope:**
- Which sections require validation?
- What specifically needs expert verification?
- Are code examples sufficient or is hands-on testing needed?

**Estimated Review Time:**
- 30 min: Quick technical accuracy check
- 1 hour: Detailed code review + testing
- 2-3 hours: Full production validation + compliance check

**Example SME Profile Output:**
```markdown
## SME Profile: ART-202511-001 (WooCommerce HPOS Migration)

**SME Level:** ⚠️ Recommended

**Required Expertise:**
- Senior WooCommerce Developer (5+ years)
- Production HPOS migration experience
- Custom query optimization knowledge

**Review Scope:**
- Section 3: "Migrating Custom Queries" (code examples validation)
- Section 5: "Performance Testing" (benchmarking methodology)
- Section 6: "Troubleshooting Edge Cases" (real-world validation)

**Not Required:**
- Introduction, prerequisites (standard content)
- Basic HPOS overview (well-documented officially)

**Estimated Time:** 1-1.5 hours
- 30 min: Code review (custom query examples)
- 30 min: Testing in staging environment
- 15-30 min: Edge case validation

**Rationale:**
- Technical Depth: 4/5 (complex custom queries)
- Risk Level: 3/5 (production impacts but recoverable)
- Composite Score: 3.7 (High Complexity → Recommended)
```

---

### Phase 4: Risk Flagging (10 seconds per topic)

**Step 4.1: Identify Specific Risks**

Flag topics with special considerations:

#### 🔐 **Security Risks**

**Triggers:**
- Authentication/authorization topics
- Payment processing
- User data handling
- File uploads
- SQL queries

**Required Review:**
- Security audit of code examples
- Vulnerability assessment
- OWASP Top 10 compliance check

**SME Profile:** Security Engineer or Certified Security Professional

**Example:** "WordPress User Authentication with OAuth"

---

#### ⚖️ **Legal/Compliance Risks**

**Triggers:**
- Privacy/GDPR topics
- Accessibility compliance
- PCI DSS (payment card industry)
- HIPAA (healthcare)
- Financial advice

**Required Review:**
- Legal compliance validation
- Regulatory requirement verification
- Liability assessment

**SME Profile:** Compliance Specialist or Legal Counsel (depending on domain)

**Example:** "GDPR-Compliant Newsletter Double Opt-In"

---

#### 📊 **Performance/Benchmark Claims**

**Triggers:**
- Performance optimization claims ("50% faster")
- Benchmarks or comparisons
- "Best" or "fastest" claims

**Required Review:**
- Benchmark methodology validation
- Reproducible test setup
- Competitive comparison accuracy

**SME Profile:** Performance Engineer + Legal (for claims substantiation)

**Example:** "WooCommerce Performance: Plugin Comparison"

---

#### 🏥 **Medical/Health Advice**

**Triggers:**
- Clinical guidance
- Health recommendations
- Medical device integration
- Therapy techniques

**Required Review:**
- Clinical accuracy validation
- Evidence-based practice verification
- Liability disclaimer assessment

**SME Profile:** Licensed practitioner (MD, PhD, licensed therapist) depending on topic

**Example:** "Telehealth WordPress Setup for Therapists"

---

**Step 4.2: Determine Review Workflow**

Based on risk flags, specify required review sequence:

**Standard Workflow (No special risks):**
1. @writer drafts article
2. @editor reviews
3. SME validates (if Required/Recommended)
4. Publish

**High-Risk Workflow (Security, compliance, medical):**
1. @writer drafts article
2. SME reviews technical accuracy
3. @editor reviews editorial quality
4. Legal/Compliance review (if applicable)
5. Final SME sign-off
6. Publish with appropriate disclaimers

**Benchmark/Claims Workflow:**
1. @writer drafts with methodology section
2. SME validates methodology + reproduces benchmarks
3. Legal reviews claims substantiation
4. @editor reviews presentation
5. Publish with methodology disclosure

---

### Phase 5: Output Generation (10 seconds per topic)

**Step 5.1: Generate Assessment Summary**

Create structured output for each topic:

```markdown
## SME Assessment: ART-202511-001
### WooCommerce HPOS Migration for Custom Integrations

**Complexity Scores:**
| Dimension | Score | Rationale |
|-----------|-------|-----------|
| **Technical Depth** | ⭐⭐⭐⭐ (4/5) | Complex custom queries, production patterns |
| **Domain Specificity** | ⭐⭐⭐ (3/5) | Requires deep WooCommerce knowledge |
| **Risk Level** | ⭐⭐⭐ (3/5) | Production impacts, data migration risks |
| **Verification Needs** | ⭐⭐⭐⭐ (4/5) | Requires staging testing with production-like data |

**Composite Score:** 3.7 / 5.0 → **High Complexity**

**SME Requirement:** ⚠️ **RECOMMENDED** (not critical but highly beneficial)

---

**SME Profile:**

**Required Expertise:**
- Senior WooCommerce Developer (5+ years experience)
- Production HPOS migration experience
- Custom query optimization knowledge
- Familiarity with WooCommerce database schema

**Review Scope:**
✅ **Requires Validation:**
- Section 3: "Migrating Custom Queries" (code examples)
- Section 5: "Performance Testing" (methodology)
- Section 6: "Troubleshooting Edge Cases" (real-world patterns)

⏭️ **Standard Review:**
- Introduction, prerequisites, basic HPOS overview

**Estimated Review Time:** 1-1.5 hours
- Code review: 30 min
- Staging testing: 30-45 min
- Edge case validation: 15-30 min

---

**Risk Flags:**
- 🟡 **MEDIUM RISK:** Production data migration (reversible but disruptive)
- ⚠️ **Testing Required:** Must validate in production-like staging environment

**Recommended Workflow:**
1. @writer drafts article
2. SME reviews Sections 3, 5, 6 with hands-on testing
3. @editor reviews full article for editorial quality
4. Publish

---

**Rationale for "Recommended" (not "Required"):**
- Risk level is medium (3/5), not high (≥4/5)
- Errors are recoverable (not critical systems)
- Official documentation available as reference
- However, SME review strongly recommended because:
  - Custom query patterns vary widely (benefit from experience)
  - Production testing improves accuracy significantly
  - Edge cases are nuanced (hard to document from docs alone)

**Confidence:** High (based on clear technical complexity and established review patterns)
```

**Step 5.2: Generate Batch Summary**

For calendar generation, create summary table:

```markdown
## SME Requirements Summary: November 2025 Calendar

**Topics Assessed:** 12
**Breakdown:**
- ✅ No SME: 7 topics (58%)
- ⚠️ SME Recommended: 4 topics (33%)
- 🚨 SME Required: 1 topic (8%)

---

### SME Required (1 topic)

| ID | Title | Composite Score | Primary Risk | SME Profile | Est. Time |
|----|-------|-----------------|--------------|-------------|-----------|
| ART-202511-008 | GDPR Double Opt-In | 4.2 | Legal/Compliance | Compliance Specialist | 2-3 hours |

**Critical Path:** Must secure compliance SME before publishing. Consider moving to later calendar if SME unavailable.

---

### SME Recommended (4 topics)

| ID | Title | Composite Score | Complexity Driver | SME Profile | Est. Time |
|----|-------|-----------------|-------------------|-------------|-----------|
| ART-202511-001 | HPOS Migration | 3.7 | Technical Depth (4/5) | Senior WooCommerce Dev | 1-1.5 hours |
| ART-202511-002 | Webhook Retry Logic | 3.5 | Verification (4/5) | Senior WordPress Dev | 1 hour |
| ART-202511-004 | Gravity + Salesforce | 3.8 | Domain Specificity (4/5) | Integration Architect | 1-1.5 hours |
| ART-202511-006 | Performance Optimization | 3.6 | Benchmarking | Performance Engineer | 1 hour |

**Resource Planning:** 5-6 hours total SME time across 4 articles. Consider staggering publications to distribute SME load.

---

### No SME Required (7 topics)

Standard editorial review workflow sufficient. Proceed with @writer → @editor → publish.

---

**Total SME Time Estimate:** 7-9 hours for November calendar
- 1 Required: 2-3 hours
- 4 Recommended: 5-6 hours

**SME Profiles Needed:**
- 1× Compliance Specialist (GDPR expertise)
- 1× Senior WooCommerce Developer (3 articles, 2.5-3.5 hours)
- 1× Integration Architect (Salesforce + WordPress, 1-1.5 hours)
- 1× Performance Engineer (benchmarking, 1 hour)

**Recommendation:** Engage SMEs during calendar planning phase to confirm availability.
```

---

## Integration Examples

### Example 1: Calendar Command Integration

```markdown
## Step 5: SME Requirements Assessment

After topic candidates generated and gap analysis complete, invoke SME assessor:

```
Please use the sme-complexity-assessor skill to assess all topics from topic-candidates.md.
```

**Output:** SME requirements summary

**Use Summary To:**
1. Flag topics with SME requirements in calendar table
2. Estimate resource needs (SME hours per calendar)
3. Identify critical-path bottlenecks (SME Required topics)
4. Inform topic prioritization (favor lower-SME topics if resources constrained)

**Add to Calendar:**
- Column: "SME Requirements" → None | Recommended | Required
- Column: "SME Profile" → Specific expertise needed
- Notes section: Total SME time estimate and profiles needed

Proceed to calendar assembly with SME context.
```

### Example 2: Research Brief Validation

```markdown
## After Research Brief Complete

@researcher has completed research brief for ART-202511-001. Before @writer starts, validate SME assessment:

```
Please use the sme-complexity-assessor skill to reassess ART-202511-001 now that we have detailed research.
```

**Compare:**
- Initial assessment (calendar phase): 3.7 complexity
- Updated assessment (research phase): 4.1 complexity (increased due to edge cases discovered)

**Action:** Upgrade from "SME Recommended" to "SME Required" based on research findings.

**Notify:** Flag change to user and secure SME before @writer begins.
```

---

## Success Metrics

### Accuracy Metrics
- 🎯 Flagging accuracy: >90% (avoid under/over-flagging)
- 🎯 Time estimates: ±30 minutes (within 30 min of actual review time)
- 🎯 Risk detection: 100% (catch all high-risk topics)

### Quality Metrics
- 📊 Consistency: Same topic → same assessment (repeatable)
- 📊 Specificity: Clear SME profiles (not vague "expert needed")
- 📊 Scoped reviews: Section-specific (not "review entire article")

### Impact Metrics
- ⏱️ Resource planning: 50% better SME scheduling (early identification)
- 🎯 Quality improvement: 30% fewer post-publication corrections
- 🛡️ Risk mitigation: 90% reduction in compliance/legal issues

---

## Limitations & Considerations

### Limitations

1. **Subjective Elements:** Complexity scoring has inherent subjectivity (mitigated by clear criteria)
2. **Context-Dependent:** Same topic may vary in complexity based on audience (adjusted via config)
3. **Not a Substitute:** Provides data for decisions but doesn't replace editorial judgment
4. **Expertise Availability:** Can identify need but can't guarantee SME availability

### Considerations

**When Scores are Borderline (e.g., 3.9 vs. 4.0):**
- Default to higher SME level (conservative approach)
- Consider aggregate factors (multiple medium-risk dimensions = higher overall risk)
- Document rationale for decision

**When SMEs Unavailable:**
- Option 1: Delay publication until SME available
- Option 2: Adjust topic to reduce complexity (narrow scope, remove risky sections)
- Option 3: Proceed with strong disclaimers + flag for post-publication SME review
- ❌ Never: Publish high-risk content without SME validation

**For New Domains:**
- First few assessments may need calibration
- Validate assessments against actual review outcomes
- Adjust scoring criteria if patterns emerge

---

## Scoring Calibration Examples

### Example 1: Tutorial (Medium Complexity)

**Topic:** "Custom WooCommerce Checkout Fields"

**Scoring:**
- Technical Depth: ⭐⭐⭐ (3/5) - Custom code but well-documented patterns
- Domain Specificity: ⭐⭐⭐ (3/5) - Requires WooCommerce familiarity
- Risk Level: ⭐⭐ (2/5) - Low risk, cosmetic changes
- Verification: ⭐⭐⭐ (3/5) - Dev testing sufficient

**Composite:** 2.8 → Medium Complexity
**SME:** ✅ No SME Required (standard editorial review)

---

### Example 2: Integration Playbook (High Complexity)

**Topic:** "WordPress + Salesforce CRM Integration"

**Scoring:**
- Technical Depth: ⭐⭐⭐⭐ (4/5) - Complex API integration, OAuth, error handling
- Domain Specificity: ⭐⭐⭐⭐ (4/5) - Requires WordPress + Salesforce expertise
- Risk Level: ⭐⭐⭐ (3/5) - Data sync risks, but recoverable
- Verification: ⭐⭐⭐⭐ (4/5) - Requires staging testing with real CRM

**Composite:** 3.8 → High Complexity
**SME:** ⚠️ SME Recommended (Senior Integration Architect, 1-1.5 hours)

---

### Example 3: Compliance Guide (Expert Complexity)

**Topic:** "GDPR-Compliant Newsletter Double Opt-In for WordPress"

**Scoring:**
- Technical Depth: ⭐⭐⭐ (3/5) - Moderate code complexity
- Domain Specificity: ⭐⭐⭐⭐⭐ (5/5) - Requires GDPR legal expertise
- Risk Level: ⭐⭐⭐⭐⭐ (5/5) - Legal liability, regulatory fines risk
- Verification: ⭐⭐⭐ (3/5) - Functional testing + legal review

**Composite:** 4.0 → Expert Complexity
**SME:** 🚨 SME Required (GDPR Compliance Specialist, 2-3 hours)
**Additional:** Legal review required before publication

---

## Error Handling

### Scenario 1: Insufficient Topic Information

**If topic description too vague to assess:**
```
⚠️ Insufficient information to assess complexity for ART-202511-005.

**Available:** Title only ("WordPress Security")
**Needed:** Topic scope, format, target audience, differentiation tactics

**Action:** Request more details from topic candidate or research brief before assessment.

**Conservative Default:** Assume SME Recommended until sufficient details available.
```

### Scenario 2: Conflicting Signals

**If dimensions suggest different SME levels:**
```
⚠️ Mixed signals for ART-202511-007.

**Scores:**
- Technical Depth: 2/5 (low)
- Risk Level: 5/5 (critical - security vulnerability disclosure)

**Analysis:** Low technical complexity BUT high risk due to security implications.

**Decision:** **SME Required** (risk level overrides technical simplicity)
**Rationale:** Even simple security topics require expert validation to avoid dangerous misinformation.
```

---

## This Skill Enables Systematic Quality Assurance

**Before:** Ad-hoc SME flagging, inconsistent quality standards
**After:** Objective complexity assessment, clear expert requirements, better resource planning

Use this skill to ensure every article gets the right level of expert validation based on objective criteria, not gut feel.
