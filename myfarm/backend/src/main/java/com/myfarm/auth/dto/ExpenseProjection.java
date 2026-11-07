package com.myfarm.auth.dto;

import java.math.BigDecimal;

public interface ExpenseProjection {
    BigDecimal getTotalExpenses();
    Long getExpenseCount();
}