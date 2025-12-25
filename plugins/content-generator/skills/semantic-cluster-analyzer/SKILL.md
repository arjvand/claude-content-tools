---
name: semantic-cluster-analyzer
description: Detect cross-signal convergence patterns where multiple independent signals point to the same business need or emerging opportunity, enabling synthesis of high-value convergence topics.
---

# Semantic Cluster Analyzer Skill

## Purpose

Identify when multiple independent signals converge on the same underlying business need, technology shift, or market opportunity. Synthesizes cross-signal patterns into high-value "convergence topics" that differentiate by connecting dots competitors miss.

**Key Benefits:**
- **Early trend detection:** Spot emerging opportunities when multiple signals align
- **Unique differentiation:** Create topics connecting multiple signals (vs single-signal coverage)
- **Strategic positioning:** Be first to connect converging trends
- **Higher value content:** Convergence topics score higher on opportunity metrics

Part of Phase 3 novelty enhancement: increases novelty to 92-95% by generating unique synthesis topics from signal patterns.

---

## When to Use

- **Automatically:** During signal discovery Phase 2 (after collecting 15-20 signal candidates)
- **Proactively:** When multiple related signals appear in same discovery window
- **Diagnostically:** To understand cross-signal patterns and identify synthesis opportunities

**NOT for:**
- Single isolated signals (requires ≥2 signals for convergence)
- Unrelated signal sets (e.g., technology + entertainment signals)
- Time-sensitive breaking news (convergence analysis adds latency)

---

## Input Parameters

### Required

- `signals[]`: Array of signal candidates (from signal discovery Phase 2)
  - Minimum: 8 signals (for meaningful clustering)
  - Maximum: 25 signals (beyond this, patterns dilute)
  - Each signal contains:
    - `signal_type`: Type of signal
    - `source`: Official source
    - `headline`: Signal headline
    - `summary`: Brief description
    - `key_aspects[]`: 3-5 key aspects

- `industry`: Industry/domain (from requirements.md)
  - Example: "WordPress data integration", "React.js development"
  - **Impact:** Influences convergence pattern templates

### Optional

- `convergence_threshold`: Minimum signals to form cluster
  - Default: 3 (at least 3 signals must converge)
  - Range: 2-5
  - **Impact:** Lower = more clusters (potentially weak), Higher = fewer clusters (stronger)

- `analysis_mode`: Analysis depth
  - `quick`: Basic clustering only (default, <5 seconds)
  - `comprehensive`: Clustering + business need extraction + synthesis (10-15 seconds)

---

## Process

### Phase 1: Signal Preprocessing (1-2 seconds)

**Step 1.1: Extract Key Terms**

For each signal, extract key terms from headline + summary:

**Extraction Method:**
1. Tokenize text (split on whitespace, punctuation)
2. Remove stop words ("the", "a", "is", "in", etc.)
3. Lemmatize terms (reduce to root: "releases" → "release")
4. Filter to nouns, verbs, adjectives (skip adverbs, conjunctions)
5. Weight by position (headline terms weighted 2x)

**Example:**
```
Signal 1:
  headline: "React 19 Server Components Stable Release"
  summary: "React 19 makes Server Components production-ready with improved performance"

  Extracted terms (weighted):
    - react (2), server (2), components (2), stable (2), release (2)
    - production (1), ready (1), performance (1), improved (1)
```

---

**Step 1.2: Build Signal-Term Matrix**

Create matrix mapping signals to extracted terms:

```
        | react | server | components | AI | performance | ...
--------|-------|--------|------------|----|-----------|----|
Signal1 |   2   |   2    |     2      | 0  |     1     | ...
Signal2 |   0   |   3    |     0      | 2  |     0     | ...
Signal3 |   2   |   1    |     2      | 0  |     2     | ...
...
```

---

### Phase 2: Semantic Clustering (2-3 seconds)

**Step 2.1: Calculate Signal Similarity**

For each pair of signals, calculate semantic similarity:

**Similarity Formula:**
```
similarity(A, B) = cosine_similarity(terms_A, terms_B)

Where:
  cosine_similarity = dot_product(A, B) / (magnitude(A) × magnitude(B))
```

**Example:**
```
Signal A terms: {react: 2, server: 2, components: 2, performance: 1}
Signal B terms: {react: 2, components: 2, performance: 2, optimization: 1}

Shared terms: {react: 2×2, components: 2×2, performance: 1×2}
dot_product = 4 + 4 + 2 = 10

magnitude(A) = sqrt(2² + 2² + 2² + 1²) = sqrt(13) ≈ 3.61
magnitude(B) = sqrt(2² + 2² + 2² + 1²) = sqrt(13) ≈ 3.61

similarity = 10 / (3.61 × 3.61) ≈ 0.77 (HIGH SIMILARITY)
```

