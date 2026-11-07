-- Migration V6: Add composite indexes for optimized member dashboard queries
-- These composite indexes cover the most common query patterns for member-scoped aggregations

-- Composite index on animals: owner_id + status (for active animal summary)
CREATE INDEX IF NOT EXISTS idx_animal_owner_status ON animals(owner_id, status);

-- Composite index on animals: owner_id + status + weight (covering index for active summary with weight)
CREATE INDEX IF NOT EXISTS idx_animal_owner_status_weight ON animals(owner_id, status, weight);

-- Composite index on feed_allocations: member_id + date (already exists from V5, but ensure it covers daily_kg/monthly_kg)
-- Adding included columns is not directly supported in PostgreSQL, but we can create a covering index
CREATE INDEX IF NOT EXISTS idx_feed_allocation_member_date_covering ON feed_allocations(member_id, date) INCLUDE (daily_kg, monthly_kg);

-- Composite index on payments: member_id + date (already exists from V5)
CREATE INDEX IF NOT EXISTS idx_payment_member_date_covering ON payments(member_id, date) INCLUDE (amount, description, type);

-- Composite index on expenses: member_id + date (already exists from V5)
CREATE INDEX IF NOT EXISTS idx_expense_member_date_covering ON expenses(member_id, date) INCLUDE (amount, category, description);

-- Composite index on contributions: member_id + date (already exists from V5)
CREATE INDEX IF NOT EXISTS idx_contribution_member_date_covering ON contributions(member_id, date) INCLUDE (amount, category, description);

-- Index for balance calculation: member_id + date across all three tables
-- The UNION ALL query in BalanceRepository will benefit from the individual indexes above