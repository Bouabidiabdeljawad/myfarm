package com.myfarm.auth.repository;

import com.myfarm.auth.dto.PaymentProjection;
import com.myfarm.auth.dto.PaymentSummaryProjection;
import com.myfarm.auth.model.Payment;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;
import java.time.LocalDate;

public interface PaymentRepository extends JpaRepository<Payment, Long> {

    @Query("SELECT new com.myfarm.auth.dto.PaymentSummaryProjectionImpl(" +
           "SUM(p.amount), COUNT(p)) " +
           "FROM Payment p WHERE p.memberId = :memberId " +
           "AND p.date BETWEEN :start AND :end")
    PaymentSummaryProjection findByMemberIdAndDateRange(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);

    @Query("SELECT new com.myfarm.auth.dto.PaymentProjectionImpl(" +
           "p.id, p.amount, p.date, p.description, p.type) " +
           "FROM Payment p WHERE p.memberId = :memberId " +
           "AND p.date BETWEEN :start AND :end " +
           "ORDER BY p.date DESC")
    Page<PaymentProjection> findByMemberIdAndDateRangePaginated(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end,
            Pageable pageable);

    /**
     * Optimized native query for payment summary using covering index.
     * Uses the idx_payment_member_date_covering index.
     */
    @Query(value = """
        SELECT COALESCE(SUM(amount), 0) as total_payments, COUNT(*) as payment_count
        FROM payments
        WHERE member_id = :memberId AND date BETWEEN :start AND :end
        """, nativeQuery = true)
    PaymentSummaryProjection findByMemberIdAndDateRangeOptimized(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);
}