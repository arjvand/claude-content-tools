# Phase 3 Implementation Notes: Trend Momentum & Long-Cycle Analysis

## Implementation Date
December 25, 2025

## Overview
Successfully implemented Phase 3 of the Topic Novelty Enhancement Plan: Trend Momentum & Long-Cycle Analysis with Convergence Detection. This enables time series-based momentum classification, predictive saturation analysis, and cross-signal convergence detection for synthesis topics.

---

## Changes Summary

### 1. Trend Momentum Analyzer Skill (NEW)

**File:** `plugins/content-generator/skills/trend-momentum-analyzer/SKILL.md`

**Purpose:** Time series analysis for momentum detection and predictive saturation.

**Key Functionality:**
- **Momentum Classification:** ACCELERATING, STABLE, DECLINING, DORMANT, EMERGING, INACTIVE
- **Predictive Saturation:** Forecasts when accelerating themes will saturate
- **Seasonal Cycle Detection:** Identifies recurring publication patterns
- **Momentum Scoring:** -0.15 to +0.20 adjustment to similarity scores

**Momentum Classification Formula:**
```
recent_avg = sum(counts[0:6]) / 6
previous_avg = sum(counts[6:12]) / 6
momentum_ratio = recent_avg / previous_avg

| Momentum Ratio | Classification | Score Adjustment |
|----------------|----------------|------------------|
| ≥ 1.5          | ACCELERATING   | +0.20            |
| 1.0 - 1.5      | STABLE         | +0.10            |
| 0.5 - 1.0      | DECLINING      | -0.05            |
| < 0.5          | DORMANT        | -0.15            |
```

**Predictive Saturation:**
```
saturation_in_N_months = 6 / (recent_avg - threshold)
```

**Location:** `skills/trend-momentum-analyzer/SKILL.md` (NEW, 500+ lines)

---

### 2. Semantic Cluster Analyzer Skill (NEW)

**File:** `plugins/content-generator/skills/semantic-cluster-analyzer/SKILL.md`

**Purpose:** Detect cross-signal convergence patterns for synthesis topics.

**Key Functionality:**
- **Signal Preprocessing:** Extract key terms, build signal-term matrix
- **Semantic Clustering:** Cosine similarity-based clustering
- **Business Need Extraction:** Industry-specific templates
- **Convergence Strength Scoring:** Composite score (0-1)
- **Topic Synthesis:** Generate unique convergence topics

**Similarity Formula:**
```
similarity(A, B) = cosine_similarity(terms_A, terms_B)
  = dot_product(A, B) / (magnitude(A) × magnitude(B))
```

**Convergence Strength Formula:**
```
convergence_strength = (
  cluster_size_score × 0.30 +
  signal_diversity_score × 0.25 +
  recency_score × 0.25 +
  semantic_cohesion × 0.20
)
```

**Synthesis Topic Pattern:**
```
"[Comparative/Overview] [Business Need Solution]: [Signal A], [Signal B], [Signal C]"

Example:
"AI-Powered Development Tools in 2025: Comparing Copilot X, Cursor, and JetBrains AI"
```

**Location:** `skills/semantic-cluster-analyzer/SKILL.md` (NEW, 500+ lines)

---

### 3. Theme Index Builder Enhancement

**File:** `plugins/content-generator/skills/theme-index-builder/SKILL.md`

**Changes:**
- ✅ Extended default lookback from 12 to 24 months
- ✅ Added `include_time_series` parameter (default: true)
- ✅ Phase 5 Step 5.1: Build time series data with monthly counts
- ✅ Added `time_series[]` and `time_series_labels[]` to core_themes output
- ✅ Added `trend_metrics{}` with recent_avg, previous_avg, historical_avg
- ✅ Updated metadata to include `includes_time_series: true`
- ✅ Updated version to 2.0
- ✅ Performance updated: ≤3 minutes for 24 calendars (~200 topics)

**Output Enhancement:**
```json
{
  "metadata": {
    "lookback_months": 24,
    "includes_time_series": true,
    "skill_version": "theme-index-builder v2.0"
  },
  "core_themes": [
    {
      "theme": "data-migration",
      "time_series": [1, 1, 0, 0, 0, 0, 2, 0, 1, ...],
      "time_series_labels": ["2025-10", "2025-09", ...],
      "trend_metrics": {
        "recent_avg": 0.33,
        "previous_avg": 0.50,
        "historical_avg": 0.08
      }
    }
  ]
}
```

