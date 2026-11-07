package com.myfarm.auth.model;

import jakarta.persistence.*;
import java.util.Set;

@Entity
@Table(name = "farms")
public class Farm {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String name;

    @Column(nullable = false)
    private boolean archived = false;

    // One farm can have many memberships (users with roles in this farm)
    @OneToMany(mappedBy = "farm", cascade = CascadeType.ALL, orphanRemoval = true)
    private Set<FarmMembership> memberships;

    // getters and setters omitted for brevity
}
