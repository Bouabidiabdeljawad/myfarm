# Member Dashboard Task 2 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement the MemberDashboardService that uses projection interfaces from Task 1 to assemble a member-scoped dashboard DTO with date-range filtering, caching, and proper security.

**Architecture:** Spring Boot service layer using JPA projections for efficient aggregation queries. Service validates member access, queries repositories for projected data, assembles DTO, and caches results for 5 minutes.

**Tech Stack:** Spring Boot 3.1.5, Java 17, Spring Data JPA, PostgreSQL, Spring Cache (Caffeine), JWT security

**Spec:** `docs/superpowers/plans/2026-11-07-member-dashboard.md` (Task 2)

## Global Constraints

- All member endpoints must verify that the authenticated user is the owner of the requested data (member-scoped security)
- No hidden UI elements will be used for security; backend must enforce all authorizations
- Use explicit foreign keys and indexes on `animal.farm_id`, `animal.owner_id`, `feed_allocation.member_id`, `payment.member_id`, etc.
- Cache member summaries for 5 minutes; invalidate on any write affecting the member's data
- Monetary values: BigDecimal, quantities: Double, IDs: Long
- Date ranges filter on relevant entities (feed_allocation, payment, expense, contribution)

## Review Focus

- Cross-member data leakage (seeing another member's finances)
- Stale cache serving outdated balances
- Incorrect aggregation when a member belongs to multiple farms
- Missing authorization checks on service methods
- Performance of aggregation queries for members with many animals

---

### Task 2.0: Prerequisites - Create Task 1 Files (Projections, DTO, Migration)

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/dto/MemberDashboardDto.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/AnimalSummaryProjection.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/FeedAllocationProjection.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/ContributionProjection.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/ExpenseProjection.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/PaymentProjection.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/BalanceProjection.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/AlertProjection.java`
- Create: `backend/src/main/resources/db/migration/V5__add_member_dashboard_indexes.sql`
- Create: `backend/src/test/java/com/myfarm/auth/dto/MemberDashboardDtoTest.java`

**Interfaces:**
- None (prerequisites)

- [ ] **Step 1:** Create all projection interfaces with getters for required fields
- [ ] **Step 2:** Create MemberDashboardDto with constructor accepting all projections and public getters
- [ ] **Step 3:** Create migration V5 adding indexes on member-related foreign keys
- [ ] **Step 4:** Create unit test for MemberDashboardDto
- [ ] **Step 5:** Verify compilation passes

---

### Task 2.1: Create Repository Interfaces with Projection Queries

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/repository/AnimalRepository.java`
- Create: `backend/src/main/java/com/myfarm/auth/repository/FeedAllocationRepository.java`
- Create: `backend/src/main/java/com/myfarm/auth/repository/ContributionRepository.java`
- Create: `backend/src/main/java/com/myfarm/auth/repository/ExpenseRepository.java`
- Create: `backend/src/main/java/com/myfarm/auth/repository/PaymentRepository.java`
- Create: `backend/src/main/java/com/myfarm/auth/repository/BalanceRepository.java` (or use existing Payment/Expense repos)

**Interfaces:**
- Consumes: Projection interfaces from Task 1

- [ ] **Step 1:** Write failing test for AnimalRepository projection query
- [ ] **Step 2:** Implement AnimalRepository with @Query returning AnimalSummaryProjection
- [ ] **Step 3:** Write failing test for FeedAllocationRepository projection query
- [ ] **Step 4:** Implement FeedAllocationRepository with @Query returning FeedAllocationProjection
- [ ] **Step 5:** Write failing test for ContributionRepository projection query
- [ ] **Step 6:** Implement ContributionRepository with @Query returning ContributionProjection
- [ ] **Step 7:** Write failing test for ExpenseRepository projection query
- [ ] **Step 8:** Implement ExpenseRepository with @Query returning ExpenseProjection
- [ ] **Step 9:** Write failing test for PaymentRepository projection query
- [ ] **Step 10:** Implement PaymentRepository with @Query returning PaymentProjection
- [ ] **Step 11:** Write failing test for BalanceProjection (net balance query)
- [ ] **Step 12:** Implement BalanceProjection query (could be in a BalanceRepository or Payment/Expense repo)
- [ ] **Step 13:** Run all tests, verify pass
- [ ] **Step 14:** Commit

---

### Task 2.2: Create CacheKeyProvider Utility

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/service/CacheKeyProvider.java`

**Interfaces:**
- Produces: Cache key generation for member dashboard

- [ ] **Step 1:** Write failing test for CacheKeyProvider.key(memberId, start, end)
- [ ] **Step 2:** Implement CacheKeyProvider with method `String key(Long memberId, LocalDate start, LocalDate end)`
- [ ] **Step 3:** Run test, verify pass
- [ ] **Step 4:** Commit

---

### Task 2.3: Create MemberDashboardService

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/service/MemberDashboardService.java`

**Interfaces:**
- Consumes: All repository interfaces from Task 2.1, CacheKeyProvider from Task 2.2
- Produces: MemberDashboardDto for Task 2.4 (Controller)

- [ ] **Step 1:** Write failing test for `getMemberDashboard(Long memberId, LocalDate start, LocalDate end)` returning fully populated MemberDashboardDto
- [ ] **Step 2:** Run test – fails (service missing)
- [ ] **Step 3:** Implement MemberDashboardService with:
  - @Service annotation
  - Constructor injection of all repositories + CacheKeyProvider
  - Method `MemberDashboardDto getMemberDashboard(Long memberId, LocalDate start, LocalDate end)`
  - Security check: validate memberId matches authenticated user (placeholder for MemberScope)
  - Query each repository with date range filtering
  - Assemble MemberDashboardDto from all projections
  - @Cacheable annotation with cache key from CacheKeyProvider
- [ ] **Step 4:** Write unit test verifying cache hit on second call (mock CacheManager)
- [ ] **Step 5:** Run all tests, ensure pass
- [ ] **Step 6:** Commit

---

### Task 2.4: Create MemberDashboardService Integration Tests

**Files:**
- Create: `backend/src/test/java/com/myfarm/auth/service/MemberDashboardServiceTest.java`
- Create: `backend/src/test/java/com/myfarm/auth/service/MemberDashboardServiceIntegrationTest.java` (with Testcontainers)

**Interfaces:**
- Tests: MemberDashboardService, all repositories

- [ ] **Step 1:** Write failing unit test with mocked repositories verifying service assembles DTO correctly
- [ ] **Step 2:** Write failing integration test using Testcontainers PostgreSQL:
  - Create member with animals, feed allocations, contributions, expenses, payments
  - Call service with date range
  - Verify all DTO fields match expected aggregated values
- [ ] **Step 3:** Implement missing pieces until tests pass
- [ ] **Step 4:** Run tests, ensure pass
- [ ] **Step 5:** Commit

---

### Task 2.5: Add Cache Configuration

**Files:**
- Create/Update: `backend/src/main/java/com/myfarm/auth/config/CacheConfig.java`

**Interfaces:**
- Configures Caffeine cache for memberDashboard cache

- [ ] **Step 1:** Write failing test that cache is configured with 5-minute TTL
- [ ] **Step 2:** Implement CacheConfig with Caffeine cache builder:
  - Cache name: "memberDashboard"
  - TTL: 5 minutes
  - Maximum size: 1000 entries
- [ ] **Step 3:** Run test, verify pass
- [ ] **Step 4:** Commit

---

## Method Signatures Reference

### Projection Interfaces (Task 1 - to be created first)

```java
// AnimalSummaryProjection
Long getTotalAnimals();
Double getTotalWeight();

// FeedAllocationProjection
Double getDailyFeedKg();
Double getMonthlyFeedKg();
List<FeedAllocationByTypeProjection> getByType(); // or separate

// ContributionProjection
BigDecimal getTotalContributions();
Integer getContributionCount();

// ExpenseProjection
BigDecimal getTotalExpenses();
Integer getExpenseCount();

// PaymentProjection
BigDecimal getTotalPayments();
Integer getPaymentCount();

// BalanceProjection
BigDecimal getOutstandingBalance();
BigDecimal getNetBalance();

// AlertProjection
String getMessage();
AlertSeverity getSeverity(); // or enum

// MemberDashboardDto
MemberDashboardDto(
    AnimalSummaryProjection animalSummary,
    FeedAllocationProjection feedAllocation,
    ContributionProjection contribution,
    ExpenseProjection expense,
    PaymentProjection payment,
    BalanceProjection balance,
    List<AlertProjection> alerts
)
// + getters for all fields
```

### Repository Methods (Task 2.1)

```java
// AnimalRepository
@Query("SELECT new com.myfarm.auth.dto.AnimalSummaryProjectionImpl(COUNT(a), SUM(a.weight)) FROM Animal a WHERE a.owner.id = :memberId")
AnimalSummaryProjection findSummaryByMemberId(@Param("memberId") Long memberId);

// FeedAllocationRepository
@Query("SELECT new com.myfarm.auth.dto.FeedAllocationProjectionImpl(SUM(f.dailyKg), SUM(f.monthlyKg)) FROM FeedAllocation f WHERE f.member.id = :memberId AND f.date BETWEEN :start AND :end")
FeedAllocationProjection findByMemberIdAndDateRange(@Param("memberId") Long memberId, @Param("start") LocalDate start, @Param("end") LocalDate end);

// Similar for ContributionRepository, ExpenseRepository, PaymentRepository
```

### Service Method (Task 2.3)

```java
@Service
public class MemberDashboardService {
    private final AnimalRepository animalRepository;
    private final FeedAllocationRepository feedAllocationRepository;
    private final ContributionRepository contributionRepository;
    private final ExpenseRepository expenseRepository;
    private final PaymentRepository paymentRepository;
    private final CacheKeyProvider cacheKeyProvider;

    @Cacheable(value = "memberDashboard", key = "#root.target.cacheKeyProvider.key(#memberId, #start, #end)")
    public MemberDashboardDto getMemberDashboard(Long memberId, LocalDate start, LocalDate end) {
        // Security check
        // Query all repositories
        // Assemble DTO
    }
}
```

### CacheKeyProvider (Task 2.2)

```java
@Component
public class CacheKeyProvider {
    public String key(Long memberId, LocalDate start, LocalDate end) {
        return "memberDashboard:" + memberId + ":" + start + ":" + end;
    }
}
```

---

## Self-Review Checklist

- [ ] All Task 1 projection interfaces and DTO created
- [ ] Repository interfaces use @Query with projections (no full entity loading)
- [ ] Service method validates member access (placeholder for MemberScope)
- [ ] @Cacheable with proper cache key including memberId, start, end
- [ ] CacheConfig configures 5-minute TTL for memberDashboard cache
- [ ] Unit tests with mocked repositories pass
- [ ] Integration test with Testcontainers passes
- [ ] All date-range filtering works correctly
- [ ] Monetary values use BigDecimal, quantities use Double, IDs use Long

---

## Next Steps

- Review this plan
- Choose execution approach (subagent-driven or native)
- Once approved, start with Task 2.0 (create Task 1 prerequisite files)