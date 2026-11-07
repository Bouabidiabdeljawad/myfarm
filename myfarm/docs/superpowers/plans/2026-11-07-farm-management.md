# Farm Management Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task‑by‑task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Provide a complete, secure, multi‑tenant farm management module allowing Super Admins, Farm Admins and Members to create, edit, archive farms, manage memberships, assign roles, and view activity, with full test coverage and farm‑scoped authorization.

**Architecture:** Backend built with Spring Boot (Java 17) using JPA/Hibernate for PostgreSQL. Entities model farms, memberships, roles, permissions. Service layer enforces business rules and farm‑scoped security. REST API exposed to Flutter mobile client. Flutter UI uses existing design system for farm selection and management screens.

**Tech Stack:** Spring Boot 3.1, Spring Data JPA, PostgreSQL, Flyway migrations, Spring Security (JWT), Argon2 password hashing, Maven, Flutter 3.19, Moor (Drift) for local DB, Retrofit for API calls.

**Spec:** `docs/superpowers/specs/2026-11-02-myfarm-architecture-design.md` (Phase 04 specification)

## Global Constraints
- PostgreSQL 15+, use explicit foreign keys and indexes.
- All write operations must be wrapped in a transaction.
- Farm ID supplied by client must be validated against the caller’s memberships before any data access.
- No cross‑farm data leakage – queries must always filter by farm ID where applicable.
- Follow existing code style: Lombok not used, explicit getters/setters, JPA annotations.

## Review Focus
- Unauthorized access to another farm's data.
- Missing cascade delete when archiving a farm (should not delete related data).
- Role escalation attacks (member becoming admin).
- Concurrency race when assigning/removing members.
- Validation of farm name uniqueness across all farms.

---

### Task 1: Define Farm Entity and Migration

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/model/Farm.java`
- Create migration: `backend/src/main/resources/db/migration/V2__create_farms.sql`

**Interfaces:**
- None (first task).

- [ ] **Step 1: Write failing test for Farm repository existence**
```java
@Test
void farmRepositoryExists() {
    assertNotNull(applicationContext.getBean(FarmRepository.class));
}
```
- [ ] **Step 2: Run test to verify it fails** (no repository yet).
- [ ] **Step 3: Implement `Farm` entity** (as created earlier).
- [ ] **Step 4: Implement `FarmRepository` extending `JpaRepository<Farm, Long>`**.
- [ ] **Step 5: Write migration creating `farms` table with columns `id`, `name` (unique), `archived` (default false).**
- [ ] **Step 6: Run migration with Flyway and verify table exists.**
- [ ] **Step 7: Run test to verify repository can save and retrieve a farm.**
- [ ] **Step 8: Commit**

### Task 2: Define FarmMembership Entity, Enum Role, and Repository

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/model/FarmMembership.java` (already created).
- Create: `backend/src/main/java/com/myfarm/auth/repository/FarmMembershipRepository.java`
- Update migration: `backend/src/main/resources/db/migration/V3__create_farm_memberships.sql`

**Interfaces:**
- Uses `Farm` and `User` entities.

- [ ] **Step 1: Write failing test for uniqueness constraint (farm_id + user_id).**
```java
@Test
void cannotCreateDuplicateMembership() {
    // create farm, user, then two identical memberships -> expect DataIntegrityViolationException
}
```
- [ ] **Step 2: Run test to see failure.
- [ ] **Step 3: Implement `FarmMembership` entity (already added) and enum `Role` (already present).
- [ ] **Step 4: Implement `FarmMembershipRepository`.
- [ ] **Step 5: Write migration creating `farm_memberships` table with foreign keys to `farms` and `users`, unique constraint on (farm_id, user_id).
- [ ] **Step 6: Verify cascade behavior (deleting a farm does not delete users, but removes memberships).
- [ ] **Step 7: Run test and ensure it passes.
- [ ] **Step 8: Commit.

