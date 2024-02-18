package goals.social.network.course.entities;

import jakarta.annotation.Nonnull;
import jakarta.persistence.*;

import java.util.Map;

@Entity
@Table(name = "goals")
public class GoalEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long id;

    @Column(name = "title", nullable = false)
    private String title;

    @Column(name = "description", nullable = false)
    private String description;

    @Column(name = "done", nullable = false)
    private Boolean done;

    public GoalEntity() {}

    public Map<String, Object> toMap() {
        return Map.of("id", id, "title", title, "description", description, "done", done);
    }

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    @Nonnull
    public Boolean getDone() {
        return done;
    }

    public void setDone(Boolean done) {
        this.done = done;
    }
}
