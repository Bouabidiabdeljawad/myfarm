package com.myfarm.auth.service;

import com.myfarm.auth.service.PasswordService;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class PasswordServiceTest {
    private final PasswordService passwordService = new PasswordService();

    @Test
    void hashAndVerifyPassword() {
        String raw = "SuperSecret123!";
        String hash = passwordService.hashPassword(raw);
        assertNotNull(hash);
        assertTrue(passwordService.verifyPassword(hash, raw));
    }

    @Test
    void verifyWrongPasswordFails() {
        String raw = "Password1";
        String wrong = "WrongPass";
        String hash = passwordService.hashPassword(raw);
        assertFalse(passwordService.verifyPassword(hash, wrong));
    }
}
