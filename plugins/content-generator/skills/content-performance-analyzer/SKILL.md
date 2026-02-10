---
name: content-performance-analyzer
description: Analyze historical content calendar and article performance to identify patterns and provide data-driven recommendations for future content strategy.
---

# Content Performance Analyzer Skill

## Purpose

Analyzes historical content calendar and published article performance to identify patterns, trends, and optimization opportunities. Provides data-driven recommendations for future content strategy based on what actually works.

## Problem Solved

**Before this skill:**
- No feedback loop from published content to future planning
- Calendar generation doesn't learn from past successes/failures
- Content mix decisions based on intuition, not data
- Missing opportunity to refine strategy based on performance
- Can't identify which competitive gap tactics actually drive results

**With this skill:**
- **Performance Patterns:** Identify high-ROI topic/format combinations
- **Strategic Insights:** Data-driven content mix recommendations
- **Competitive Intelligence:** Track position changes over time
- **Gap Strategy Validation:** Correlate gap tactics with outcomes
- **Continuous Improvement:** Learn and adapt with every publication

---

## When to Invoke

### Mandatory Invocation Points

**1. Content Calendar Generation (Optional but Recommended)**
- **When:** At start of `/content-calendar` command (before signal research)
- **Purpose:** Inform topic selection and content mix with performance data
- **Time:** 2-3 minutes
- **Value:** Data-driven strategy adjustments

**2. Quarterly Content Review**
- **When:** End of each quarter (Q1, Q2, Q3, Q4)
- **Purpose:** Comprehensive performance analysis and strategy refinement
- **Time:** 5-10 minutes
- **Value:** Strategic course corrections

**3. Ad-Hoc Performance Questions**
- **When:** User asks about content performance, ROI, or optimization
- **Purpose:** Answer specific performance questions
- **Time:** 1-2 minutes
- **Value:** Targeted insights

### Invocation Syntax

```
Please use the content-performance-analyzer skill to analyze the last 6 months of content and provide recommendations for the November 2025 calendar.
```

**Parameters:**
- **Analysis Period:** Last 3 months | 6 months | 12 months | Custom date range
- **Focus Area:** All topics | Specific pillar | Format type | Gap strategy effectiveness
- **Output Format:** Full report | Quick insights | Specific metric

---

## Skill Workflow

### Phase 1: Data Collection (1-2 min)

**Step 1.1: Discover Historical Content**

Scan project for published articles and calendars:

```bash
# Find all calendars
find project/Calendar/ -name "content-calendar.md" -type f | sort

# Find all published articles
find project/Articles/ -name "article.md" -type f | sort

# Find article metadata
find project/Articles/ -name "meta.yml" -type f | sort
```

**Step 1.2: Load Configuration Context**

Invoke `requirements-extractor` skill for current strategy:

```
Please use the requirements-extractor skill to load current configuration.
```

**Extract:**
- Current content mix targets
- Current focus areas
- Current opportunity score thresholds
- Current gap strategy weights

**Step 1.2B: Load GSC Performance Data (Conditional)**

**Condition:** `config.analytics.gsc` exists and export path is valid. If not configured, skip silently and proceed to Step 1.3.

Invoke `gsc-analyst` agent in performance dashboard mode:

```
Invoke gsc-analyst agent in performance dashboard mode.
```

**Expected Output:**
- `project/GSC/reports/gsc-performance-dashboard.md`
- URL-to-article-ID mappings
- Per-article GSC metrics (clicks, impressions, position, CTR)
- Performance tier assignments (Star/Steady/Growth/Underperformer/Low Visibility)
- Updated `meta.yml` files with `gsc_data` section for each mapped article
- Opportunity scores based on real CTR gaps

**If GSC data unavailable:** Skip silently. Step 1.3 falls back to manual `meta.yml` performance entries. All downstream phases work without GSC data.

**Step 1.3: Extract Article Metadata**

For each article, extract from `meta.yml` and article frontmatter:

**Essential Metadata:**
- Article ID (e.g., ART-202510-001)
- Title and target keyword
- Format (Tutorial, Playbook, Deep Dive, etc.)
- Publication date
- Topic pillar
- Word count
- Opportunity score (from gap analysis)
- Primary differentiation tactics used

**Performance Metadata (from GSC or manual entry):**

