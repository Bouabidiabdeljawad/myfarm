# Task 4 – REST Controller – MemberDashboardController

**Status:** DONE

**Implemented files:**
- `backend/src/main/java/com/myfarm/auth/controller/MemberDashboardController.java`
- `backend/src/main/java/com/myfarm/auth/dto/PaymentDto.java`
- `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationDto.java`
- `backend/src/main/java/com/myfarm/auth/dto/PaymentProjection.java` (updated)
- `backend/src/main/java/com/myfarm/auth/dto/PaymentProjectionImpl.java` (updated)
- `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationProjection.java` (updated)
- `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationProjectionImpl.java` (updated)
- `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationSummaryProjection.java` (new)
- `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationSummaryProjectionImpl.java` (new)
- `backend/src/main/java/com/myfarm/auth/dto/PaymentSummaryProjection.java` (new)
- `backend/src/main/java/com/myfarm/auth/dto/PaymentSummaryProjectionImpl.java` (new)
- `backend/src/main/java/com/myfarm/auth/repository/PaymentRepository.java` (updated with pagination)
- `backend/src/main/java/com/myfarm/auth/repository/FeedAllocationRepository.java` (updated with pagination)
- `backend/src/main/java/com/myfarm/auth/service/MemberDashboardService.java` (updated with pagination methods)
- `backend/src/main/java/com/myfarm/auth/dto/MemberDashboardDto.java` (updated to use summary projections)
- `backend/src/main/java/com/myfarm/auth/config/SecurityConfig.java` (new)
- `backend/src/main/java/com/myfarm/auth/security/MemberScope.java` (new)
- `backend/src/main/java/com/myfarm/auth/security/MemberScopeResolver.java` (new)
- Test: `backend/src/test/java/com/myfarm/auth/controller/MemberDashboardControllerTest.java`

**What was done:**
1. Created `MemberDashboardController` with three endpoints:
   - `GET /api/member-dashboard?memberId={}&start={}&end={}` - Returns full dashboard summary
   - `GET /api/member-dashboard/payments?memberId={}&start={}&end={}` - Paginated payment history
   - `GET /api/member-dashboard/feed-history?memberId={}&start={}&end={}` - Paginated feed allocation history

2. Added pagination support to repositories:
   - `PaymentRepository.findByMemberIdAndDateRangePaginated()` with `Pageable`
   - `FeedAllocationRepository.findByMemberIdAndDateRangePaginated()` with `Pageable`

3. Added summary projections to separate dashboard aggregation from detail queries:
   - `FeedAllocationSummaryProjection` - for dashboard (sum of daily/monthly kg)
   - `PaymentSummaryProjection` - for dashboard (sum of payments, count)
   - Kept detailed projections for pagination endpoints

4. Implemented security with `@PreAuthorize("@memberScope.check(authentication, #memberId)")`:
   - Created `MemberScope` annotation
   - Created `MemberScopeResolver` component with `check()` method
   - Users can access their own data; SUPER_ADMIN and FARM_ADMIN can access any member's data
   - Created `SecurityConfig` with `@EnableMethodSecurity` and argument resolver registration

5. Added unit tests for controller (3 tests covering all three endpoints)

**Tests Status:**
```
mvn test -Dtest=MemberDashboardDtoTest,MemberDashboardServiceTest,MemberDashboardCacheInvalidationListenerTest,MemberDashboardControllerTest
# All 14 tests pass ✓
```

**Concerns / Observations:**
- Security implementation uses JWT subject as user ID - assumes token contains user ID in subject claim
- MemberScopeResolver fetches user from database on each check - could be optimized with caching
- Pagination defaults to 20 items per page, sorted by date descending
- Date format uses ISO date (yyyy-MM-dd) via @DateTimeFormat

**Next steps:**
- Proceed to Task 5 (PDF Report Generation Endpoint)
- Consider adding integration test for full controller flow with security