package com.myfarm.auth.service;

import com.myfarm.auth.model.User;
import com.myfarm.auth.model.Role;
import com.myfarm.auth.repository.UserRepository;
import com.myfarm.auth.repository.RefreshTokenRepository;
import com.myfarm.auth.jwt.JwtProvider;
import com.myfarm.auth.service.InvitationService;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import static org.junit.jupiter.api.Assertions.*;
import java.util.Optional;

public class InvitationServiceTest {
    private final InvitationRepository invitationRepo = Mockito.mock(InvitationRepository.class);
    private final UserRepository userRepo = Mockito.mock(UserRepository.class);
    private final JwtProvider jwtProvider = Mockito.mock(JwtProvider.class);
    private final InvitationService invitationService = new InvitationService(invitationRepo, userRepo, jwtProvider);

    @Test
    void createInvitationCreatesHashedToken() {
        // Arrange
        String email = "newuser@example.com";
        Long farmId = 42L;
        Mockito.when(invitationRepo.save(Mockito.any())).thenAnswer(i -> i.getArgument(0));
        // Act
        var invitation = invitationService.createInvitation(email, farmId);
        // Assert
        assertNotNull(invitation.getTokenHash());
        assertEquals(email, invitation.getEmail());
        assertEquals(farmId, invitation.getFarmId());
        assertFalse(invitation.isUsed());
    }
}
