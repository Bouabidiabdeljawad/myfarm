package com.myfarm.auth.repository;

import com.myfarm.auth.dto.AnimalSummaryProjection;
import com.myfarm.auth.model.Animal;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

public interface AnimalRepository extends JpaRepository<Animal, Long> {

    @Query("SELECT new com.myfarm.auth.dto.AnimalSummaryProjectionImpl(" +
           "COUNT(a), SUM(a.weight)) " +
           "FROM Animal a WHERE a.ownerId = :memberId")
    AnimalSummaryProjection findSummaryByMemberId(@Param("memberId") Long memberId);

    @Query("SELECT new com.myfarm.auth.dto.AnimalSummaryProjectionImpl(" +
           "COUNT(a), SUM(a.weight)) " +
           "FROM Animal a WHERE a.ownerId = :memberId AND a.status = 'ACTIVE'")
    AnimalSummaryProjection findActiveSummaryByMemberId(@Param("memberId") Long memberId);

    /**
     * Optimized native query for active animal summary using composite index.
     * Uses the idx_animal_owner_status_weight covering index.
     */
    @Query(value = """
        SELECT COUNT(*) as total_animals, COALESCE(SUM(weight), 0) as total_weight
        FROM animals
        WHERE owner_id = :memberId AND status = 'ACTIVE'
        """, nativeQuery = true)
    AnimalSummaryProjection findActiveSummaryByMemberIdOptimized(@Param("memberId") Long memberId);
}