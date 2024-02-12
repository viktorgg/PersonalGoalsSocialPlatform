package goals.social.network.course.controllers;

import goals.social.network.course.entities.TaskEntity;
import goals.social.network.course.repositories.TaskRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping(path = "/tasks")
public class TaskController {

    @Autowired
    private TaskRepository taskRepository;

    @GetMapping
    public List<TaskEntity> getTasks() {
        return taskRepository.findAll();
    }

    @PostMapping("/create")
    public ResponseEntity<?> createTask(@RequestBody TaskEntity taskEntity) {
        taskRepository.save(taskEntity);
        return new ResponseEntity<>("Task is created", HttpStatus.OK);
    }

    @PutMapping("/update/{id}")
    public ResponseEntity<?> updateTask(@PathVariable Long id, @RequestBody TaskEntity taskEntity) {
        boolean exists = taskRepository.existsById(id);
        if (exists) {
            TaskEntity taskToUpdate = taskRepository.getReferenceById(id);
            taskToUpdate.setTitle(taskEntity.getTitle());
            taskToUpdate.setDescription(taskEntity.getDescription());
            taskToUpdate.setDone(taskEntity.getDone());
            taskRepository.save(taskToUpdate);
            return new ResponseEntity<>("Task is updated", HttpStatus.OK);
        }
        return new ResponseEntity<>("Task with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<?> deleteTask(@PathVariable Long id) {
        boolean exists = taskRepository.existsById(id);
        if (exists) {
            taskRepository.deleteById(id);
            return new ResponseEntity<>("Task with ID %s is deleted".formatted(id), HttpStatus.OK);
        }
        return new ResponseEntity<>("Task with ID %s is not found".formatted(id), HttpStatus.BAD_REQUEST);
    }
}
