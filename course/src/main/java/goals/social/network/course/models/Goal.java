package goals.social.network.course.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.Map;

@Getter
@Setter
@Entity
@RequiredArgsConstructor
@Table(name = "goals")
@JsonIgnoreProperties({"hibernateLazyInitializer", "handler"})
public class Goal {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column(nullable = false)
    private String description;

    @Column(nullable = false)
    private Boolean done;

    public Goal(String title, String description, boolean done, User user) {
        this.title = title;
        this.description = description;
        this.done = done;
        this.user = user;
    }

    public Map<String, Object> toMap() {
        return Map.of("id", id, "title", title, "description", description, "done", done, "user", user);
    }

    @JsonIgnore
    @ManyToOne()
    @JoinColumn(name="user_id", referencedColumnName = "id", nullable = false)
    private User user;

}
