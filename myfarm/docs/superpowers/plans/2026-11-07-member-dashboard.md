# Member Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task‑by‑task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Provide a secure, personalized Member Dashboard for livestock owners that displays only their authorized data (animals, feed allocations, contributions, expenses, payments, balances, and statements) with PDF export and accounting period selection.

**Architecture:** Backend Spring Boot service exposing member‑scoped summary endpoints using DTO projections and farm‑scoped security. Flutter UI built with Riverpod, GoRouter, and the existing design system, following UI/UX Pro‑Max guidelines.

**Tech Stack:** Spring Boot 3.1, Spring Data JPA, PostgreSQL, Flyway, Spring Cache (Caffeine), JWT security, Lombok‑free POJOs, Flutter 3.19, Riverpod, GoRouter, fl_chart for any small charts, pdf_flutter for PDF view.

**Spec:** `docs/superpowers/specs/2026-11-02-myfarm-architecture-design.md` (Phase 06 description).

## Global Constraints
- All member endpoints must verify that the authenticated user is the owner of the requested data (member‑scoped security, not just farm‑scoped).
- No hidden UI elements will be used for security; backend must enforce all authorizations.
- Use explicit foreign keys and indexes on `animal.farm_id`, `animal.owner_id`, `feed_allocation.member_id`, `payment.member_id`, etc.
- Cache member summaries for 5 minutes; invalidate on any write affecting the member's data.
- PDF reports must be generated on‑demand, not stored permanently.

