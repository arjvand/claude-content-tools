#!/bin/bash
# Calendar Context Integration - Validation Script
# Tests the 5 improvements implemented in v2.2.0

set -e

echo "=========================================="
echo "Calendar Context Integration Test Suite"
echo "Version 2.2.0 - 2026-02-02"
echo "=========================================="
echo ""

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Test counters
PASSED=0
FAILED=0
WARNINGS=0

# Helper functions
pass() {
    echo -e "${GREEN}✅ PASS${NC}: $1"
    ((PASSED++))
}

warn() {
    echo -e "${YELLOW}⚠️ WARN${NC}: $1"
    ((WARNINGS++))
}

fail() {
    echo -e "${RED}❌ FAIL${NC}: $1"
    ((FAILED++))
}

# Test 1: Gap Pre-Analysis Detection
echo "Test 1: Gap Pre-Analysis Reuse"
echo "--------------------------------"

CALENDAR_PATH="project/Calendar/2025/October/content-calendar.md"
TEST_ARTICLE_ID="ART-202510-001"

if [ -f "$CALENDAR_PATH" ]; then
    pass "Calendar file exists: $CALENDAR_PATH"

    # Check for gap pre-analysis directory
    CALENDAR_DIR=$(dirname "$CALENDAR_PATH")
    PRE_ANALYSIS_DIR="${CALENDAR_DIR}/gap-pre-analysis"

    if [ -d "$PRE_ANALYSIS_DIR" ]; then
        pass "Gap pre-analysis directory exists"

        # Check for specific pre-analysis file
        PRE_ANALYSIS_FILE="${PRE_ANALYSIS_DIR}/${TEST_ARTICLE_ID}-summary.md"
        if [ -f "$PRE_ANALYSIS_FILE" ]; then
            pass "Pre-analysis file exists for $TEST_ARTICLE_ID"
            echo "   Path: $PRE_ANALYSIS_FILE"

            # Check file has content
            if [ -s "$PRE_ANALYSIS_FILE" ]; then
                pass "Pre-analysis file has content"
            else
                fail "Pre-analysis file is empty"
            fi
        else
            warn "Pre-analysis file not found for $TEST_ARTICLE_ID"
            echo "   Expected: $PRE_ANALYSIS_FILE"
        fi
    else
        warn "Gap pre-analysis directory not found"
        echo "   Expected: $PRE_ANALYSIS_DIR"
        echo "   Suggestion: Run /content-calendar first to generate pre-analysis data"
    fi
else
    fail "Calendar file not found: $CALENDAR_PATH"
    echo "   Suggestion: Run /content-calendar October 2025 first"
fi

echo ""

# Test 2: Calendar Context JSON Structure
echo "Test 2: Calendar Context JSON Creation"
echo "---------------------------------------"

ARTICLE_DIR="project/Articles/${TEST_ARTICLE_ID}"

if [ -d "$ARTICLE_DIR" ]; then
    pass "Article directory exists: $ARTICLE_DIR"

    CONTEXT_FILE="${ARTICLE_DIR}/calendar-context.json"
    if [ -f "$CONTEXT_FILE" ]; then
        pass "calendar-context.json exists"

        # Check for required fields
        if grep -q "opportunity_score" "$CONTEXT_FILE"; then
            pass "Contains opportunity_score field"
        else
            fail "Missing opportunity_score field"
        fi

        if grep -q "tier" "$CONTEXT_FILE"; then
            pass "Contains tier field"
        else
            fail "Missing tier field"
        fi

        if grep -q "skip_full_gap_analysis" "$CONTEXT_FILE"; then
            pass "Contains skip_full_gap_analysis flag"
        else
            fail "Missing skip_full_gap_analysis flag"
        fi

        echo "   Preview:"
        head -n 10 "$CONTEXT_FILE" | sed 's/^/   /'
    else
        warn "calendar-context.json not yet created"
        echo "   Expected: $CONTEXT_FILE"
        echo "   Will be created when running /write-article"
    fi
else
    warn "Article directory not found: $ARTICLE_DIR"
    echo "   Will be created when running /write-article"
fi

echo ""

# Test 3: Tier Classification Data
echo "Test 3: Tier Classification Detection"
echo "--------------------------------------"

if [ -f "$CALENDAR_PATH" ]; then
    # Check if calendar has opportunity scores
    if grep -q "Opportunity Score:" "$CALENDAR_PATH"; then
        pass "Calendar contains opportunity scores"

        # Count articles by tier
        T1_COUNT=$(grep -c "Tier: T1" "$CALENDAR_PATH" || echo 0)
        T2_COUNT=$(grep -c "Tier: T2" "$CALENDAR_PATH" || echo 0)
        T3_COUNT=$(grep -c "Tier: T3" "$CALENDAR_PATH" || echo 0)
        T4_COUNT=$(grep -c "Tier: T4" "$CALENDAR_PATH" || echo 0)

        echo "   Tier Distribution:"
        echo "   - T1 (≥4.0): $T1_COUNT articles"
        echo "   - T2 (3.0-3.9): $T2_COUNT articles"
        echo "   - T3 (2.0-2.9): $T3_COUNT articles"
        echo "   - T4 (<2.0): $T4_COUNT articles"

        if [ $T1_COUNT -gt 0 ]; then
            pass "Has Tier 1 articles for high-depth research testing"
        else
            warn "No Tier 1 articles - cannot test full research depth"
        fi

        if [ $T3_COUNT -gt 0 ] || [ $T4_COUNT -gt 0 ]; then
            pass "Has Tier 3/4 articles for streamlined research testing"
        else
            warn "No Tier 3/4 articles - cannot test streamlined research"
        fi
    else
        fail "Calendar missing opportunity scores"
        echo "   Suggestion: Regenerate calendar with /content-calendar"
    fi
