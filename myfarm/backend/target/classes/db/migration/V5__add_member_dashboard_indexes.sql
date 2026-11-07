-- Migration V5: Add indexes for member dashboard queries
-- These indexes optimize the projection queries for member-scoped data aggregation

-- Index on animal.owner_id for animal summary queries
CREATE INDEX IF NOT EXISTS idx_animal_owner_id ON animals(owner_id);

-- Index on feed_allocation.member_id and date for date-range filtering
CREATE INDEX IF NOT EXISTS idx_feed_allocation_member_date ON feed_allocations(member_id, date);

-- Index on payment.member_id and date for date-range filtering
CREATE INDEX IF NOT EXISTS idx_payment_member_date ON payments(member_id, date);

-- Index on expense.member_id and date for date-range filtering
CREATE INDEX IF NOT EXISTS idx_expense_member_date ON expenses(member_id, date);

-- Index on contribution.member_id and date for date-range filtering
CREATE INDEX IF NOT EXISTS idx_contribution_member_date ON contributions(member_id, date);