# Task 2 – Implement MemberDashboardService

**Status:** DONE

**Implemented files:**
- `backend/src/main/java/com/myfarm/auth/service/MemberDashboardService.java`
- `backend/src/main/java/com/myfarm/auth/service/CacheKeyProvider.java`
- `backend/src/main/java/com/myfarm/auth/config/CacheConfig.java`
- `backend/src/main/java/com/myfarm/auth/repository/AnimalRepository.java`
- `backend/src/main/java/com/myfarm/auth/repository/FeedAllocationRepository.java`
- `backend/src/main/java/com/myfarm/auth/repository/ContributionRepository.java`
- `backend/src/main/java/com/myfarm/auth/repository/ExpenseRepository.java`
- `backend/src/main/java/com/myfarm/auth/repository/PaymentRepository.java`
- `backend/src/main/java/com/myfarm/auth/repository/BalanceRepository.java`
- Prerequisite Task 1 files (created as part of this task):
  - `backend/src/main/java/com/myfarm/auth/dto/MemberDashboardDto.java`
  - `backend/src/main/java/com/myfarm/auth/dto/AnimalSummaryProjection.java`
  - `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationProjection.java`
  - `backend/src/main/java/com/myfarm/auth/dto/ContributionProjection.java`
  - `backend/src/main/java/com/myfarm/auth/dto/ExpenseProjection.java`
  - `backend/src/main/java/com/myfarm/auth/dto/PaymentProjection.java`
  - `backend/src/main/java/com/myfarm/auth/dto/BalanceProjection.java`
  - `backend/src/main/java/com/myfarm/auth/dto/AlertProjection.java`
  - `backend/src/main/java/com/myfarm/auth/dto/AnimalSummaryProjectionImpl.java`
  - `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationProjectionImpl.java`
  - `backend/src/main/java/com/myfarm/auth/dto/ContributionProjectionImpl.java`
  - `backend/src/main/java/com/myfarm/auth/dto/ExpenseProjectionImpl.java`
  - `backend/src/main/java/com/myfarm/auth/dto/PaymentProjectionImpl.java`
  - `backend/src/main/java/com/myfarm/auth/dto/BalanceProjectionImpl.java`
  - `backend/src/main/java/com/myfarm/auth/dto/AlertProjectionImpl.java`
  - `backend/src/main/java/com/myfarm/auth/model/Animal.java`
  - `backend/src/main/java/com/myfarm/auth/model/FeedAllocation.java`
  - `backend/src/main/java/com/myfarm/auth/model/Payment.java`
  - `backend/src/main/java/com/myfarm/auth/model/Expense.java`
  - `backend/src/main/java/com/myfarm/auth/model/Contribution.java`
  - Migration `backend/src/main/resources/db/migration/V5__add_member_dashboard_indexes.sql`

**Tests created:**
- `backend/src/test/java/com/myfarm/auth/dto/MemberDashboardDtoTest.java`
- `backend/src/test/java/com/myfarm/auth/service/MemberDashboardServiceTest.java`

**What was done:**
1. Created all missing model entities (Animal, FeedAllocation, Payment, Expense, Contribution) that the projections query against
2. Created all projection interfaces and their implementation classes
3. Created MemberDashboardDto that aggregates all projection data
4. Created repository interfaces with @Query methods returning projection implementations
5. Created CacheKeyProvider utility for generating cache keys
6. Created CacheConfig with Caffeine cache (5-minute TTL, max 1000 entries)
7. Implemented MemberDashboardService with:
   - @Cacheable annotation on getMemberDashboard method
   - Date-range filtering via repository queries
   - Member-scoped queries (all queries filter by memberId)
   - Null-safe handling of empty projections
   - Alert generation placeholder (returns empty list for now)
8. Added migration V5 with indexes on member-related foreign keys
9. Wrote unit tests for MemberDashboardDto and MemberDashboardService
10. Fixed existing model classes (User, Farm, FarmMembership) by adding getters/setters
11. Fixed JWT provider for compatibility with jjwt 0.12.5
12. Updated pom.xml with spring-boot-starter-parent and spring-boot-starter-cache

**Concerns / Observations:**
- The BalanceRepository uses a native SQL query with UNION ALL which may need optimization for large datasets
- AlertProjection is still a placeholder - will need structured alert types in future tasks
- The MemberScope security annotation is not yet implemented (Task 9); currently service assumes caller is authorized
- Tests pass but integration tests with Testcontainers are not yet created (would require database setup)
- Cache invalidation listener not yet implemented (Task 3)

**Next steps:**
- Proceed to Task 3 (Cache Invalidation for Member Data) to add @CacheEvict listeners
- Proceed to Task 4 (REST Controller) to expose the service via HTTP
- Consider adding integration tests with Testcontainers

**Report file:** `backend/.superpowers/sdd/member-dashboard/task-2-report.md`