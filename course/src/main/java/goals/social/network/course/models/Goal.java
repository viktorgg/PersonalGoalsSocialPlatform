package goals.social.network.course.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.Map;

@Getter
@Entity
@RequiredArgsConstructor
@Table(name = "goals")
public class Goal {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Setter
    @Column(nullable = false)
    private String title;

    @Setter
    @Column(nullable = false)
    private String description;

    @Setter
    @Column(nullable = false)
    private Boolean done;

    public Map<String, Object> toMap() {
        return Map.of("id", id, "title", title, "description", description, "done", done, "user", user);
    }

    @JsonIgnore
    @ManyToOne
    @JoinColumn(name="user_id", nullable=false)
    private User user;
}
