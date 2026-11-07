package com.myfarm.auth.service;

import org.springframework.stereotype.Component;
import java.time.LocalDate;

@Component
public class CacheKeyProvider {

    public String memberDashboardKey(Long memberId, LocalDate start, LocalDate end) {
        return "memberDashboard:" + memberId + ":" + start + ":" + end;
    }
}