If GSC dashboard data was loaded in Step 1.2B, use `gsc_data` from `meta.yml` as the primary performance source:
- `gsc_data.avg_position` → Keyword ranking
- `gsc_data.total_clicks` → Organic traffic proxy (clicks from search)
- `gsc_data.avg_ctr` → CTR performance
- `gsc_data.total_impressions` → Search visibility
- `gsc_data.opportunity_score` → Real CTR-gap-based opportunity
- `gsc_data.authority_score` → Multi-query ranking authority
- `gsc_data.performance_tier` → GSC-assigned tier

If GSC data is absent, fall back to manual `performance` section in `meta.yml`:
- Keyword rankings (position 1-100+)
- Organic traffic (sessions/month)
- Engagement metrics (time on page, scroll depth, bounce rate)
- Conversion metrics (newsletter signups, CTA clicks)
- Backlinks acquired
- Social shares

**Priority:** GSC data takes precedence over manual entries for overlapping fields (ranking, traffic, CTR). Manual-only fields (engagement, conversions, backlinks, social shares) supplement GSC data when both are available.

**Example meta.yml structure:**
```yaml
article_id: ART-202510-001
title: "Complete WooCommerce HPOS Migration Guide"
keyword: "WooCommerce HPOS migration"
format: Tutorial
published: 2025-10-15
topic_pillar: WooCommerce Integration
word_count: 1850
opportunity_score: 4.5
differentiation_tactics:
  - Priority 1: "HPOS compatibility coverage (0/8 competitors)"
  - Priority 1: "Working code examples (0/8 competitors)"
  - Priority 2: "Mobile recovery tactics (2/8 competitors)"

# Performance data (updated monthly)
performance:
  ranking: 3  # Position in SERPs
  traffic_monthly: 2400  # Sessions/month
  time_on_page: 285  # Seconds
  conversion_rate: 0.08  # 8% conversion rate
  backlinks: 12
  updated: 2025-11-05
```

**Step 1.4: Build Performance Dataset**

Create structured dataset:

```json
{
  "analysis_period": {
    "start": "2025-05-01",
    "end": "2025-10-31",
    "duration_months": 6
  },
  "articles": [
    {
      "id": "ART-202510-001",
      "title": "...",
      "keyword": "...",
      "format": "Tutorial",
      "pillar": "WooCommerce Integration",
      "published": "2025-10-15",
      "word_count": 1850,
      "opportunity_score": 4.5,
      "gap_tier": "Tier 1",
      "tactics_used": ["depth_gap", "coverage_gap"],
      "performance": {
        "ranking": 3,
        "traffic": 2400,
        "engagement": 285,
        "conversions": 192,
        "backlinks": 12
      },
      "age_days": 21
    }
    // ... all articles
  ],
  "calendars": [
    {
      "month": "2025-10",
      "articles_planned": 10,
      "articles_published": 10,
      "avg_opportunity_score": 4.2,
      "tier1_percentage": 0.70
    }
    // ... all calendars
  ]
}
```

---

### Phase 2: Pattern Analysis (2-4 min)

**Step 2.1: Topic/Format Performance Analysis**

Analyze which topics and formats drive best results.

**If GSC data available:** Group GSC metrics (clicks, impressions, position, CTR) by article format and topic pillar for evidence-based analysis using real search performance rather than manually entered estimates.

#### By Format

Calculate average performance metrics by format:

```
Tutorial Format (n=15):
  - Avg Traffic: 2,100 sessions/month
  - Avg Ranking: Position 4.2
  - Avg Engagement: 245 seconds
  - Avg Conversions: 8.2%
  - Avg Backlinks: 8

Integration Playbook (n=8):
  - Avg Traffic: 3,400 sessions/month ⭐ (62% higher than Tutorial)
  - Avg Ranking: Position 2.8 ⭐
  - Avg Engagement: 320 seconds ⭐
  - Avg Conversions: 11.5% ⭐
  - Avg Backlinks: 14 ⭐

Deep Dive (n=4):
  - Avg Traffic: 1,800 sessions/month
  - Avg Ranking: Position 5.5
  - Avg Engagement: 380 seconds ⭐
  - Avg Conversions: 6.8%
  - Avg Backlinks: 18 ⭐
```

**Insight Example:** "Integration Playbooks drive 62% higher traffic and 40% better conversion rates than Tutorials. Consider increasing Playbook allocation from 30% to 40%."

#### By Topic Pillar

```
WooCommerce Integration (n=12):
  - Avg Traffic: 2,800 sessions/month ⭐
  - Avg Backlinks: 11

Content Migration (n=7):
  - Avg Traffic: 1,600 sessions/month
  - Avg Backlinks: 6

CRM Workflows (n=5):
  - Avg Traffic: 2,200 sessions/month
  - Avg Backlinks: 9

Form Processing (n=3):
  - Avg Traffic: 1,400 sessions/month
  - Avg Backlinks: 4
```

