# Member Dashboard Task 3 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Implement cache invalidation for the Member Dashboard when member-related data changes.

**Architecture:** Spring event-driven cache invalidation using `@TransactionalEventListener` to listen for JPA entity changes and evict the corresponding member dashboard cache entries.

**Tech Stack:** Spring Boot 3.1.5, Spring Cache (Caffeine), Spring Data JPA, Java 17

**Spec:** `docs/superpowers/plans/2026-11-07-member-dashboard.md` (Task 3)

## Global Constraints

- All member endpoints must verify that the authenticated user is the owner of the requested data (member-scoped security)
- Cache member summaries for 5 minutes; invalidate on any write affecting the member's data
- No hidden UI elements will be used for security; backend must enforce all authorizations

## Review Focus

- Stale cache serving outdated balances after data changes
- Cache eviction not triggering for all relevant entity types
- Cross-member cache eviction (evicting wrong member's cache)
- Performance impact of event listeners on write operations

---

### Task 3.1: Create Cache Invalidation Event

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/event/MemberDashboardInvalidationEvent.java`

**Interfaces:**
- Produces: Event class for cache invalidation

- [ ] **Step 1:** Create `MemberDashboardInvalidationEvent` record/class with `memberId` field
- [ ] **Step 2:** Add constructor and getter
- [ ] **Step 3:** Verify compilation passes
- [ ] **Step 4:** Commit

---

### Task 3.2: Create Cache Invalidation Listener

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/listener/MemberDashboardCacheInvalidationListener.java`

**Interfaces:**
- Consumes: JPA entity events for Animal, FeedAllocation, Payment, Expense, Contribution
- Produces: MemberDashboardInvalidationEvent published to Spring ApplicationEventPublisher

- [ ] **Step 1:** Write failing test for listener triggering on entity save
- [ ] **Step 2:** Implement listener with `@TransactionalEventListener` for each entity type
- [ ] **Step 3:** Handle INSERT, UPDATE, DELETE operations
- [ ] **Step 4:** Extract memberId/ownerId from entity and publish event
- [ ] **Step 5:** Run test, verify event is published
- [ ] **Step 6:** Commit

---

### Task 3.3: Add Cache Eviction Handler in MemberDashboardService

**Files:**
- Modify: `backend/src/main/java/com/myfarm/auth/service/MemberDashboardService.java`

**Interfaces:**
- Consumes: MemberDashboardInvalidationEvent
- Produces: Cache eviction for specific memberId

- [ ] **Step 1:** Write failing test that cache is evicted when event is received
- [ ] **Step 2:** Add `@EventListener` method with `@CacheEvict(value = "memberDashboard", key = "#event.memberId")`
- [ ] **Step 3:** Run test, verify cache eviction works
- [ ] **Step 4:** Commit

---

### Task 3.4: Integration Test for Cache Invalidation

**Files:**
- Create: `backend/src/test/java/com/myfarm/auth/listener/MemberDashboardCacheInvalidationListenerIntegrationTest.java`

**Interfaces:**
- Tests: Full flow from entity save → event → cache eviction

- [ ] **Step 1:** Write failing integration test using Spring's @SpringBootTest
- [ ] **Step 2:** Test: Save entity → call service (populates cache) → modify entity → call service again (should hit DB, not cache)
- [ ] **Step 3:** Verify cache was evicted (repository method called twice)
- [ ] **Step 4:** Run test, ensure pass
- [ ] **Step 5:** Commit

---

## Method Signatures Reference

### Event Class (Task 3.1)

```java
package com.myfarm.auth.event;

public record MemberDashboardInvalidationEvent(Long memberId) {
    // Record automatically provides constructor, getter, equals, hashCode, toString
}
```

### Listener (Task 3.2)

```java
package com.myfarm.auth.listener;

import com.myfarm.auth.event.MemberDashboardInvalidationEvent;
import com.myfarm.auth.model.*;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionalEventListener;

@Component
public class MemberDashboardCacheInvalidationListener {
    
    private final ApplicationEventPublisher eventPublisher;
    
    public MemberDashboardCacheInvalidationListener(ApplicationEventPublisher eventPublisher) {
        this.eventPublisher = eventPublisher;
    }
    
    @TransactionalEventListener
    public void onAnimalChanged(Animal entity) {
        if (entity.getOwnerId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getOwnerId()));
        }
    }
    
    @TransactionalEventListener
    public void onFeedAllocationChanged(FeedAllocation entity) {
        if (entity.getMemberId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getMemberId()));
        }
    }
    
    @TransactionalEventListener
    public void onPaymentChanged(Payment entity) {
        if (entity.getMemberId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getMemberId()));
        }
    }
    
    @TransactionalEventListener
    public void onExpenseChanged(Expense entity) {
        if (entity.getMemberId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getMemberId()));
        }
    }
    
    @TransactionalEventListener
    public void onContributionChanged(Contribution entity) {
        if (entity.getMemberId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getMemberId()));
        }
    }
}
```

### Cache Eviction Handler (Task 3.3)

```java
// In MemberDashboardService
@EventListener
@CacheEvict(value = "memberDashboard", key = "#event.memberId", allEntries = true)
public void evictMemberDashboardCache(MemberDashboardInvalidationEvent event) {
    // Cache eviction happens automatically via annotation
    // This method body can be empty or log for debugging
}
```

---

## Self-Review Checklist

- [ ] Event class created with memberId
- [ ] Listener handles all 5 entity types (Animal, FeedAllocation, Payment, Expense, Contribution)
- [ ] Listener uses @TransactionalEventListener (runs after transaction commits)
- [ ] Listener extracts correct ID field (ownerId for Animal, memberId for others)
- [ ] MemberDashboardService has @EventListener + @CacheEvict method
- [ ] Cache eviction uses correct cache name ("memberDashboard")
- [ ] Cache eviction key uses event.memberId
- [ ] allEntries = true to evict all date-range variations for the member
- [ ] Integration test verifies full flow works
- [ ] Tests pass

---

## Next Steps

- Review this plan
- Choose execution approach
- Once approved, start with Task 3.1 (create event class)