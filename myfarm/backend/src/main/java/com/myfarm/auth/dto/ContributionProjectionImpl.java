package com.myfarm.auth.dto;

import java.math.BigDecimal;

public class ContributionProjectionImpl implements ContributionProjection {
    private final BigDecimal totalContributions;
    private final Long contributionCount;

    public ContributionProjectionImpl(BigDecimal totalContributions, Long contributionCount) {
        this.totalContributions = totalContributions;
        this.contributionCount = contributionCount;
    }

    @Override
    public BigDecimal getTotalContributions() {
        return totalContributions;
    }

    @Override
    public Long getContributionCount() {
        return contributionCount;
    }
}