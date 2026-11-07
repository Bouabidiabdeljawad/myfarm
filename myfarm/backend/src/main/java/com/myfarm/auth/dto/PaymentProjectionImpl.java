package com.myfarm.auth.dto;

import java.math.BigDecimal;
import java.time.LocalDate;

public class PaymentProjectionImpl implements PaymentProjection {
    private final Long id;
    private final BigDecimal amount;
    private final LocalDate date;
    private final String description;
    private final String type;

    public PaymentProjectionImpl(Long id, BigDecimal amount, LocalDate date, String description, String type) {
        this.id = id;
        this.amount = amount;
        this.date = date;
        this.description = description;
        this.type = type;
    }

    @Override
    public Long getId() {
        return id;
    }

    @Override
    public BigDecimal getAmount() {
        return amount;
    }

    @Override
    public LocalDate getDate() {
        return date;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public String getType() {
        return type;
    }
}