### Task 3: Service Layer – FarmManagementService

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/service/FarmManagementService.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/FarmDto.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/FarmCreateRequest.java`
- Create: `backend/src/main/java/com/myfarm/auth/dto/FarmUpdateRequest.java`

**Interfaces:**
- Depends on `FarmRepository`, `FarmMembershipRepository`, `UserRepository`.

- [ ] **Step 1: Write failing test for creating a farm (valid request).**
- [ ] **Step 2: Write failing test for editing a farm (only name change).**
- [ ] **Step 3: Write failing test for archiving a farm (sets archived flag, does not delete).**
- [ ] **Step 4: Implement service methods `createFarm`, `updateFarm`, `archiveFarm` with transaction management and validation (unique name, farm exists).**
- [ ] **Step 5: Ensure service checks that caller's user has `SUPER_ADMIN` or `FARM_ADMIN` role for the target farm.**
- [ ] **Step 6: Run all tests, verify pass.
- [ ] **Step 7: Commit.

### Task 4: Membership Management Service

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/service/MembershipService.java`
- Create DTOs: `MembershipCreateRequest.java`, `MembershipUpdateRequest.java`

**Interfaces:**
- Uses `FarmMembershipRepository`, `UserRepository`, `FarmRepository`.

- [ ] **Step 1: Write failing test for adding a member to a farm (valid admin).**
- [ ] **Step 2: Write failing test for removing a member.**
- [ ] **Step 3: Write failing test for role change (member ↔ farm admin).**
- [ ] **Step 4: Implement service methods with checks: caller must be `SUPER_ADMIN` or `FARM_ADMIN` of the farm; cannot assign `SUPER_ADMIN` role via this endpoint.
- [ ] **Step 5: Ensure all operations are transactional and emit audit events (simple log statements).**
- [ ] **Step 6: Run tests and confirm pass.
- [ ] **Step 7: Commit.

### Task 5: REST Controllers

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/controller/FarmController.java`
- Create: `backend/src/main/java/com/myfarm/auth/controller/MembershipController.java`

**Interfaces:**
- Calls `FarmManagementService` and `MembershipService`.
- Secured with `@PreAuthorize` annotations that reference custom `@FarmScope` annotation (to be added).

- [ ] **Step 1: Write failing test for `POST /farms` returning 201 and location header.**
- [ ] **Step 2: Write failing test for `PUT /farms/{id}` returning 200.
- [ ] **Step 3: Write failing test for `DELETE /farms/{id}` (archive) returning 204.
- [ ] **Step 4: Write failing test for `POST /farms/{id}/members` (add member) returning 201.
- [ ] **Step 5: Implement controller endpoints, map DTOs, return appropriate HTTP status codes.
- [ ] **Step 6: Add `@FarmScope` custom annotation + argument resolver that validates the farm ID against the authenticated user's memberships (security filter).**
- [ ] **Step 7: Run all controller tests with MockMvc, ensure pass.
- [ ] **Step 8: Commit.

### Task 6: Security – Farm‑Scoped Authorization

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/security/FarmScope.java` (annotation).
- Create: `backend/src/main/java/com/myfarm/auth/security/FarmScopeResolver.java`
- Update: `SecurityConfig.java` to register the resolver.

**Interfaces:**
- Works with Spring Security authentication principal (UserDetails) that contains user ID and global role.

- [ ] **Step 1: Write failing test that a user without membership cannot access `/farms/{id}/members`.**
- [ ] **Step 2: Implement annotation and resolver that fetches the farm membership for the authenticated user; throws `AccessDeniedException` if not found.
- [ ] **Step 3: Verify that `FARM_ADMIN` can manage members, `MEMBER` can only view activity (later task).
- [ ] **Step 4: Run test, ensure pass.
- [ ] **Step 5: Commit.

### Task 7: Activity History Service & Endpoint