**Location:** Lines 43-46 (parameters), 305-360 (time series step), 527-553 (output format)

---

### 4. Topic Deduplicator Enhancement

**File:** `plugins/content-generator/skills/topic-deduplicator/SKILL.md`

**Changes:**
- ✅ Added Phase 3.5: Momentum Analysis (30 seconds)
- ✅ Loads time series data from theme index
- ✅ Invokes trend-momentum-analyzer for momentum classification
- ✅ Adjusts similarity scores based on momentum:
  - ACCELERATING: +0.20 (avoid saturating trends)
  - STABLE: +0.10 (moderate caution)
  - DECLINING: -0.05 (slight preference)
  - DORMANT: -0.15 (strong preference for revival)
- ✅ Returns both base_similarity and effective_similarity
- ✅ Includes momentum_analysis in output

**Enhanced Similarity Formula:**
```
effective_similarity = base_similarity + momentum_score
```

**Output Enhancement:**
```json
{
  "base_similarity_score": 0.71,
  "effective_similarity_score": 0.66,
  "momentum_analysis": {
    "classification": "DECLINING",
    "momentum_score": -0.05,
    "recommendation": "FAVORABLE - Declining themes are good revival opportunities"
  }
}
```

**Location:** Lines 3 (description), 10-19 (purpose), 346-421 (Phase 3.5)

---

### 5. Signal Researcher Agent Enhancement

**File:** `plugins/content-generator/agents/signal-researcher.md`

**Changes:**

**Step 1.1 (Configuration Extraction):**
- ✅ Added Phase 3 configuration extraction (lines 79-83):
  - `content.novelty_controls.trend_analysis.enabled`
  - `content.novelty_controls.trend_analysis.lookback_months`
  - `content.novelty_controls.convergence_detection.enabled`
  - `content.novelty_controls.convergence_detection.min_cluster_size`
  - `content.novelty_controls.convergence_detection.similarity_threshold`

**Step 1.2 (Build Theme Index):**
- ✅ Updated to use 24-month lookback (line 94)
- ✅ Added `include_time_series: true` parameter (line 97)
- ✅ Updated process steps to include time series building (lines 106-107)

**Phase 3.5 (NEW): Convergence Detection (2-3 min):**
- ✅ Runs only if `convergence_detection.enabled == true`
- ✅ Step 3.5.1: Prepare signal data for analysis
- ✅ Step 3.5.2: Invoke semantic-cluster-analyzer skill
- ✅ Step 3.5.3: Quick-check synthesis topics
- ✅ Step 3.5.4: Add high-priority synthesis topics to candidate pool

**Convergence Detection Benefits:**
- 🔗 Cross-signal synthesis combining multiple related signals
- 🎯 Business need alignment tied to verified needs
- 📊 Data-driven prioritization via convergence strength
- ✅ Differentiation boost (synthesis topics naturally differentiate)

**Location:** Lines 79-83 (config extraction), 94-108 (theme index), 574-685 (Phase 3.5)

---

### 6. Configuration Updates

**Files Modified (All 7 Templates):**
- ✅ `examples/requirements-generic.md`
- ✅ `examples/requirements-wordpress.md`
- ✅ `examples/requirements-react.md`
- ✅ `examples/requirements-python.md`
- ✅ `examples/requirements-finance.md`
- ✅ `examples/requirements-psychology.md`
- ✅ `examples/requirements-entertainment.md`

**Section Added:** `Content Strategy > Novelty Controls > Trend Analysis & Convergence Detection`

**Configuration Structure:**
```markdown
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
```

---

## Expected Impact

### Metrics (Target)
- **Novelty Rate:** 88-92% → **92-95%** (+4% improvement from Phase 2)
- **Block Rate:** 3-5% → **2-3%** (33% reduction from Phase 2)
- **Opportunity Scores:** 4.5 → **4.8** average (better gap targeting via momentum)
- **Synthesis Topics:** 0 → **1-2 per calendar** (unique convergence topics)
- **Workflow Time:** 16 min → **20 min** total (+4 minutes for momentum + convergence)