---

**Step 2.2: Form Signal Clusters**

Group signals with high similarity (≥ 0.60):

**Clustering Algorithm (Simple Greedy):**
1. Start with highest similarity pair
2. Add signals with similarity ≥ 0.60 to existing cluster
3. Repeat until no more signals meet threshold
4. Create new cluster with next highest similarity pair
5. Continue until all signals processed

**Cluster Size Filter:**
- Keep clusters with ≥ `convergence_threshold` signals (default: 3)
- Discard clusters with < threshold (too weak)

**Example Clusters:**
```
Cluster 1: Server-Side Rendering Convergence
  - Signal 1: React 19 Server Components
  - Signal 3: Next.js 15 Server Actions
  - Signal 7: Remix improved server rendering
  → 3 signals converge on "server-side React patterns"

Cluster 2: AI Tooling Integration
  - Signal 2: GitHub Copilot X release
  - Signal 5: VS Code AI assistant features
  - Signal 9: JetBrains AI coding tools
  - Signal 12: Cursor IDE AI features
  → 4 signals converge on "AI-powered development tools"
```

---

### Phase 3: Business Need Extraction (Comprehensive Mode)

**Step 3.1: Identify Common Thread**

For each cluster, extract the underlying business need or opportunity:

**Extraction Method:**
1. Find most frequent terms across cluster signals (weighted)
2. Identify common signal types (all Product Releases? Mix of releases + discussions?)
3. Extract business context from summaries
4. Synthesize into business need statement

**Business Need Templates (by industry):**

**Technology/Software:**
- "Developers need [capability] to solve [problem]"
- "Teams adopting [technology] for [benefit]"
- "Market shift toward [approach] driven by [driver]"

**Business/Finance:**
- "Organizations require [solution] to address [regulatory/market change]"
- "Businesses seeking [outcome] through [strategy]"

**Healthcare:**
- "Practitioners need [tool/protocol] for [patient outcome]"
- "Healthcare systems adopting [technology] to improve [metric]"

**Example:**
```
Cluster: AI Tooling Integration (4 signals)
  Common terms: AI (12), coding (8), assistant (7), productivity (6), IDE (5)
  Signal types: Mix of Product Releases + Feature Announcements

  Business Need:
    "Developers need AI-powered coding assistance integrated into their
     development environment to improve productivity and code quality"
```

---

**Step 3.2: Generate Convergence Topic Candidates**

Synthesize cluster into 1-2 topic candidates:

**Convergence Topic Pattern:**
```
"[Comparative/Overview] [Business Need Solution]: [Signal A], [Signal B], [Signal C]"

OR

"[Business Need] with [Technology]: Comparing [Approach 1] vs [Approach 2] vs [Approach 3]"

OR

"The [Trend Name]: How [Signal A], [Signal B], and [Signal C] Are Changing [Domain]"
```

**Example Topic Candidates:**
```
Cluster: AI Tooling Integration

Candidate 1 (Comparison):
  "AI-Powered Development Tools in 2025: Comparing Copilot X, Cursor, and JetBrains AI"

  Differentiation angle:
    "Only comprehensive comparison covering all 4 major AI IDE integrations
     released in Q4 2024. Evaluates productivity impact, accuracy, and
     integration quality across different development workflows."

Candidate 2 (Trend Overview):
  "The AI-Assisted Coding Revolution: How GitHub, VS Code, and JetBrains
   Are Transforming Developer Productivity"

  Differentiation angle:
    "Synthesis of Q4 2024 AI tooling releases examining the broader trend
     toward AI-native development environments. Analyzes convergence patterns
     and predicts future integration points."
```

---

### Phase 4: Synthesis Scoring (Comprehensive Mode)

**Step 4.1: Calculate Convergence Strength**

Score convergence topics based on cluster quality:

**Convergence Strength Formula:**
```
convergence_strength = (
  cluster_size_score × 0.30 +
  signal_diversity_score × 0.25 +
  recency_score × 0.25 +
  semantic_cohesion × 0.20
)
```

**Components:**

**a. Cluster Size Score (0-1):**
```
cluster_size_score = min(cluster_size / 5, 1.0)

Example:
  3 signals: 3/5 = 0.60
  5+ signals: 5/5 = 1.00
```