## Review Focus
- Cross‑member data leakage (seeing another member's finances).
- Stale cache serving outdated balances.
- Incorrect aggregation when a member belongs to multiple farms.
- Missing authorization checks on PDF endpoint.
- Performance of aggregation queries for members with many animals.

---

### Task 1: Define Member‑Scoped DTO Projections

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/dto/MemberDashboardDto.java`
- Create projection interfaces:
  - `AnimalSummaryProjection`
  - `FeedAllocationProjection`
  - `ContributionProjection`
  - `ExpenseProjection`
  - `PaymentProjection`
  - `BalanceProjection`
  - `AlertProjection`
- Create migration `V5__add_member_dashboard_indexes.sql` for needed indexes.

**Interfaces:**
- Uses `AnimalRepository`, `FeedAllocationRepository`, `PaymentRepository`, `ExpenseRepository`, `ContributionRepository`.

- [ ] **Step 1:** Write failing test that `MemberDashboardDto` can be built from repository projections for a given member.
- [ ] **Step 2:** Run test – fails (no DTO/projections).
- [ ] **Step 3:** Implement projection interfaces with getters for required aggregated fields (e.g., `Long getTotalAnimals()`, `Double getDailyFeedKg()`). Use JPQL/Native queries with `GROUP BY` on `owner_id`.
- [ ] **Step 4:** Implement `MemberDashboardDto` constructor that accepts all projection results.
- [ ] **Step 5:** Add indexes on `animal.owner_id`, `feed_allocation.member_id`, `payment.member_id`, `expense.member_id` via migration.
- [ ] **Step 6:** Run migration with Flyway, verify indexes exist.
- [ ] **Step 7:** Run test to ensure DTO populates correctly.
- [ ] **Step 8:** Commit.

### Task 2: Service Layer – MemberDashboardService

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/service/MemberDashboardService.java`
- Create: `backend/src/main/java/com/myfarm/auth/service/CacheKeyProvider.java` (reuse from admin dashboard, maybe shared).

**Interfaces:**
- Depends on the repositories and projection interfaces from Task 1.

- [ ] **Step 1:** Write failing test for `getMemberDashboard(Long memberId, LocalDate start, LocalDate end)` returning a fully populated `MemberDashboardDto`.
- [ ] **Step 2:** Run test – fails (service missing).
- [ ] **Step 3:** Implement service method:
  - Validate that `memberId` matches `authentication.principal.id` (or that the user is a member of the farm and owns the data).
  - Query each projection, assemble DTO.
- [ ] **Step 4:** Annotate with `@Cacheable(value = "memberDashboard", key = "#root.target.cacheKeyProvider.key(memberId, start, end)")`.
- [ ] **Step 5:** Write unit test verifying cache hit on second call.
- [ ] **Step 6:** Run all tests, ensure pass.
- [ ] **Step 7:** Commit.

### Task 3: Cache Invalidation for Member Data

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/listener/MemberDashboardCacheInvalidationListener.java`
- Update `CacheConfig.java` to configure Caffeine cache for member dashboards (TTL 5 min).

**Interfaces:**
- Listens to entity events for `Animal`, `FeedAllocation`, `Payment`, `Expense`, `Contribution` where `owner_id`/`member_id` matches.

- [ ] **Step 1:** Write failing test that updating a `Payment` for a member evicts the cached member dashboard for that member.
- [ ] **Step 2:** Implement listener publishing `MemberDashboardInvalidationEvent(memberId)` on relevant saves/updates/deletes.
- [ ] **Step 3:** In `MemberDashboardService`, add a method annotated with `@CacheEvict(value = "memberDashboard", key = "#event.memberId")` that receives the event.
- [ ] **Step 4:** Run test to confirm eviction.
- [ ] **Step 5:** Commit.

### Task 4: REST Controller – MemberDashboardController

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/controller/MemberDashboardController.java`

**Interfaces:**
- Calls `MemberDashboardService`.
- Secured with `@PreAuthorize("@memberScope.check(authentication, #memberId)")` (new `MemberScope` annotation to validate the caller is the same member or a Farm Admin with view rights).

- [ ] **Step 1:** Write failing test for `GET /api/member-dashboard?memberId={}&start={}&end={}` returning 200 JSON matching `MemberDashboardDto`.
- [ ] **Step 2:** Run test – fails (no controller).
- [ ] **Step 3:** Implement controller method, map query params to `LocalDate`, call service, return DTO.
- [ ] **Step 4:** Add pagination endpoint for `GET /api/member-dashboard/payments` and `GET /api/member-dashboard/feed-history` returning `Page<PaymentDto>` / `Page<FeedAllocationDto>`.
- [ ] **Step 5:** Write failing test for payments pagination (verify totalElements and content).
- [ ] **Step 6:** Implement repository methods with `Pageable` and projection `PaymentProjection` (fields: date, amount, description).
- [ ] **Step 7:** Run tests, ensure pass.
- [ ] **Step 8:** Commit.

### Task 5: PDF Report Generation Endpoint

**Files:**
- Add dependency `org.apache.pdfbox:pdfbox` (or use `openhtmltopdf` for HTML‑to‑PDF).
- Create: `backend/src/main/java/com/myfarm/auth/service/MemberReportService.java`
- Create: `backend/src/main/java/com/myfarm/auth/controller/MemberReportController.java`

**Interfaces:**
- Uses `MemberDashboardService` to fetch data, then renders a PDF (e.g., using a simple template engine like Thymeleaf to produce HTML, then convert to PDF).

- [ ] **Step 1:** Write failing test that `GET /api/member-dashboard/report?memberId={}&period=2023-01` returns `application/pdf` and contains the member's name and total owed.
- [ ] **Step 2:** Run test – fails (no endpoint).
- [ ] **Step 3:** Implement service that builds an HTML string with the dashboard data, feeds it to PDF generator, returns `byte[]`.
- [ ] **Step 4:** Implement controller method with `@GetMapping(produces = MediaType.APPLICATION_PDF_VALUE)` that returns `ResponseEntity<byte[]>`.
- [ ] **Step 5:** Ensure the endpoint is secured with the same member‑scope check.
- [ ] **Step 6:** Run test, verify PDF content (e.g., check that PDF bytes start with `%PDF`).
- [ ] **Step 7:** Commit.

### Task 6: Backend – Optimized Queries & Indexes

**Files:**
- Update existing repositories with JPQL/native aggregation queries that compute per‑member totals without loading full entity graphs.
- Example: `@Query("SELECT SUM(p.amount) FROM Payment p WHERE p.member.id = :memberId AND p.date BETWEEN :start AND :end") Double sumPayments(...);
- Add migration `V6__optimize_member_dashboard_queries.sql` adding composite indexes on (`owner_id`, `date`) for tables `animals`, `feed_allocation`, `expenses`, `payments`.

- [ ] **Step 1:** Write failing test that `AnimalRepository.countByOwnerId(Long ownerId)` returns correct count for a member with many animals.
- [ ] **Step 2:** Implement repository method using native SQL with index.
- [ ] **Step 3:** Add migration adding indexes on `owner_id` + `date` columns where applicable.
- [ ] **Step 4:** Run migration, verify indexes.
- [ ] **Step 5:** Run test, ensure accurate and performant result.
- [ ] **Step 6:** Commit.

### Task 7: Flutter – Member Dashboard Screen Skeleton

**Files:**
- Create: `mobile/lib/features/member_dashboard/member_dashboard_screen.dart`
- Create: `mobile/lib/features/member_dashboard/member_dashboard_viewmodel.dart`
- Create widgets:
  - `MemberAnimalCard.dart`
  - `FeedAllocationCard.dart`
  - `ContributionCard.dart`
  - `ExpenseCard.dart`
  - `BalanceCard.dart`
  - `AlertTile.dart`
- Update `app_routes.dart` to include `/member-dashboard` route with GoRouter, protected by authentication guard.

**Interfaces:**
- Calls backend `/api/member-dashboard` and pagination endpoints via existing `ApiClient`.
- Uses Riverpod `FutureProvider` for data fetching.

- [ ] **Step 1:** Write failing widget test that the screen shows a loading indicator while fetching data.
- [ ] **Step 2:** Run test – fails (screen not implemented).
- [ ] **Step 3:** Implement ViewModel that fetches `MemberDashboardDto` and paginated payment/feed history.
- [ ] **Step 4:** Build UI layout using UI/UX Pro‑Max guidelines:
  - Top bar with member name and period selector (date picker for month).
  - Grid of cards for each statistic (animals, feed allocation, contributions, expenses, balances, alerts).
  - Scrollable sections for payment history and feed history with pagination (infinite scroll).
  - Button to download PDF report (opens native PDF viewer).
- [ ] **Step 5:** Write widget test that after data loads, cards display correct numbers from a mocked API response.
- [ ] **Step 6:** Run widget tests, ensure pass.
- [ ] **Step 7:** Commit.

### Task 8: Flutter – Period Selector & PDF Access

**Files:**
- Extend: `member_dashboard_viewmodel.dart` with method `setPeriod(YearMonth period)` that reloads data.
- Add UI component: `PeriodPickerButton` (shows `showMonthPicker` dialog).
- Add PDF download button that calls `ApiClient.downloadMemberReport(memberId, period)` and opens file with `open_file` package.

- [ ] **Step 1:** Write failing widget test that selecting a different month triggers a new API call and updates the displayed totals.
- [ ] **Step 2:** Implement period picker UI and ViewModel reload logic.
- [ ] **Step 3:** Implement PDF download method in `ApiClient` (GET request, save to temporary file, open).
- [ ] **Step 4:** Write integration test (flutter_driver or integration_test) that tapping the PDF button results in a file being saved and opened (mock the file system).
- [ ] **Step 5:** Run tests, ensure pass.
- [ ] **Step 6:** Commit.

### Task 9: Security – MemberScope Annotation

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/security/MemberScope.java` (custom annotation).
- Create: `backend/src/main/java/com/myfarm/auth/security/MemberScopeResolver.java` (method argument resolver that validates the authenticated user matches `memberId` or has admin privileges).
- Update `SecurityConfig.java` to register the resolver.

**Interfaces:**
- Used by `MemberDashboardController` and any other member‑specific endpoints.

- [ ] **Step 1:** Write failing test that a user trying to access another member's dashboard receives `403 Forbidden`.
- [ ] **Step 2:** Implement annotation and resolver that checks `authentication.principal.id == memberId`.
- [ ] **Step 3:** Run test to confirm proper denial and allow for correct member.
- [ ] **Step 4:** Commit.

### Task 10: End‑to‑End Tests (Backend + Flutter)

**Files:**
- Backend integration test: `backend/src/test/java/com/myfarm/auth/integration/MemberDashboardIntegrationTest.java` using Testcontainers PostgreSQL.
- Flutter integration test: `mobile/integration_test/member_dashboard_test.dart`.

- [ ] **Step 1:** Write failing backend test that creating a member, adding animals, feed allocations, expenses, payments, and a pending alert results in a dashboard summary where:
  - `totalAnimals`, `dailyFeedKg`, `monthlyFeedKg`, `totalExpenses`, `totalPayments`, `outstandingBalance`, and `alerts` are accurate.
- [ ] **Step 2:** Implement missing service, cache, controller, security until test passes.
- [ ] **Step 3:** Write failing Flutter integration test that launching the app, logging in as a member, navigating to the member dashboard shows the same numbers as the backend summary (using real or mocked server).
- [ ] **Step 4:** Run both tests in CI, ensure they pass.
- [ ] **Step 5:** Commit.

---

**Self‑Review Checklist**
- DTOs use projections; no full entity graphs are loaded.
- Every endpoint is protected by `MemberScope` (member‑scoped) and also farm‑scoped where appropriate.
- Indexes exist on columns used for aggregation (`owner_id`, `member_id`, `date`).
- Cache keys include `memberId` and period; TTL 5 min; eviction on related writes.
- Flutter UI follows UI/UX Pro‑Max spacing, typography, and color palette; charts/labels are clear.
- PDF generation is on‑demand, secured, and does not expose other members' data.
- Tests cover unauthorized access, cache invalidation, pagination, PDF content, and end‑to‑end data consistency.

**Next Steps**
- Review this plan with you.
- Choose execution approach (subagent‑driven recommended).

Please let me know if the plan captures everything you need for Phase 06 and which execution method you’d like to proceed with.