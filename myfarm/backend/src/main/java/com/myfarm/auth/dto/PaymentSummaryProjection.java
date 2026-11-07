package com.myfarm.auth.dto;

import java.math.BigDecimal;

public interface PaymentSummaryProjection {
    BigDecimal getTotalPayments();
    Long getPaymentCount();
}