# Admin Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task‑by‑task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a complete, secure, high‑performance Admin Dashboard for myFarm that gives farm admins a concise, actionable overview of animal counts, feed inventory, financials, member allocations, pending requests, and alerts.

**Architecture:** Backend Spring Boot service exposing aggregated summary endpoints using DTO projections and cached results. Frontend Flutter screen following UI/UX Pro‑Max guidelines, with cards, charts, filters, farm selector, quick actions, and notification system.

**Tech Stack:** Spring Boot 3.1 (Java 17), Spring Data JPA, PostgreSQL, Flyway, Spring Cache (Caffeine), JWT security, Lombok‑free POJOs, Flutter 3.19, Riverpod/Provider for state‑management, charts_flutter (or fl_chart) for visualisations, Moor (Drift) for local caching.

**Spec:** `docs/superpowers/specs/2026-11-02-myfarm-architecture-design.md` (Phase 05 description).

## Global Constraints
- All dashboard endpoints must be farm‑scoped: verify the authenticated admin has access to the farm ID before any data is returned.
- Use explicit indexes on columns used for aggregation (e.g., `animal.farm_id`, `feed_consumption.farm_id`, `payment.farm_id`).
- Cache keys must include `farmId` and the requested date range (`start`, `end`).
- Cache TTL: 5 minutes for most summaries; invalidate immediately on writes to related tables (feed stock, expenses, payments, animal counts, member allocations, requests).
- No fabricated production data – use real aggregated values from the DB.
- Follow UI/UX Pro‑Max design system (consistent spacing, typography, color palette from `mobile/lib/core/theme/app_colors.dart`).

## Review Focus
- Unauthorized data leakage between farms.
- Stale cache serving outdated financial numbers.
- Performance regressions on large farms (many animals, many transactions).
- Missing or inaccurate alerts for low feed stock / upcoming expenses.
- Incorrect pagination or missing total counts on activity list.

---

### Task 1: Define Dashboard Summary DTOs & Projection Interfaces

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/dto/DashboardSummaryDto.java`
- Create projection interfaces:
  - `AnimalSummaryProjection`
  - `FeedSummaryProjection`
  - `FinancialSummaryProjection`
  - `MemberAllocationProjection`
  - `PendingRequestProjection`
  - `AlertProjection`
- Create migration `V5__add_dashboard_indexes.sql` for needed indexes.

**Interfaces:**
- Uses `AnimalRepository`, `FeedRepository`, `PaymentRepository`, `ExpenseRepository`, `FarmMembershipRepository`, `RequestRepository`.

- [ ] **Step 1:** Write failing test that `DashboardSummaryDto` can be constructed from repository projections.
- [ ] **Step 2:** Run test – it fails (no DTO/projections).
- [ ] **Step 3:** Implement projection interfaces with getters for needed aggregated fields (e.g., `Long getTotalAnimals()`). Use JPQL `SELECT COUNT(a) AS totalAnimals, SUM(a.weight) AS totalWeight FROM Animal a WHERE a.farm.id = :farmId` etc.
- [ ] **Step 4:** Implement `DashboardSummaryDto` constructor that accepts all projection results.
- [ ] **Step 5:** Write migration adding indexes on `animal.farm_id`, `feed_stock.farm_id`, `payment.farm_id`, `expense.farm_id`, `request.farm_id`.
- [ ] **Step 6:** Run migration with Flyway, verify indexes exist.
- [ ] **Step 7:** Run test to ensure DTO is populated correctly.
- [ ] **Step 8:** Commit.

### Task 2: Service Layer – DashboardService

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/service/DashboardService.java`
- Create: `backend/src/main/java/com/myfarm/auth/service/CacheKeyProvider.java` (utility to generate cache keys).

**Interfaces:**
- Depends on repositories and the projection interfaces from Task 1.

- [ ] **Step 1:** Write failing test for method `getDashboardSummary(Long farmId, LocalDate start, LocalDate end)` returning a fully populated `DashboardSummaryDto`.
- [ ] **Step 2:** Run test – fails (service missing).
- [ ] **Step 3:** Implement service method:
  - Validate farm access via `FarmScope` (reuse existing security filter).
  - Use repository methods with `@Query` returning projection interfaces.
  - Assemble DTO.
- [ ] **Step 4:** Annotate method with `@Cacheable(value = "dashboard", key = "#root.target.cacheKeyProvider.key(farmId, start, end)")`.
- [ ] **Step 5:** Write unit test verifying cache is hit on second call (mock CacheManager).
- [ ] **Step 6:** Run all tests, ensure pass.
- [ ] **Step 7:** Commit.

