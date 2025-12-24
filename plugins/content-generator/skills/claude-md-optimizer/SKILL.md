---
name: claude-md-optimizer
description: Create, audit, and optimize CLAUDE.md files for Claude Code projects. Use when setting up new projects, reviewing existing CLAUDE.md files, or improving instruction effectiveness.
---

# CLAUDE.md Optimizer Skill

## Purpose
This skill helps Claude Code users create, maintain, and optimize CLAUDE.md files for their projects. CLAUDE.md files are automatically pulled into context when starting Claude Code conversations, making them critical for providing consistent, project-specific guidance.

## When to Use This Skill
- Creating a new CLAUDE.md file for a project
- Auditing an existing CLAUDE.md for completeness and effectiveness
- Optimizing CLAUDE.md content for better instruction following
- Migrating or updating CLAUDE.md after major project changes
- Ensuring team-wide CLAUDE.md consistency across repositories

## Core Principles

### 1. Keep It Concise and Actionable
CLAUDE.md files are part of every prompt, consuming tokens. Make every line count:
- ✅ Write clear, specific instructions
- ✅ Use simple, scannable formatting
- ✅ Focus on what's different or unexpected about this project
- ❌ Don't duplicate information Claude already knows
- ❌ Avoid verbose explanations or background information

### 2. Human-Readable Format
No required format, but keep it readable for both Claude and humans:
- Use markdown headers for organization
- Use bullet points for lists
- Include code examples where helpful
- Keep instructions imperative and direct

### 3. Iterative Refinement
Treat CLAUDE.md like any frequently used prompt:
- Test instructions to see if Claude follows them
- Add emphasis (IMPORTANT, YOU MUST) for critical guidelines
- Run through prompt improver periodically
- Remove or refine instructions that don't improve results

## What to Include in CLAUDE.md

### Essential Sections

#### 1. Bash Commands
Document commonly used commands that might not be obvious:
```markdown
# Bash Commands
- `npm run dev`: Start development server on port 3000
- `npm run typecheck`: Run TypeScript type checker
- `make test-unit`: Run unit tests (fast, use for iteration)
- `make test-integration`: Run integration tests (slow, use before commits)
- `docker-compose up -d`: Start local database and Redis
```

#### 2. Core Files and Architecture
Help Claude understand your codebase structure:
```markdown
# Core Files
- `src/utils/logger.ts`: Central logging utility - use for all logging
- `src/config/database.ts`: Database connection configuration
- `tests/helpers/`: Shared test utilities and fixtures
- `.github/workflows/`: CI/CD pipeline definitions

# Architecture
- API routes in `src/routes/` map to `src/controllers/`
- Business logic stays in `src/services/`, not in controllers
- Database queries use the query builder in `src/db/`, not raw SQL
```

#### 3. Code Style Guidelines
Document project-specific style choices:
```markdown
# Code Style
- Use ES modules (import/export), not CommonJS (require)
- Destructure imports: `import { foo } from 'bar'`
- Prefer async/await over .then() for promises
- Use functional components with hooks, not class components
- IMPORTANT: Always add JSDoc comments to exported functions
```

#### 4. Testing Instructions
Clarify testing expectations:
```markdown
# Testing
- Write unit tests for all new functions in `src/utils/`
- Integration tests required for new API endpoints
- YOU MUST run tests before committing: `npm run test`
- Test files should mirror source structure: `src/foo/bar.ts` → `tests/foo/bar.test.ts`
- Use `describe` blocks to group related tests
```

#### 5. Repository Etiquette
Document team workflow preferences:
```markdown
# Workflow
- Branch naming: `feature/description`, `fix/description`, `refactor/description`
- IMPORTANT: Rebase, don't merge - use `git pull --rebase`
- Commit messages: Use conventional commits format
- Always typecheck after making changes: `npm run typecheck`
- Update CHANGELOG.md for user-facing changes
```

#### 6. Development Environment
Document setup requirements and quirks:
```markdown
# Development Environment
- Requires Node.js 18+ (use `nvm use` to switch)
- IMPORTANT: Run `npm install` after pulling - package-lock changes frequently
- Use Python 3.11 specifically - 3.12 breaks some dependencies
- macOS: Install libvips via `brew install vips` for image processing
- MUST use PostgreSQL 15+ - older versions lack required features
```

