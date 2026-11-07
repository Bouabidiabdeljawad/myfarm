package com.myfarm.auth.dto;

public class AlertProjectionImpl implements AlertProjection {
    private final String message;

    public AlertProjectionImpl(String message) {
        this.message = message;
    }

    @Override
    public String getMessage() {
        return message;
    }
}