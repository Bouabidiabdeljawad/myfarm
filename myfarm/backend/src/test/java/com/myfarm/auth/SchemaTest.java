package com.myfarm.auth;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.beans.factory.annotation.Autowired;
import org.flywaydb.core.Flyway;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
public class SchemaTest {
    @Autowired
    private Flyway flyway;

    @Test
    void migrationShouldCreateInvitationTable() {
        // This will fail until the Flyway migration V1__auth_schema.sql exists with the table
        var dataSource = flyway.getConfiguration().getDataSource();
        try (var conn = dataSource.getConnection();
             var stmt = conn.createStatement();
             var rs = stmt.executeQuery("SELECT column_name FROM information_schema.columns WHERE table_name='invitations' AND column_name='token_hash'")) {
            boolean found = rs.next();
            assertTrue(found, "Invitation table with token_hash column should exist");
        } catch (Exception e) {
            fail("Database query failed: " + e.getMessage());
        }
    }
}
