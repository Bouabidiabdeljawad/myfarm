package com.myfarm.auth.jwt;

import com.myfarm.auth.model.User;
import com.myfarm.auth.model.Role;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

public class JwtProviderTest {
    private final JwtProvider jwtProvider = new JwtProvider();

    @Test
    void generateAndParseAccessToken() {
        User user = new User();
        user.setId(1L);
        user.setRole(Role.FARM_ADMIN);
        // Normally the secret would be injected; for test we set a dummy secret directly
        jwtProvider.jwtSecret = "test-secret-key-test-secret-key-test-secret-key-32bytes";
        jwtProvider.init();
        String token = jwtProvider.generateAccessToken(user);
        assertNotNull(token);
        var claims = jwtProvider.parseToken(token);
        assertEquals("1", claims.getBody().getSubject());
        assertEquals("FARM_ADMIN", claims.getBody().get("role", String.class));
    }
}
