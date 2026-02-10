# Configuration Validation Report - Example

**File:** requirements.md
**Extracted:** 2025-11-05 14:32:15
**Status:** ✅ Valid (2 warnings)

## Summary

- ✅ All required fields present
- ✅ Format validation passed
- ⚠️ 2 consistency warnings
- 📌 0 deprecation notices

---

## Validation Details

### Required Fields ✅
- ✅ project.industry: "WordPress data integration"
- ✅ project.platform: "WordPress, WooCommerce, Gravity Forms"
- ✅ audience.primary_roles: 3 roles found
- ✅ brand.name: "Summix Blog"
- ✅ content.formats: 5 formats found
- ✅ content.depth: present
- ✅ content.topic_pillars.primary: "WooCommerce Integration"
- ✅ localization.spelling: "US"

### Format Validation ✅
- ✅ Content mix sums to 100.0% (tolerance: ±1%)
- ✅ Opportunity weights sum to 1.0
- ✅ Word count range valid: [900, 2000]
- ✅ All URLs valid (4 checked)
- ✅ Percentages in correct range (0.0-1.0)
- ✅ Multi-angle selection criteria weights sum to 1.0 (0.40 + 0.35 + 0.25)
- ✅ Alternative angle preference sums to 100% (60 + 40)
- ✅ Convergence detection similarity threshold in range (0.40)
- ✅ Length per format ranges valid (5 formats checked)

### Consistency Checks ⚠️
- ✅ Content formats match content mix keys
- ⚠️ **Warning:** topic_candidate_count (12) slightly low for 10-article target
  - Recommendation: Increase to 14-15 for better selection
- ⚠️ **Warning:** CMS platform "WordPress" but html_formatter_skill is "none"
  - Recommendation: Set to "gutenberg-formatter" for WordPress
- ✅ Competitor counts aligned (pre: 8, full: 10)
- ✅ Export format "gutenberg" matches CMS platform "WordPress"
- ✅ Trend analysis lookback (24 months) sufficient for trend classification
- ✅ Length per format keys match content formats

### Deprecation Notices 📌
- No deprecated patterns detected

---

## Configuration Summary

**Extracted 11/11 sections:**
1. ✅ Project Definition
2. ✅ Audience
3. ✅ Brand Identity
4. ✅ Content Strategy
5. ✅ SEO & Distribution
6. ✅ Competitive Gap Analysis
7. ✅ Delivery Settings
8. ✅ Localization
9. ✅ Novelty Controls
10. ✅ Quality & Review
11. ✅ Additional Notes

**Cached to:** .claude/cache/config.json
**Cache expires:** 2025-11-05 15:32:15
