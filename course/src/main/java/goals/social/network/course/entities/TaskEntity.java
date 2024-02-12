package goals.social.network.course.entities;

import jakarta.annotation.Nonnull;
import jakarta.persistence.*;

@Entity
@Table(name = "tasks")
public class TaskEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    @Column(name = "id")
    private Long id;

    @Nonnull
    @Column(name = "title")
    private String title;

    @Nonnull
    @Column(name = "description")
    private String description;

    @Nonnull
    @Column(name = "done")
    private Boolean done;

    public TaskEntity() {}

    public TaskEntity(@Nonnull String title, @Nonnull String description, @Nonnull Boolean done) {
        this.title = title;
        this.description = description;
        this.done = done;
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

    public void setDone(@Nonnull Boolean done) {
        this.done = done;
    }
}
