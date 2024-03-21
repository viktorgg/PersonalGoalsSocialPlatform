package goals.social.network.course.controllers;

import goals.social.network.course.models.User;
import goals.social.network.course.models.UserRelations;
import goals.social.network.course.repositories.UserRepository;
import goals.social.network.course.repositories.UserRelationsRepository;
import goals.social.network.course.services.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "/user")
public class UserController {

    private final UserRepository userRepository;
    private final UserRelationsRepository relationsRepository;

    private final UserService userService;

    @GetMapping("{userId}/rel")
    public ResponseEntity<?> getUserRelations(@PathVariable Long userId) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            List<User> followers = userService.getUserFollowers(user.get());
            List<User> following = userService.getUserFollowing(user.get());
            return new ResponseEntity<>(Map.of("following", following, "followers", followers), HttpStatus.OK);
        }
        return new ResponseEntity<>("User with ID %s is not found".formatted(userId), HttpStatus.BAD_REQUEST);
    }

    @GetMapping("{userId}/goals")
    public ResponseEntity<?> getUserGroups(@PathVariable Long userId) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            return new ResponseEntity<>(user.get().getGoals(), HttpStatus.OK);
        }
        return new ResponseEntity<>("User with ID %s is not found".formatted(userId), HttpStatus.BAD_REQUEST);
    }

    @PostMapping("{userIdFrom}/follow/{userIdTo}")
    public ResponseEntity<?> createUserRel(@PathVariable Long userIdFrom, @PathVariable Long userIdTo) {
        Optional<User> userFrom = userRepository.findById(userIdFrom);
        Optional<User> userTo = userRepository.findById(userIdTo);
        if (userFrom.isPresent() && userTo.isPresent()) {
            UserRelations obj = new UserRelations(userTo.get(), userFrom.get());
            relationsRepository.save(obj);
            return new ResponseEntity<>("User %s follows user %s".formatted(userIdFrom, userIdTo), HttpStatus.OK);
        }
        return new ResponseEntity<>("Users not found", HttpStatus.BAD_REQUEST);
    }

    @GetMapping("/findAllByName/{name}")
    public ResponseEntity<?> getUsersByName(@PathVariable String name) {
        List<User> users = userRepository.findByNameContaining(name.toUpperCase());
        return new ResponseEntity<>(users, HttpStatus.OK);
    }
}
