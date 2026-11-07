package com.myfarm.auth.dto;

import java.math.BigDecimal;

public class PaymentSummaryProjectionImpl implements PaymentSummaryProjection {
    private final BigDecimal totalPayments;
    private final Long paymentCount;

    public PaymentSummaryProjectionImpl(BigDecimal totalPayments, Long paymentCount) {
        this.totalPayments = totalPayments;
        this.paymentCount = paymentCount;
    }

    @Override
    public BigDecimal getTotalPayments() {
        return totalPayments;
    }

    @Override
    public Long getPaymentCount() {
        return paymentCount;
    }
}