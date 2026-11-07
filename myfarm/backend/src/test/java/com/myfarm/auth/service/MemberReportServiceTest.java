package com.myfarm.auth.service;

import com.myfarm.auth.dto.*;
import com.myfarm.auth.model.User;
import com.myfarm.auth.repository.UserRepository;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MemberReportServiceTest {

    @Mock
    private MemberDashboardService memberDashboardService;

    @Mock
    private UserRepository userRepository;

    @InjectMocks
    private MemberReportService memberReportService;

    @Test
    void generateMemberReportShouldReturnPdfBytes() {
        // Arrange
        Long memberId = 1L;
        String period = "2024-01";
        LocalDate start = LocalDate.of(2024, 1, 1);
        LocalDate end = LocalDate.of(2024, 1, 31);

        User user = new User();
        user.setId(memberId);
        user.setEmail("test@example.com");
        user.setRole(com.myfarm.auth.model.Role.MEMBER);

        MemberDashboardDto dashboard = new MemberDashboardDto(
                new AnimalSummaryProjectionImpl(5L, 1250.0),
                new FeedAllocationSummaryProjectionImpl(15.5, 465.0),
                new ContributionProjectionImpl(new BigDecimal("5000.00"), 10L),
                new ExpenseProjectionImpl(new BigDecimal("3000.00"), 5L),
                new PaymentSummaryProjectionImpl(new BigDecimal("2000.00"), 3L),
                new BalanceProjectionImpl(new BigDecimal("1000.00"), new BigDecimal("-1000.00")),
                List.of()
        );

        when(userRepository.findById(memberId)).thenReturn(Optional.of(user));
        when(memberDashboardService.getMemberDashboard(memberId, start, end)).thenReturn(dashboard);

        // Act
        byte[] pdfBytes = memberReportService.generateMemberReport(memberId, period);

        // Assert
        assertNotNull(pdfBytes);
        assertTrue(pdfBytes.length > 0);
        // PDF files start with %PDF
        assertEquals('%', (char) pdfBytes[0]);
        assertEquals('P', (char) pdfBytes[1]);
        assertEquals('D', (char) pdfBytes[2]);
        assertEquals('F', (char) pdfBytes[3]);

        verify(userRepository).findById(memberId);
        verify(memberDashboardService).getMemberDashboard(memberId, start, end);
    }

    @Test
    void generateMemberReportShouldHandleMissingUser() {
        // Arrange
        Long memberId = 999L;
        String period = "2024-01";
        LocalDate start = LocalDate.of(2024, 1, 1);
        LocalDate end = LocalDate.of(2024, 1, 31);

        MemberDashboardDto dashboard = new MemberDashboardDto(
                new AnimalSummaryProjectionImpl(0L, 0.0),
                new FeedAllocationSummaryProjectionImpl(0.0, 0.0),
                new ContributionProjectionImpl(BigDecimal.ZERO, 0L),
                new ExpenseProjectionImpl(BigDecimal.ZERO, 0L),
                new PaymentSummaryProjectionImpl(BigDecimal.ZERO, 0L),
                new BalanceProjectionImpl(BigDecimal.ZERO, BigDecimal.ZERO),
                List.of()
        );

        when(userRepository.findById(memberId)).thenReturn(Optional.empty());
        when(memberDashboardService.getMemberDashboard(memberId, start, end)).thenReturn(dashboard);

        // Act
        byte[] pdfBytes = memberReportService.generateMemberReport(memberId, period);

        // Assert
        assertNotNull(pdfBytes);
        assertTrue(pdfBytes.length > 0);
        assertEquals('%', (char) pdfBytes[0]);
        assertEquals('P', (char) pdfBytes[1]);
        assertEquals('D', (char) pdfBytes[2]);
        assertEquals('F', (char) pdfBytes[3]);
    }
}