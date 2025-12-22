---
description: Generate Nano Banana (Gemini 2.5 Flash) JSON prompts for article featured images
---

# Featured Image Generator Skill

Generate structured JSON prompts for Nano Banana Pro (Gemini 2.5 Flash) image generation, tailored to article content and TBM brand guidelines.

---

## Purpose

Transform article content into a well-structured JSON prompt that produces consistent, on-brand featured images:
- Analyzes article themes, concepts, and metaphors
- Maps content to visual motifs based on category
- Enforces TBM brand palette and style guidelines
- Outputs Nano Banana-compatible JSON prompt

---

## When to Use

**Automatic triggers:**
- Via `/generate-featured-image` command after article completion
- Optional integration in `/write-article` Phase 8 (Exports & Packaging)

**Manual triggers:**
- When preparing visual assets for any published article
- When regenerating featured image with updated article content

---

## Inputs

| Input | Source | Required |
|-------|--------|----------|
| Article ID | Command argument | Yes |
| Article content | `project/Articles/[ARTICLE-ID]/article.md` | Yes |
| Article metadata | `project/Articles/[ARTICLE-ID]/meta.yml` | Yes |
| Style configuration | `project/graphic.json` | Yes |
| Brand configuration | `project/requirements.md` | Yes (for brand voice context) |

### Required Fields from meta.yml

- `title` - Article headline
- `category` - Blog category (for-clients, for-creators, future-of-work)
- `target_keyword` - Primary topic keyword
- `secondary_keywords` - Additional topic context

### Optional Fields from meta.yml

- `format` - Article format (tutorial, playbook, pov-essay, etc.)
- `differentiation_tactics` - Unique angles to emphasize visually

---

## Process

### Step 1: Load Configuration

Read style and brand configuration:

```bash
cat "project/graphic.json"
cat "project/requirements.md"
```

Extract from graphic.json:
- Default style settings (colors, photography, composition)
- Category-specific overrides (mood, motifs)
- Theme mappings (visual concepts per topic)
- Exclusions (what to avoid)

### Step 2: Load Article Sources

Read article content and metadata:

```bash
cat "project/Articles/[ARTICLE-ID]/article.md"
cat "project/Articles/[ARTICLE-ID]/meta.yml"
```

### Step 3: Content Analysis

Analyze article to extract visual elements:

| Extraction | What to Find | Method |
|------------|--------------|--------|
| **Core Theme** | Primary concept the article explores | Title + first 3 paragraphs |
| **Category** | for-clients, for-creators, future-of-work | meta.yml `category` field |
| **Key Metaphors** | Analogies, comparisons, symbolic language | Scan for "like", "as if", metaphorical phrases |
| **Action Concepts** | What the reader does or achieves | Verbs in H2 headings, TL;DR bullets |
| **Emotional Tone** | Empowerment, clarity, trust, innovation | Brand voice + article language |
| **Topic Keywords** | Specific themes (pricing, collaboration, AI) | target_keyword + secondary_keywords |

**Theme Detection Priority:**
1. Match keywords against `theme_mappings` in graphic.json
2. Fall back to category-specific `motifs`
3. Derive from article metaphors if no direct match

### Step 4: Visual Concept Generation

Based on analysis, determine:

**Subject Selection:**
1. Identify 1-2 theme mappings that match article content
2. Select visual concept from mapped options
3. Combine with category mood and atmosphere
4. Ensure abstraction (conceptual, not literal)

**Environment Selection:**
1. Use defaults from graphic.json `composition`
2. Apply category-specific `atmosphere`
3. Maintain minimal, clean aesthetic

**Color Application:**
1. Use TBM palette from graphic.json
2. Apply color emphasis per theme mapping
3. Limit to max_colors (4)

### Step 5: Generate JSON Prompt

Construct structured Nano Banana JSON:

```json
{
  "meta": {
    "article_id": "[ARTICLE-ID]",
    "article_title": "[from meta.yml]",
    "category": "[from meta.yml]",
    "generated_at": "YYYY-MM-DD",
    "generator": "featured-image-generator v1.0"
  },
  "prompt": {
    "subject": {
      "main_element": "[visual concept derived from article]",
      "symbolism": "[what it represents]",
      "abstraction_level": "conceptual, not literal"
    },
    "environment": {
      "setting": "minimal abstract space",
      "atmosphere": "[from category_overrides]",
      "background": "[gradient or solid from palette]"
    },
    "photography": {
      "lighting": "[from defaults.photography]",
      "angle": "[from defaults.photography]",
      "texture": "[from defaults.photography]",
      "depth_of_field": "[from defaults.photography]"
    },
    "style": {
      "approach": "[from defaults.style]",
      "rendering": "[from defaults.rendering]",
      "color_palette": "TBM brand: [primary_name], [accent_name], white space"
    },
    "composition": {
      "framing": "[from defaults.composition]",
      "aspect_ratio": "[from defaults.aspect_ratio]",
      "visual_weight": "[from defaults.composition]"
    },
    "color_restriction": {
      "primary": "[from color_palette.primary] ([primary_name])",
      "accent": "[from color_palette.accent] ([accent_name])",
      "background": "[from color_palette.background]",
      "max_colors": 4
    },
    "exclusions": [
      "[from exclusions.never_include]"
    ]
  },
  "usage_notes": {
    "platform": "Gemini 2.5 Flash (Nano Banana Pro)",
    "instruction": "Copy the 'prompt' object and use with Nano Banana",
    "recommended_size": "[from defaults.recommended_size]"
  }
}
```