### Task 3: Cache Invalidation Listeners

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/listener/DashboardCacheInvalidationListener.java`
- Update: `backend/src/main/java/com/myfarm/auth/config/CacheConfig.java` to configure Caffeine cache with TTL 5 min.

**Interfaces:**
- Listens to JPA entity events (`@EntityListeners` or Spring `@TransactionalEventListener`) for changes to Animal, FeedStock, Payment, Expense, FarmMembership, Request.

- [ ] **Step 1:** Write failing test that updating a `FeedStock` entry triggers cache eviction for the related farm summary.
- [ ] **Step 2:** Implement listener that publishes `DashboardInvalidationEvent(farmId)` on relevant saves/updates/deletes.
- [ ] **Step 3:** In `DashboardService`, add `@CacheEvict(value = "dashboard", allEntries = true, condition = "#event.farmId != null && #event.farmId == #farmId")` via `@CacheEvict` on a method that receives the event (or use `CacheManager.evict`).
- [ ] **Step 4:** Run test to confirm eviction.
- [ ] **Step 5:** Commit.

### Task 4: REST Controller – DashboardController

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/controller/DashboardController.java`

**Interfaces:**
- Calls `DashboardService`.
- Secured with `@PreAuthorize("@farmScope.check(authentication, #farmId)")`.

- [ ] **Step 1:** Write failing test for `GET /api/dashboard/summary?farmId={}&start={}&end={}` returning 200 and a JSON matching `DashboardSummaryDto` fields.
- [ ] **Step 2:** Run test – fails (no controller).
- [ ] **Step 3:** Implement controller method, map query params to `LocalDate`, call service, return DTO as JSON.
- [ ] **Step 4:** Add pagination support for activity list (`/api/dashboard/activities?farmId=&page=&size=`) returning `Page<ActivityDto>`.
- [ ] **Step 5:** Write failing test for activity pagination (verify `totalElements` and `content` length).
- [ ] **Step 6:** Implement activity repository method with `Pageable` and projection `ActivityProjection` (fields: timestamp, user, action, details).
- [ ] **Step 7:** Run both tests, ensure pass.
- [ ] **Step 8:** Commit.

### Task 5: Backend – Optimized Queries & Indexes

**Files:**
- Update existing repositories with JPQL/native queries that aggregate directly in the DB (avoid loading full entity graphs).
- Example: `AnimalRepository` method `@Query("SELECT COUNT(a) FROM Animal a WHERE a.farm.id = :farmId") Long countAnimals(@Param("farmId") Long farmId);`
- Add indexes via migration `V6__optimize_dashboard_queries.sql` for columns used in GROUP BY / WHERE clauses (`feed_consumption.date`, `expense.date`, `payment.date`).

**Interfaces:**
- Used by `DashboardService`.

- [ ] **Step 1:** Write failing test that `AnimalRepository.countAnimalsByFarm(Long farmId)` returns correct count for a farm with many animals (use Testcontainers PostgreSQL).
- [ ] **Step 2:** Run test – fails (method missing).
- [ ] **Step 3:** Implement repository method with native SQL using indexes.
- [ ] **Step 4:** Add migration adding composite indexes on (`farm_id`, `date`).
- [ ] **Step 5:** Run migration, verify indexes.
- [ ] **Step 6:** Run test, ensure accurate and performant count (assert query plan contains index usage via `EXPLAIN` if desired).
- [ ] **Step 7:** Commit.

### Task 6: Flutter – Dashboard Screen Skeleton

**Files:**
- Create: `mobile/lib/features/admin_dashboard/admin_dashboard_screen.dart`
- Create: `mobile/lib/features/admin_dashboard/admin_dashboard_viewmodel.dart`
- Create: `mobile/lib/features/admin_dashboard/widgets/overview_card.dart`
- Create: `mobile/lib/features/admin_dashboard/widgets/alert_tile.dart`
- Update navigation in `app_routes.dart` to include `/admin-dashboard`.

**Interfaces:**
- Calls backend `/api/dashboard/summary` and `/api/dashboard/activities` via existing `ApiClient`.
- Uses `CurrentFarmProvider` (already existing) for selected farm.

- [ ] **Step 1:** Write failing widget test that the screen shows a loading indicator while data is fetched.
- [ ] **Step 2:** Run test – fails (screen not implemented).
- [ ] **Step 3:** Implement ViewModel using Riverpod `FutureProvider` that fetches `DashboardSummaryDto` and activity page.
- [ ] **Step 4:** Build UI layout using UI/UX Pro‑Max guidelines:
  - Top app bar with farm selector dropdown.
  - Date range picker (Material date range selector) that triggers reload.
  - Grid of `OverviewCard` widgets for sections 1‑12 (animals, feed, finances, alerts).
  - `AlertTile` list for pending member requests and low‑feed warnings (highlight in red).
  - Chart widgets (e.g., `BarChart` for feed consumption, `LineChart` for expenses) using `fl_chart`.
  - Quick‑action row with icons for “Add Animal”, “Record Expense”, “Approve Request”.
  - Paginated activity list at bottom with infinite scroll.
