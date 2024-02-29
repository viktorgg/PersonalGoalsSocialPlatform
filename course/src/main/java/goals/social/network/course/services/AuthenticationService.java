package goals.social.network.course.services;
import goals.social.network.course.dto.SignInRequest;
import goals.social.network.course.models.User;
import goals.social.network.course.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final UserRepository userRepository;
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public void signUp(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userService.save(user);
    }

    public String signIn(SignInRequest request) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));
        } catch (BadCredentialsException ex) {
            return "Invalid email or password";
        }
        Optional<User> foundUser = userRepository.findByEmail(request.getEmail());
        if (foundUser.isEmpty()) {
            return "Invalid email";
        }
        return jwtService.generateToken(foundUser.get());
    }
}