**Insight Example:** "WooCommerce Integration pillar generates 75% more traffic than Content Migration. Prioritize WooCommerce topics in upcoming calendars."

**Step 2.2: Opportunity Score Correlation**

Analyze relationship between gap analysis scores and outcomes.

**If GSC data available:** Use real GSC positions (`gsc_data.avg_position`) to validate whether predicted opportunity scores from gap analysis correlate with actual ranking outcomes. This replaces manual ranking entries with verified search console positions.

```
Tier 1 Articles (Opportunity 4.0-5.0, n=18):
  - Avg Traffic: 2,900 sessions/month
  - Avg Ranking: Position 2.8 (GSC-verified if available)
  - Avg Time to Rank: 45 days
  - Success Rate: 83% (15/18 reach top 5)

Tier 2 Articles (Opportunity 3.0-3.9, n=9):
  - Avg Traffic: 1,800 sessions/month (-38%)
  - Avg Ranking: Position 5.2 (GSC-verified if available)
  - Avg Time to Rank: 72 days
  - Success Rate: 56% (5/9 reach top 5)

Tier 3 Articles (Opportunity 2.0-2.9, n=2):
  - Avg Traffic: 900 sessions/month (-69%)
  - Avg Ranking: Position 12.5 (GSC-verified if available)
  - Avg Time to Rank: 90+ days
  - Success Rate: 0% (0/2 reach top 5)
```

**With GSC validation:** Compare predicted opportunity scores against actual GSC performance tiers. If Tier 1 articles consistently land in GSC "Star Performer" or "Steady Performer" tiers, the gap analysis scoring is well-calibrated. Mismatches indicate scoring model needs adjustment.

**Insight Example:** "Tier 1 opportunity scores strongly predict success: 83% success rate vs. 56% for Tier 2. Maintain 60%+ Tier 1 requirement in calendars."

**Step 2.3: Gap Strategy Effectiveness**

Analyze which differentiation tactics drive best outcomes:

```
Depth Gap Tactics (code examples, detailed explanations):
  - Used in: 12 articles
  - Avg Traffic: 2,700 sessions/month
  - Avg Backlinks: 13
  - Success Rate: 75%

Coverage Gap Tactics (comprehensive topic coverage):
  - Used in: 15 articles
  - Avg Traffic: 2,400 sessions/month
  - Avg Backlinks: 10
  - Success Rate: 67%

Format Gap Tactics (video, interactive, downloads):
  - Used in: 6 articles
  - Avg Traffic: 3,200 sessions/month ⭐
  - Avg Backlinks: 16 ⭐
  - Success Rate: 83% ⭐

Recency Gap Tactics (latest version, recent updates):
  - Used in: 8 articles
  - Avg Traffic: 3,100 sessions/month ⭐
  - Avg Ranking: Position 2.2 ⭐ (first-mover advantage)
  - Success Rate: 88% ⭐
  - Time Decay: Traffic drops 40% after 90 days ⚠️
```

**Insight Example:** "Recency gaps drive 88% success rate but have 40% traffic decay after 90 days. Prioritize timely topics for immediate impact; depth/format gaps for evergreen value."

**Step 2.4: Seasonal Pattern Detection**

Identify performance variations by time period:

```
Q2 2025 (Apr-Jun):
  - Avg Traffic: 1,900 sessions/month
  - Top Format: Tutorial (45% of traffic)
  - Top Pillar: Content Migration (seasonal: end-of-fiscal migrations)

Q3 2025 (Jul-Sep):
  - Avg Traffic: 1,600 sessions/month (-16% vs Q2)
  - Top Format: Playbook (48% of traffic)
  - Top Pillar: WooCommerce Integration (seasonal: Q4 ecommerce prep)

Q4 2025 (Oct-Dec):
  - Avg Traffic: 2,800 sessions/month (+75% vs Q3) ⭐
  - Top Format: Playbook (52% of traffic)
  - Top Pillar: WooCommerce Integration (holiday shopping optimization)
```

**Insight Example:** "Q4 shows 75% traffic spike driven by WooCommerce/ecommerce topics. Plan heavier WooCommerce content for Q4 calendars."

**Step 2.5: Content Mix Optimization**

Compare current content mix to performance-based ideal mix.

**If GSC data available:** Use GSC clicks and impressions aggregated by format and pillar to calculate evidence-based content mix recommendations. GSC data provides real search demand validation rather than relying on manually tracked metrics alone.