### Benefits
1. 🎯 **Strategic timing:** Avoid accelerating trends, favor dormant themes
2. 📊 **Predictive saturation:** Know when themes will saturate (2-6 months ahead)
3. 🔗 **Cross-signal synthesis:** Generate unique topics combining multiple signals
4. ⚡ **Higher novelty:** 92-95% novelty rate (vs 67% baseline, 88-92% Phase 2)
5. ✅ **Business need alignment:** Synthesis topics explicitly tied to verified needs
6. 🔄 **Seasonal awareness:** Detect and leverage recurring publication cycles

---

## Workflow Comparison

### Phase 2 Workflow (Multi-Angle Generation)
```
Signal → Generate 3 variants (coverage, depth, use-case) → Quick-check all 3
  → Filter out BLOCKED variants
  → Score remaining variants (composite scoring)
  → Select variant with highest score
  → Result: 1 final candidate (best of 3)
```

### Phase 3 Workflow (Momentum + Convergence)
```
Signals → Generate 3 variants per signal → Quick-check all variants
  → Score remaining variants (composite scoring)
  → Select best variant per signal
  → Detect convergence patterns across all candidates
  → Generate synthesis topics for convergent clusters
  → Quick-check synthesis topics
  → Add high-priority synthesis topics to pool
  → Deduplication with momentum-adjusted scoring
  → Result: 12 individual + 1-2 synthesis = 13-14 candidates
```

**Key Difference:** Phase 3 adds momentum-aware deduplication (favor dormant themes, avoid accelerating trends) and cross-signal synthesis (combine multiple related signals into comprehensive topics).

---

## Testing & Validation

### Test Cases (To Be Validated)

