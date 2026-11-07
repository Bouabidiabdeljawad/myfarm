package com.myfarm.auth.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public interface FeedAllocationProjection {
    Long getId();
    String getFeedType();
    BigDecimal getDailyKg();
    BigDecimal getMonthlyKg();
    LocalDate getDate();
}