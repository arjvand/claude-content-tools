# Example Project - Task Management API

## Bash Commands
- `npm run dev`: Start development server on http://localhost:3000 with hot reload
- `npm run build`: Build production bundle with optimizations
- `npm run test`: Run full test suite (unit + integration, ~12 seconds)
- `npm run test:unit`: Run only unit tests (~3 seconds, use for TDD)
- `npm run test:integration`: Run only integration tests (~10 seconds)
- `npm run test:watch`: Run tests in watch mode for active development
- `npm run lint`: Check code style with ESLint and Prettier
- `npm run typecheck`: Verify TypeScript types across entire codebase
- `npm run db:migrate`: Run pending database migrations
- `npm run db:seed`: Seed database with sample data for development
- `docker-compose up -d`: Start PostgreSQL, Redis, and MailHog containers
- `docker-compose down`: Stop all Docker containers
- `npm run docs`: Generate API documentation from OpenAPI spec

## Code Style
- Use TypeScript for ALL new files - no JavaScript allowed
- Prefer functional React components with hooks over class components
- Use named exports exclusively - NEVER use default exports
- Import order: React → Third-party libraries → Internal modules → Types
- IMPORTANT: All exported functions and classes MUST have JSDoc comments
- Use `const` over `let`, absolutely never use `var`
- Prefer template literals (`\`Hello ${name}\``) over string concatenation
- Async functions: use async/await, not .then() chaining
- Error handling: ALWAYS use try/catch in async functions
- Destructure imports when possible: `import { Button } from 'components'`

## Architecture
- Request flow: Route → Controller → Service → Repository → Database
- **Controllers** (`src/controllers/`): Handle HTTP requests/responses, validate input, call services
  - Keep thin - just HTTP concerns, no business logic
  - Return standardized response format using `src/utils/response.ts`
- **Services** (`src/services/`): Contain all business logic
  - No HTTP concerns (no req/res objects)
  - Can call multiple repositories
  - Handle complex operations and transformations
- **Repositories** (`src/repositories/`): Data access layer only
  - Use Knex query builder, NEVER raw SQL strings
  - Return plain objects, not database rows directly
- **Models** (`src/models/`): TypeScript interfaces and types
- **Utils** (`src/utils/`): Pure functions with no side effects
- CRITICAL: Never put database queries in controllers or services - always use repositories

## Testing
- Unit tests REQUIRED for all utility functions in `src/utils/`
- Integration tests REQUIRED for all API endpoints
- Test file naming: `src/foo/bar.ts` → `tests/foo/bar.test.ts`
- YOU MUST run `npm test` before committing - CI will reject failing tests
- Use `describe` blocks to group related tests logically
- Mock external services using factories in `tests/mocks/`
- Database: Use test database, reset between tests via `beforeEach`
- IMPORTANT: Test edge cases, not just happy paths
- Coverage requirement: minimum 80% for new code

## Workflow
- Branch naming: `feature/short-description`, `fix/bug-description`, `refactor/what-changed`
- IMPORTANT: Use `git pull --rebase`, never `git pull` (prevents merge commits)
- Commit messages: Follow [Conventional Commits](https://www.conventionalcommits.org/)
  - Format: `type(scope): description`
  - Examples: `feat(auth): add password reset`, `fix(api): handle null user IDs`
- Always run `npm run typecheck` after making changes
- Always run `npm run lint` before committing
- Update `CHANGELOG.md` for user-facing changes
- CRITICAL: Request code review from at least one team member before merging
- Squash commits when merging to main (use GitHub's squash merge)

## Development Environment
- Requires Node.js 18.x specifically - 19.x and 20.x break some dependencies
  - Run `nvm use` to automatically switch to correct version (see .nvmrc)
- MUST use PostgreSQL 15+ - we rely on JSONB functions added in v15
- Redis 7.0+ required for session storage
- Environment variables: Copy `.env.example` to `.env` and fill in values
  - NEVER commit `.env` to version control
  - See `.env.example` for required variables
- First-time setup: `npm ci && npm run db:migrate && npm run db:seed`
- CRITICAL: Run `npm run db:migrate` before starting dev server after pulling
- macOS: Install libpq via `brew install libpq` and add to PATH
- Linux: Install postgresql-client via package manager
- If you see "MODULE_NOT_FOUND" errors, delete `node_modules/` and run `npm ci`

## Important Notes
- Database uses soft deletes via `deleted_at` column
  - ALWAYS add `WHERE deleted_at IS NULL` to queries
  - Use `repository.findActive()` helper methods
- NEVER use `console.log()` in code - it breaks production logs
  - Use `logger` from `src/utils/logger.ts` instead
  - Levels: `logger.debug()`, `logger.info()`, `logger.warn()`, `logger.error()`
- Image uploads timeout in development environment (this is normal)
  - Works fine in staging and production with proper S3 configuration
- API rate limiting is disabled in development, active in staging/production
  - Test rate limiting using staging environment before deploying
- The `tasks` table is partitioned by `workspace_id`
  - MUST include `workspace_id` in WHERE clause for optimal performance
  - Index queries will fail without this filter
- Session cookies use `sameSite: 'lax'` in production
  - Cross-origin requests need CORS configuration (see `src/config/cors.ts`)
- Background jobs use Bull queue with Redis
  - Monitor queue at http://localhost:3000/admin/queues (dev only)
  - Job failures retry 3 times with exponential backoff
- CRITICAL: User passwords are hashed with bcrypt (12 rounds)
  - NEVER store or log plain text passwords
  - Use `authService.hashPassword()` and `authService.comparePassword()`

## Common Issues
- **Port 3000 already in use**: Kill the process with `lsof -ti:3000 | xargs kill`
- **Database connection fails**: Ensure Docker containers are running (`docker-compose ps`)
- **Tests fail after migration**: Run `npm run db:migrate` in test environment
- **TypeScript errors after npm install**: Restart your IDE's TypeScript server
- **Redis connection errors**: Check Redis is running in Docker, restart container if needed