# Task 6 – Backend – Optimized Queries & Indexes

**Status:** DONE

**Implemented files:**
- `backend/src/main/java/com/myfarm/auth/repository/AnimalRepository.java` (added optimized native query)
- `backend/src/main/java/com/myfarm/auth/repository/FeedAllocationRepository.java` (added optimized native query)
- `backend/src/main/java/com/myfarm/auth/repository/PaymentRepository.java` (added optimized native query)
- `backend/src/main/java/com/myfarm/auth/repository/ExpenseRepository.java` (added optimized native query)
- `backend/src/main/java/com\myfarm\auth\repository\ContributionRepository.java` (added optimized native query)
- `backend/src/main/java/com\myfarm\auth\repository\BalanceRepository.java` (added optimized CTE-based query)
- `backend/src/main/java/com\myfarm\auth\service\MemberDashboardService.java` (updated to use optimized queries)
- `backend/src/main/resources/db/migration/V6__optimize_member_dashboard_queries.sql` (new migration)
- Test: `backend/src/test/java/com/myfarm/auth/service/MemberDashboardServiceTest.java` (updated to use optimized methods)

**What was done:**
1. Added optimized native SQL queries to all repositories using the composite indexes:
   - `AnimalRepository.findActiveSummaryByMemberIdOptimized()` - uses `idx_animal_owner_status_weight`
   - `FeedAllocationRepository.findByMemberIdAndDateRangeOptimized()` - uses `idx_feed_allocation_member_date_covering`
   - `PaymentRepository.findByMemberIdAndDateRangeOptimized()` - uses `idx_payment_member_date_covering`
   - `ExpenseRepository.findByMemberIdAndDateRangeOptimized()` - uses `idx_expense_member_date_covering`
   - `ContributionRepository.findByMemberIdAndDateRangeOptimized()` - uses `idx_contribution_member_date_covering`
   - `BalanceRepository.findByMemberIdAndDateRangeOptimized()` - uses CTEs with separate aggregations leveraging all indexes

2. Created Migration V6 with composite/covering indexes:
   - `idx_animal_owner_status` - for animal status filtering
   - `idx_animal_owner_status_weight` - covering index for active animal summary with weight
   - `idx_feed_allocation_member_date_covering` - includes daily_kg, monthly_kg
   - `idx_payment_member_date_covering` - includes amount, description, type
   - `idx_expense_member_date_covering` - includes amount, category, description
   - `idx_contribution_member_date_covering` - includes amount, category, description

3. Updated `MemberDashboardService` to use optimized methods (findActiveSummaryByMemberIdOptimized, findByMemberIdAndDateRangeOptimized, etc.)

4. Updated tests to mock the optimized methods

**Tests Status:**
```
mvn test -Dtest=MemberDashboardDtoTest,MemberDashboardServiceTest,MemberDashboardCacheInvalidationListenerTest,MemberDashboardControllerTest,MemberReportServiceTest
# All 16 tests pass ✓
```

**Concerns / Observations:**
- PostgreSQL covering indexes (INCLUDE clause) are used for better performance - these are PostgreSQL 11+ feature
- The BalanceRepository optimized query uses CTEs which PostgreSQL can execute in parallel
- Migration V5 indexes are still used; V6 adds composite/covering variants
- The optimized queries return the same projection interfaces, so the service layer contract is unchanged
- Native queries bypass JPA/Hibernate overhead for aggregations

**Next steps:**
- Proceed to Task 7 (Flutter – Member Dashboard Screen Skeleton) - Frontend implementation