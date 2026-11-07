package com.myfarm.auth.service;

import com.myfarm.auth.dto.*;
import com.myfarm.auth.repository.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.mockito.quality.Strictness;

import java.math.BigDecimal;
import java.time.LocalDate;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@org.mockito.junit.jupiter.MockitoSettings(strictness = Strictness.LENIENT)
class MemberDashboardServiceTest {

    @Mock
    private AnimalRepository animalRepository;

    @Mock
    private FeedAllocationRepository feedAllocationRepository;

    @Mock
    private ContributionRepository contributionRepository;

    @Mock
    private ExpenseRepository expenseRepository;

    @Mock
    private PaymentRepository paymentRepository;

    @Mock
    private BalanceRepository balanceRepository;

    @Mock
    private CacheKeyProvider cacheKeyProvider;

    @InjectMocks
    private MemberDashboardService memberDashboardService;

    @Test
    void getMemberDashboardShouldReturnPopulatedDto() {
        // Arrange
        Long memberId = 1L;
        LocalDate start = LocalDate.of(2024, 1, 1);
        LocalDate end = LocalDate.of(2024, 1, 31);

        when(cacheKeyProvider.memberDashboardKey(memberId, start, end))
                .thenReturn("memberDashboard:1:2024-01-01:2024-01-31");

        AnimalSummaryProjection animalSummary = new AnimalSummaryProjectionImpl(5L, 1250.0);
        when(animalRepository.findActiveSummaryByMemberIdOptimized(memberId))
                .thenReturn(animalSummary);

        FeedAllocationSummaryProjection feedAllocation = new FeedAllocationSummaryProjectionImpl(15.5, 465.0);
        when(feedAllocationRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end))
                .thenReturn(feedAllocation);

        ContributionProjection contribution = new ContributionProjectionImpl(
                new BigDecimal("5000.00"), 10L);
        when(contributionRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end))
                .thenReturn(contribution);

        ExpenseProjection expense = new ExpenseProjectionImpl(
                new BigDecimal("3000.00"), 5L);
        when(expenseRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end))
                .thenReturn(expense);

        PaymentSummaryProjection payment = new PaymentSummaryProjectionImpl(
                new BigDecimal("2000.00"), 3L);
        when(paymentRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end))
                .thenReturn(payment);

        BalanceProjection balance = new BalanceProjectionImpl(
                new BigDecimal("1000.00"), new BigDecimal("-1000.00"));
        when(balanceRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end))
                .thenReturn(balance);

        // Act
        MemberDashboardDto result = memberDashboardService.getMemberDashboard(memberId, start, end);

        // Assert
        assertNotNull(result);
        assertEquals(5L, result.getTotalAnimals());
        assertEquals(1250.0, result.getTotalWeight());
        assertEquals(15.5, result.getDailyFeedKg());
        assertEquals(465.0, result.getMonthlyFeedKg());
        assertEquals(new BigDecimal("5000.00"), result.getTotalContributions());
        assertEquals(10L, result.getContributionCount());
        assertEquals(new BigDecimal("3000.00"), result.getTotalExpenses());
        assertEquals(5L, result.getExpenseCount());
        assertEquals(new BigDecimal("2000.00"), result.getTotalPayments());
        assertEquals(3L, result.getPaymentCount());
        assertEquals(new BigDecimal("1000.00"), result.getOutstandingBalance());
        assertEquals(new BigDecimal("-1000.00"), result.getNetBalance());
        assertTrue(result.getAlerts().isEmpty());

        // Verify all repositories were called with optimized methods
        verify(animalRepository).findActiveSummaryByMemberIdOptimized(memberId);
        verify(feedAllocationRepository).findByMemberIdAndDateRangeOptimized(memberId, start, end);
        verify(contributionRepository).findByMemberIdAndDateRangeOptimized(memberId, start, end);
        verify(expenseRepository).findByMemberIdAndDateRangeOptimized(memberId, start, end);
        verify(paymentRepository).findByMemberIdAndDateRangeOptimized(memberId, start, end);
        verify(balanceRepository).findByMemberIdAndDateRangeOptimized(memberId, start, end);
    }

    @Test
    void getMemberDashboardShouldHandleNullProjections() {
        // Arrange
        Long memberId = 2L;
        LocalDate start = LocalDate.of(2024, 1, 1);
        LocalDate end = LocalDate.of(2024, 1, 31);

        when(cacheKeyProvider.memberDashboardKey(memberId, start, end))
                .thenReturn("memberDashboard:2:2024-01-01:2024-01-31");

        when(animalRepository.findActiveSummaryByMemberIdOptimized(memberId)).thenReturn(null);
        when(feedAllocationRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end)).thenReturn(null);
        when(contributionRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end)).thenReturn(null);
        when(expenseRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end)).thenReturn(null);
        when(paymentRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end)).thenReturn(null);
        when(balanceRepository.findByMemberIdAndDateRangeOptimized(memberId, start, end)).thenReturn(null);

        // Act
        MemberDashboardDto result = memberDashboardService.getMemberDashboard(memberId, start, end);

        // Assert
        assertNotNull(result);
        assertEquals(0L, result.getTotalAnimals());
        assertEquals(0.0, result.getTotalWeight());
        assertEquals(0.0, result.getDailyFeedKg());
        assertEquals(0.0, result.getMonthlyFeedKg());
        assertEquals(BigDecimal.ZERO, result.getTotalContributions());
        assertEquals(0L, result.getContributionCount());
        assertEquals(BigDecimal.ZERO, result.getTotalExpenses());
        assertEquals(0L, result.getExpenseCount());
        assertEquals(BigDecimal.ZERO, result.getTotalPayments());
        assertEquals(0L, result.getPaymentCount());
        assertEquals(BigDecimal.ZERO, result.getOutstandingBalance());
        assertEquals(BigDecimal.ZERO, result.getNetBalance());
    }
}