package goals.social.network.course.controllers;

import goals.social.network.course.models.Goal;
import goals.social.network.course.models.GoalPostReview;
import goals.social.network.course.models.GoalProgressPost;
import goals.social.network.course.models.User;
import goals.social.network.course.repositories.GoalPostReviewRepository;
import goals.social.network.course.repositories.GoalProgressPostRepositoy;
import goals.social.network.course.repositories.GoalRepository;
import goals.social.network.course.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.Map;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "/reviews")
public class GoalPostReviewController {

    private final GoalRepository goalRepository;
    private final GoalProgressPostRepositoy goalProgressPostRepository;
    private final GoalPostReviewRepository goalPostReviewRepository;

    private final UserRepository userRepository;

    @PostMapping("/create")
    public ResponseEntity<?> createGoalPostReview(@RequestBody Map<String, Object> payload) {
        long goalPostId = (int) payload.get("goalPostId");
        Optional<GoalProgressPost> foundGoalPost = goalProgressPostRepository.findById(goalPostId);
        if (foundGoalPost.isPresent()) {
            GoalProgressPost goalPost = goalProgressPostRepository.getReferenceById(goalPostId);

            long userId = (int) payload.get("byUserId");
            User user = userRepository.findById(userId).get();
            GoalPostReview postReview = new GoalPostReview(
                    (boolean) payload.get("approved"),
                    (String) payload.get("comment"),
                    goalPost,
                    user
            );
            Goal goal = goalPost.getGoal();
            goal.setUpdatedAt(LocalDateTime.now());
            goalRepository.save(goal);
            goalPostReviewRepository.save(postReview);
            return new ResponseEntity<>(postReview.toMap(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Goal post with ID %s is not found".formatted(goalPostId), HttpStatus.BAD_REQUEST);
    }

    @GetMapping("/post/{goalPostId}")
    public ResponseEntity<?> getGoalPostReviews(@PathVariable Long goalPostId) {
        Optional<GoalProgressPost> goalPost = goalProgressPostRepository.findById(goalPostId);
        if (goalPost.isPresent()) {
            return new ResponseEntity<>(goalPost.get().getPostReviews(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Goal post with ID %s is not found".formatted(goalPostId), HttpStatus.BAD_REQUEST);
    }

    @PutMapping("/edit/{id}")
    public ResponseEntity<?> editGoalPostReview(@PathVariable Long id, @RequestBody GoalPostReview goalPostReview) {
        boolean exists = goalPostReviewRepository.existsById(id);
        if (exists) {
            GoalPostReview reviewToUpdate = goalPostReviewRepository.getReferenceById(id);
            reviewToUpdate.setApproved(goalPostReview.isApproved());
            reviewToUpdate.setComment(goalPostReview.getComment());
            Goal goal = reviewToUpdate.getGoalPost().getGoal();
            goal.setUpdatedAt(LocalDateTime.now());
            goalRepository.save(goal);
            goalPostReviewRepository.save(reviewToUpdate);
            return new ResponseEntity<>(reviewToUpdate.toMap(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Goal with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteGoalPostReview(@PathVariable Long id) {
        boolean exists = goalPostReviewRepository.existsById(id);
        if (exists) {
            goalPostReviewRepository.deleteById(id);
            return new ResponseEntity<>("Review with ID %s is deleted".formatted(id), HttpStatus.OK);
        }
        return new ResponseEntity<>("Review with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }
}
