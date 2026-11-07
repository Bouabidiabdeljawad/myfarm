package com.myfarm.auth.dto;

import java.math.BigDecimal;

public interface BalanceProjection {
    BigDecimal getOutstandingBalance();
    BigDecimal getNetBalance();
}