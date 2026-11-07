package com.myfarm.auth.repository;

import com.myfarm.auth.dto.FeedAllocationProjection;
import com.myfarm.auth.dto.FeedAllocationSummaryProjection;
import com.myfarm.auth.model.FeedAllocation;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;
import java.time.LocalDate;

public interface FeedAllocationRepository extends JpaRepository<FeedAllocation, Long> {

    @Query("SELECT new com.myfarm.auth.dto.FeedAllocationSummaryProjectionImpl(" +
           "SUM(f.dailyKg), SUM(f.monthlyKg)) " +
           "FROM FeedAllocation f WHERE f.memberId = :memberId " +
           "AND f.date BETWEEN :start AND :end")
    FeedAllocationSummaryProjection findByMemberIdAndDateRange(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);

    @Query("SELECT new com.myfarm.auth.dto.FeedAllocationProjectionImpl(" +
           "f.id, f.feedType, f.dailyKg, f.monthlyKg, f.date) " +
           "FROM FeedAllocation f WHERE f.memberId = :memberId " +
           "AND f.date BETWEEN :start AND :end " +
           "ORDER BY f.date DESC")
    Page<FeedAllocationProjection> findByMemberIdAndDateRangePaginated(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end,
            Pageable pageable);

    /**
     * Optimized native query for feed allocation summary using covering index.
     * Uses the idx_feed_allocation_member_date_covering index.
     */
    @Query(value = """
        SELECT COALESCE(SUM(daily_kg), 0) as daily_feed_kg, COALESCE(SUM(monthly_kg), 0) as monthly_feed_kg
        FROM feed_allocations
        WHERE member_id = :memberId AND date BETWEEN :start AND :end
        """, nativeQuery = true)
    FeedAllocationSummaryProjection findByMemberIdAndDateRangeOptimized(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);
}