package goals.social.network.course.controllers;

import goals.social.network.course.dto.SignInRequest;
import goals.social.network.course.dto.SignUpRequest;
import goals.social.network.course.models.Role;
import goals.social.network.course.models.User;
import goals.social.network.course.repositories.UserRepository;
import goals.social.network.course.services.AuthenticationService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

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
}
