package com.myfarm.auth.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public record PaymentDto(
        Long id,
        BigDecimal amount,
        LocalDate date,
        String description,
        String type
) {
}