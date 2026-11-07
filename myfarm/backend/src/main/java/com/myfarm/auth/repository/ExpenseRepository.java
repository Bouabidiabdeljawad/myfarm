package com.myfarm.auth.repository;

import com.myfarm.auth.dto.ExpenseProjection;
import com.myfarm.auth.model.Expense;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;
import java.time.LocalDate;

public interface ExpenseRepository extends JpaRepository<Expense, Long> {

    @Query("SELECT new com.myfarm.auth.dto.ExpenseProjectionImpl(" +
           "SUM(e.amount), COUNT(e)) " +
           "FROM Expense e WHERE e.memberId = :memberId " +
           "AND e.date BETWEEN :start AND :end")
    ExpenseProjection findByMemberIdAndDateRange(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);

    /**
     * Optimized native query for expense summary using covering index.
     * Uses the idx_expense_member_date_covering index.
     */
    @Query(value = """
        SELECT COALESCE(SUM(amount), 0) as total_expenses, COUNT(*) as expense_count
        FROM expenses
        WHERE member_id = :memberId AND date BETWEEN :start AND :end
        """, nativeQuery = true)
    ExpenseProjection findByMemberIdAndDateRangeOptimized(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);
}