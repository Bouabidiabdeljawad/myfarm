package com.myfarm.auth.dto;

import java.math.BigDecimal;

public class BalanceProjectionImpl implements BalanceProjection {
    private final BigDecimal outstandingBalance;
    private final BigDecimal netBalance;

    public BalanceProjectionImpl(BigDecimal outstandingBalance, BigDecimal netBalance) {
        this.outstandingBalance = outstandingBalance;
        this.netBalance = netBalance;
    }

    @Override
    public BigDecimal getOutstandingBalance() {
        return outstandingBalance;
    }

    @Override
    public BigDecimal getNetBalance() {
        return netBalance;
    }
}