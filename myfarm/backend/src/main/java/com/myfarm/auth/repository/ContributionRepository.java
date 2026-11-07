package com.myfarm.auth.repository;

import com.myfarm.auth.dto.ContributionProjection;
import com.myfarm.auth.model.Contribution;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import java.math.BigDecimal;
import java.time.LocalDate;

public interface ContributionRepository extends JpaRepository<Contribution, Long> {

    @Query("SELECT new com.myfarm.auth.dto.ContributionProjectionImpl(" +
           "SUM(c.amount), COUNT(c)) " +
           "FROM Contribution c WHERE c.memberId = :memberId " +
           "AND c.date BETWEEN :start AND :end")
    ContributionProjection findByMemberIdAndDateRange(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);

    /**
     * Optimized native query for contribution summary using covering index.
     * Uses the idx_contribution_member_date_covering index.
     */
    @Query(value = """
        SELECT COALESCE(SUM(amount), 0) as total_contributions, COUNT(*) as contribution_count
        FROM contributions
        WHERE member_id = :memberId AND date BETWEEN :start AND :end
        """, nativeQuery = true)
    ContributionProjection findByMemberIdAndDateRangeOptimized(
            @Param("memberId") Long memberId,
            @Param("start") LocalDate start,
            @Param("end") LocalDate end);
}