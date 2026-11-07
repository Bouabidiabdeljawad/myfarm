package com.myfarm.auth.dto;

public class AnimalSummaryProjectionImpl implements AnimalSummaryProjection {
    private final Long totalAnimals;
    private final Double totalWeight;

    public AnimalSummaryProjectionImpl(Long totalAnimals, Double totalWeight) {
        this.totalAnimals = totalAnimals;
        this.totalWeight = totalWeight;
    }

    @Override
    public Long getTotalAnimals() {
        return totalAnimals;
    }

    @Override
    public Double getTotalWeight() {
        return totalWeight;
    }
}