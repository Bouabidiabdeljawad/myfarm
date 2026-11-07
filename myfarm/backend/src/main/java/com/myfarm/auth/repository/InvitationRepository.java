package com.myfarm.auth.repository;

import com.myfarm.auth.model.Invitation;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.Optional;

public interface InvitationRepository extends JpaRepository<Invitation, Long> {
    Optional<Invitation> findByEmail(String email);
    Optional<Invitation> findByTokenHash(String tokenHash);
}
