package com.myfarm.auth.controller;

import com.myfarm.auth.dto.*;
import com.myfarm.auth.security.MemberScopeResolver;
import com.myfarm.auth.service.MemberDashboardService;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;

import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MemberDashboardControllerTest {

    @Mock
    private MemberDashboardService memberDashboardService;

    @Mock
    private MemberScopeResolver memberScopeResolver;

    private MemberDashboardController controller;

    @Test
    void getMemberDashboardShouldReturnDashboardDto() {
        // Arrange
        controller = new MemberDashboardController(memberDashboardService);

        Long memberId = 1L;
        LocalDate start = LocalDate.of(2024, 1, 1);
        LocalDate end = LocalDate.of(2024, 1, 31);

        MemberDashboardDto expectedDto = new MemberDashboardDto(
                new AnimalSummaryProjectionImpl(5L, 1250.0),
                new FeedAllocationSummaryProjectionImpl(15.5, 465.0),
                new ContributionProjectionImpl(new BigDecimal("5000.00"), 10L),
                new ExpenseProjectionImpl(new BigDecimal("3000.00"), 5L),
                new PaymentSummaryProjectionImpl(new BigDecimal("2000.00"), 3L),
                new BalanceProjectionImpl(new BigDecimal("1000.00"), new BigDecimal("-1000.00")),
                List.of()
        );

        when(memberDashboardService.getMemberDashboard(memberId, start, end))
                .thenReturn(expectedDto);

        // Act
        ResponseEntity<MemberDashboardDto> response = controller.getMemberDashboard(memberId, start, end);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertEquals(5L, response.getBody().getTotalAnimals());
        assertEquals(new BigDecimal("2000.00"), response.getBody().getTotalPayments());

        verify(memberDashboardService).getMemberDashboard(memberId, start, end);
    }

    @Test
    void getPaymentHistoryShouldReturnPaginatedPayments() {
        // Arrange
        controller = new MemberDashboardController(memberDashboardService);

        Long memberId = 1L;
        LocalDate start = LocalDate.of(2024, 1, 1);
        LocalDate end = LocalDate.of(2024, 1, 31);
        Pageable pageable = PageRequest.of(0, 20);

        PaymentDto payment1 = new PaymentDto(1L, new BigDecimal("100.00"), LocalDate.of(2024, 1, 15), "Feed", "CASH");
        PaymentDto payment2 = new PaymentDto(2L, new BigDecimal("200.00"), LocalDate.of(2024, 1, 20), "Vet", "BANK_TRANSFER");
        Page<PaymentDto> expectedPage = new PageImpl<>(List.of(payment1, payment2), pageable, 2);

        when(memberDashboardService.getPaymentHistory(memberId, start, end, pageable))
                .thenReturn(expectedPage);

        // Act
        ResponseEntity<Page<PaymentDto>> response = controller.getPaymentHistory(memberId, start, end, pageable);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertEquals(2, response.getBody().getTotalElements());
        assertEquals(2, response.getBody().getContent().size());
        assertEquals(new BigDecimal("100.00"), response.getBody().getContent().get(0).amount());

        verify(memberDashboardService).getPaymentHistory(memberId, start, end, pageable);
    }

    @Test
    void getFeedHistoryShouldReturnPaginatedFeedAllocations() {
        // Arrange
        controller = new MemberDashboardController(memberDashboardService);

        Long memberId = 1L;
        LocalDate start = LocalDate.of(2024, 1, 1);
        LocalDate end = LocalDate.of(2024, 1, 31);
        Pageable pageable = PageRequest.of(0, 20);

        FeedAllocationDto feed1 = new FeedAllocationDto(1L, "HAY", new BigDecimal("10.0"), new BigDecimal("300.0"), LocalDate.of(2024, 1, 15));
        FeedAllocationDto feed2 = new FeedAllocationDto(2L, "GRAIN", new BigDecimal("5.0"), new BigDecimal("150.0"), LocalDate.of(2024, 1, 20));
        Page<FeedAllocationDto> expectedPage = new PageImpl<>(List.of(feed1, feed2), pageable, 2);

        when(memberDashboardService.getFeedHistory(memberId, start, end, pageable))
                .thenReturn(expectedPage);

        // Act
        ResponseEntity<Page<FeedAllocationDto>> response = controller.getFeedHistory(memberId, start, end, pageable);

        // Assert
        assertEquals(200, response.getStatusCodeValue());
        assertNotNull(response.getBody());
        assertEquals(2, response.getBody().getTotalElements());
        assertEquals(2, response.getBody().getContent().size());
        assertEquals("HAY", response.getBody().getContent().get(0).feedType());

        verify(memberDashboardService).getFeedHistory(memberId, start, end, pageable);
    }
}