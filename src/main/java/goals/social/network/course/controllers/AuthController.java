package goals.social.network.course.controllers;

import goals.social.network.course.dto.SignInRequest;
import goals.social.network.course.dto.SignUpRequest;
import goals.social.network.course.models.Role;
import goals.social.network.course.models.User;
import goals.social.network.course.repositories.UserRepository;
import goals.social.network.course.services.AuthenticationService;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.context.SecurityContext;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.util.StringUtils;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@RestController
@RequiredArgsConstructor
public class AuthController {

    private final UserRepository userRepository;
    private final AuthenticationService authenticationService;

    @PostMapping("/signup")
    public ResponseEntity<?> signUp(@RequestBody SignUpRequest request) {
        String requestEmail = request.getEmail();
        if (userRepository.findByEmail(requestEmail).isPresent()) {
            return new ResponseEntity<>(Map.of("message", "User with email %s is already registered".formatted(requestEmail)), HttpStatus.FORBIDDEN);
        }
        User user = User
                .builder()
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .email(request.getEmail())
                .password(request.getPassword())
                .phone(request.getPhone())
                .role(Role.ROLE_USER)
                .build();
        String token = authenticationService.signUp(user);
        Map<String, Object> userMap = user.toMap();
        Map<String, Object> responseMap = new HashMap<>(userMap);
        responseMap.put("token", token);
        return new ResponseEntity<>(responseMap, HttpStatus.OK);
    }

    @PostMapping("/signin")
    public ResponseEntity<?> signIn(@RequestBody SignInRequest request) {
        Map<String, Object> responseMap = authenticationService.signIn(request);
        if (!responseMap.containsKey("token")) {
            return new ResponseEntity<>(responseMap, HttpStatus.FORBIDDEN);
        }
        return new ResponseEntity<>(responseMap, HttpStatus.OK);
    }

    @GetMapping("/signout")
    public String signOut(HttpServletRequest request, HttpServletResponse response) {
        boolean isSecure = false;
        String contextPath = null;
        if (request != null) {
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.invalidate();
            }
            isSecure = request.isSecure();
            contextPath = request.getContextPath();
        }
        SecurityContext context = SecurityContextHolder.getContext();
        SecurityContextHolder.clearContext();
        context.setAuthentication(null);
        if (response != null) {
            Cookie cookie = new Cookie("JSESSIONID", null);
            String cookiePath = StringUtils.hasText(contextPath) ? contextPath : "/";
            cookie.setPath(cookiePath);
            cookie.setMaxAge(0);
            cookie.setSecure(isSecure);
            response.addCookie(cookie);
        }
        return "Cool";
    }
}
