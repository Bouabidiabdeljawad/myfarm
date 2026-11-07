package com.myfarm.auth.security;

import java.lang.annotation.*;

@Target({ElementType.METHOD, ElementType.TYPE})
@Retention(RetentionPolicy.RUNTIME)
@Documented
public @interface MemberScope {
    // This annotation is used with @PreAuthorize("@memberScope.check(authentication, #memberId)")
    // The actual logic is in MemberScopeResolver.check()
}