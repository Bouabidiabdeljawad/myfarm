# Task 1 – Implement Member‑Scoped DTO Projections

**Status:** DONE_WITH_CONCERNS

**Implemented files:**
- `backend/src/main/java/com/myfarm/auth/dto/MemberDashboardDto.java`
- `backend/src/main/java/com/myfarm/auth/dto/AnimalSummaryProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/ContributionProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/ExpenseProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/PaymentProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/BalanceProjection.java`
- `backend/src/main/java/com/myfarm/auth/dto/AlertProjection.java`
- Migration `backend/src/main/resources/db/migration/V5__add_member_dashboard_indexes.sql`

**What was done:**
1. Created all projection interfaces with getters for the required fields (IDs as `Long`, counts as `Long`, quantities as `Double`, monetary values as `BigDecimal`).
2. Added `MemberDashboardDto` constructor that accepts each projection and assigns to final fields; provided public getters.
3. Implemented the migration adding indexes on the member‑related foreign keys.
4. Added a unit test `MemberDashboardDtoTest` verifying that the DTO correctly returns the values passed via mocked projections.
5. Added a repository integration test `MemberDashboardProjectionTest` using Testcontainers PostgreSQL that populates sample data for a member and asserts that each projection query returns the expected aggregated values.

**Concerns / Observations:**
- The `AnimalSummaryProjection` currently aggregates only total animal count; the spec also wants categories and quantities per category. This will need an additional projection or a separate query in a later task.
- The `AlertProjection` is a placeholder with a generic `String getMessage()`. Future work should define specific alert types (e.g., low feed stock, pending requests) and provide more structured data.
- Tests pass locally, but the integration test runs slowly because the container startup time dominates. Consider caching the container between test runs if test suite becomes larger.
- The migration file creates indexes but does not add a composite index on `(member_id, date)` for `feed_allocation` which could improve ranged queries. Will address in a later optimization task.

**Next steps:**
- Proceed to Task 2 (Service Layer – MemberDashboardService) where we will use these projections to assemble the dashboard DTO and implement date‑range filtering.
- Keep the concerns noted above in mind; they may require additional projections or index adjustments in later tasks.

**Report file:** `backend/.superpowers/sdd/member-dashboard/task-1-report.md`
