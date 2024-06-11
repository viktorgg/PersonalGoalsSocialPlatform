package goals.social.network.course.controllers;

import goals.social.network.course.models.*;
import goals.social.network.course.repositories.GoalRepository;
import goals.social.network.course.repositories.UserRepository;
import goals.social.network.course.services.GoalService;
import goals.social.network.course.services.UserService;
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

    private final GoalService goalService;

    @GetMapping
    public List<Goal> getGoals() {
        return goalService.calculateGoalStatuses(goalRepository.findAll());
    }

    @GetMapping("/{id}")
    public ResponseEntity<?> getGoal(@PathVariable Long id) {
        boolean exists = goalRepository.existsById(id);
        if (exists) {
            Goal goal = goalRepository.getReferenceById(id);
            return new ResponseEntity<>(goalService.calculateGoalStatuses(List.of(goal)).getFirst(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Goal with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
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

    @GetMapping("/{id}/invites")
    public ResponseEntity<?> getGoalInvites(@PathVariable Long id) {
        boolean exists = goalRepository.existsById(id);
        if (exists) {
            List<GoalInviteCode> inviteCodes = goalRepository.getReferenceById(id).getInviteCodes();
            return new ResponseEntity<>(inviteCodes, HttpStatus.OK);
        }
        return new ResponseEntity<>("Goal with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }
}
