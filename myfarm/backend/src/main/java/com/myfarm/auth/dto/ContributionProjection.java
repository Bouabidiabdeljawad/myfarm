package com.myfarm.auth.dto;

import java.math.BigDecimal;

public interface ContributionProjection {
    BigDecimal getTotalContributions();
    Long getContributionCount();
}