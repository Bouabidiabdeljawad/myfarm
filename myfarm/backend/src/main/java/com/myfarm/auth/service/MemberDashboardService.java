package com.myfarm.auth.service;

import com.myfarm.auth.dto.*;
import com.myfarm.auth.event.MemberDashboardInvalidationEvent;
import com.myfarm.auth.repository.*;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.context.event.EventListener;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Transactional(readOnly = true)
public class MemberDashboardService {

    private final AnimalRepository animalRepository;
    private final FeedAllocationRepository feedAllocationRepository;
    private final ContributionRepository contributionRepository;
    private final ExpenseRepository expenseRepository;
    private final PaymentRepository paymentRepository;
    private final BalanceRepository balanceRepository;
    private final CacheKeyProvider cacheKeyProvider;

    public MemberDashboardService(
            AnimalRepository animalRepository,
            FeedAllocationRepository feedAllocationRepository,
            ContributionRepository contributionRepository,
            ExpenseRepository expenseRepository,
            PaymentRepository paymentRepository,
            BalanceRepository balanceRepository,
            CacheKeyProvider cacheKeyProvider) {
        this.animalRepository = animalRepository;
        this.feedAllocationRepository = feedAllocationRepository;
        this.contributionRepository = contributionRepository;
        this.expenseRepository = expenseRepository;
        this.paymentRepository = paymentRepository;
        this.balanceRepository = balanceRepository;
        this.cacheKeyProvider = cacheKeyProvider;
    }

    /**
     * Get the member dashboard for a given member and date range.
     * Results are cached for 5 minutes.
     *
     * @param memberId the ID of the member (must match authenticated user)
     * @param start start date for filtering (inclusive)
     * @param end end date for filtering (inclusive)
     * @return MemberDashboardDto with all aggregated data
     */
    @Cacheable(value = "memberDashboard", key = "#root.target.cacheKeyProvider.memberDashboardKey(#memberId, #start, #end)")
    public MemberDashboardDto getMemberDashboard(Long memberId, LocalDate start, LocalDate end) {
        // Security check: validate memberId matches authenticated user
        // This is a placeholder - actual check will be done by MemberScope annotation in controller
        // or by Spring Security @PreAuthorize

        // Query all projections using optimized native queries with composite indexes
        AnimalSummaryProjection animalSummary = animalRepository.findActiveSummaryByMemberIdOptimized(memberId);
        FeedAllocationSummaryProjection feedAllocation = feedAllocationRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end);
        ContributionProjection contribution = contributionRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end);
        ExpenseProjection expense = expenseRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end);
        PaymentSummaryProjection payment = paymentRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end);
        BalanceProjection balance = balanceRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end);

        // Handle null projections (no data)
        if (animalSummary == null) {
            animalSummary = new AnimalSummaryProjectionImpl(0L, 0.0);
        }
        if (feedAllocation == null) {
            feedAllocation = new FeedAllocationSummaryProjectionImpl(0.0, 0.0);
        }
        if (contribution == null) {
            contribution = new ContributionProjectionImpl(BigDecimal.ZERO, 0L);
        }
        if (expense == null) {
            expense = new ExpenseProjectionImpl(BigDecimal.ZERO, 0L);
        }
        if (payment == null) {
            payment = new PaymentSummaryProjectionImpl(BigDecimal.ZERO, 0L);
        }
        if (balance == null) {
            balance = new BalanceProjectionImpl(BigDecimal.ZERO, BigDecimal.ZERO);
        }

        // Generate alerts based on data
        List<AlertProjection> alerts = generateAlerts(animalSummary, feedAllocation, balance);

        // Assemble DTO
        return new MemberDashboardDto(
                animalSummary,
                feedAllocation,
                contribution,
                expense,
                payment,
                balance,
                alerts
        );
    }

    /**
     * Generate alerts based on dashboard data.
     */
    private List<AlertProjection> generateAlerts(
            AnimalSummaryProjection animalSummary,
            FeedAllocationSummaryProjection feedAllocation,
            BalanceProjection balance) {
        // For now, return empty list - will be enhanced in future tasks
        // Example alerts could be:
        // - Low feed stock (if daily feed > 0 but no recent allocations)
        // - Outstanding balance (if balance > threshold)
        // - Upcoming payments
        return Collections.emptyList();
    }

    /**
     * Get paginated payment history for a member within a date range.
     *
     * @param memberId the ID of the member
     * @param start start date for filtering (inclusive)
     * @param end end date for filtering (inclusive)
     * @param pageable pagination parameters
     * @return Page of PaymentDto
     */
    public Page<PaymentDto> getPaymentHistory(Long memberId, LocalDate start, LocalDate end, Pageable pageable) {
        return paymentRepository.findByMemberIdAndDateRangePaginated(memberId, start, end, pageable)
                .map(projection -> new PaymentDto(
                        projection.getId(),
                        projection.getAmount(),
                        projection.getDate(),
                        projection.getDescription(),
                        projection.getType()
                ));
    }

    /**
     * Get paginated feed allocation history for a member within a date range.
     *
     * @param memberId the ID of the member
     * @param start start date for filtering (inclusive)
     * @param end end date for filtering (inclusive)
     * @param pageable pagination parameters
     * @return Page of FeedAllocationDto
     */
    public Page<FeedAllocationDto> getFeedHistory(Long memberId, LocalDate start, LocalDate end, Pageable pageable) {
        return feedAllocationRepository.findByMemberIdAndDateRangePaginated(memberId, start, end, pageable)
                .map(projection -> new FeedAllocationDto(
                        projection.getId(),
                        projection.getFeedType(),
                        projection.getDailyKg(),
                        projection.getMonthlyKg(),
                        projection.getDate()
                ));
    }

    /**
     * Evict member dashboard cache when member data changes.
     * This is triggered by MemberDashboardCacheInvalidationListener publishing
     * MemberDashboardInvalidationEvent after entity modifications.
     *
     * @param event the invalidation event containing the memberId
     */
    @EventListener
    @CacheEvict(value = "memberDashboard", key = "#event.memberId", allEntries = true)
    public void evictMemberDashboardCache(MemberDashboardInvalidationEvent event) {
        // Cache eviction happens automatically via annotation
        // This method body can be empty or log for debugging
    }
}