package goals.social.network.course.controllers;

import goals.social.network.course.models.Goal;
import goals.social.network.course.models.GoalInviteCode;
import goals.social.network.course.models.User;
import goals.social.network.course.repositories.GoalInviteCodesRepository;
import goals.social.network.course.repositories.GoalRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.Map;
import java.util.Optional;

@RestController
@RequiredArgsConstructor
@RequestMapping(path = "/invites")
public class GoalInvitesController {

    private final GoalInviteCodesRepository goalInvitesRepository;
    private final GoalRepository goalRepository;

    @GetMapping("/{code}")
    public ResponseEntity<?> getInviteByCode(@PathVariable String code) {
        Optional<GoalInviteCode> invite = goalInvitesRepository.findByCode(code);
        if (invite.isPresent()) {
            return new ResponseEntity<>(Map.of("id", invite.get().getId(), "goalId", invite.get().getGoal().getId()), HttpStatus.OK);
        }
        return new ResponseEntity<>("Code %s is not found in DB".formatted(code), HttpStatus.BAD_REQUEST);
    }

    @PostMapping("/create")
    public ResponseEntity<?> createGoalInvite(@RequestBody Map<String, Object> payload) {
        int goalId = (int) payload.get("goalId");
        Goal goal = goalRepository.findById((long) goalId).get();
        String code = (String) payload.get("code");
        GoalInviteCode invite = new GoalInviteCode(code, goal);
        goalInvitesRepository.save(invite);
        return new ResponseEntity<>("Goal invite with code %s created".formatted(code), HttpStatus.OK);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteGoalInvite(@PathVariable Long id) {
        boolean exists = goalInvitesRepository.existsById(id);
        if (exists) {
            goalInvitesRepository.deleteById(id);
            return new ResponseEntity<>("Invite with ID %s is deleted".formatted(id), HttpStatus.OK);
        }
        return new ResponseEntity<>("Invite with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }
}
