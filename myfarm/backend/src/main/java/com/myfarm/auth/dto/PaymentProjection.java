package com.myfarm.auth.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public interface PaymentProjection {
    Long getId();
    BigDecimal getAmount();
    LocalDate getDate();
    String getDescription();
    String getType();
}