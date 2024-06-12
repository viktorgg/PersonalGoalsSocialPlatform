package goals.social.network.course.controllers;

import goals.social.network.course.models.Goal;
import goals.social.network.course.models.User;
import goals.social.network.course.models.UserGoalRelations;
import goals.social.network.course.models.UserRelations;
import goals.social.network.course.repositories.GoalRepository;
import goals.social.network.course.repositories.UserGoalRelationsRepository;
import goals.social.network.course.repositories.UserRepository;
import goals.social.network.course.repositories.UserRelationsRepository;
import goals.social.network.course.services.GoalService;
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
@RequestMapping(path = "/users")
public class UserController {

    private final UserRepository userRepository;
    private final UserRelationsRepository userRelationsRepository;

    private final GoalRepository goalRepository;
    private final UserGoalRelationsRepository userGoalRelationsRepository;

    private final GoalService goalService;
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

    @GetMapping("{userId}/goalsowned")
    public ResponseEntity<?> getUserGoalsOwned(@PathVariable Long userId) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            List<Goal> goalsOwned = goalService.calculateGoalStatuses(user.get().getGoalsOwned());
            return new ResponseEntity<>(goalsOwned, HttpStatus.OK);
        }
        return new ResponseEntity<>("User with ID %s is not found".formatted(userId), HttpStatus.BAD_REQUEST);
    }

    @GetMapping("{userId}/goalsfollowed")
    public ResponseEntity<?> getUserGoalsFollowed(@PathVariable Long userId) {
        Optional<User> user = userRepository.findById(userId);
        if (user.isPresent()) {
            List<Goal> goalsFollowed = goalService.calculateGoalStatuses(userService.getUserGoalsFollowed(user.get()));
            return new ResponseEntity<>(goalsFollowed, HttpStatus.OK);
        }
        return new ResponseEntity<>("User with ID %s is not found".formatted(userId), HttpStatus.BAD_REQUEST);
    }

    @PostMapping("{userIdFrom}/follow/{userIdTo}")
    public ResponseEntity<?> createUserRel(@PathVariable Long userIdFrom, @PathVariable Long userIdTo) {
        Optional<User> userFrom = userRepository.findById(userIdFrom);
        Optional<User> userTo = userRepository.findById(userIdTo);
        if (userFrom.isPresent() && userTo.isPresent()) {
            UserRelations obj = new UserRelations(userTo.get(), userFrom.get());
            userRelationsRepository.save(obj);
            return new ResponseEntity<>("User %s follows user %s".formatted(userIdFrom, userIdTo), HttpStatus.OK);
        }
        return new ResponseEntity<>("Users not found", HttpStatus.BAD_REQUEST);
    }

    @PostMapping("{userId}/followgoal/{goalId}")
    public ResponseEntity<?> createUserGoalRel(@PathVariable Long userId, @PathVariable Long goalId) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Goal> goal = goalRepository.findById(goalId);
        if (user.isPresent() && goal.isPresent()) {
            UserGoalRelations relation = new UserGoalRelations(user.get(), goal.get());
            userGoalRelationsRepository.save(relation);
            return new ResponseEntity<>("User %s follows goal %s".formatted(userId, goalId), HttpStatus.OK);
        }
        return new ResponseEntity<>("User or goal not found", HttpStatus.BAD_REQUEST);
    }

    @PostMapping("{userId}/unfollowgoal/{goalId}")
    public ResponseEntity<?> deleteUserGoalRel(@PathVariable Long userId, @PathVariable Long goalId) {
        Optional<User> user = userRepository.findById(userId);
        Optional<Goal> goal = goalRepository.findById(goalId);
        if (user.isPresent() && goal.isPresent()) {
            UserGoalRelations relation = userGoalRelationsRepository.findByUserIdAndGoalId(user.get().getId(), goal.get().getId());
            userGoalRelationsRepository.delete(relation);
            return new ResponseEntity<>("User %s unfollowed goal %s".formatted(userId, goalId), HttpStatus.OK);
        }
        return new ResponseEntity<>("User or goal not found", HttpStatus.BAD_REQUEST);
    }

    @GetMapping("/findAllByName")
    public ResponseEntity<?> getUsersByName(@RequestParam String name) {
        if (name != null && !name.isEmpty()) {
            List<User> users = userRepository.findByNameContaining(name.toUpperCase());
            return new ResponseEntity<>(users, HttpStatus.OK);
        }
        return new ResponseEntity<>(List.of(), HttpStatus.OK);
    }
}