```
Current Content Mix (Target):
  - Tutorials: 40%
  - Integration Playbooks: 30%
  - Deep Dives: 15%
  - Product News: 10%
  - Industry Analysis: 5%

Performance-Based Ideal Mix:
  - Integration Playbooks: 40% (+10%) ⭐ [Highest traffic & conversions]
  - Tutorials: 30% (-10%) [Good performance but lower ROI]
  - Deep Dives: 15% (no change) [Excellent engagement & backlinks]
  - Product News: 10% (no change) [Strategic value, not traffic]
  - Industry Analysis: 5% (no change) [Brand authority]
```

**Recommendation:** "Shift 10% from Tutorials to Integration Playbooks to maximize traffic and conversion ROI."

---

### Phase 3: Competitive Position Tracking (1-2 min)

**Step 3.1: Ranking Progression Analysis**

Track how articles move through SERPs over time:

```
ART-202510-001: WooCommerce HPOS Migration
  - Week 1: Position 18
  - Week 2: Position 12
  - Week 3: Position 7
  - Week 4: Position 3 (current)
  - Trajectory: ⬆️ Gaining (15 positions in 4 weeks)

ART-202509-003: WordPress Webhook Handlers
  - Month 1: Position 4
  - Month 2: Position 2
  - Month 3: Position 5 (current)
  - Trajectory: ⬇️ Declining (lost position to competitor)
  - Alert: ⚠️ Competitor published fresher guide
```

**Step 3.2: Competitive Displacement Detection**

Identify articles losing position to competitors.

**If GSC data available:** Use real GSC position data for displacement detection instead of manually tracked rankings. When multiple GSC exports exist (different dates), compare positions across exports to detect actual ranking changes over time. This provides verified displacement alerts rather than estimates.

**With single GSC export:** Compare GSC positions against manually recorded historical rankings in `meta.yml` to detect recent changes.

**With multiple GSC exports:** Calculate position deltas directly from GSC data:
- Position improved by 3+: Flag as gaining momentum
- Position declined by 3+: Flag as competitive displacement
- Position stable (within 2): No action needed

```
⚠️ Competitive Displacement Alerts (Last 30 Days):

1. ART-202509-003: WordPress Webhook Handlers
   - Lost Position: #2 → #5 (GSC-verified)
   - Displaced By: WPTavern.com (published Oct 20, fresher guide)
   - GSC Impressions: 4,200 (demand still strong)
   - Action: Consider refresh/update

2. ART-202508-001: WooCommerce Security Audit
   - Lost Position: #3 → #6 (GSC-verified)
   - Displaced By: WooExperts.com (more comprehensive checklist)
   - GSC Opportunity Score: 280 potential clicks recoverable
   - Action: Consider expansion/depth increase
```

**Step 3.3: Refresh Opportunity Identification**

Flag articles that would benefit from updates.

**If GSC data available:** Calculate refresh priorities with quantified ROI based on real search data:

```
potential_gain = impressions x (expected_ctr_at_target_position - current_ctr)
```

GSC data identifies three refresh trigger types:
1. **CTR gap refresh:** Good position but CTR significantly below expected (title/meta optimization)
2. **Position recovery refresh:** Position declined from previous levels (content strengthening)
3. **Expansion refresh:** Receiving impressions for queries not covered in content (add new sections)

```
High-Value Refresh Opportunities:

1. ART-202505-002: Gravity Forms CRM Integration (Published: May 2025)
   - Current Position: #4 (GSC-verified)
   - GSC Clicks: 1,800/month | Impressions: 22,500/month
   - Current CTR: 8.0% | Expected at Position 4: 8.0%
   - Refresh Trigger: Gravity Forms 3.0 released (Oct 2025)
   - Potential Gain: 675 additional clicks/month (if improved to position #2)
   - Priority: HIGH (version update + position improvement opportunity)

2. ART-202506-004: WooCommerce Data Sync (Published: Jun 2025)
   - Current Position: #7 (GSC-verified)
   - GSC Clicks: 540/month | Impressions: 18,000/month
   - Current CTR: 3.0% | Expected at Position 7: 3.0%
   - Refresh Trigger: Stale content (6 months old)
   - Potential Gain: 360 additional clicks/month (if improved to position #4)
   - Priority: MEDIUM (aging content, quantified ROI)
```

**Without GSC data:** Fall back to estimated impact percentages based on manual ranking data.

---

### Phase 4: Strategic Recommendations (1-2 min)

**Step 4.1: Content Mix Adjustments**

