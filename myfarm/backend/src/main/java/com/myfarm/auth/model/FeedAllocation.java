package com.myfarm.auth.model;

import jakarta.persistence.*;
import java.math.BigDecimal;
import java.time.LocalDate;

@Entity
@Table(name = "feed_allocations")
public class FeedAllocation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(name = "member_id", nullable = false)
    private Long memberId;

    @Column(name = "farm_id", nullable = false)
    private Long farmId;

    @Column(nullable = false)
    private String feedType; // e.g., "HAY", "GRAIN", "SILAGE"

    @Column(name = "daily_kg", precision = 10, scale = 2)
    private BigDecimal dailyKg;

    @Column(name = "monthly_kg", precision = 10, scale = 2)
    private BigDecimal monthlyKg;

    @Column(nullable = false)
    private LocalDate date;

    // Getters and setters
    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Long getMemberId() {
        return memberId;
    }

    public void setMemberId(Long memberId) {
        this.memberId = memberId;
    }

    public Long getFarmId() {
        return farmId;
    }

    public void setFarmId(Long farmId) {
        this.farmId = farmId;
    }

    public String getFeedType() {
        return feedType;
    }

    public void setFeedType(String feedType) {
        this.feedType = feedType;
    }

    public BigDecimal getDailyKg() {
        return dailyKg;
    }

    public void setDailyKg(BigDecimal dailyKg) {
        this.dailyKg = dailyKg;
    }

    public BigDecimal getMonthlyKg() {
        return monthlyKg;
    }

    public void setMonthlyKg(BigDecimal monthlyKg) {
        this.monthlyKg = monthlyKg;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }
}