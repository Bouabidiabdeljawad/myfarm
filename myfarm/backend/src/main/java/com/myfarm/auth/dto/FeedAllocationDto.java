package com.myfarm.auth.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public record FeedAllocationDto(
        Long id,
        String feedType,
        BigDecimal dailyKg,
        BigDecimal monthlyKg,
        LocalDate date
) {
}