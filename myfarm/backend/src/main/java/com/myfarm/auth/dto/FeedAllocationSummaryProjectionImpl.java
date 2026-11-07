package com.myfarm.auth.dto;

public class FeedAllocationSummaryProjectionImpl implements FeedAllocationSummaryProjection {
    private final Double dailyFeedKg;
    private final Double monthlyFeedKg;

    public FeedAllocationSummaryProjectionImpl(Double dailyFeedKg, Double monthlyFeedKg) {
        this.dailyFeedKg = dailyFeedKg;
        this.monthlyFeedKg = monthlyFeedKg;
    }

    @Override
    public Double getDailyFeedKg() {
        return dailyFeedKg;
    }

    @Override
    public Double getMonthlyFeedKg() {
        return monthlyFeedKg;
    }
}