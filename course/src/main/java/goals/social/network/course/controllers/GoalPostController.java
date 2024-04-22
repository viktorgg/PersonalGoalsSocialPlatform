package goals.social.network.course.controllers;

import goals.social.network.course.models.Goal;
import goals.social.network.course.models.GoalProgressPost;
import goals.social.network.course.repositories.GoalProgressPostRepositoy;
import goals.social.network.course.repositories.GoalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "/posts")
public class GoalPostController {

    private final GoalRepository goalRepository;

    private final GoalProgressPostRepositoy goalProgressPostRepository;

    @PostMapping("/create")
    public ResponseEntity<?> createGoalProgressPost(@RequestBody Map<String, Object> payload) {
        int goalId = (int) payload.get("goalId");
        Goal goal = goalRepository.findById((long) goalId).get();
        GoalProgressPost goalPost = new GoalProgressPost(
                (String) payload.get("description"),
                goal
        );
        goalProgressPostRepository.save(goalPost);
        return new ResponseEntity<>(goalPost.toMap(), HttpStatus.OK);
    }

    @GetMapping("/goal/{goalId}")
    public ResponseEntity<?> getGoalPosts(@PathVariable Long goalId) {
        Optional<Goal> goal = goalRepository.findById(goalId);
        if (goal.isPresent()) {
            return new ResponseEntity<>(goal.get().getProgressPosts(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Goal with ID %s is not found".formatted(goalId), HttpStatus.BAD_REQUEST);
    }
}