**b. Signal Diversity Score (0-1):**
```
signal_diversity = unique_signal_types / total_signals

Example:
  4 signals: 2 Product Releases, 1 Security Advisory, 1 Community Discussion
  unique_types = 3
  signal_diversity = 3/4 = 0.75
```

**c. Recency Score (0-1):**
```
recency_score = avg(signal_recencies)

Where signal_recency = max(0, 1 - (days_old / 90))

Example:
  Signal 1: 10 days old → 1 - (10/90) = 0.89
  Signal 2: 20 days old → 1 - (20/90) = 0.78
  Signal 3: 5 days old → 1 - (5/90) = 0.94

  recency_score = (0.89 + 0.78 + 0.94) / 3 = 0.87
```

**d. Semantic Cohesion (0-1):**
```
semantic_cohesion = avg_pairwise_similarity

Example:
  Cluster with 3 signals:
    sim(1,2) = 0.77
    sim(1,3) = 0.82
    sim(2,3) = 0.71

  semantic_cohesion = (0.77 + 0.82 + 0.71) / 3 = 0.77
```

**Example Convergence Strength:**
```
AI Tooling Integration Cluster:
  cluster_size_score = 4/5 = 0.80
  signal_diversity_score = 3/4 = 0.75
  recency_score = 0.87
  semantic_cohesion = 0.77

convergence_strength = (0.80 × 0.30) + (0.75 × 0.25) + (0.87 × 0.25) + (0.77 × 0.20)
                     = 0.24 + 0.1875 + 0.2175 + 0.154
                     = 0.799 (STRONG CONVERGENCE)
```

---

**Step 4.2: Prioritize Convergence Topics**

Rank convergence topics by strength:

**Prioritization:**
- **Strong (≥0.75):** High priority, excellent synthesis opportunities
- **Moderate (0.60-0.74):** Medium priority, viable convergence topics
- **Weak (<0.60):** Low priority, may be coincidental clustering

---

## Output Format

### Quick Mode Output

```json
{
  "clusters_detected": 2,
  "clusters": [
    {
      "cluster_id": 1,
      "cluster_name": "Server-Side Rendering Convergence",
      "signal_count": 3,
      "signals": [
        {"id": "sig-1", "headline": "React 19 Server Components"},
        {"id": "sig-3", "headline": "Next.js 15 Server Actions"},
        {"id": "sig-7", "headline": "Remix improved server rendering"}
      ],
      "common_terms": ["react", "server", "components", "rendering", "performance"]
    },
    {
      "cluster_id": 2,
      "cluster_name": "AI Tooling Integration",
      "signal_count": 4,
      "signals": [
        {"id": "sig-2", "headline": "GitHub Copilot X release"},
        {"id": "sig-5", "headline": "VS Code AI assistant"},
        {"id": "sig-9", "headline": "JetBrains AI tools"},
        {"id": "sig-12", "headline": "Cursor IDE AI features"}
      ],
      "common_terms": ["AI", "coding", "assistant", "productivity", "IDE"]
    }
  ],
  "analysis_mode": "quick",
  "timestamp": "ISO-8601"
}
```

---

### Comprehensive Mode Output

```json
{
  "clusters_detected": 2,
  "clusters": [
    {
      "cluster_id": 1,
      "cluster_name": "Server-Side Rendering Convergence",
      "signal_count": 3,
      "signals": [
        {"id": "sig-1", "headline": "React 19 Server Components", "recency_days": 10},
        {"id": "sig-3", "headline": "Next.js 15 Server Actions", "recency_days": 15},
        {"id": "sig-7", "headline": "Remix improved server rendering", "recency_days": 8}
      ],
      "business_need": "Developers need server-side React patterns to improve performance and SEO for modern web applications",
      "convergence_strength": 0.72,
      "convergence_breakdown": {
        "cluster_size_score": 0.60,
        "signal_diversity_score": 0.67,
        "recency_score": 0.91,
        "semantic_cohesion": 0.75
      },
      "topic_candidates": [
        {
          "title": "Server-Side React in 2025: Comparing React 19, Next.js 15, and Remix Approaches",
          "differentiation_angle": "Comprehensive comparison of server-side rendering implementations across major React frameworks",
          "format": "Analysis",
          "estimated_word_count": "2000-2500"
        }
      ],
      "priority": "MODERATE"
    },
    {
      "cluster_id": 2,
      "cluster_name": "AI Tooling Integration",
      "signal_count": 4,
      "signals": [
        {"id": "sig-2", "headline": "GitHub Copilot X release", "recency_days": 12},
        {"id": "sig-5", "headline": "VS Code AI assistant", "recency_days": 18},
        {"id": "sig-9", "headline": "JetBrains AI tools", "recency_days": 20},
        {"id": "sig-12", "headline": "Cursor IDE AI features", "recency_days": 5}
      ],
      "business_need": "Developers need AI-powered coding assistance integrated into development environments to improve productivity and code quality",
      "convergence_strength": 0.799,
      "convergence_breakdown": {
        "cluster_size_score": 0.80,
        "signal_diversity_score": 0.75,
        "recency_score": 0.87,
        "semantic_cohesion": 0.77
      },
      "topic_candidates": [
        {
          "title": "AI-Powered Development Tools in 2025: Comparing Copilot X, Cursor, and JetBrains AI",
          "differentiation_angle": "Only comprehensive comparison covering all 4 major AI IDE integrations released in Q4 2024",
          "format": "Analysis",
          "estimated_word_count": "2200-2800"
        },
        {
          "title": "The AI-Assisted Coding Revolution: How GitHub, VS Code, and JetBrains Are Transforming Developer Productivity",
          "differentiation_angle": "Synthesis of Q4 2024 AI tooling releases examining convergence toward AI-native development",
          "format": "Analysis",
          "estimated_word_count": "1800-2200"
        }
      ],
      "priority": "STRONG"
    }
  ],
  "analysis_mode": "comprehensive",
  "timestamp": "ISO-8601"
}
```