Based on performance data, recommend content mix changes:

```markdown
## Recommended Content Mix Adjustments

### Current vs. Ideal Mix

| Format | Current | Ideal | Change | Rationale |
|--------|---------|-------|--------|-----------|
| Integration Playbooks | 30% | 40% | +10% | 62% higher traffic, 40% better conversions |
| Tutorials | 40% | 30% | -10% | Solid performance but lower ROI than Playbooks |
| Deep Dives | 15% | 15% | 0% | Excellent engagement & backlinks, keep current |
| Product News | 10% | 10% | 0% | Strategic value for brand authority |
| Industry Analysis | 5% | 5% | 0% | Niche but important for thought leadership |

**Action:** Update `requirements.md` content mix to reflect ideal distribution.
```

**Step 4.2: Topic Pillar Prioritization**

Recommend focus area adjustments:

```markdown
## Topic Pillar Prioritization

### Performance Ranking (Last 6 Months)

1. **WooCommerce Integration** ⭐⭐⭐⭐⭐
   - Avg Traffic: 2,800 sessions/month (+75% above avg)
   - Avg Backlinks: 11
   - Success Rate: 85%
   - **Recommendation:** Maintain as primary focus (50-60% of calendar)

2. **CRM Workflows** ⭐⭐⭐⭐
   - Avg Traffic: 2,200 sessions/month (+38% above avg)
   - Avg Backlinks: 9
   - Success Rate: 71%
   - **Recommendation:** Increase from 15% to 20% of calendar

3. **Content Migration** ⭐⭐⭐
   - Avg Traffic: 1,600 sessions/month (baseline)
   - Avg Backlinks: 6
   - Success Rate: 60%
   - **Recommendation:** Reduce from 20% to 15%, focus on Q2 seasonal spike

4. **Form Processing** ⭐⭐
   - Avg Traffic: 1,400 sessions/month (-12% below avg)
   - Avg Backlinks: 4
   - Success Rate: 50%
   - **Recommendation:** Reduce from 15% to 10%, niche audience

**Action:** Adjust focus area allocation in upcoming calendars.
```

**Step 4.3: Gap Strategy Recommendations**

Recommend differentiation tactic priorities:

```markdown
## Gap Strategy Effectiveness Rankings

### High-Impact Tactics (Prioritize in Gap Analysis)

1. **Recency Gaps** ⭐⭐⭐⭐⭐
   - Success Rate: 88%
   - Avg Traffic: 3,100 sessions/month (+94% above avg)
   - Avg Ranking: Position 2.2
   - **Caveat:** 40% traffic decay after 90 days
   - **Recommendation:** Prioritize for immediate impact, pair with depth gaps for longevity

2. **Format Gaps** ⭐⭐⭐⭐⭐
   - Success Rate: 83%
   - Avg Traffic: 3,200 sessions/month (+100% above avg)
   - Avg Backlinks: 16 (+60% above avg)
   - **Recommendation:** Invest in videos, interactive demos, downloadable resources

3. **Depth Gaps** ⭐⭐⭐⭐
   - Success Rate: 75%
   - Avg Traffic: 2,700 sessions/month (+69% above avg)
   - Avg Backlinks: 13
   - **Recommendation:** Maintain emphasis on code examples, detailed explanations

4. **Coverage Gaps** ⭐⭐⭐
   - Success Rate: 67%
   - Avg Traffic: 2,400 sessions/month (+50% above avg)
   - Avg Backlinks: 10
   - **Recommendation:** Use selectively for truly underexplored topics

**Action:** Update `requirements.md` competitive.opportunity_weights to reflect priority:
- Recency: 0.25 (increase from 0.15)
- Format: 0.25 (increase from 0.15)
- Depth: 0.35 (decrease from 0.40)
- Coverage: 0.15 (decrease from 0.30)
```

**Step 4.4: Timing & Seasonal Recommendations**

Provide calendar timing guidance:

