package com.myfarm.auth.security;

import com.myfarm.auth.jwt.JwtProvider;
import com.myfarm.auth.model.Role;
import com.myfarm.auth.model.User;
import com.myfarm.auth.repository.UserRepository;
import org.springframework.core.MethodParameter;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Component;
import org.springframework.web.bind.support.WebDataBinderFactory;
import org.springframework.web.context.request.NativeWebRequest;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.method.support.ModelAndViewContainer;

import java.util.Optional;

@Component
public class MemberScopeResolver implements HandlerMethodArgumentResolver {

    private final JwtProvider jwtProvider;
    private final UserRepository userRepository;

    public MemberScopeResolver(JwtProvider jwtProvider, UserRepository userRepository) {
        this.jwtProvider = jwtProvider;
        this.userRepository = userRepository;
    }

    /**
     * Check if the authenticated user has access to the specified member's data.
     * A user can access their own data, or if they are an admin, they can access any member's data.
     *
     * @param authentication the current authentication
     * @param memberId the member ID being accessed
     * @return true if access is allowed, false otherwise
     */
    public boolean check(Authentication authentication, Long memberId) {
        if (authentication == null || !authentication.isAuthenticated()) {
            return false;
        }

        // Get the authenticated user's ID from the JWT token subject
        String subject = authentication.getName();
        if (subject == null) {
            return false;
        }

        Long authenticatedUserId;
        try {
            authenticatedUserId = Long.parseLong(subject);
        } catch (NumberFormatException e) {
            return false;
        }

        // User can always access their own data
        if (authenticatedUserId.equals(memberId)) {
            return true;
        }

        // Check if user is an admin
        Optional<User> userOpt = userRepository.findById(authenticatedUserId);
        if (userOpt.isPresent()) {
            User user = userOpt.get();
            // Admins can access any member's data
            if (user.getRole() == Role.SUPER_ADMIN || user.getRole() == Role.FARM_ADMIN) {
                return true;
            }
        }

        return false;
    }

    @Override
    public boolean supportsParameter(MethodParameter parameter) {
        // This resolver is for the @MemberScope annotation usage in @PreAuthorize
        // We don't actually resolve method parameters here, we just provide the check() method
        return false;
    }

    @Override
    public Object resolveArgument(MethodParameter parameter, ModelAndViewContainer mavContainer,
                                  NativeWebRequest webRequest, WebDataBinderFactory binderFactory) {
        // Not used - this is just a Spring component to be referenced in @PreAuthorize
        return null;
    }
}