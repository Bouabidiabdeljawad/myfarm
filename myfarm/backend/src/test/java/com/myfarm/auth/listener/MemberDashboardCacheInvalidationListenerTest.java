package com.myfarm.auth.listener;

import com.myfarm.auth.event.MemberDashboardInvalidationEvent;
import com.myfarm.auth.model.*;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.context.ApplicationEventPublisher;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class MemberDashboardCacheInvalidationListenerTest {

    @Mock
    private ApplicationEventPublisher eventPublisher;

    @InjectMocks
    private MemberDashboardCacheInvalidationListener listener;

    @Test
    void onAnimalChangedShouldPublishEventWithOwnerId() {
        // Arrange
        Animal animal = new Animal();
        animal.setOwnerId(42L);

        // Act
        listener.onAnimalChanged(animal);

        // Assert
        ArgumentCaptor<MemberDashboardInvalidationEvent> captor = ArgumentCaptor.forClass(MemberDashboardInvalidationEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());
        assertEquals(42L, captor.getValue().memberId());
    }

    @Test
    void onAnimalChangedShouldNotPublishEventWhenOwnerIdIsNull() {
        // Arrange
        Animal animal = new Animal();
        animal.setOwnerId(null);

        // Act
        listener.onAnimalChanged(animal);

        // Assert
        verify(eventPublisher, never()).publishEvent(any());
    }

    @Test
    void onFeedAllocationChangedShouldPublishEventWithMemberId() {
        // Arrange
        FeedAllocation feedAllocation = new FeedAllocation();
        feedAllocation.setMemberId(100L);

        // Act
        listener.onFeedAllocationChanged(feedAllocation);

        // Assert
        ArgumentCaptor<MemberDashboardInvalidationEvent> captor = ArgumentCaptor.forClass(MemberDashboardInvalidationEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());
        assertEquals(100L, captor.getValue().memberId());
    }

    @Test
    void onFeedAllocationChangedShouldNotPublishEventWhenMemberIdIsNull() {
        // Arrange
        FeedAllocation feedAllocation = new FeedAllocation();
        feedAllocation.setMemberId(null);

        // Act
        listener.onFeedAllocationChanged(feedAllocation);

        // Assert
        verify(eventPublisher, never()).publishEvent(any());
    }

    @Test
    void onPaymentChangedShouldPublishEventWithMemberId() {
        // Arrange
        Payment payment = new Payment();
        payment.setMemberId(200L);

        // Act
        listener.onPaymentChanged(payment);

        // Assert
        ArgumentCaptor<MemberDashboardInvalidationEvent> captor = ArgumentCaptor.forClass(MemberDashboardInvalidationEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());
        assertEquals(200L, captor.getValue().memberId());
    }

    @Test
    void onExpenseChangedShouldPublishEventWithMemberId() {
        // Arrange
        Expense expense = new Expense();
        expense.setMemberId(300L);

        // Act
        listener.onExpenseChanged(expense);

        // Assert
        ArgumentCaptor<MemberDashboardInvalidationEvent> captor = ArgumentCaptor.forClass(MemberDashboardInvalidationEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());
        assertEquals(300L, captor.getValue().memberId());
    }

    @Test
    void onContributionChangedShouldPublishEventWithMemberId() {
        // Arrange
        Contribution contribution = new Contribution();
        contribution.setMemberId(400L);

        // Act
        listener.onContributionChanged(contribution);

        // Assert
        ArgumentCaptor<MemberDashboardInvalidationEvent> captor = ArgumentCaptor.forClass(MemberDashboardInvalidationEvent.class);
        verify(eventPublisher).publishEvent(captor.capture());
        assertEquals(400L, captor.getValue().memberId());
    }
}