```markdown
## Seasonal Content Strategy

### Q4 (Oct-Dec): HIGH TRAFFIC PERIOD ⭐
**Focus:** WooCommerce Integration, Holiday Ecommerce Prep
**Formats:** Integration Playbooks (high-conversion tutorials)
**Expected Traffic:** +75% above baseline
**Calendar Size:** 10-12 articles (capitalize on traffic spike)

### Q1 (Jan-Mar): MODERATE TRAFFIC PERIOD
**Focus:** Content Migration, Year-End Reporting
**Formats:** Tutorials, Deep Dives
**Expected Traffic:** Baseline
**Calendar Size:** 8-10 articles (standard cadence)

### Q2 (Apr-Jun): HIGH OPPORTUNITY PERIOD
**Focus:** Content Migration (fiscal year transitions)
**Formats:** Integration Playbooks
**Expected Traffic:** +20% above baseline
**Calendar Size:** 10-12 articles

### Q3 (Jul-Sep): LOW TRAFFIC PERIOD ⚠️
**Focus:** Evergreen content, Q4 prep
**Formats:** Deep Dives (build backlink equity)
**Expected Traffic:** -15% below baseline
**Calendar Size:** 6-8 articles (conserve resources, focus on quality)
```

**Step 4.5: Refresh Priority List**

Recommend specific articles to update:

```markdown
## High-Priority Article Refreshes

### Immediate Action (This Month)

1. **ART-202505-002: Gravity Forms CRM Integration**
   - Reason: Gravity Forms 3.0 released (version update)
   - Current: Position #4, 1,800 sessions/month
   - Potential: Position #2-3, 2,500+ sessions/month (+40%)
   - Effort: 2-3 hours (update code examples, test new features)
   - ROI: HIGH

2. **ART-202509-003: WordPress Webhook Handlers**
   - Reason: Displaced by competitor (competitive threat)
   - Current: Position #5, 1,500 sessions/month (declining)
   - Potential: Position #2-3, 2,200+ sessions/month (+47%)
   - Effort: 3-4 hours (expand coverage, add advanced patterns)
   - ROI: HIGH

### Next Quarter

3. **ART-202506-004: WooCommerce Data Sync**
   - Reason: Aging content (6 months old, no updates)
   - Current: Position #7, 1,200 sessions/month
   - Potential: Position #4-5, 1,500+ sessions/month (+25%)
   - Effort: 2-3 hours (refresh examples, update versions)
   - ROI: MEDIUM
```

---

### Phase 5: Output Generation (1 min)

**Step 5.1: Generate Performance Report**

Create comprehensive markdown report:

**Filename:** `performance-insights-[YYYY-MM].md`
**Location:** `project/Calendar/[YEAR]/[MONTH]/` (alongside content calendar)

**Report Structure:**

```markdown
# Content Performance Insights: November 2025 Planning
## Analysis Period: May 2025 - October 2025 (6 months)

**Generated:** 2025-11-05
**Articles Analyzed:** 29 published articles
**Calendars Analyzed:** 6 monthly calendars

---

## Executive Summary

**Key Findings:**
- ⭐ Integration Playbooks drive 62% higher traffic than Tutorials (should increase allocation)
- ⭐ Tier 1 opportunity scores predict 83% success rate (validate gap analysis importance)
- ⭐ Recency gaps deliver 88% success rate but decay fast (balance quick wins with evergreen)
- ⭐ Q4 shows 75% traffic spike (WooCommerce topics, plan accordingly)

**Top Recommendations:**
1. Shift content mix: +10% Integration Playbooks, -10% Tutorials
2. Increase WooCommerce Integration pillar to 60% (currently 50%)
3. Update opportunity weights: Increase recency (0.25) and format (0.25)
4. Refresh 2 high-value articles immediately (Gravity Forms, Webhooks)

**Expected Impact:**
- +30% average article traffic
- +15% conversion rate
- +20% backlink acquisition
- Faster time-to-rank (45 days → 35 days)

---

[Include all sections from Phase 2, 3, 4]

---

## Action Items

### Immediate (This Week)

1. **Update requirements.md:**
   - Content mix: Playbooks 40%, Tutorials 30%
   - Opportunity weights: Recency 0.25, Format 0.25, Depth 0.35, Coverage 0.15
   - Focus areas: WooCommerce 60%, CRM 20%, Migration 15%, Forms 10%

2. **Refresh High-Value Articles:**
   - ART-202505-002: Gravity Forms CRM (version update)
   - ART-202509-003: Webhook Handlers (competitive threat)

### November 2025 Calendar Planning

1. **Topic Selection:**
   - Prioritize WooCommerce Integration (60% of topics)
   - Target 70% Tier 1 opportunity scores (increase from 60%)
   - Emphasize recency + format gaps (high-impact tactics)

2. **Format Distribution:**
   - Integration Playbooks: 40% (4 articles)
   - Tutorials: 30% (3 articles)
   - Deep Dives: 15% (1-2 articles)
   - Product News: 10% (1 article)
   - Analysis: 5% (0-1 article)

3. **Seasonal Optimization:**
   - Q4 spike: Plan 10-12 articles (vs. 8-10 baseline)
   - Focus: Holiday ecommerce prep, Q4 optimization topics
   - Expected traffic: +75% above Q3 average

---

## Confidence & Limitations

**Confidence Level:** ⭐⭐⭐⭐ (High, based on 29 articles over 6 months)

**Data Strengths:**
- ✅ Sufficient sample size (29 articles)
- ✅ Consistent metadata tracking
- ✅ Multiple performance dimensions (traffic, rankings, engagement, conversions)
- ✅ Clear performance patterns

**Limitations:**
- ⚠️ Limited external factors analysis (algorithm changes, competitor actions)
- ⚠️ Performance metrics may have 2-4 week lag
- ⚠️ Seasonal patterns based on single year (need multi-year data for validation)
- ⚠️ Some articles too recent (<30 days) for full performance assessment

**Recommended Review Frequency:** Quarterly (every 3 months)

---

**Next Analysis:** February 2026 (Q4 2025 complete data)
```

