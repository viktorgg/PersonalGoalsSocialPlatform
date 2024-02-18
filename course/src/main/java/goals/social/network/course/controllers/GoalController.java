package goals.social.network.course.controllers;

import goals.social.network.course.entities.GoalEntity;
import goals.social.network.course.repositories.GoalRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping(path = "/goals")
public class GoalController {

    @Autowired
    private GoalRepository goalRepository;

    @GetMapping
    public List<GoalEntity> getGoals() {
        return goalRepository.findAll();
    }

    @PostMapping("/create")
    public ResponseEntity<?> createTask(@RequestBody GoalEntity goalEntity) {
        goalRepository.save(goalEntity);
        return new ResponseEntity<>(goalEntity.toMap(), HttpStatus.OK);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateTask(@PathVariable Long id, @RequestBody GoalEntity goalEntity) {
        boolean exists = goalRepository.existsById(id);
        if (exists) {
            GoalEntity taskToUpdate = goalRepository.getReferenceById(id);
            taskToUpdate.setTitle(goalEntity.getTitle());
            taskToUpdate.setDescription(goalEntity.getDescription());
            taskToUpdate.setDone(goalEntity.getDone());
            goalRepository.save(taskToUpdate);
            return new ResponseEntity<>(taskToUpdate.toMap(), HttpStatus.OK);
        }
        return new ResponseEntity<>("Task with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTask(@PathVariable Long id) {
        boolean exists = goalRepository.existsById(id);
        if (exists) {
            goalRepository.deleteById(id);
            return new ResponseEntity<>("Task with ID %s is deleted".formatted(id), HttpStatus.OK);
        }
        return new ResponseEntity<>("Task with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }
}