#### 1. Momentum Classification Test
**Given:** Time series [1, 1, 0, 0, 0, 0, 2, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
**When:** trend-momentum-analyzer invoked
**Then:**
- Recent avg: 0.33 (months 0-5)
- Previous avg: 0.50 (months 6-11)
- Momentum ratio: 0.66
- Classification: DECLINING
- Momentum score: -0.05

#### 2. Momentum Adjustment Test
**Given:** Base similarity 0.71, DECLINING theme (momentum score -0.05)
**When:** topic-deduplicator applies momentum adjustment
**Then:**
- Effective similarity: 0.66
- Output includes both base and effective similarity
- Momentum analysis included in response

#### 3. Convergence Detection Test
**Given:** 4 signals about "WooCommerce HPOS migration"
**When:** semantic-cluster-analyzer invoked
**Then:**
- Detects convergence cluster (similarity > 0.40)
- Generates synthesis topic combining all 4 signals
- Convergence strength ≥ 0.60
- Synthesis topic includes rationale

#### 4. Synthesis Topic Quick-Check Test
**Given:** Synthesis topic from convergence cluster
**When:** Quick-check saturation
**Then:**
- Returns AVAILABLE or BORDERLINE
- Synthesis topic added to candidate pool with convergence metadata

#### 5. 24-Month Lookback Test
**Given:** Target month November 2025, lookback 24 months
**When:** theme-index-builder runs
**Then:**
- Analyzes calendars from November 2023 → October 2025
- Builds 24-element time series arrays
- Calculates recent/previous/historical averages

#### 6. Predictive Saturation Test
**Given:** ACCELERATING theme with recent_avg = 1.2
**When:** trend-momentum-analyzer calculates saturation
**Then:**
- Predicts saturation in 3-6 months
- Recommendation: "AVOID - Theme will saturate soon"

#### 7. All Variants Blocked with Convergence Test
**Given:** Signal with all 3 variants BLOCKED
**When:** Convergence detection runs
**Then:**
- Individual candidates skipped
- Signal still included in convergence analysis
- May contribute to synthesis topic

#### 8. Backward Compatibility Test
**Given:** trend_analysis.enabled = false, convergence_detection.enabled = false
**When:** Signal researcher runs
**Then:**
- Uses Phase 2 workflow (multi-angle generation only)
- No momentum analysis
- No convergence detection
- Output format matches Phase 2

---

## Backward Compatibility

✅ **Fully backward compatible:**
- Phase 3 settings default to `true` (opt-out, not opt-in)
- Phase 2 workflow preserved when trend_analysis/convergence_detection disabled
- Existing calendars and workflows continue to work
- Configuration sections are optional (defaults apply if omitted)
- 12-month lookback still supported (set `lookback_months: 12`)
- Phase 1 and Phase 2 output formats still supported

**Migration Path:**
- Existing projects automatically use Phase 3 (enabled: true by default)
- Projects can opt out by setting `enabled: false` for trend_analysis and/or convergence_detection
- No breaking changes to existing files or workflows

---

## Integration Points

### Skill → Skill
- **signal-researcher** → **theme-index-builder** (24-month lookback with time series)
- **signal-researcher** → **semantic-cluster-analyzer** (convergence detection)
- **signal-researcher** → **topic-deduplicator** (quick-check synthesis topics)
- **topic-deduplicator** → **trend-momentum-analyzer** (momentum classification)
- **trend-momentum-analyzer** reads **theme-index.json** (time series data)
- **semantic-cluster-analyzer** reads **requirements.md** (industry, focus areas)

### Configuration → Agent
- **signal-researcher** reads `requirements.md` → Novelty Controls > Trend Analysis
- **signal-researcher** reads `requirements.md` → Novelty Controls > Convergence Detection
- Enabled flags control workflow selection (Phase 3 vs Phase 2 vs Phase 1)
- Lookback months controls theme index window (24 vs 12)
- Min cluster size and similarity threshold control convergence criteria

---

## Files Modified Summary

| File | Lines Changed | Type | Status |
|------|---------------|------|--------|
| `skills/trend-momentum-analyzer/SKILL.md` | +500 | New Skill | ✅ Complete |
| `skills/semantic-cluster-analyzer/SKILL.md` | +500 | New Skill | ✅ Complete |
| `skills/theme-index-builder/SKILL.md` | +60 | Enhancement | ✅ Complete |
| `skills/topic-deduplicator/SKILL.md` | +75 | Enhancement | ✅ Complete |
| `agents/signal-researcher.md` | +115 | Enhancement | ✅ Complete |
| `examples/requirements-generic.md` | +28 | Config | ✅ Complete |
| `examples/requirements-wordpress.md` | +28 | Config | ✅ Complete |
| `examples/requirements-react.md` | +28 | Config | ✅ Complete |
| `examples/requirements-python.md` | +28 | Config | ✅ Complete |
| `examples/requirements-finance.md` | +28 | Config | ✅ Complete |
| `examples/requirements-psychology.md` | +28 | Config | ✅ Complete |
| `examples/requirements-entertainment.md` | +28 | Config | ✅ Complete |

**Total:** 2 new skills + 3 skills enhanced + 1 agent enhanced + 7 config files updated, ~1,500 lines added

---

## Performance Considerations

### Time Complexity
- **Phase 2:** 3 variants per signal, 12 signals = 36 candidates processed
- **Phase 3:**
  - Same multi-variant generation as Phase 2
  - **+30 seconds** for momentum analysis (per candidate)
  - **+2-3 minutes** for convergence detection (analyzes all signals)
  - **Total:** +4 minutes from Phase 2 baseline

### Optimization Opportunities (Future)
- **Batch momentum analysis:** Analyze all core themes in parallel (reduce from 30s to 10s)
- **Caching:** Cache momentum classifications for core themes (reuse across candidates)
- **Smart convergence:** Skip convergence if <6 signals (no clusters possible)
- **Parallel processing:** Run momentum and convergence in parallel (save 1-2 minutes)

**Note:** Parallel processing optimization deferred to future enhancement. Current implementation prioritizes clarity and correctness over speed.

---

## Risk Mitigation

| Risk | Mitigation | Status |
|------|-----------|--------|
| 24-month lookback requires data | Fallback to 12-month if insufficient calendars | ✅ Mitigated |
| Momentum classification needs 24 months | Graceful degradation if <24 months available | ✅ Mitigated |
| Convergence detection too slow | Configurable min_cluster_size and similarity_threshold | ✅ Mitigated |
| All synthesis topics BLOCKED | Convergence detection optional (can be disabled) | ✅ Mitigated |
| Backward compatibility | Phase 2 workflow preserved as fallback | ✅ Maintained |

---

## Troubleshooting Guide

### Issue: Momentum classification returns INACTIVE for all themes

**Symptom:** All themes classified as INACTIVE regardless of publication history
**Cause:** Insufficient historical data (<24 months of calendars)
**Solution:**
- Check theme index metadata: `lookback_months` and `calendars_analyzed`
- If <24 calendars, momentum classification falls back to neutral (0.00 adjustment)
- Wait until 24+ months of calendars available, or set `trend_analysis.enabled: false`

### Issue: No convergent clusters detected

**Symptom:** semantic-cluster-analyzer returns empty convergent_clusters array
**Cause:** Signals too dissimilar or min_cluster_size too high
**Solution:**
- Lower `similarity_threshold` from 0.40 to 0.30 (more lenient)
- Lower `min_cluster_size` from 3 to 2 (smaller clusters)
- Verify signal diversity - convergence requires related but distinct signals

### Issue: Synthesis topics always BLOCKED

**Symptom:** All synthesis topics fail quick-check (status: BLOCKED)
**Cause:** Synthesis topics too similar to existing content
**Solution:**
- Review saturation sensitivity (switch to "lenient" if too strict)
- Increase signal diversity in convergence clusters
- Adjust convergence_strength threshold (require ≥ 0.70 instead of ≥ 0.60)

### Issue: Workflow too slow (>25 minutes)

**Symptom:** Calendar generation takes >25 minutes with Phase 3
**Cause:** Momentum analysis + convergence detection adds overhead
**Solution:**
- Disable convergence detection (`convergence_detection.enabled: false`) for faster runs
- Use Phase 2 workflow for time-sensitive calendars
- Future: Implement batch momentum analysis optimization

---

## Validation Checklist

Before deploying to production:

- [ ] Test trend-momentum-analyzer with various time series patterns
- [ ] Verify momentum classification accuracy (ACCELERATING, STABLE, DECLINING, DORMANT)
- [ ] Test predictive saturation calculation
- [ ] Test semantic-cluster-analyzer with multiple signal configurations
- [ ] Verify convergence detection with min_cluster_size 2, 3, 4
- [ ] Test synthesis topic generation quality
- [ ] Verify momentum-adjusted similarity in topic-deduplicator
- [ ] Test 24-month lookback in theme-index-builder
- [ ] Verify time series arrays and trend metrics in theme index output
- [ ] Confirm convergence detection in signal-researcher Phase 3.5
- [ ] Validate all 7 requirements templates have Phase 3 config
- [ ] Test with trend_analysis.enabled: true and false
- [ ] Test with convergence_detection.enabled: true and false
- [ ] Verify output format includes momentum analysis and synthesis metadata
- [ ] Confirm backward compatibility (Phase 2 workflow still works)

---

## Implementation Timeline

- **Week 4:** trend-momentum-analyzer skill creation (COMPLETED ✅)
- **Week 4:** semantic-cluster-analyzer skill creation (COMPLETED ✅)
- **Week 4:** theme-index-builder enhancement (COMPLETED ✅)
- **Week 4:** topic-deduplicator enhancement (COMPLETED ✅)
- **Week 4:** signal-researcher integration (COMPLETED ✅)
- **Week 4:** Configuration updates (COMPLETED ✅)
- **Week 5:** Testing & validation (PENDING ⏳)

**Status:** Phase 3 implementation COMPLETE, awaiting validation testing.

---

## Cumulative Novelty Improvement

### Baseline (No Enhancement)
- Novelty Rate: 67%
- Block Rate: 16%

### After Phase 1 (Real-Time Saturation Feedback)
- Novelty Rate: 80-85% (+13-18%)
- Block Rate: 5-8% (-50%)

### After Phase 2 (Multi-Angle Generation)
- Novelty Rate: 88-92% (+8% from Phase 1, +21-25% from baseline)
- Block Rate: 3-5% (-40% from Phase 1, -69% from baseline)

### After Phase 3 (Trend Momentum & Convergence Detection)
- Novelty Rate: 92-95% (+4% from Phase 2, +25-28% from baseline)
- Block Rate: 2-3% (-33% from Phase 2, -81% from baseline)
- **NEW:** Synthesis Topics: 1-2 per calendar (unique convergence topics)

**Total Improvement:** 67% → 92-95% (37-42% relative improvement)

---

## Notes

- Phase 3 builds on Phase 1 and Phase 2 foundations (requires quick-check mode and multi-angle generation)
- Momentum analysis requires 24-month time series data (graceful fallback if unavailable)
- Convergence detection is optional (can be disabled if synthesis topics not desired)
- All 3 enhancement layers are configurable via requirements.md
- Backward compatibility maintained via fallback to Phase 2 or Phase 1 workflows
- Performance acceptable: +4 minutes for 4-5% novelty gain + unique synthesis topics