**Files:**
- Create: `backend/src/main/java/com/myfarm/auth/model/FarmActivity.java`
- Create migration `V4__create_farm_activity.sql` (timestamp, farm_id, user_id, action, details).
- Create: `backend/src/main/java/com/myfarm/auth/service/FarmActivityService.java`
- Create: `backend/src/main/java/com/myfarm/auth/controller/FarmActivityController.java`

**Interfaces:**
- Uses `FarmActivityRepository` (new) and security checks.

- [ ] **Step 1: Write failing test for `GET /farms/{id}/activity` returns list ordered by timestamp, only for authorized members.
- [ ] **Step 2: Implement entity, repository, service that records actions (create, edit, member add/remove, role change, archive).
- [ ] **Step 3: Implement controller endpoint with pagination support.
- [ ] **Step 4: Run test, ensure pass.
- [ ] **Step 5: Commit.

### Task 8: Flutter UI – Farm Selection Screen

**Files:**
- Create: `mobile/lib/features/farm_selection/farm_selection_screen.dart`
- Create: `mobile/lib/features/farm_selection/farm_selection_viewmodel.dart`
- Update navigation routes in `app_routes.dart`.

**Interfaces:**
- Calls backend `/farms` endpoints via existing `ApiClient`.
- Uses existing design system components (cards, list tiles).

- [ ] **Step 1: Write failing widget test that the screen displays a list of farms fetched from API.
- [ ] **Step 2: Implement ViewModel that fetches farms for the authenticated user and exposes a list of `FarmDto`.
- [ ] **Step 3: Build UI showing each farm with name, status (archived badge), and a tap to select.
- [ ] **Step 4: Ensure selecting a farm updates a global `CurrentFarmProvider` (to be created).
- [ ] **Step 5: Run widget test, ensure pass.
- [ ] **Step 6: Commit.

### Task 9: Flutter UI – Farm Management Screens

**Files:**
- Create: `mobile/lib/features/farm_management/farm_detail_screen.dart`
- Create: `mobile/lib/features/farm_management/farm_edit_screen.dart`
- Create: `mobile/lib/features/farm_management/member_management_screen.dart`
- Create corresponding ViewModels.

**Interfaces:**
- Calls backend create/edit/archive endpoints, membership endpoints.
- Uses `CurrentFarmProvider` to know which farm is active.

- [ ] **Step 1: Write failing widget test for farm detail showing name, edit button, archive toggle.
- [ ] **Step 2: Implement edit screen with form validation (unique name check via API call on submit).
- [ ] **Step 3: Implement archive action (shows confirmation dialog, calls API, updates UI).
- [ ] **Step 4: Implement member management screen: list members, add member (email invite), change role, remove member.
- [ ] **Step 5: Write failing integration test that a `FARM_ADMIN` can add a member and a `MEMBER` cannot see the add button.
- [ ] **Step 6: Run all widget and integration tests, ensure pass.
- [ ] **Step 7: Commit.

### Task 10: End‑to‑End Tests (Backend + Mobile)

**Files:**
- Add backend integration tests under `backend/src/test/java/com/myfarm/auth/integration/FarmIntegrationTest.java` using `@SpringBootTest` and Testcontainers for PostgreSQL.
- Add mobile integration test using `integration_test` package.

- [ ] **Step 1: Write failing test that creates a farm, adds members, switches farm, and verifies activity history contains each action.
- [ ] **Step 2: Implement missing pieces until test passes.
- [ ] **Step 3: Ensure CI pipeline runs these tests.
- [ ] **Step 4: Commit.

---

**Self‑Review Checklist**
- All entities have explicit foreign keys and indexes.
- All write operations are transactional.
- Farm‑scoped checks are applied to every endpoint.
- Tests cover unauthorized access, role escalation, and concurrency edge cases.
- Flutter UI respects the current farm context and disables actions for insufficient roles.

**Next Steps**
- Review this plan with you.
- Choose execution approach (subagent‑driven or native).
- Once approved, we will start implementing tasks in order.
