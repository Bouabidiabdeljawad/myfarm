package com.myfarm.auth.listener;

import com.myfarm.auth.event.MemberDashboardInvalidationEvent;
import com.myfarm.auth.model.*;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.stereotype.Component;
import org.springframework.transaction.event.TransactionalEventListener;

@Component
public class MemberDashboardCacheInvalidationListener {

    private final ApplicationEventPublisher eventPublisher;

    public MemberDashboardCacheInvalidationListener(ApplicationEventPublisher eventPublisher) {
        this.eventPublisher = eventPublisher;
    }

    @TransactionalEventListener
    public void onAnimalChanged(Animal entity) {
        if (entity.getOwnerId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getOwnerId()));
        }
    }

    @TransactionalEventListener
    public void onFeedAllocationChanged(FeedAllocation entity) {
        if (entity.getMemberId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getMemberId()));
        }
    }

    @TransactionalEventListener
    public void onPaymentChanged(Payment entity) {
        if (entity.getMemberId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getMemberId()));
        }
    }

    @TransactionalEventListener
    public void onExpenseChanged(Expense entity) {
        if (entity.getMemberId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getMemberId()));
        }
    }

    @TransactionalEventListener
    public void onContributionChanged(Contribution entity) {
        if (entity.getMemberId() != null) {
            eventPublisher.publishEvent(new MemberDashboardInvalidationEvent(entity.getMemberId()));
        }
    }
}