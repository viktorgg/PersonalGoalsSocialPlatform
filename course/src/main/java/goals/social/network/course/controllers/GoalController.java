package goals.social.network.course.controllers;

import goals.social.network.course.models.Goal;
import goals.social.network.course.models.User;
import goals.social.network.course.repositories.GoalRepository;
import goals.social.network.course.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "/goals")
public class GoalController {

    private final GoalRepository goalRepository;

    private final UserRepository userRepository;

    @GetMapping
    public List<Goal> getGoals() {
        return goalRepository.findAll();
    }

    @PostMapping("/create")
    public ResponseEntity<?> createGoal(@RequestBody Map<String, Object> payload) {
        int userId = (int) payload.get("userId");
        User user = userRepository.findById((long) userId).get();
        Goal goal = new Goal(
                (String) payload.get("title"),
                (String) payload.get("description"),
                (Boolean) payload.get("done"),
                user
        );
        goalRepository.save(goal);
        return new ResponseEntity<>(goal.toMap(), HttpStatus.OK);
    }

    @PutMapping("/edit/{id}")
    public ResponseEntity<?> editGoal(@PathVariable Long id, @RequestBody Goal goal) {
        boolean exists = goalRepository.existsById(id);
        if (exists) {
            Goal goalToUpdate = goalRepository.getReferenceById(id);
            goalToUpdate.setTitle(goal.getTitle());
            goalToUpdate.setDescription(goal.getDescription());
            goalToUpdate.setDone(goal.getDone());
            goalRepository.save(goalToUpdate);
            return new ResponseEntity<>(goalToUpdate.toMap(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Goal with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteGoal(@PathVariable Long id) {
        boolean exists = goalRepository.existsById(id);
        if (exists) {
            goalRepository.deleteById(id);
            return new ResponseEntity<>("Goal with ID %s is deleted".formatted(id), HttpStatus.OK);
        }
        return new ResponseEntity<>("Goal with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }
}
