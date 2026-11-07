package com.myfarm.auth.controller;

import com.myfarm.auth.dto.*;
import com.myfarm.auth.service.MemberDashboardService;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.web.PageableDefault;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;

import java.math.BigDecimal;
import java.time.LocalDate;

@RestController
@RequestMapping("/api/member-dashboard")
public class MemberDashboardController {

    private final MemberDashboardService memberDashboardService;

    public MemberDashboardController(MemberDashboardService memberDashboardService) {
        this.memberDashboardService = memberDashboardService;
    }

    /**
     * Get the member dashboard summary for a given member and date range.
     *
     * @param memberId the ID of the member (must match authenticated user)
     * @param start start date for filtering (inclusive), format: yyyy-MM-dd
     * @param end end date for filtering (inclusive), format: yyyy-MM-dd
     * @return MemberDashboardDto with all aggregated data
     */
    @GetMapping
    @PreAuthorize("@memberScope.check(authentication, #memberId)")
    public ResponseEntity<MemberDashboardDto> getMemberDashboard(
            @RequestParam Long memberId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate end) {

        MemberDashboardDto dashboard = memberDashboardService.getMemberDashboard(memberId, start, end);
        return ResponseEntity.ok(dashboard);
    }

    /**
     * Get paginated payment history for a member within a date range.
     *
     * @param memberId the ID of the member
     * @param start start date for filtering (inclusive), format: yyyy-MM-dd
     * @param end end date for filtering (inclusive), format: yyyy-MM-dd
     * @param pageable pagination parameters (page, size, sort)
     * @return Page of PaymentDto
     */
    @GetMapping("/payments")
    @PreAuthorize("@memberScope.check(authentication, #memberId)")
    public ResponseEntity<Page<PaymentDto>> getPaymentHistory(
            @RequestParam Long memberId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate end,
            @PageableDefault(size = 20, sort = "date") Pageable pageable) {

        Page<PaymentDto> payments = memberDashboardService.getPaymentHistory(memberId, start, end, pageable);
        return ResponseEntity.ok(payments);
    }

    /**
     * Get paginated feed allocation history for a member within a date range.
     *
     * @param memberId the ID of the member
     * @param start start date for filtering (inclusive), format: yyyy-MM-dd
     * @param end end date for filtering (inclusive), format: yyyy-MM-dd
     * @param pageable pagination parameters (page, size, sort)
     * @return Page of FeedAllocationDto
     */
    @GetMapping("/feed-history")
    @PreAuthorize("@memberScope.check(authentication, #memberId)")
    public ResponseEntity<Page<FeedAllocationDto>> getFeedHistory(
            @RequestParam Long memberId,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate start,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate end,
            @PageableDefault(size = 20, sort = "date") Pageable pageable) {

        Page<FeedAllocationDto> feedHistory = memberDashboardService.getFeedHistory(memberId, start, end, pageable);
        return ResponseEntity.ok(feedHistory);
    }
}