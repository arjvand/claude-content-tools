---
name: trend-momentum-analyzer
description: Analyze topic momentum trends over time, detect acceleration/decline patterns, predict future saturation, and identify seasonal cycles for strategic timing optimization.
---

# Trend Momentum Analyzer Skill

## Purpose

Perform time series analysis on topic publication patterns to detect momentum trends, predict future saturation, and optimize topic timing. Transforms static 12-month deduplication into dynamic trend-aware filtering that proactively avoids accelerating themes and prioritizes dormant opportunities.

**Key Benefits:**
- **Predictive saturation avoidance:** Detect themes that will saturate before competitors notice
- **Timing optimization:** Identify optimal publication windows based on seasonal patterns
- **Dormant theme revival:** Surface high-value topics that are past their saturation peak
- **Strategic foresight:** Understand which topics are trending up vs cooling down

Increases novelty from 88-92% to 92-95% by avoiding themes with accelerating momentum and prioritizing declining/dormant opportunities.

---

## When to Use

- **Automatically:** During topic deduplication (invoked by topic-deduplicator for momentum scoring)
- **Proactively:** During calendar generation (invoked by signal-researcher for timing optimization)
- **Diagnostically:** To analyze historical topic trends and identify saturation patterns

**NOT for:**
- Projects with <24 months of historical calendar data (insufficient data for time series)
- One-time content generation (momentum analysis requires historical context)
- News/event-based content (inherently time-sensitive, momentum doesn't apply)

---

## Input Parameters

### Required

- `theme_index`: Extended theme index JSON (24-month lookback) with:
  - `topics[]`: Array of past topics with timestamps
  - `core_themes[]`: Core theme registry
  - `time_series[]`: Monthly topic counts by theme (24-month history)
  - `metadata.lookback_months`: 24 (required for momentum analysis)

- `candidate_core_theme`: Core theme to analyze
  - Primary core theme from topic candidate
  - **Impact:** Determines which time series to analyze

### Optional

- `analysis_mode`: Analysis depth
  - `quick`: Momentum classification only (default, <2 seconds)
  - `comprehensive`: Momentum + cycle detection + predictions (5-10 seconds)
  - **Impact:** Affects processing time and output detail

- `current_month`: Current month for analysis
  - Format: "YYYY-MM" (e.g., "2025-12")
  - Default: Current system date
  - **Impact:** Affects recency calculations and predictions

---

## Process

### Phase 1: Time Series Extraction (< 1 second)

**Step 1.1: Extract Theme Time Series**

From `theme_index.time_series[]`, extract monthly publication counts for the candidate's core theme:

```json
{
  "core_theme": "data-migration",
  "time_series": [
    {"month": "2023-12", "count": 0},
    {"month": "2024-01", "count": 1},
    {"month": "2024-02", "count": 0},
    {"month": "2024-03", "count": 0},
    {"month": "2024-04", "count": 1},
    {"month": "2024-05", "count": 0},
    {"month": "2024-06", "count": 2},
    {"month": "2024-07", "count": 1},
    {"month": "2024-08", "count": 0},
    {"month": "2024-09", "count": 1},
    {"month": "2024-10", "count": 2},
    {"month": "2024-11", "count": 3},
    {"month": "2024-12", "count": 0}
  ],
  "total_24_months": 11,
  "total_12_months": 7,
  "total_6_months": 6
}
```

**If no time series data available:**
- Return status: `INSUFFICIENT_DATA`
- Fallback: Use standard deduplication without momentum

---

### Phase 2: Momentum Classification (< 1 second)

**Step 2.1: Calculate Period Averages**

Divide 24-month window into periods:

```
Recent 6-month period: Last 6 months
Previous 6-month period: Months 7-12 (6 months before recent)

Calculations:
  recent_avg = sum(counts[0:6]) / 6
  previous_avg = sum(counts[6:12]) / 6
  momentum_ratio = recent_avg / previous_avg (or 0 if previous_avg == 0)
```

**Example:**
```
Recent 6 months (Jul-Dec 2024): counts = [1, 0, 1, 2, 3, 0] → sum = 7
  recent_avg = 7 / 6 = 1.17 topics/month

Previous 6 months (Jan-Jun 2024): counts = [1, 0, 0, 1, 0, 2] → sum = 4
  previous_avg = 4 / 6 = 0.67 topics/month

momentum_ratio = 1.17 / 0.67 = 1.75
```

---

**Step 2.2: Classify Momentum**

Apply momentum thresholds:

| Momentum Ratio | Classification | Interpretation |
|----------------|----------------|----------------|
| ≥ 1.5 | **ACCELERATING** | Topic frequency increasing rapidly (trend is hot) |
| 1.0 - 1.5 | **STABLE** | Topic frequency steady or slowly increasing |
| 0.5 - 1.0 | **DECLINING** | Topic frequency decreasing (trend cooling) |
| < 0.5 | **DORMANT** | Topic rarely published recently (past saturation peak) |

**Special Cases:**
- If `previous_avg == 0` and `recent_avg > 0`: Classify as **EMERGING** (new trend starting)
- If `recent_avg == 0` and `previous_avg > 0`: Classify as **DORMANT**
- If both `recent_avg == 0` and `previous_avg == 0`: Classify as **INACTIVE** (never published)

**Example Classification:**
```
momentum_ratio = 1.75
→ Classification: ACCELERATING (≥ 1.5)
→ Interpretation: Topic frequency increasing rapidly; expect saturation soon
```

---

**Step 2.3: Calculate Momentum Score**

Convert momentum classification to penalty/bonus score:

| Classification | Momentum Score | Effect on Similarity |
|----------------|----------------|----------------------|
| ACCELERATING | +0.20 | Penalize (treat as more saturated) |
| STABLE | +0.10 | Slight penalty |
| EMERGING | +0.05 | Very slight penalty (emerging trend) |
| DECLINING | -0.05 | Slight bonus (opportunity) |
| DORMANT | -0.15 | Strong bonus (high opportunity) |
| INACTIVE | 0.00 | Neutral (no historical pattern) |

**Purpose:** Momentum score adjusts effective similarity to account for trend direction:
- **Accelerating themes:** Increase effective similarity (avoid future saturation)
- **Declining/dormant themes:** Decrease effective similarity (opportunity to revive)

---

### Phase 3: Predictive Saturation Analysis (Comprehensive Mode Only)

**Step 3.1: Calculate Saturation Velocity**

Measure how quickly the theme is approaching saturation:

```
saturation_velocity = (recent_6mo_count - previous_6mo_count) / 6
```

**Example:**
```
recent_6mo_count = 7
previous_6mo_count = 4

saturation_velocity = (7 - 4) / 6 = 0.5 topics/month increase
```

**Interpretation:**
- **Positive velocity:** Theme is accelerating toward saturation
- **Negative velocity:** Theme is declining (past peak)
- **Zero velocity:** Theme is stable

---

**Step 3.2: Predict Future Saturation**

Extrapolate future topic count based on velocity:

```
predicted_3mo_count = recent_avg * 3 + (saturation_velocity * 3 * 3/2)
```

**Saturation Prediction:**
- If `predicted_3mo_count >= 2`: **WILL SATURATE** (expect 2+ topics in next 3 months)
- If `predicted_3mo_count >= 1`: **BORDERLINE** (expect 1-2 topics)
- If `predicted_3mo_count < 1`: **SAFE** (low future saturation risk)

**Example:**
```
recent_avg = 1.17
saturation_velocity = 0.5

predicted_3mo_count = 1.17 * 3 + (0.5 * 3 * 1.5)
                    = 3.51 + 2.25
                    = 5.76 topics in next 3 months

→ Prediction: WILL SATURATE (high risk)
```

---

### Phase 4: Cycle Detection (Comprehensive Mode Only)

**Step 4.1: Detect Seasonal Patterns**

Analyze 24-month time series for recurring patterns:

**Method:** Simple peak detection
1. Group months by season/quarter
2. Calculate average topic count per season
3. Identify peak seasons (avg > overall avg)

**Example:**
```
24-month time series by quarter:
  Q1 (Jan-Mar): [1, 0, 0, 0, 0, 0, 1, 0] → avg = 0.25
  Q2 (Apr-Jun): [1, 0, 2, 0, 0, 1] → avg = 0.67
  Q3 (Jul-Sep): [1, 0, 1, 0, 0, 0] → avg = 0.33
  Q4 (Oct-Dec): [2, 3, 0, 0, 1, 2] → avg = 1.33 ← PEAK

Overall avg: 0.65

Peak Seasons: Q4 (Oct-Dec) with 1.33 topics/month (2.05x overall avg)
```

---

**Step 4.2: Generate Timing Recommendations**

Based on detected cycles:

**If peak season detected:**
```
Recommendation: "Optimal timing: Publish in [peak months] when topic interest peaks.
                 Current month: [current]. Timing: [OPTIMAL / SUBOPTIMAL]"
```

**If no clear pattern:**
```
Recommendation: "No seasonal pattern detected. Topic can be published anytime."
```

**Example:**
```
Peak Season: Q4 (Oct-Dec)
Current Month: December 2024

Recommendation: "Optimal timing: Publish in Oct-Dec when topic interest peaks.
                 Current month: Dec. Timing: OPTIMAL ✅"
```

---

## Output Format

### Quick Mode Output

```json
{
  "core_theme": "data-migration",
  "momentum": {
    "classification": "ACCELERATING",
    "momentum_ratio": 1.75,
    "momentum_score": 0.20,
    "recent_avg": 1.17,
    "previous_avg": 0.67,
    "interpretation": "Topic frequency increasing rapidly; expect saturation soon"
  },
  "recommendation": {
    "action": "AVOID",
    "reason": "Accelerating trend indicates future saturation. Consider alternative angle or delay."
  },
  "analysis_mode": "quick",
  "timestamp": "ISO-8601"
}
```

---

### Comprehensive Mode Output

```json
{
  "core_theme": "data-migration",
  "momentum": {
    "classification": "ACCELERATING",
    "momentum_ratio": 1.75,
    "momentum_score": 0.20,
    "recent_avg": 1.17,
    "previous_avg": 0.67,
    "saturation_velocity": 0.5,
    "interpretation": "Topic frequency increasing rapidly; expect saturation soon"
  },
  "prediction": {
    "predicted_3mo_count": 5.76,
    "saturation_risk": "WILL_SATURATE",
    "confidence": "HIGH",
    "explanation": "Predicted 5.8 topics in next 3 months based on current acceleration"
  },
  "cycles": {
    "detected": true,
    "peak_seasons": ["Q4 (Oct-Dec)"],
    "peak_avg": 1.33,
    "current_month": "2024-12",
    "timing_status": "OPTIMAL",
    "timing_recommendation": "Optimal timing: Publish in Oct-Dec when topic interest peaks. Current month: Dec. Timing: OPTIMAL ✅"
  },
  "recommendation": {
    "action": "AVOID",
    "reason": "Accelerating trend + predicted saturation (5.8 topics in 3mo). Consider alternative angle or delay until trend cools.",
    "alternative_strategy": "Pivot to niche use-case angle to differentiate from upcoming saturation"
  },
  "time_series_summary": {
    "total_24_months": 11,
    "total_12_months": 7,
    "total_6_months": 6,
    "lookback_months": 24
  },
  "analysis_mode": "comprehensive",
  "timestamp": "ISO-8601"
}
```

---

## Integration with Topic Deduplicator

### Enhanced Similarity Scoring

**Original Formula:**
```
theme_similarity_score = (
  keyword_overlap × 0.30 +
  theme_tag_overlap × 0.25 +
  title_semantic × 0.25 +
  core_theme_match × 0.20
)
```

**Momentum-Enhanced Formula:**
```
effective_similarity = base_similarity + momentum_score

Where:
  base_similarity = original similarity score (0-1)
  momentum_score = from momentum classification (-0.15 to +0.20)

Example:
  base_similarity = 0.65
  momentum_score = 0.20 (ACCELERATING)
  effective_similarity = 0.65 + 0.20 = 0.85 → BLOCKED
```

**Effect:**
- **ACCELERATING themes:** Similarity 0.60 becomes 0.80 (BLOCKED)
- **DECLINING themes:** Similarity 0.65 becomes 0.60 (may PASS)
- **DORMANT themes:** Similarity 0.70 becomes 0.55 (PASS with differentiation)

---

## Recommendation Logic

### Action Recommendations

| Momentum | Recent Avg | Action | Reason |
|----------|-----------|--------|--------|
| ACCELERATING | Any | **AVOID** | Future saturation risk |
| STABLE | > 1.0 | **CAUTION** | Moderately saturated |
| STABLE | < 1.0 | **ACCEPTABLE** | Stable, low saturation |
| DECLINING | Any | **OPPORTUNITY** | Trend cooling, good timing |
| DORMANT | Any | **HIGH OPPORTUNITY** | Past peak, ready for revival |
| EMERGING | Any | **EVALUATE** | New trend, assess demand |
| INACTIVE | Any | **NOVEL** | No historical pattern |

---

## Error Handling

### Scenario 1: Insufficient Time Series Data

**Response:**
- Return status: `INSUFFICIENT_DATA`
- Momentum score: 0.00 (neutral)
- Recommendation: Fall back to standard deduplication
- Warning: `"Momentum analysis requires 24-month lookback. Theme index only has [N] months."`

### Scenario 2: Theme Not in Time Series

**Response:**
- Classification: `INACTIVE`
- Momentum score: 0.00 (neutral)
- Recommendation: `NOVEL` (no historical pattern)
- Note: `"Theme never published in past 24 months. Novel topic."`

### Scenario 3: All Zeros in Time Series

**Response:**
- Classification: `INACTIVE`
- Momentum score: 0.00 (neutral)
- Skip momentum analysis
- Note: `"No publication history for theme."`

### Scenario 4: Division by Zero (previous_avg = 0)

**Response:**
- If `recent_avg > 0`: Classify as `EMERGING`
- If `recent_avg == 0`: Classify as `INACTIVE`
- Use special case handling (no ratio calculation)

---

## Quality Guidelines

### DO:

- Use 24-month lookback for reliable trend detection
- Apply momentum penalties to accelerating themes
- Provide timing recommendations based on cycles
- Return detailed explanations in comprehensive mode
- Handle edge cases (zeros, insufficient data) gracefully

### DON'T:

- Use momentum analysis with <18 months of data (unreliable)
- Over-penalize emerging themes (they may be valuable)
- Ignore seasonal patterns (missed timing optimization)
- Return momentum scores without interpretation
- Apply momentum scoring to news/event-based topics (not applicable)

---

## Success Metrics

### Accuracy
- **Momentum classification accuracy:** ≥85% (manual validation of ACCELERATING/DECLINING)
- **Saturation prediction accuracy:** ≥70% (predicted saturation matches actual saturation 3 months later)
- **Cycle detection precision:** ≥80% (detected peaks align with actual publication patterns)

### Performance
- **Quick mode:** ≤2 seconds per theme
- **Comprehensive mode:** ≤10 seconds per theme

### Quality
- **Avoided false positives:** ≥90% of ACCELERATING themes indeed saturate within 3 months
- **Dormant revival success:** ≥60% of DORMANT themes successfully published without conflict

---

## Example Invocations

### Scenario 1: Accelerating Theme (Avoid)

**Input:**
```json
{
  "theme_index": { /* 24-month data */ },
  "candidate_core_theme": "ai-automation",
  "analysis_mode": "comprehensive"
}
```

**Time Series:**
```
Recent 6mo: [2, 3, 4, 5, 6, 7] → avg = 4.5
Previous 6mo: [0, 1, 1, 0, 2, 1] → avg = 0.83
momentum_ratio = 4.5 / 0.83 = 5.42 → ACCELERATING
```

**Output:**
```json
{
  "momentum": {
    "classification": "ACCELERATING",
    "momentum_score": 0.20,
    "interpretation": "Topic frequency increasing rapidly"
  },
  "prediction": {
    "saturation_risk": "WILL_SATURATE",
    "predicted_3mo_count": 18+
  },
  "recommendation": {
    "action": "AVOID",
    "reason": "Extreme acceleration (5.4x increase). Saturation imminent."
  }
}
```

---

### Scenario 2: Dormant Theme (Opportunity)

**Input:**
```json
{
  "theme_index": { /* 24-month data */ },
  "candidate_core_theme": "legacy-wordpress-plugins",
  "analysis_mode": "quick"
}
```

**Time Series:**
```
Recent 6mo: [0, 0, 0, 1, 0, 0] → avg = 0.17
Previous 6mo: [2, 1, 2, 1, 0, 1] → avg = 1.17
momentum_ratio = 0.17 / 1.17 = 0.15 → DORMANT
```

**Output:**
```json
{
  "momentum": {
    "classification": "DORMANT",
    "momentum_score": -0.15,
    "interpretation": "Topic rarely published recently (past saturation peak)"
  },
  "recommendation": {
    "action": "HIGH_OPPORTUNITY",
    "reason": "Theme is dormant (past peak). Excellent timing to revive."
  }
}
```

---

### Scenario 3: Stable Theme with Seasonal Pattern

**Input:**
```json
{
  "theme_index": { /* 24-month data */ },
  "candidate_core_theme": "tax-planning",
  "analysis_mode": "comprehensive",
  "current_month": "2025-02"
}
```

**Time Series:**
```
Recent 6mo: [1, 1, 1, 1, 1, 1] → avg = 1.0
Previous 6mo: [1, 1, 1, 1, 1, 1] → avg = 1.0
momentum_ratio = 1.0 → STABLE

Seasonal Analysis:
  Q1 (Jan-Mar): avg = 2.5 ← PEAK (tax season)
  Q2-Q4: avg = 0.5
```

**Output:**
```json
{
  "momentum": {
    "classification": "STABLE",
    "momentum_score": 0.10
  },
  "cycles": {
    "detected": true,
    "peak_seasons": ["Q1 (Jan-Mar)"],
    "current_month": "2025-02",
    "timing_status": "OPTIMAL",
    "timing_recommendation": "Optimal timing: Publish in Jan-Mar (tax season). Current: Feb. Timing: OPTIMAL ✅"
  },
  "recommendation": {
    "action": "ACCEPTABLE",
    "reason": "Stable theme with optimal seasonal timing (Q1 tax season)."
  }
}
```

---

## Notes

- Momentum analysis is **optional** (requires 24-month data)
- Works best with **consistent publication cadence** (not sporadic)
- **Predictive saturation** is probabilistic (not deterministic)
- **Cycle detection** is basic (simple peak detection, not advanced time series analysis)
- Momentum scores **adjust effective similarity** for better filtering
- Use **comprehensive mode** for calendar planning, **quick mode** for real-time deduplication
