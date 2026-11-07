package com.myfarm.auth.dto;

import java.math.BigDecimal;
import java.util.List;

public class MemberDashboardDto {
    private final Long totalAnimals;
    private final Double totalWeight;
    private final Double dailyFeedKg;
    private final Double monthlyFeedKg;
    private final BigDecimal totalContributions;
    private final Long contributionCount;
    private final BigDecimal totalExpenses;
    private final Long expenseCount;
    private final BigDecimal totalPayments;
    private final Long paymentCount;
    private final BigDecimal outstandingBalance;
    private final BigDecimal netBalance;
    private final List<AlertProjection> alerts;

    public MemberDashboardDto(
            AnimalSummaryProjection animalSummary,
            FeedAllocationSummaryProjection feedAllocation,
            ContributionProjection contribution,
            ExpenseProjection expense,
            PaymentSummaryProjection payment,
            BalanceProjection balance,
            List<AlertProjection> alerts) {
        this.totalAnimals = animalSummary.getTotalAnimals();
        this.totalWeight = animalSummary.getTotalWeight();
        this.dailyFeedKg = feedAllocation.getDailyFeedKg();
        this.monthlyFeedKg = feedAllocation.getMonthlyFeedKg();
        this.totalContributions = contribution.getTotalContributions();
        this.contributionCount = contribution.getContributionCount();
        this.totalExpenses = expense.getTotalExpenses();
        this.expenseCount = expense.getExpenseCount();
        this.totalPayments = payment.getTotalPayments();
        this.paymentCount = payment.getPaymentCount();
        this.outstandingBalance = balance.getOutstandingBalance();
        this.netBalance = balance.getNetBalance();
        this.alerts = alerts;
    }

    public Long getTotalAnimals() {
        return totalAnimals;
    }

    public Double getTotalWeight() {
        return totalWeight;
    }

    public Double getDailyFeedKg() {
        return dailyFeedKg;
    }

    public Double getMonthlyFeedKg() {
        return monthlyFeedKg;
    }

    public BigDecimal getTotalContributions() {
        return totalContributions;
    }

    public Long getContributionCount() {
        return contributionCount;
    }

    public BigDecimal getTotalExpenses() {
        return totalExpenses;
    }

    public Long getExpenseCount() {
        return expenseCount;
    }

    public BigDecimal getTotalPayments() {
        return totalPayments;
    }

    public Long getPaymentCount() {
        return paymentCount;
    }

    public BigDecimal getOutstandingBalance() {
        return outstandingBalance;
    }

    public BigDecimal getNetBalance() {
        return netBalance;
    }

    public List<AlertProjection> getAlerts() {
        return alerts;
    }
}