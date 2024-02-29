package goals.social.network.course.models;

import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

import java.util.Map;

@Setter
@Getter
@Entity
@RequiredArgsConstructor
@Table(name = "goals")
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

    public Map<String, Object> toMap() {
        return Map.of("id", id, "title", title, "description", description, "done", done);
    }
}
