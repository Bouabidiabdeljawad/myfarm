package com.myfarm.auth.service;

import de.mkammerer.argon2.Argon2Factory;
import de.mkammerer.argon2.Argon2;
import org.springframework.stereotype.Service;

@Service
public class PasswordService {
    private final Argon2 argon2 = Argon2Factory.create();

    public String hashPassword(String raw) {
        return argon2.hash(2, 65536, 1, raw.toCharArray());
    }

    public boolean verifyPassword(String hash, String raw) {
        return argon2.verify(hash, raw.toCharArray());
    }
}
