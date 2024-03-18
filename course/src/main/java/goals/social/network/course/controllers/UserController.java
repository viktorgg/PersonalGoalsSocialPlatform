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
import java.util.Set;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "/user")
public class UserController {

    private final UserRepository userRepository;
    private final UserRelationsRepository relationsRepository;

    private final UserService userService;

    @GetMapping("/rel/{userId}")
    public ResponseEntity<?> getUserRelations(@PathVariable Long userId) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            List<User> followers = userService.getUserFollowers(user.get());
            List<User> following = userService.getUserFollowing(user.get());
            return new ResponseEntity<>(Map.of("following", following, "followers", followers), HttpStatus.OK);
        }
        return new ResponseEntity<>("User with ID %s is not found".formatted(userId), HttpStatus.BAD_REQUEST);
    }

    @GetMapping("/goals/{userId}")
    public ResponseEntity<?> getUserGroups(@PathVariable Long userId) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            return new ResponseEntity<>(user.get().getGoals(), HttpStatus.OK);
        }
        return new ResponseEntity<>("User with ID %s is not found".formatted(userId), HttpStatus.BAD_REQUEST);
    }

    @PostMapping("/followers/create")
    public ResponseEntity<?> createUserRel(@RequestBody Map<String, String> userEmails) {
//        UsersRelations obj = new UsersRelations();
//        User user1 = userRepository.findByEmail(userEmails.get("id1")).get();
//        User user2 = userRepository.findByEmail(userEmails.get("id2")).get();
//        obj.setFollower(user1);
//        obj.setFollowed(user2);
//        relationsRepository.save(obj);
//        return new ResponseEntity<>(obj, HttpStatus.OK);
        return null;
    }
}
