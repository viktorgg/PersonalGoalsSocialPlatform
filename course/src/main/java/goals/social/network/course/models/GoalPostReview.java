package goals.social.network.course.models;

import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

import java.time.LocalDateTime;
import java.util.Map;

@Getter
@Setter
@Entity
@RequiredArgsConstructor
@Table(name = "goal_post_reviews")
public class GoalPostReview {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private boolean approved;

    @Column(nullable = false)
    private String comment;

    @Column(updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column()
    @UpdateTimestamp
    private LocalDateTime updatedAt;

    public GoalPostReview(boolean approved, String comment, GoalProgressPost goalPost, User userOwner) {
        this.approved = approved;
        this.comment = comment;
        this.goalPost = goalPost;
        this.userOwner = userOwner;
    }

    public Map<String, Object> toMap() {
        return Map.of(
                "id", id,
                "approved", approved,
                "comment", comment,
                "goalPost", goalPost.toMap(),
                "userOwner", userOwner.toMap(),
                "updatedAt", updatedAt
        );
    }

    @JsonIncludeProperties(value = {"id", "description"})
    @ManyToOne()
    @JoinColumn(name="goal_post_id", referencedColumnName = "id", nullable = false)
    private GoalProgressPost goalPost;

    @JsonIncludeProperties(value = {"id", "firstName", "lastName", "email", "phone"})
    @ManyToOne()
    @JoinColumn(name="user_id", referencedColumnName = "id", nullable = false)
    private User userOwner;
}
