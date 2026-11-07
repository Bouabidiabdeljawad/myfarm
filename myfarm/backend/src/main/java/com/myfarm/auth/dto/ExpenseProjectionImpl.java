package com.myfarm.auth.dto;

import java.math.BigDecimal;

public class ExpenseProjectionImpl implements ExpenseProjection {
    private final BigDecimal totalExpenses;
    private final Long expenseCount;

    public ExpenseProjectionImpl(BigDecimal totalExpenses, Long expenseCount) {
        this.totalExpenses = totalExpenses;
        this.expenseCount = expenseCount;
    }

    @Override
    public BigDecimal getTotalExpenses() {
        return totalExpenses;
    }

    @Override
    public Long getExpenseCount() {
        return expenseCount;
    }
}