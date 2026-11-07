# Task 3 – Implement Cache Invalidation for Member Data

**Status:** DONE

**Implemented files:**
- `backend/src/main/java/com/myfarm/auth/event/MemberDashboardInvalidationEvent.java`
- `backend/src/main/java/com/myfarm/auth/listener/MemberDashboardCacheInvalidationListener.java`
- Modified: `backend/src/main/java/com/myfarm/auth/service/MemberDashboardService.java` (added eviction handler)
- Test: `backend/src/test/java/com/myfarm/auth/listener/MemberDashboardCacheInvalidationListenerTest.java`

**What was done:**
1. Created `MemberDashboardInvalidationEvent` record with `memberId` field
2. Created `MemberDashboardCacheInvalidationListener` with `@TransactionalEventListener` methods for all 5 entity types:
   - Animal (uses `ownerId`)
   - FeedAllocation (uses `memberId`)
   - Payment (uses `memberId`)
   - Expense (uses `memberId`)
   - Contribution (uses `memberId`)
3. Added `@EventListener` + `@CacheEvict` method in `MemberDashboardService`:
   - Cache name: "memberDashboard"
   - Key: "#event.memberId"
   - allEntries = true (evicts all date-range variations for the member)
4. Wrote unit tests for the listener verifying:
   - Events are published with correct memberId for each entity type
   - No event published when ID field is null

**Concerns / Observations:**
- Uses `@TransactionalEventListener` which fires after transaction commits (correct behavior)
- `allEntries = true` evicts all cached date ranges for the member - this is intentional since any data change could affect any period
- Listener doesn't distinguish between INSERT/UPDATE/DELETE - any change triggers invalidation (simpler, safer)
- No integration test yet with actual database (would require Testcontainers setup)

**Next steps:**
- Proceed to Task 4 (REST Controller – MemberDashboardController) to expose the service via HTTP
- Consider adding integration test for full cache invalidation flow

**Report file:** `backend/.superpowers/sdd/member-dashboard/task-3-report.md`