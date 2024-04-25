package goals.social.network.course.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

@Getter
@Setter
@Entity
@RequiredArgsConstructor
@Table(name = "goal_posts")
public class GoalProgressPost {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private String description;

    @Column(updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column()
    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public GoalProgressPost(String description, Goal goal) {
        this.description = description;
        this.goal = goal;
    }

    public Map<String, Object> toMap() {
        return Map.of("id", id, "description", description, "goal", goal.toMap());
    }

    @JsonIncludeProperties(value = {"id", "title", "description", "done"})
    @ManyToOne()
    @JoinColumn(name="goal_id", referencedColumnName = "id", nullable = false)
    private Goal goal;

    @JsonIncludeProperties(value = {"id", "approved", "comment", "userOwner"})
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "goalPost")
    @Fetch(FetchMode.SUBSELECT)
    private List<GoalPostReview> postReviews = new ArrayList<>();

}
