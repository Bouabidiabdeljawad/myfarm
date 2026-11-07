# Task 1 – Define Member‑Scoped DTO Projections

**Goal:** Create the DTOs and JPA projection interfaces needed for the Member Dashboard, plus a migration adding necessary indexes.

**Files to create/modify:**
- `backend/src/main/java/com/myfarm/auth/dto/MemberDashboardDto.java`
- `backend/src/main/java/com/myfarm/auth/dto/AnimalSummaryProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/ContributionProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/ExpenseProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/PaymentProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/BalanceProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/AlertProjection.java`
- Migration file `backend/src/main/resources/db/migration/V5__add_member_dashboard_indexes.sql`

**Requirements:**
1. Each projection must expose only the aggregated fields needed for the dashboard (see spec). Use JPQL or native queries with `@Query` returning the projection interface.
2. `MemberDashboardDto` constructor should accept all projection results and expose getters for the UI.
3. Migration must add indexes on:
   - `animal.owner_id`
   - `feed_allocation.member_id`
   - `payment.member_id`
   - `expense.member_id`
   - `contribution.member_id`
4. Write a unit test that constructs `MemberDashboardDto` from mock projection data and verifies getters.
5. Write a repository test that verifies each projection query returns correct aggregated values for a sample member (use Testcontainers PostgreSQL).

**Ambiguities resolved:**
- Use `Long` for IDs, `Double` for quantities, `BigDecimal` for monetary values.
- All monetary values are stored in `numeric(12,2)` in the DB; map to `BigDecimal`.
- Date ranges will be passed as `LocalDate start, end` to the service layer; projections must filter on these dates where relevant.

**Report file:** `backend/.superpowers/sdd/member-dashboard/task-1-report.md`

**Context:** No prior tasks affect this one.
