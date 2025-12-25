# Content Requirements Configuration

This file configures the content generation system. Agents read this file at runtime to adapt their behavior to React Mastery.

---

## PROJECT CONFIGURATION

### Primary Topic & Focus

* **Industry/Niche**: Frontend web development, React.js ecosystem
* **Focus Areas**: Performance optimization, component architecture, state management patterns, React hooks, Server Components, testing strategies, TypeScript integration, accessibility

### Official Documentation Sources

* **Primary Documentation**: [https://react.dev/](https://react.dev/)
* **Community Forums**: Stack Overflow (react, reactjs tags) • Reddit r/reactjs • Reactiflux Discord • GitHub Discussions
* **Official Blogs**: React.dev Blog • Next.js Blog • Vercel Engineering Blog
* **Repository**: [https://github.com/facebook/react](https://github.com/facebook/react) • [https://github.com/vercel/next.js](https://github.com/vercel/next.js)
* **Other Authoritative Sources**: MDN Web Docs • TC39 (JavaScript standards) • Web.dev • TypeScript Handbook

---

## AUDIENCE

### Target Readers

* **Primary Roles**: Frontend developers, React developers, full-stack JavaScript developers, technical leads, UI engineers
* **Skill Level**: Intermediate to advanced
* **Primary Segment**: Professional developers building production React applications; developers transitioning from class components to hooks; teams adopting React Server Components

---

## BRAND IDENTITY

### Brand Information

* **Brand Name**: React Mastery

### Brand Voice

* **Traits**: Technical, precise, code-first, pragmatic, performance-focused, pattern-oriented

#### Brand Voice Guidelines

**DO (On-Brand):**

* "Here's how to optimize your useEffect dependencies to prevent unnecessary re-renders..."
* "This pattern avoids prop drilling while maintaining type safety..."
* "Let's refactor this component to leverage concurrent features..."
* "Consider the trade-offs: client-side state management vs. server state..."

**DON'T (Off-Brand):**

* "The ULTIMATE React hooks guide you absolutely need!"
* "This will REVOLUTIONIZE your React app!"
* "React Server Components are killing client-side rendering!"
* "Just use this library and forget about performance issues." (oversimplification)

---

## CONTENT STRATEGY

### Content Objectives

* **Objective**: Educate React developers on modern best practices, performance optimization, and architectural patterns; establish authority in the React ecosystem; attract professional developers seeking production-grade solutions
* **Primary KPI**: Organic search traffic to React-related queries; newsletter sign-ups; GitHub stars on companion repos; time-on-page for tutorials; code snippet copy events

### Content Formats

* **Formats**: Step-by-step tutorials, architectural deep dives, performance case studies, code pattern libraries, comparative analyses, migration guides
* **Content Mix**: Tutorials (55%), Deep dives (30%), Pattern libraries (10%), Ecosystem news (5%)
* **Depth**: Primarily intermediate to advanced; occasional beginner-to-intermediate onboarding content
* **Length**: Tutorials: 1,200-2,200 words; Deep dives: 2,000-3,500 words; Pattern libraries: 800-1,500 words

### Topic Pillars

* **Primary Pillar**: React Performance Optimization
* **Secondary Pillars**:
  * State Management Patterns (Context, reducers, Zustand, Jotai)
  * Component Architecture & Composition
  * React Server Components & Next.js App Router
  * Testing & Type Safety (Vitest, Testing Library, TypeScript)
  * Accessibility & Internationalization

### SEO & Distribution

* **SEO Intent**: Target "how to optimize React", "React best practices", "React patterns", "useEffect vs useCallback", "Server Components tutorial" queries; build topic clusters around hooks, performance, and architecture
* **Internal Linking**: Hub-and-spoke model; each pattern article links to related patterns and performance implications
* **Primary CTA**: Subscribe to weekly React newsletter; download React patterns cheat sheet; star GitHub repo with examples
* **Distribution Channels**: Newsletter/RSS, Dev.to, LinkedIn, Twitter, r/reactjs, React Weekly newsletter, Hacker News (for deep dives)

### Quality & Review Process

* **SME Involvement**: Required for advanced React internals, performance benchmarking, and concurrent features content
* **Review Workflow**: Draft → Code review (all examples tested) → Technical accuracy check → Editorial QA → Publish
* **Cadence**: 2 posts/week (1 tutorial + 1 deep dive or pattern)
* **Product Announcements Scope**: Cover major React releases, significant Next.js updates, important ecosystem library releases (Remix, Astro, state management libs)

### Novelty Controls

#### Saturation Sensitivity
* **Level**: balanced
  * Options: `lenient`, `balanced`, `strict`
  * **lenient**: Only hard-block core themes, allow borderline candidates
  * **balanced**: Hard-block core themes, pivot on borderline (default)
  * **strict**: Hard-block + pivot on borderline + avoid 0.40-0.59 similarity

#### Alternative Angle Preference
* **Depth angles**: 60% — Favor technical depth differentiation
* **Use-case angles**: 40% — Favor niche application differentiation

#### Multi-Angle Generation
* **Enabled**: true
  * Generate 3 angle variants per signal (coverage, depth, use-case)
  * Select best variant via composite scoring
  * Set to `false` to use Phase 1 single-angle workflow

* **Variant types**: [coverage, depth, use-case]
  * Which angle types to generate
  * All 3 types recommended for maximum differentiation

* **Selection criteria**:
  * **Novelty weight**: 0.40 — Prioritize unique topics
  * **Opportunity weight**: 0.35 — Favor high-gap topics
  * **Feasibility weight**: 0.25 — Ensure resource availability
  * Total weights must sum to 1.0

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

---

## CONTENT DELIVERY

### Publication Platform

* **CMS Platform**: Markdown files (static site generator - Astro or Next.js)
* **Export Format**: markdown

### Visual Standards

* **Image Style**: Code-first; syntax-highlighted screenshots; component tree diagrams; React DevTools profiler screenshots; performance flame graphs; minimal decorative imagery
* **Featured Images**: Required for each post; abstract tech visuals with React logo/branding
* **Code Snippets**: Syntax-highlighted TypeScript/JavaScript; always include imports; show before/after refactors; provide full working examples in companion GitHub repo
* **Downloads**: GitHub repos with runnable examples; React patterns cheat sheets; performance optimization checklists; migration guides (PDF)

---

## LOCALIZATION

### Language & Region

* **Language**: en
* **Regions**: Global
* **Spelling**: US English
* **Accessibility**: Alt text required for diagrams; code examples must have text explanations; keyboard navigation considerations in UI examples

---

## ADDITIONAL NOTES

### Target Audience Insights & Pain Points

* Developers struggle with React performance optimization—too many re-renders, unclear memoization strategies
* Need practical patterns for state management that scale beyond toy examples
* Confusion around when to use Server Components vs. client components
* TypeScript integration challenges—generic components, proper typing for hooks
* Accessibility often an afterthought; need integrated examples
* Testing strategies unclear—what to test, when to use unit vs. integration tests

### Editorial Guardrails

* All code examples must be tested and functional; link to working sandbox (CodeSandbox, StackBlitz) or GitHub repo
* Show trade-offs, not silver bullets—discuss performance, bundle size, complexity costs
* Framework-agnostic where possible; when showing Next.js/Remix examples, note transferable patterns
* Always reference official React docs for APIs/features; link to relevant RFC/GitHub discussions for experimental features
* Avoid framework wars; focus on patterns applicable across the React ecosystem
* Include TypeScript examples by default; provide JavaScript alternatives for broader audience

### Sample Article Ideas (non-promotional)

1. **Optimizing useEffect Dependencies: Common Pitfalls and Solutions** — exhaustive deps, functions as deps, object deps
2. **State Management in 2025: Comparing Context, Zustand, and Jotai** — when to use each, bundle size, DevTools support
3. **Building Accessible React Forms: A Complete Guide** — ARIA labels, error handling, keyboard navigation, screen reader testing
4. **React Server Components: From Mental Model to Production** — understanding the paradigm shift, data fetching patterns, composition
5. **Preventing Unnecessary Re-renders: useMemo, useCallback, and React.memo** — when (and when not) to optimize
6. **Component Composition Patterns: Render Props, HOCs, and Hooks** — modern approaches, when each pattern shines
7. **Type-Safe React: Advanced TypeScript Patterns for Components** — generics, discriminated unions, utility types for props
8. **Testing React Hooks: Unit vs. Integration Strategies** — Testing Library best practices, custom hook testing
9. **Code Splitting in React: Dynamic Imports and Suspense** — lazy loading, error boundaries, loading states
10. **Managing Form State: Controlled vs. Uncontrolled Components** — trade-offs, performance, validation patterns
11. **React Query vs. SWR: Server State Management Compared** — caching strategies, mutations, invalidation
12. **Migrating from useState to useReducer: When and Why** — complex state logic, action patterns, testing benefits
13. **Next.js App Router Data Fetching Patterns** — server components, route handlers, parallel data loading
14. **Building Reusable Component Libraries with TypeScript** — prop API design, polymorphic components, generics
15. **React Performance Profiling: Using DevTools Profiler** — identifying bottlenecks, flame graphs, commit timings
16. **Internationalization in React: react-i18next Deep Dive** — translation management, namespace organization, TypeScript integration
17. **Error Boundaries: Graceful Error Handling in React** — implementation patterns, logging, user feedback
18. **React Context Performance: Avoiding Provider Hell** — context splitting, selector patterns, state colocation
19. **Building a Design System with React and Storybook** — component organization, documentation, variant management
20. **Advanced useEffect Patterns: Cleanup, Dependencies, and Timing** — cleanup functions, effect timing, avoiding infinite loops

### KPIs & Measurement Details

* Track: Organic traffic for React-related keywords; newsletter conversion rate; GitHub repo stars; code example copy events (via analytics)
* Quality signals: Time on page (target 5+ minutes for tutorials), scroll depth, returning visitors, inbound links from React community (Reddit, Twitter, Dev.to)
* Engagement: Comments/questions on articles; GitHub issues on example repos; Twitter mentions; Dev.to reactions

### Maintenance

* Review all React hooks/API tutorials after major React releases (18.x → 19.x)
* Update Next.js App Router content when stable versions release
* Quarterly review of state management library comparisons (versions, API changes)
* Add deprecation warnings when React features change (e.g., legacy context, class component lifecycle)
* Maintain public changelog for example repo updates
