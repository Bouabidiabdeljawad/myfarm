package com.myfarm.auth.dto;

import org.junit.jupiter.api.Test;
import org.mockito.Mockito;

import java.math.BigDecimal;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class MemberDashboardDtoTest {

    @Test
    void constructorShouldPopulateAllFieldsFromProjections() {
        // Arrange
        AnimalSummaryProjection animalSummary = Mockito.mock(AnimalSummaryProjection.class);
        Mockito.when(animalSummary.getTotalAnimals()).thenReturn(42L);
        Mockito.when(animalSummary.getTotalWeight()).thenReturn(1250.5);

        FeedAllocationSummaryProjection feedAllocation = Mockito.mock(FeedAllocationSummaryProjection.class);
        Mockito.when(feedAllocation.getDailyFeedKg()).thenReturn(15.5);
        Mockito.when(feedAllocation.getMonthlyFeedKg()).thenReturn(465.0);

        ContributionProjection contribution = Mockito.mock(ContributionProjection.class);
        Mockito.when(contribution.getTotalContributions()).thenReturn(new BigDecimal("5000.00"));
        Mockito.when(contribution.getContributionCount()).thenReturn(10L);

        ExpenseProjection expense = Mockito.mock(ExpenseProjection.class);
        Mockito.when(expense.getTotalExpenses()).thenReturn(new BigDecimal("3000.00"));
        Mockito.when(expense.getExpenseCount()).thenReturn(5L);

        PaymentSummaryProjection payment = Mockito.mock(PaymentSummaryProjection.class);
        Mockito.when(payment.getTotalPayments()).thenReturn(new BigDecimal("2000.00"));
        Mockito.when(payment.getPaymentCount()).thenReturn(3L);

        BalanceProjection balance = Mockito.mock(BalanceProjection.class);
        Mockito.when(balance.getOutstandingBalance()).thenReturn(new BigDecimal("1000.00"));
        Mockito.when(balance.getNetBalance()).thenReturn(new BigDecimal("-1000.00"));

        AlertProjection alert = Mockito.mock(AlertProjection.class);
        Mockito.when(alert.getMessage()).thenReturn("Low feed stock");

        // Act
        MemberDashboardDto dto = new MemberDashboardDto(
                animalSummary,
                feedAllocation,
                contribution,
                expense,
                payment,
                balance,
                List.of(alert)
        );

        // Assert
        assertEquals(42L, dto.getTotalAnimals());
        assertEquals(1250.5, dto.getTotalWeight());
        assertEquals(15.5, dto.getDailyFeedKg());
        assertEquals(465.0, dto.getMonthlyFeedKg());
        assertEquals(new BigDecimal("5000.00"), dto.getTotalContributions());
        assertEquals(10L, dto.getContributionCount());
        assertEquals(new BigDecimal("3000.00"), dto.getTotalExpenses());
        assertEquals(5L, dto.getExpenseCount());
        assertEquals(new BigDecimal("2000.00"), dto.getTotalPayments());
        assertEquals(3L, dto.getPaymentCount());
        assertEquals(new BigDecimal("1000.00"), dto.getOutstandingBalance());
        assertEquals(new BigDecimal("-1000.00"), dto.getNetBalance());
        assertEquals(1, dto.getAlerts().size());
        assertEquals("Low feed stock", dto.getAlerts().get(0).getMessage());
    }

    @Test
    void constructorShouldHandleNullAlerts() {
        // Arrange
        AnimalSummaryProjection animalSummary = Mockito.mock(AnimalSummaryProjection.class);
        Mockito.when(animalSummary.getTotalAnimals()).thenReturn(0L);
        Mockito.when(animalSummary.getTotalWeight()).thenReturn(0.0);

        FeedAllocationSummaryProjection feedAllocation = Mockito.mock(FeedAllocationSummaryProjection.class);
        Mockito.when(feedAllocation.getDailyFeedKg()).thenReturn(0.0);
        Mockito.when(feedAllocation.getMonthlyFeedKg()).thenReturn(0.0);

        ContributionProjection contribution = Mockito.mock(ContributionProjection.class);
        Mockito.when(contribution.getTotalContributions()).thenReturn(BigDecimal.ZERO);
        Mockito.when(contribution.getContributionCount()).thenReturn(0L);

        ExpenseProjection expense = Mockito.mock(ExpenseProjection.class);
        Mockito.when(expense.getTotalExpenses()).thenReturn(BigDecimal.ZERO);
        Mockito.when(expense.getExpenseCount()).thenReturn(0L);

        PaymentSummaryProjection payment = Mockito.mock(PaymentSummaryProjection.class);
        Mockito.when(payment.getTotalPayments()).thenReturn(BigDecimal.ZERO);
        Mockito.when(payment.getPaymentCount()).thenReturn(0L);

        BalanceProjection balance = Mockito.mock(BalanceProjection.class);
        Mockito.when(balance.getOutstandingBalance()).thenReturn(BigDecimal.ZERO);
        Mockito.when(balance.getNetBalance()).thenReturn(BigDecimal.ZERO);

        // Act
        MemberDashboardDto dto = new MemberDashboardDto(
                animalSummary,
                feedAllocation,
                contribution,
                expense,
                payment,
                balance,
                List.of()
        );

        // Assert
        assertEquals(0L, dto.getTotalAnimals());
        assertEquals(BigDecimal.ZERO, dto.getTotalContributions());
        assertTrue(dto.getAlerts().isEmpty());
    }
}