fi

echo ""

# Test 4: Funnel Stage Detection
echo "Test 4: Funnel Stage Data"
echo "-------------------------"

if [ -f "$CALENDAR_PATH" ]; then
    if grep -q "Funnel Stage:" "$CALENDAR_PATH"; then
        pass "Calendar contains funnel stage data"

        # Count by funnel stage
        AWARENESS_COUNT=$(grep -c "Funnel Stage: Awareness" "$CALENDAR_PATH" || echo 0)
        CONSIDERATION_COUNT=$(grep -c "Funnel Stage: Consideration" "$CALENDAR_PATH" || echo 0)
        DECISION_COUNT=$(grep -c "Funnel Stage: Decision" "$CALENDAR_PATH" || echo 0)

        echo "   Funnel Distribution:"
        echo "   - Awareness: $AWARENESS_COUNT articles"
        echo "   - Consideration: $CONSIDERATION_COUNT articles"
        echo "   - Decision: $DECISION_COUNT articles"

        if [ $AWARENESS_COUNT -gt 0 ] && [ $DECISION_COUNT -gt 0 ]; then
            pass "Has mix of funnel stages for tone/CTA testing"
        else
            warn "Limited funnel stage variety"
        fi
    else
        warn "Calendar missing funnel stage data"
        echo "   This is optional - workflow will use default (Consideration)"
    fi
fi

echo ""

# Test 5: Content Mix Distribution
echo "Test 5: Content Mix Configuration"
echo "----------------------------------"

if [ -f "$CALENDAR_PATH" ]; then
    if grep -q "Content Mix Distribution" "$CALENDAR_PATH"; then
        pass "Calendar contains content mix distribution"

        echo "   Content Mix Targets:"
        grep -A 10 "Content Mix Distribution" "$CALENDAR_PATH" | grep "%" | sed 's/^/   /'
    else
        fail "Calendar missing content mix distribution section"
        echo "   Suggestion: Regenerate calendar with /content-calendar"
    fi
fi

echo ""

# Test 6: Theme Index
echo "Test 6: Theme Index for Deduplication"
echo "--------------------------------------"

THEME_INDEX="project/Calendar/theme-index.json"

if [ -f "$THEME_INDEX" ]; then
    pass "Theme index exists: $THEME_INDEX"

    # Check if it has content
    if [ -s "$THEME_INDEX" ]; then
        pass "Theme index has content"

        # Count indexed articles
        ARTICLE_COUNT=$(grep -c '"article_id"' "$THEME_INDEX" || echo 0)
        echo "   Indexed articles: $ARTICLE_COUNT"

        if [ $ARTICLE_COUNT -gt 5 ]; then
            pass "Sufficient history for deduplication testing"
        else
            warn "Limited article history (< 6 articles)"
        fi
    else
        fail "Theme index is empty"
    fi
else
    warn "Theme index not found: $THEME_INDEX"
    echo "   This is optional - run theme-index-builder skill to create"
fi

echo ""

# Test 7: Command File Modifications
echo "Test 7: File Modifications Check"
echo "---------------------------------"

WRITE_ARTICLE="plugins/content-generator/commands/write-article.md"
RESEARCHER="plugins/content-generator/agents/researcher.md"
WRITER="plugins/content-generator/agents/writer.md"
EDITOR="plugins/content-generator/agents/editor.md"

# Check write-article.md
if grep -q "Step 1C: Load Calendar Context" "$WRITE_ARTICLE"; then
    pass "write-article.md has Step 1C (Load Calendar Context)"
else
    fail "write-article.md missing Step 1C"
fi

if grep -q "Tier-Adaptive Research" "$WRITE_ARTICLE"; then
    pass "write-article.md has tier-adaptive research logic"
else
    fail "write-article.md missing tier-adaptive research"
fi

# Check researcher.md
if grep -q "skip_full_gap_analysis" "$RESEARCHER"; then
    pass "researcher.md has conditional gap analysis skip logic"
else
    fail "researcher.md missing skip logic"
fi

# Check writer.md
if grep -q "Phase 0A: Load Funnel Stage Context" "$WRITER"; then
    pass "writer.md has Phase 0A (Funnel Stage Context)"
else
    fail "writer.md missing Phase 0A"
fi

# Check editor.md
if grep -q "Phase 2.1: Funnel Stage Validation" "$EDITOR"; then
    pass "editor.md has Phase 2.1 (Funnel Stage Validation)"
else
    fail "editor.md missing Phase 2.1"
fi

echo ""

# Summary
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo -e "${GREEN}Passed:${NC} $PASSED"
echo -e "${YELLOW}Warnings:${NC} $WARNINGS"
echo -e "${RED}Failed:${NC} $FAILED"
echo ""

if [ $FAILED -eq 0 ] && [ $WARNINGS -lt 3 ]; then
    echo -e "${GREEN}✅ Integration looks good! Ready for production testing.${NC}"
    exit 0
elif [ $FAILED -eq 0 ]; then
    echo -e "${YELLOW}⚠️ Integration functional but has warnings. Review above.${NC}"
    exit 0
else
    echo -e "${RED}❌ Integration has failures. Review above and fix issues.${NC}"
    exit 1
fi
