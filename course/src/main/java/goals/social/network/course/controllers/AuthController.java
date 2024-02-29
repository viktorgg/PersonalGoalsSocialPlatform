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
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;

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
            return new ResponseEntity<>("User with email %s is already registered".formatted(requestEmail), HttpStatus.FORBIDDEN);
        }
        User user = User
                .builder()
                .firstName(request.getFirstName())
                .lastName(request.getLastName())
                .email(request.getEmail())
                .password(request.getPassword())
                .role(Role.ROLE_USER)
                .build();
        authenticationService.signUp(user);
        return new ResponseEntity<>("User is registered", HttpStatus.OK);
    }

    @PostMapping("/signin")
    public ResponseEntity<?> signIn(@RequestBody SignInRequest request) {
        String message = authenticationService.signIn(request);
        if (message.contains("Invalid")) {
            return new ResponseEntity<>(Map.of("message", message), HttpStatus.FORBIDDEN);
        }
        return new ResponseEntity<>(Map.of("message", message), HttpStatus.OK);
    }
}