---

## Integration with Signal Researcher

### Convergence Topic Injection

**Workflow:**
1. Signal researcher completes signal discovery (15-20 signals)
2. Invoke semantic-cluster-analyzer (comprehensive mode)
3. Receive convergence topic candidates
4. **Inject convergence topics** into topic candidate pool
5. Mark convergence topics with special flag: `is_convergence_topic: true`
6. Continue with standard workflow (deduplication, gap analysis, selection)

**Convergence Topic Advantages:**
- **Higher novelty:** Synthesis topics are inherently unique (multi-signal connection)
- **Better opportunity scores:** Covering multiple signals = broader coverage gaps
- **Strategic differentiation:** Competitors typically cover signals individually, not synthesized

---

## Error Handling

### Scenario 1: Insufficient Signals for Clustering

**Response:**
- Minimum signals: 8 (below this, clustering unreliable)
- Return: `{"clusters_detected": 0, "note": "Insufficient signals for clustering (min: 8)"}`
- Fallback: Skip convergence analysis, proceed with individual signal topics

### Scenario 2: No Clusters Found

**Response:**
- All signals too dissimilar (max similarity < 0.60)
- Return: `{"clusters_detected": 0, "note": "No convergence patterns detected (signals too diverse)"}`
- Expected: Happens when signals span unrelated domains

### Scenario 3: All Clusters Below Threshold

**Response:**
- Clusters formed but all have <3 signals
- Return: `{"clusters_detected": 0, "note": "Clusters too weak (all below min size threshold)"}`
- Recommendation: Lower convergence_threshold to 2 (if appropriate)

---

## Quality Guidelines

### DO:

- Run convergence analysis on ≥8 signals (reliable clustering)
- Use comprehensive mode for calendar generation (synthesis topics valuable)
- Inject convergence topics into candidate pool (don't replace individual topics)
- Set convergence_threshold = 3 for strong clusters
- Provide business need context for convergence topics

### DON'T:

- Run on <5 signals (unreliable, skip analysis)
- Force clustering when signals are clearly unrelated (accept 0 clusters)
- Replace individual signal topics with convergence topics (both are valuable)
- Lower threshold below 2 (clusters too weak)
- Generate convergence topics without differentiation angles

---

## Success Metrics

### Accuracy
- **Cluster coherence:** ≥80% of cluster signals truly related (manual validation)
- **Business need accuracy:** ≥70% of extracted business needs align with industry expert assessment
- **Topic viability:** ≥60% of convergence topics pass novelty and gap analysis

### Performance
- **Quick mode:** ≤5 seconds for 20 signals
- **Comprehensive mode:** ≤15 seconds for 20 signals

### Quality
- **Convergence topic acceptance:** ≥50% of strong convergence topics selected for calendar
- **Differentiation success:** Convergence topics average 0.80+ novelty scores

---

## Notes

- Convergence analysis is **supplementary** (doesn't replace individual signal topics)
- Works best with **homogeneous signal sets** (all from same industry)
- **Synthesis topics** often score higher on opportunity (broader coverage)
- Clustering is **deterministic** for same signal set (reproducible)
- Use **quick mode** for fast discovery, **comprehensive mode** for final calendar generation
