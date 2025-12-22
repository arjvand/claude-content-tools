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

---

## CONTENT DELIVERY

### Publication Platform

* **CMS Platform**: Markdown files (static site generator - Astro or Next.js)
* **HTML Formatter Skill**: none

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
