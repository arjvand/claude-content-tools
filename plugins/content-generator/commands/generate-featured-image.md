---
name: generate-featured-image
description: Generate a Nano Banana JSON prompt for article featured image (cross-industry)
argument-hint: [article-id] (e.g., "ART-202511-001")
allowed-tools: Read, Write, Bash, Glob, Grep
---

# Generate Featured Image Prompt

Generate a Nano Banana Pro (Gemini 2.5 Flash) JSON prompt for creating an on-brand featured image from article content.

## Usage

```bash
/generate-featured-image ART-202511-001
```

* Argument: Article ID (e.g., ART-202511-001)

---

## Phase 0: Validate Inputs

### Step 1: Verify Article Exists

```bash
ls -la "project/Articles/$1/"
```

**Required files:**
- `article.md` (final article content)
- `meta.yml` (article metadata)

**BLOCKING CHECKPOINT:** If article directory doesn't exist or required files are missing, STOP and report error:

```
ERROR: Article not found at project/Articles/[ARTICLE-ID]/
ACTION: Verify article ID and ensure article has been generated via /write-article
```

### Step 2: Verify Style Configuration

```bash
ls -la "project/graphic.json"
```

**BLOCKING CHECKPOINT:** If graphic.json doesn't exist, STOP and report error:

```
ERROR: Style configuration not found at project/graphic.json

REQUIRED SETUP:
1. Copy the template to your project:
   cp plugins/content-generator/examples/graphic-template.json project/graphic.json

2. Customize the template with your brand colors and visual style
   Edit: project/graphic.json

3. Then retry this command

TEMPLATE LOCATION: plugins/content-generator/examples/graphic-template.json
```

---

## Phase 1: Generate Prompt

**Invoke the `featured-image-generator` skill:**

```
Please use the featured-image-generator skill to generate a Nano Banana JSON prompt.

**Inputs:**
- Article ID: $1
- Article path: project/Articles/$1/article.md
- Metadata path: project/Articles/$1/meta.yml
- Style config: project/graphic.json

**Output:** project/Articles/$1/featured-image-prompt.json
```

The skill will:
1. Load style configuration from `project/graphic.json`
2. Read article content and metadata
3. Analyze themes, metaphors, and key concepts
4. Map category to visual motifs and mood
5. Generate structured JSON prompt
6. Save to `project/Articles/[ARTICLE-ID]/featured-image-prompt.json`

---

## Phase 2: Summary Report

After the skill completes, output summary:

```markdown
## Featured Image Prompt Generated

**Article ID:** [ARTICLE-ID]
**Article:** [Title from meta.yml]
**Category:** [Category from meta.yml]
**Generated:** [Date]

### Visual Concept

**Subject:** [Main visual element]
**Symbolism:** [What it represents]
**Mood:** [Category-specific atmosphere]
**Colors:** [Primary, Accent from palette]

### JSON Preview

```json
{
  "subject": {
    "main_element": "[...]"
  }
}
```

(Full JSON saved to file)

### Validation
- ✅ Article content analyzed
- ✅ Theme mapping applied
- ✅ TBM brand palette enforced
- ✅ Exclusions verified
- ✅ JSON structure valid

### File Created
- `project/Articles/[ARTICLE-ID]/featured-image-prompt.json`

### Next Steps
1. Open Gemini 2.5 Flash (Nano Banana Pro)
2. Copy the `prompt` object from the JSON file
3. Generate image at 1200x675 (16:9)
4. Review for brand alignment
5. Save as featured image for article
```

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
ACTION: Ensure article is complete with both article.md and meta.yml
```

### Missing Style Configuration

```
ERROR: Style configuration not found at project/graphic.json

REQUIRED SETUP:
1. Copy the template to your project:
   cp plugins/content-generator/examples/graphic-template.json project/graphic.json

2. Customize the template with your brand colors and visual style
   Edit: project/graphic.json

3. Then retry this command

TEMPLATE LOCATION: plugins/content-generator/examples/graphic-template.json
```

### No Theme Mapping

```
WARNING: No theme mapping found for article keywords
ACTION: Using category motifs as fallback
RECOMMENDATION: Add theme mapping to graphic.json for better results
```

### Skill Errors

If the `featured-image-generator` skill reports errors, display them and suggest remediation.

---

## Example Output

For article ART-202511-001 "How to Brief a Designer Without the Back-and-Forth":

```json
{
  "meta": {
    "article_id": "ART-202511-001",
    "article_title": "How to Brief a Designer Without the Back-and-Forth",
    "category": "for-clients",
    "generated_at": "2025-11-20",
    "generator": "featured-image-generator v1.0"
  },
  "prompt": {
    "subject": {
      "main_element": "Two simplified hands passing a clear blueprint between them",
      "symbolism": "Clear communication, efficient handoff, mutual understanding",
      "abstraction_level": "conceptual, not literal"
    },
    "environment": {
      "setting": "minimal abstract space",
      "atmosphere": "confident, reassuring, approachable",
      "background": "soft gradient from deep blue to white"
    },
    "photography": {
      "lighting": "soft diffused studio lighting",
      "angle": "straight-on, centered",
      "texture": "clean, minimal grain",
      "depth_of_field": "shallow, subject in focus"
    },
    "style": {
      "approach": "minimalist abstract illustration",
      "rendering": "clean vector-like shapes",
      "color_palette": "TBM brand: deep blue, golden accent, white space"
    },
    "composition": {
      "framing": "centered with generous breathing room",
      "aspect_ratio": "16:9",
      "visual_weight": "balanced, calm"
    },
    "color_restriction": {
      "primary": "#1e3a5f (deep blue)",
      "accent": "#f0b429 (golden)",
      "background": "#ffffff",
      "max_colors": 4
    },
    "exclusions": [
      "no text or typography",
      "no logos or watermarks",
      "avoid stock photo clichés",
      "no crowded compositions",
      "no photorealistic human faces"
    ]
  },
  "usage_notes": {
    "platform": "Gemini 2.5 Flash (Nano Banana Pro)",
    "instruction": "Copy the 'prompt' object and use with Nano Banana",
    "recommended_size": "1200x675"
  }
}
```
