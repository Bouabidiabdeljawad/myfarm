package com.myfarm.auth.jwt;

import com.myfarm.auth.model.Role;
import com.myfarm.auth.model.User;
import io.jsonwebtoken.*;
import io.jsonwebtoken.security.Keys;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

import java.security.Key;
import java.time.Instant;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;

@Component
public class JwtProvider {
    @Value("${jwt.secret}")
    private String jwtSecret;

    @Value("${jwt.access.expiration.minutes:15}")
    private long accessExpirationMinutes;

    @Value("${jwt.refresh.expiration.days:30}")
    private long refreshExpirationDays;

    private Key key;

    @PostConstruct
    public void init() {
        this.key = Keys.hmacShaKeyFor(jwtSecret.getBytes());
    }

    public String generateAccessToken(User user) {
        Instant now = Instant.now();
        return Jwts.builder()
                .setSubject(user.getId().toString())
                .claim("role", user.getRole().name())
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(now.plusSeconds(accessExpirationMinutes * 60)))
                .signWith(key)
                .compact();
    }

    public String generateRefreshToken(User user) {
        Instant now = Instant.now();
        return Jwts.builder()
                .setSubject(user.getId().toString())
                .setIssuedAt(Date.from(now))
                .setExpiration(Date.from(now.plusSeconds(refreshExpirationDays * 24 * 60 * 60)))
                .signWith(key)
                .compact();
    }

    public Jws<Claims> parseToken(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(key)
                .build()
                .parseClaimsJws(token);
    }
}