**Step 5.2: Return Summary to Caller**

Provide concise summary for command/user:

```markdown
## Performance Insights Ready ✅

**Analysis:** 29 articles, 6 calendars (May-Oct 2025)

**Top Recommendations:**
1. Shift to Integration Playbooks (+10%) for 62% traffic boost
2. Increase WooCommerce topics to 60% (75% higher traffic)
3. Prioritize recency + format gaps (88% success rate)
4. Refresh 2 articles immediately (Gravity Forms, Webhooks)

**Expected Impact:** +30% avg traffic, +15% conversions

**Full Report:** project/Calendar/2025/November/performance-insights-2025-11.md

**Ready for:** Signal research and calendar generation with optimized strategy.
```

---

## Output Files

### performance-insights-[YYYY-MM].md

**Purpose:** Comprehensive analysis report
**Location:** `project/Calendar/[YEAR]/[MONTH]/`
**Contents:**
- Executive summary
- Format/pillar performance analysis
- Opportunity score correlation
- Gap strategy effectiveness
- Seasonal patterns
- Competitive position tracking
- Strategic recommendations
- Action items

### Updated requirements.md (Optional)

If skill detects significant performance-based recommendations, can propose requirements.md updates:

```markdown
**Would you like me to update requirements.md with these performance-based recommendations?**

Proposed Changes:
1. Content Mix: Integration Playbooks 40% (+10%), Tutorials 30% (-10%)
2. Focus Areas: WooCommerce 60%, CRM 20%, Migration 15%, Forms 10%
3. Opportunity Weights: Recency 0.25, Format 0.25, Depth 0.35, Coverage 0.15

These changes reflect data showing Integration Playbooks drive 62% higher traffic and WooCommerce topics generate 75% more traffic than average.
```

---

## Integration Examples

### Example 1: Calendar Command Integration

```markdown
## Step 1: Load Performance Insights (OPTIONAL)

If available, invoke content-performance-analyzer skill:

```
Please use the content-performance-analyzer skill to analyze the last 6 months and provide recommendations for November 2025 calendar.
```

**If insights available:**
- Adjust focus area priorities based on performance
- Target higher Tier 1 percentage if data supports it
- Emphasize high-performing formats
- Avoid underperforming topic areas

**If no insights (new blog or insufficient data):**
- Proceed with configured strategy from requirements.md
- Generate insights for future use

Proceed to Step 2: Signal Research
```

### Example 2: Quarterly Review

```markdown
## Quarterly Content Review: Q3 2025

**User Request:** "How did our content perform in Q3? What should we adjust for Q4?"

**Agent Response:**
Let me analyze Q3 performance using the content-performance-analyzer skill.

[Invokes skill with parameters: analysis_period="Q3 2025", output_format="full_report"]

**Q3 Performance Summary:**
- 8 articles published
- Avg traffic: 1,600 sessions/month (-16% vs Q2)
- Avg ranking: Position 4.8
- Top performer: ART-202508-002 (WooCommerce Integration Playbook, 3,200 sessions/month)

**Q4 Recommendations:**
1. Increase WooCommerce topics (Q4 shows +75% traffic spike)
2. Shift to Integration Playbooks (highest ROI format)
3. Plan 10-12 articles (vs. 8 in Q3) to capitalize on Q4 traffic

[Provides full report with detailed recommendations]
```

---

## Success Metrics

### Analysis Accuracy
- 🎯 Pattern detection: >80% predictive accuracy
- 🎯 Recommendation validation: >70% of changes improve outcomes
- 🎯 Refresh recommendations: >60% achieve projected traffic gains