#### 7. Project-Specific Quirks
Document unexpected behaviors or workarounds:
```markdown
# Important Notes
- CRITICAL: Always run migrations before starting dev server
- The `user` table has a soft-delete column - use `deleted_at IS NULL` in queries
- Image uploads timeout in development - this is expected, works in production
- Don't use `console.log` - it breaks in production. Use `logger` instead
- API rate limiting is disabled in development but active in staging
```

## CLAUDE.md File Locations

### Where to Place CLAUDE.md Files

1. **Repository Root** (most common)
   - Name: `CLAUDE.md` (check into git) or `CLAUDE.local.md` (gitignored)
   - Pulled in automatically when you run `claude` from this directory
   - Shared across team when checked into version control

2. **Parent Directories** (for monorepos)
   - Place `CLAUDE.md` in both `root/` and `root/foo/`
   - When running `claude` from `root/foo/`, both files are included
   - Useful for repo-wide + package-specific instructions

3. **Child Directories**
   - Auto-included when working with files in those directories
   - Good for package-specific or module-specific guidance

4. **Home Directory**
   - Location: `~/.claude/CLAUDE.md`
   - Applied to ALL Claude Code sessions
   - Use for personal preferences across all projects

### Choosing gitignored vs. checked-in

**Check into git** (`CLAUDE.md`) when:
- Instructions benefit the entire team
- Content is project-specific, not personal
- You want consistency across team members
- Guidelines relate to code style, architecture, workflows

**Gitignore** (`CLAUDE.local.md`) when:
- Instructions are personal preferences
- Content includes sensitive information
- Different team members need different setups
- Testing experimental instructions

## Optimization Strategies

### 1. Test Instruction Effectiveness
After adding new instructions:
```bash
# Test if Claude follows the instruction
claude -p "Create a new API endpoint for user authentication"

# Observe: Does Claude follow your style guidelines?
# If not, refine the instruction or add emphasis
```

### 2. Use the # Key for Iterative Updates
While coding, press `#` to tell Claude to add something to CLAUDE.md:
```
# Add this bash command to CLAUDE.md
# Update CLAUDE.md with this code style rule
# Document this in CLAUDE.md
```

### 3. Add Emphasis for Critical Rules
When Claude consistently ignores an instruction:
```markdown
Before: Write tests for new functions
After: IMPORTANT: YOU MUST write unit tests for all new functions
```

### 4. Run Through Prompt Improver
Periodically improve your CLAUDE.md:
- Copy CLAUDE.md content
- Use Anthropic's prompt improver tool
- Integrate improvements back into your file
- Test to ensure improved adherence

### 5. Remove Ineffective Instructions
If an instruction doesn't improve Claude's behavior:
- Remove it to save tokens
- Consider if it's too vague or too obvious
- Try rephrasing with more specificity

## Common Patterns and Examples

### Pattern: Command Reference with Context
❌ Bad:
```markdown
- npm start
- npm test
```

✅ Good:
```markdown
- `npm run dev`: Starts dev server on port 3000 with hot reload
- `npm run test:unit`: Fast tests (~2s), use for TDD iteration  
- `npm run test:e2e`: Slow tests (~30s), run before commits
```

### Pattern: Code Style with Rationale
❌ Bad:
```markdown
Use async/await
```

✅ Good:
```markdown
- Prefer async/await over .then() for better readability and error handling
- IMPORTANT: Always handle errors with try/catch in async functions
```

### Pattern: Architecture Guidance
❌ Bad:
```markdown
Controllers are in src/controllers
```

✅ Good:
```markdown
# Architecture Pattern
- Request → Route → Controller → Service → Repository → Database
- Controllers in `src/controllers/`: Handle HTTP, validate input, call services
- Services in `src/services/`: Business logic only, no HTTP concerns
- CRITICAL: Never put database queries in controllers - use repositories
```

### Pattern: Environment-Specific Notes
❌ Bad:
```markdown
Use Node 18
```

✅ Good:
```markdown
# Development Environment
- MUST use Node.js 18.x specifically - 19.x breaks build process
- Run `nvm use` to auto-switch to correct version (see .nvmrc)
- If getting "MODULE_NOT_FOUND" errors, delete node_modules and run `npm ci`
```

## Audit Checklist

