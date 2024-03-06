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

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class AuthenticationService {

    private final UserRepository userRepository;
    private final UserService userService;
    private final PasswordEncoder passwordEncoder;
    private final JwtService jwtService;
    private final AuthenticationManager authenticationManager;

    public String signUp(User user) {
        user.setPassword(passwordEncoder.encode(user.getPassword()));
        userService.save(user);
        return jwtService.generateToken(user);
    }

    public Map<String, Object> signIn(SignInRequest request) {
        try {
            authenticationManager.authenticate(
                    new UsernamePasswordAuthenticationToken(request.getEmail(), request.getPassword()));
        } catch (BadCredentialsException ex) {
            return Map.of("message", "Invalid email or password");
        }
        Optional<User> foundUser = userRepository.findByEmail(request.getEmail());
        User user = foundUser.get();
        Map<String, Object> userMap = user.toMap();
        Map<String, Object> responseMap = new HashMap<>(userMap);
        responseMap.put("token", jwtService.generateToken(user));
        return responseMap;
    }
}