- [ ] **Step 5:** Write widget test that after data loads, the overview cards display correct numbers from a mocked API response.
- [ ] **Step 6:** Run widget tests, ensure pass.
- [ ] **Step 7:** Commit.

### Task 7: Flutter – Charts & Date Filters

**Files:**
- Create: `mobile/lib/shared/widgets/chart_card.dart`
- Update: `admin_dashboard_screen.dart` to embed `ChartCard` instances for feed consumption, expenses, water/grazing/health costs.

**Interfaces:**
- ViewModel provides time‑series data (list of `{date, value}`) for each chart.

- [ ] **Step 1:** Write failing widget test that a `ChartCard` renders axis labels and tooltip correctly for a sample data set.
- [ ] **Step 2:** Implement `ChartCard` using `fl_chart` with proper labeling, legend, and responsive layout.
- [ ] **Step 3:** Add date range filter UI (Material `showDateRangePicker`). When user selects a range, ViewModel reloads summary with new `start`/`end` query parameters.
- [ ] **Step 4:** Write integration test that changing the date range updates the numbers on the cards.
- [ ] **Step 5:** Run tests, ensure pass.
- [ ] **Step 6:** Commit.

### Task 8: Flutter – Alerts & Quick Actions

**Files:**
- Create: `mobile/lib/shared/widgets/notification_badge.dart`
- Extend: `admin_dashboard_viewmodel.dart` with methods `approveRequest(requestId)`, `addFeedStock()`, etc.

**Interfaces:**
- Calls backend endpoints: `POST /api/requests/{id}/approve`, `POST /api/feed/stock`.

- [ ] **Step 1:** Write failing widget test that a pending request appears with a red badge and an “Approve” button.
- [ ] **Step 2:** Implement UI: `AlertTile` shows request description and action button.
- [ ] **Step 3:** Implement ViewModel method to call approve endpoint, then invalidate dashboard cache (backend will evict automatically).
- [ ] **Step 4:** Write test that after approving, the alert disappears and the summary numbers (outstanding debts) update.
- [ ] **Step 5:** Implement quick‑action icons at top (add animal, add expense) that navigate to existing forms.
- [ ] **Step 6:** Run widget and integration tests, ensure pass.
- [ ] **Step 7:** Commit.

### Task 9: Backend – Activity Pagination Endpoint

**Files:**
- Create DTO: `backend/src/main/java/com/myfarm/auth/dto/ActivityDto.java`
- Update `DashboardController` with endpoint `GET /api/dashboard/activities` returning `Page<ActivityDto>`.
- Add repository method `Page<ActivityProjection> findByFarmId(Long farmId, Pageable pageable)`.

**Interfaces:**
- Used by Flutter activity list.

- [ ] **Step 1:** Write failing test that requesting page 0 size 20 returns correct total count and first 20 activities sorted descending by timestamp.
- [ ] **Step 2:** Implement repository method with `@Query` selecting needed fields only.
- [ ] **Step 3:** Implement controller method, map projection to `ActivityDto`.
- [ ] **Step 4:** Run test, ensure pagination works and respects farm scope.
- [ ] **Step 5:** Commit.

### Task 10: End‑to‑End Tests (Backend + Flutter)

**Files:**
- Backend integration test: `backend/src/test/java/com/myfarm/auth/integration/DashboardIntegrationTest.java` using Testcontainers PostgreSQL.
- Flutter integration test: `mobile/integration_test/admin_dashboard_test.dart` using `integration_test` package.

- [ ] **Step 1:** Write failing backend test that creating a farm, adding animals, feed stock, expenses, and a pending request results in a dashboard summary where:
  - `totalAnimals` matches count.
  - `availableFeed` reflects stock minus daily consumption.
  - `outstandingDebts` reflects unpaid amounts.
  - `alerts` list includes low‑feed warning.
- [ ] **Step 2:** Implement missing pieces (service, cache, controller) until test passes.
- [ ] **Step 3:** Write failing Flutter integration test that launching the app, selecting a farm, and opening the admin dashboard displays the same numbers as the backend summary (mocked or real server).
- [ ] **Step 4:** Run both tests in CI pipeline, ensure they pass.
- [ ] **Step 5:** Commit.

---

**Self‑Review Checklist**
- All DTOs use projections to avoid loading full entity graphs.
- Every read endpoint is protected by farm‑scoped security.
- Indexes exist for all columns used in aggregation / filtering.
- Cache keys include `farmId`, `start`, `end`; TTL is 5 min and eviction triggers on relevant writes.
- Flutter UI follows UI/UX Pro‑Max spacing, typography, and color palette; charts have clear labels and legends.
- Alerts prioritize low feed stock, upcoming expenses, and pending member requests.
- Tests cover unauthorized access, cache invalidation, pagination, and end‑to‑end data consistency.

**Next Steps**
- Review this plan with you.
- Choose execution approach (subagent‑driven recommended).

Please let me know if the plan captures everything you need for Phase 05 and which execution method you’d like to proceed with.