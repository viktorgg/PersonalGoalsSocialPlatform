package goals.social.network.course.controllers;

import goals.social.network.course.models.User;
import goals.social.network.course.models.UserRelations;
import goals.social.network.course.repositories.UserRepository;
import goals.social.network.course.repositories.UserRelationsRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;
import java.util.Set;

@RestController
@RequiredArgsConstructor
public class FollowersController {

    private final UserRepository userRepository;
    private final UserRelationsRepository relationsRepository;

    @GetMapping("/followers")
    public ResponseEntity<?> getUserRel(@RequestBody Map<String, String> userEmail) {
        Optional<User> user = userRepository.findByEmail(userEmail.get("email"));
        Optional<User> user2 = userRepository.findByEmail(userEmail.get("email2"));
        relationsRepository.save(new UserRelations(user.get(), user2.get()));
        if (user.isPresent()) {
            user = userRepository.findByEmail(userEmail.get("email2"));
            Set<UserRelations> following = user.get().getFollowing();
            Set<UserRelations> followers = user.get().getFollowers();
            return new ResponseEntity<>(Map.of("following", following, "followers", followers), HttpStatus.OK);
        }
        return new ResponseEntity<>("Task with ID %s is not found".formatted(userEmail), HttpStatus.BAD_REQUEST);
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
