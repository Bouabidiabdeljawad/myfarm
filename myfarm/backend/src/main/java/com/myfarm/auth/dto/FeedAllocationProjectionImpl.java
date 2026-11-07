package com.myfarm.auth.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class FeedAllocationProjectionImpl implements FeedAllocationProjection {
    private final Long id;
    private final String feedType;
    private final BigDecimal dailyKg;
    private final BigDecimal monthlyKg;
    private final LocalDate date;

    public FeedAllocationProjectionImpl(Long id, String feedType, BigDecimal dailyKg, BigDecimal monthlyKg, LocalDate date) {
        this.id = id;
        this.feedType = feedType;
        this.dailyKg = dailyKg;
        this.monthlyKg = monthlyKg;
        this.date = date;
    }

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public String getFeedType() {
        return feedType;
    }

    @Override
    public BigDecimal getDailyKg() {
        return dailyKg;
    }

    @Override
    public BigDecimal getMonthlyKg() {
        return monthlyKg;
    }

    @Override
    public LocalDate getDate() {
        return date;
    }
}