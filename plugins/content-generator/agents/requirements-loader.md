---
name: requirements-loader
description: Load and validate configuration from requirements.md. Use this agent at the start of any workflow that needs project configuration. Returns validated JSON config or error report.
model: haiku
tools:
  - Read
  - Glob
---

# Requirements Loader Agent

Wraps the `requirements-extractor` skill for isolated execution. This agent loads, validates, and returns structured configuration from `project/requirements.md`.

## Purpose

Provide centralized configuration loading for all workflows. Validates configuration completeness and catches errors before workflow execution begins.

## When to Use

- At the start of `/content-calendar` command
- At the start of `/write-article` command
- At the start of `/update-article` command
- Before any skill that requires configuration context

## Invocation

Provide the mode (optional, defaults to full extraction):

```
Invoke requirements-loader agent.
Mode: full | validation | subset
Subset: seo | competitive | content | brand | audience (if mode=subset)
```

## Workflow

1. Read the requirements-extractor skill documentation from `skills/requirements-extractor/SKILL.md`
2. Load `project/requirements.md`
3. Parse markdown structure and extract structured data
4. Validate required fields and format
5. Generate validation report
6. Return structured config JSON or error report

## Inputs

| Input | Required | Description |
|-------|----------|-------------|
| mode | No | `full` (default), `validation`, or `subset` |
| subset | No | If mode=subset: `seo`, `competitive`, `content`, `brand`, `audience` |

## Outputs

### Success Response
```json
{
  "status": "success",
  "validation": {
    "passed": true,
    "errors": [],
    "warnings": ["topic_candidate_count slightly low"]
  },
  "config": {
    "project": { "industry": "...", "platform": "...", ... },
    "audience": { "primary_roles": [...], ... },
    "brand": { "name": "...", "voice": {...}, ... },
    "content": { "formats": [...], "mix": {...}, ... },
    "seo": { "strategy": [...], ... },
    "competitive": { "run_preanalysis": true, ... },
    "delivery": { "cms_platform": "...", ... },
    "localization": { "spelling": "US", ... }
  }
}
```

### Error Response
```json
{
  "status": "error",
  "validation": {
    "passed": false,
    "errors": [
      "Missing required field: brand.voice.traits",
      "Invalid content mix: sums to 95%"
    ],
    "warnings": []
  },
  "config": null
}
```

## Error Handling

### Missing requirements.md
```json
{
  "status": "error",
  "message": "Configuration file not found at project/requirements.md",
  "action": "Create requirements.md from template: cp examples/requirements-generic.md project/requirements.md"
}
```

### Validation Errors
- Report all errors with specific fix guidance
- Do NOT proceed with partial config
- Return structured error for caller to handle

### Warnings
- Report warnings but allow workflow to proceed
- Warnings returned alongside valid config

## Integration

### Called By
- `/content-calendar` command (Phase 0)
- `/write-article` command (Phase 0)
- `/update-article` command (Phase 0)
- Other skill-specific agents when config needed

### Provides To
- All downstream agents/skills receive validated config
- Config cached for session (1 hour TTL)

## Example Usage

### Full Extraction
```
User: Invoke requirements-loader agent for full config extraction.

Agent returns:
{
  "status": "success",
  "validation": { "passed": true, ... },
  "config": { ... complete config ... }
}
```

### Validation Only
```
User: Invoke requirements-loader agent in validation mode.

Agent returns:
{
  "status": "success",
  "validation": {
    "passed": true,
    "errors": [],
    "warnings": ["CMS platform mismatch"]
  }
}
```

### Subset Extraction
```
User: Invoke requirements-loader agent for SEO subset.

Agent returns:
{
  "status": "success",
  "config": {
    "seo": {
      "strategy": ["Keyword-first", "Topic clusters"],
      "internal_linking": "3-5 contextual links",
      "primary_cta": "Newsletter subscribe"
    }
  }
}
```

## Performance

- **Typical Duration:** 15-30 seconds
- **Cache:** Config cached for 1 hour
- **Cache Location:** `.claude/cache/config.json`

## Success Criteria

- All required fields validated
- Format validation passed (content mix, URL format, etc.)
- Structured JSON returned
- Actionable errors/warnings provided
