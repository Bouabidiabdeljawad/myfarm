package com.myfarm.auth.controller;

import com.myfarm.auth.model.User;
import com.myfarm.auth.model.Role;
import com.myfarm.auth.service.PasswordService;
import com.myfarm.auth.service.InvitationService;
import com.myfarm.auth.jwt.JwtProvider;
import org.junit.jupiter.api.Test;
import org.mockito.Mockito;
import static org.junit.jupiter.api.Assertions.*;

public class AuthControllerTest {
    private final PasswordService passwordService = Mockito.mock(PasswordService.class);
    private final JwtProvider jwtProvider = Mockito.mock(JwtProvider.class);
    private final InvitationService invitationService = Mockito.mock(InvitationService.class);
    private final AuthController authController = new AuthController(passwordService, jwtProvider, invitationService);

    @Test
    void loginSuccessReturnsTokens() {
        String email = "admin@example.com";
        String rawPassword = "Password123";
        User user = new User();
        user.setId(1L);
        user.setEmail(email);
        user.setRole(Role.SUPER_ADMIN);
        user.setPasswordHash("hashed");

        Mockito.when(passwordService.verifyPassword("hashed", rawPassword)).thenReturn(true);
        Mockito.when(invitationService.findUserByEmail(email)).thenReturn(Optional.of(user));
        Mockito.when(jwtProvider.generateAccessToken(user)).thenReturn("access-token");
        Mockito.when(jwtProvider.generateRefreshToken(user)).thenReturn("refresh-token");

        var response = authController.login(email, rawPassword);
        assertNotNull(response);
        assertEquals("access-token", response.getAccessToken());
        assertEquals("refresh-token", response.getRefreshToken());
    }
}
