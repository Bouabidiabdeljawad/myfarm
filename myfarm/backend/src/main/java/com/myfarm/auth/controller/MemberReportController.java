package com.myfarm.auth.controller;

import com.myfarm.auth.service.MemberReportService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/member-dashboard")
public class MemberReportController {

    private final MemberReportService memberReportService;

    public MemberReportController(MemberReportService memberReportService) {
        this.memberReportService = memberReportService;
    }

    /**
     * Generate and download a PDF report for a member for a specific period.
     *
     * @param memberId the ID of the member
     * @param period the period in format "yyyy-MM" (e.g., "2024-01")
     * @return PDF file as byte array with appropriate headers
     */
    @GetMapping(value = "/report", produces = MediaType.APPLICATION_PDF_VALUE)
    @PreAuthorize("@memberScope.check(authentication, #memberId)")
    public ResponseEntity<byte[]> generateReport(
            @RequestParam Long memberId,
            @RequestParam String period) {

        byte[] pdfBytes = memberReportService.generateMemberReport(memberId, period);

        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_PDF);
        headers.setContentDispositionFormData("attachment", "member-report-" + period + ".pdf");
        headers.setCacheControl("must-revalidate, post-check=0, pre-check=0");

        return ResponseEntity.ok()
                .headers(headers)
                .body(pdfBytes);
    }
}