### Step 6: Save Output

Save JSON to article directory:

```bash
# Output path
project/Articles/[ARTICLE-ID]/featured-image-prompt.json
```

---

## Output Format

```markdown
# Featured Image Prompt: [ARTICLE-ID]
## [Article Title]

**Article ID:** [ARTICLE-ID]
**Category:** [category]
**Generated:** YYYY-MM-DD

---

## Generated JSON Prompt

```json
[Full JSON output here]
```

---

## Visual Concept Summary

**Subject:** [description of main visual element]
**Symbolism:** [what it represents in context of article]
**Mood:** [atmosphere from category]
**Color Emphasis:** [which colors lead]

---

## Usage Instructions

1. Open Gemini 2.5 Flash (Nano Banana Pro)
2. Copy the `prompt` object from the JSON file
3. Paste as structured input
4. Generate at recommended size: 1200x675 (16:9)
5. Review output for brand alignment
6. Regenerate with adjustments if needed

---

**Generation Status:** COMPLETE
**Ready for Use:** Yes
```

---

## Quality Guidelines

### DO

- Extract the most evocative metaphor or concept from the article
- Keep visual concepts abstract and symbolic
- Maintain generous negative space in composition
- Use the exact hex codes from graphic.json
- Verify theme mapping exists before generating

### DON'T

- Use literal representations (no generic office scenes)
- Include any text, logos, or typography
- Overcomplicate with multiple subjects
- Deviate from the 4-color maximum
- Use stock photo clichés listed in exclusions
- Generate without reading the full article first

---

## Theme Mapping Reference

The skill maps article keywords to visual concepts. Common mappings:

| Theme | Visual Concepts |
|-------|-----------------|
| Collaboration | Interlocking shapes, bridges, joined hands |
| Pricing | Balanced scales, clear containers, transparent layers |
| AI Workflows | Human hand + geometric helper, parallel paths |
| Growth | Ascending stairs, sprouting seeds, expanding circles |
| Trust | Open hands, transparent boxes, secure foundations |
| Process | Sequential steps, flowchart elements, journey paths |
| Fairness | Balanced elements, equal portions, shared space |

If no direct mapping exists, derive from category motifs.

---

## Error Handling

### Article Not Found

```
ERROR: Article directory not found at project/Articles/[ARTICLE-ID]/
ACTION: Verify article ID and ensure article has been generated via /write-article
```

### Missing Required Files

```
ERROR: Required file missing: [article.md|meta.yml]
ACTION: Ensure article is complete with both files
```

### Missing graphic.json

```
ERROR: Style configuration not found at project/graphic.json
ACTION: Create graphic.json from template or restore from repository
```

### No Theme Mapping Found

```
WARNING: No theme mapping found for keywords: [keywords]
ACTION: Falling back to category motifs
RECOMMENDATION: Consider adding theme mapping to graphic.json
```

### Missing Category

```
WARNING: Category not specified in meta.yml
ACTION: Using default settings (no category-specific overrides)
RECOMMENDATION: Add category field to meta.yml
```

---

## Integration

### From /generate-featured-image Command

```markdown
**Invoke the `featured-image-generator` skill:**

Please use the featured-image-generator skill to generate a Nano Banana JSON prompt.

**Inputs:**
- Article ID: [ARTICLE-ID]
- Article path: project/Articles/[ARTICLE-ID]/article.md
- Metadata path: project/Articles/[ARTICLE-ID]/meta.yml

**Output:** project/Articles/[ARTICLE-ID]/featured-image-prompt.json
```

### From /write-article Command (Phase 8 - Optional)

```markdown
**Optional: Generate Featured Image Prompt**

If featured image generation is needed, invoke `featured-image-generator` skill:
- Input: Completed article from Phase 6
- Output: featured-image-prompt.json alongside article.md
```

---

## Customization

### Adding New Theme Mappings

Edit `project/graphic.json` and add to `theme_mappings`:

```json
"new_theme": {
  "visual_concepts": ["concept1", "concept2", "concept3"],
  "color_emphasis": "primary with accent highlights"
}
```

### Adding Category-Specific Overrides

Edit `project/graphic.json` and modify `category_overrides`:

```json
"new-category": {
  "mood": "description of mood",
  "motifs": ["motif1", "motif2"],
  "atmosphere": "atmosphere description"
}
```

### Changing Default Style

Edit `project/graphic.json` defaults section to modify:
- Photography settings (lighting, angle, texture)
- Composition rules (framing, negative space)
- Color palette (TBM brand colors)

---

## Adaptation Notes

This skill reads configuration from `project/graphic.json` at runtime, making it adaptable to:
- Different brand palettes (update color_palette)
- Different visual styles (update defaults.style)
- New content categories (add category_overrides)
- New topic themes (add theme_mappings)

The JSON output format is optimized for Nano Banana Pro but can be adapted for other structured prompt systems by modifying the prompt structure in Step 5.
