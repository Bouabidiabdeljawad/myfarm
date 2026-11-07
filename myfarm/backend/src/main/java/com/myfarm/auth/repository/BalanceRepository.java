package com.myfarm.auth.repository;

import com.myfarm.auth.dto.BalanceProjection;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.time.LocalDate;

public interface BalanceRepository {

    @Query(value = """
        SELECT
            COALESCE(SUM(CASE WHEN t.type = 'EXPENSE' THEN t.amount ELSE 0 END), 0) -
            COALESCE(SUM(CASE WHEN t.type = 'PAYMENT' THEN t.amount ELSE 0 END), 0) AS outstanding_balance,
            COALESCE(SUM(CASE WHEN t.type = 'CONTRIBUTION' THEN t.amount ELSE 0 END), 0) +
            COALESCE(SUM(CASE WHEN t.type = 'PAYMENT' THEN t.amount ELSE 0 END), 0) -
            COALESCE(SUM(CASE WHEN t.type = 'EXPENSE' THEN t.amount ELSE 0 END), 0) AS net_balance
        FROM (
            SELECT amount, 'EXPENSE' as type FROM expenses WHERE member_id = :memberId AND date BETWEEN :start AND :end
            UNION ALL
            SELECT amount, 'PAYMENT' as type FROM payments WHERE member_id = :memberId AND date BETWEEN :start AND :end
            UNION ALL
            SELECT amount, 'CONTRIBUTION' as type FROM contributions WHERE member_id = :memberId AND date BETWEEN :start AND :end
        ) t
        """, nativeQuery = true)
    BalanceProjection findByMemberIdAndDateRange(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);

    /**
     * Optimized native query for balance using CTEs and the composite indexes.
     * This version uses separate aggregations which may be more efficient with the covering indexes.
     */
    @Query(value = """
        WITH expense_agg AS (
            SELECT COALESCE(SUM(amount), 0) as total_expenses
            FROM expenses
            WHERE member_id = :memberId AND date BETWEEN :start AND :end
        ),
        payment_agg AS (
            SELECT COALESCE(SUM(amount), 0) as total_payments
            FROM payments
            WHERE member_id = :memberId AND date BETWEEN :start AND :end
        ),
        contribution_agg AS (
            SELECT COALESCE(SUM(amount), 0) as total_contributions
            FROM contributions
            WHERE member_id = :memberId AND date BETWEEN :start AND :end
        )
        SELECT
            e.total_expenses - p.total_payments as outstanding_balance,
            c.total_contributions + p.total_payments - e.total_expenses as net_balance
        FROM expense_agg e, payment_agg p, contribution_agg c
        """, nativeQuery = true)
    BalanceProjection findByMemberIdAndDateRangeOptimized(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);
}