When auditing a CLAUDE.md file, check for:

- [ ] **Conciseness**: Every line provides value, no fluff
- [ ] **Specificity**: Instructions are clear and actionable
- [ ] **Scannability**: Easy to read with good formatting
- [ ] **Completeness**: Covers bash commands, code style, testing, workflow, environment
- [ ] **Accuracy**: All commands and paths are correct and up-to-date
- [ ] **Emphasis**: Critical rules use IMPORTANT, MUST, CRITICAL appropriately
- [ ] **Examples**: Complex patterns include code examples
- [ ] **Relevance**: Content is project-specific, not generic advice
- [ ] **Testing**: Instructions have been tested with actual Claude Code usage
- [ ] **Maintenance**: File is up-to-date with recent project changes

## Creating a New CLAUDE.md

### Approach 1: Use /init Command
```bash
# Claude will auto-generate a CLAUDE.md
claude
/init
```

### Approach 2: Manual Creation
1. **Start with template sections:**
   - Bash Commands
   - Code Style  
   - Workflow
   - Testing
   - Development Environment
   - Important Notes

2. **Fill in project-specific details:**
   - Run common commands and document them
   - Note any non-standard practices
   - Document build/test procedures
   - List environment requirements

3. **Test and iterate:**
   - Use Claude Code for typical tasks
   - Note when Claude doesn't follow expectations
   - Add/refine instructions based on observations

4. **Get team input:**
   - Share with team for feedback
   - Incorporate pain points others have experienced
   - Ensure accuracy of technical details

## Advanced Techniques

### Multi-File Strategy for Monorepos
```
repo/
├── CLAUDE.md              # Repo-wide guidelines
├── frontend/
│   ├── CLAUDE.md          # Frontend-specific
│   └── package.json
└── backend/
    ├── CLAUDE.md          # Backend-specific
    └── package.json
```

### Personal + Project Combination
```
~/.claude/CLAUDE.md        # Your personal preferences (all projects)
~/project/CLAUDE.md        # Project guidelines (team-shared)
~/project/CLAUDE.local.md  # Your project-specific tweaks (gitignored)
```

### Dynamic Content via Scripts
While CLAUDE.md is static, you can reference dynamic commands:
```markdown
# Bash Commands
- `./scripts/show-env.sh`: Display current environment configuration
- `./scripts/current-version.sh`: Show current version and changelog
```

### Integration with MCP Servers
Document MCP tools available in the project:
```markdown
# Available Tools
- This project has Puppeteer MCP server configured
- Use it for browser automation and screenshot testing
- Example: "Take a screenshot of the login page"
- Server config in `.mcp.json` - already set up for all team members
```

## Common Mistakes to Avoid

### ❌ Over-Documentation
```markdown
# Bad: Too verbose
The test command runs the entire test suite using Jest as the test runner.
Jest is a JavaScript testing framework developed by Facebook. It provides
a zero-configuration testing experience...
```

### ✅ Right Amount
```markdown
# Good: Concise and relevant
- `npm test`: Run test suite (uses Jest)
- Tests must pass before commits
```

### ❌ Generic Advice
```markdown
# Bad: Claude already knows this
- Write clean code
- Use meaningful variable names
- Handle errors properly
```

### ✅ Project-Specific Guidance
```markdown
# Good: Project-specific details
- User ID variables must be named `userId`, not `id` or `user_id`
- IMPORTANT: All API errors must use the AppError class from src/errors/
- Validation errors return 400, auth errors return 401, not 403
```

### ❌ Outdated Information
```markdown
# Bad: Outdated command
- `npm run build`: Builds for production

# (Command changed to `npm run build:prod` 3 months ago)
```

### ✅ Maintained and Current
```markdown
# Good: Current information
- `npm run build:prod`: Build optimized production bundle
- `npm run build:dev`: Build development bundle with source maps
```

## Measuring Success

Your CLAUDE.md is effective when:
- Claude consistently follows your code style without reminders
- Claude runs the right commands without trial and error
- New team members onboard faster with Claude's help
- You rarely need to correct Claude's approach to common tasks
- Claude understands project quirks and handles them appropriately

## Workflow Integration

### During Development
```bash
# As you work, update CLAUDE.md
claude
> "# Add this new test command to CLAUDE.md: npm run test:watch"
```