### Strategic Impact
- 📈 Calendar quality: 15% higher average opportunity scores
- 📈 Traffic improvement: +25-35% after implementing recommendations
- 📈 Conversion rate: +10-20% from format optimization
- 📈 Time to rank: 20-30% faster with optimized strategy

### Efficiency
- ⏱️ Analysis time: 2-4 minutes for 6-month period
- ⏱️ Quarterly review: 5-10 minutes
- ⏱️ ROI: 10-20 hours saved per quarter (vs. manual analysis)

---

## Limitations & Future Enhancements

### Current Limitations

1. **Requires Metadata:** Depends on articles having `meta.yml` with performance data (GSC auto-populates if configured)
2. **GSC is CSV-Based:** GSC integration uses CSV exports, not live API. Data freshness depends on export frequency.
3. **Sample Size:** Needs minimum 10-15 articles for meaningful patterns
4. **External Factors:** Can't automatically account for algorithm changes, competitor shifts
5. **Single-Domain:** Analyzes one blog at a time (no cross-project insights)

### Future Enhancements (Phase 2)

1. **Automatic Metrics Integration:**
   - Connect to Google Analytics API
   - ~~Connect to Google Search Console API~~ (Partially achieved via CSV export integration)
   - Real-time ranking tracking
   - Automated backlink monitoring

2. **Predictive Modeling:**
   - ML-based traffic prediction
   - Success probability scoring
   - Optimal publish timing recommendations

3. **Competitive Benchmarking:**
   - Track competitor content calendars
   - Identify competitor gaps
   - Competitive velocity analysis

4. **A/B Testing Framework:**
   - Test format variations
   - Test gap strategy combinations
   - Systematic optimization loops

5. **ROI Attribution:**
   - Revenue per article
   - Customer acquisition cost per topic
   - Lifetime value by content pillar

---

## Error Handling

### Scenario 1: Insufficient Data

**If <10 articles found:**
```
⚠️ Insufficient data for meaningful performance analysis.

**Articles Found:** 6 articles
**Minimum Required:** 10 articles

**Recommendation:** Generate 4-6 more articles before running performance analysis. In the meantime, use configured strategy from requirements.md.

**Estimated Timeline:** Run analysis after 2-3 more monthly calendars published.
```

### Scenario 2: Missing Performance Metrics

**If metadata exists but performance data missing:**
```
⚠️ Articles found, but performance metrics incomplete.

**Articles with Metrics:** 8/20 articles (40%)
**Missing Metrics:** Traffic, rankings, conversions

**Recommendation:** Update article meta.yml files with performance data:
- Use Google Analytics for traffic metrics
- Use Google Search Console for ranking positions
- Track conversions from CTA/newsletter signups

**Example meta.yml update:**
```yaml
performance:
  ranking: 3
  traffic_monthly: 2400
  time_on_page: 285
  conversion_rate: 0.08
  backlinks: 12
  updated: 2025-11-05
```

### Scenario 3: Inconsistent Metadata

**If article metadata formats inconsistent:**
```
⚠️ Inconsistent metadata detected across articles.

**Issues Found:**
- 5 articles missing opportunity_score
- 3 articles missing format field
- 2 articles using old meta.yml structure

**Action:** Standardizing metadata to current format. Please update remaining articles to match:
[Provides standard meta.yml template]
```

---

## Usage Best Practices

### When to Run Analysis

**✅ Good Times:**
- Before quarterly planning (Q1, Q2, Q3, Q4)
- Before annual strategy review
- After major strategy changes (want to validate impact)
- When user asks specific performance questions

**⚠️ Caution:**
- Within first 3 months of blog launch (insufficient data)
- After major algorithm updates (wait 2-4 weeks for stabilization)
- During seasonal anomalies (holiday traffic spikes)

### How to Use Insights

**✅ Do:**
- Use insights to inform (not dictate) strategy
- Validate recommendations against editorial judgment
- Test recommendations incrementally (A/B test if possible)
- Update requirements.md based on validated insights
- Re-analyze quarterly to detect trend changes

**❌ Don't:**
- Blindly follow recommendations without context
- Abandon configured strategy based on 1 month of data
- Ignore editorial expertise in favor of pure data
- Over-optimize for traffic at expense of quality
- Forget that correlation ≠ causation

---

## This Skill Enables Data-Driven Content Strategy

**Before:** Intuition-based content planning
**After:** Evidence-based optimization with continuous learning

Use this skill to transform your content calendar from reactive to strategic, and from static to continuously improving.
