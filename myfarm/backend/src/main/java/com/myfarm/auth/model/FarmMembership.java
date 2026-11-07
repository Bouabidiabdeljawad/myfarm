package com.myfarm.auth.model;

import jakarta.persistence.*;

@Entity
@Table(name = "farm_memberships",
       uniqueConstraints = {@UniqueConstraint(columnNames = {"farm_id", "user_id"})})
public class FarmMembership {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "farm_id", nullable = false)
    private Farm farm;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role; // FARM_ADMIN or MEMBER

    // getters & setters omitted for brevity
}