### In Code Reviews
- Check if new patterns should be in CLAUDE.md
- Update CLAUDE.md when team establishes new conventions
- Include CLAUDE.md updates in relevant PRs

### During Onboarding
- Point new team members to CLAUDE.md
- Have them use Claude Code for learning the codebase
- Capture their questions as potential CLAUDE.md additions

## Template: Comprehensive CLAUDE.md

```markdown
# Project Name

## Bash Commands
- `npm run dev`: Start development server on http://localhost:3000
- `npm run build`: Build production bundle
- `npm run test`: Run full test suite (~15 seconds)
- `npm run test:watch`: Run tests in watch mode for TDD
- `npm run lint`: Check code style with ESLint
- `npm run typecheck`: Verify TypeScript types
- `docker-compose up -d`: Start PostgreSQL and Redis containers

## Code Style
- Use TypeScript for all new files
- Prefer functional React components with hooks
- Use named exports, not default exports
- Import order: React → Third-party → Internal → Types
- IMPORTANT: All exported functions must have JSDoc comments
- Use `const` over `let`, never use `var`
- Prefer template literals over string concatenation

## Architecture
- Routes (`src/routes/`) → Controllers → Services → Repositories
- Controllers handle HTTP only, no business logic
- Services contain business logic, no HTTP concerns
- Repositories handle data access, use query builder not raw SQL
- CRITICAL: Never put database queries in controllers or services

## Testing
- Unit tests required for all utility functions
- Integration tests required for all API endpoints
- Test files mirror source: `src/foo/bar.ts` → `tests/foo/bar.test.ts`
- YOU MUST run `npm test` before committing
- Use `describe` blocks to group related tests
- Mock external APIs using `src/tests/mocks/`

## Workflow
- Branch naming: `feature/`, `fix/`, `refactor/` + description
- IMPORTANT: Use `git pull --rebase`, never merge
- Commit messages: Follow conventional commits format
- Always run typecheck after changes: `npm run typecheck`
- Update CHANGELOG.md for user-facing changes
- Request reviews from at least one team member

## Development Environment
- Requires Node.js 18.x (run `nvm use`)
- MUST use PostgreSQL 15+ for JSONB features
- Run `npm ci` after pulling, not `npm install`
- Environment variables in `.env` (copy from `.env.example`)
- CRITICAL: Run `npm run migrate` before starting dev server

## Important Notes
- Database uses soft deletes: check `deleted_at IS NULL` in queries
- Image uploads timeout in dev (normal), work fine in production
- API rate limiting disabled in dev, active in staging/prod
- NEVER use `console.log` - use `logger` from `src/utils/logger.ts`
- The `users` table is partitioned - queries need tenant_id in WHERE clause
```

## Quick Reference: When to Update CLAUDE.md

Update when:
- Adding new build/test commands
- Establishing new code conventions
- Changing development workflow
- Discovering project quirks
- Onboarding reveals knowledge gaps
- Team identifies repeated corrections to Claude
- Major dependencies or tools change
- Migrating to new patterns/architecture

Don't update for:
- Temporary instructions for specific tasks
- Personal to-do items or notes
- Information that changes frequently
- Generic programming advice
- Debugging notes for current issues

## Resources

- [Claude Code Documentation](https://docs.anthropic.com/en/docs/agents-and-tools/claude-code)
- [Best Practices Article](https://www.anthropic.com/engineering/claude-code-best-practices)
- [Prompt Engineering Guide](https://docs.claude.com/en/docs/build-with-claude/prompt-engineering/overview)
- [Prompt Improver Tool](https://docs.anthropic.com/en/docs/build-with-claude/prompt-engineering/prompt-improver)

---

## Usage Instructions for Claude

When a user asks you to help with CLAUDE.md:

1. **Creating**: Use the template above as a starting point, customize for their project
2. **Auditing**: Check against the audit checklist, note gaps and improvements
3. **Optimizing**: Look for verbosity, vague instructions, missing emphasis, outdated content
4. **Updating**: Ask what changed in the project, update relevant sections
5. **Testing**: Suggest specific scenarios to test if instructions are followed

Always ask questions about:
- Project type and tech stack
- Team size and workflow preferences
- Common pain points with Claude Code
- Development environment specifics
- Testing strategy and requirements