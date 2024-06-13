package goals.social.network.course.models;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
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
import java.util.*;

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

    @Column(updatable = false)
    @CreationTimestamp
    private LocalDateTime createdAt;

    @Column()
    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @Transient
    private int status;

    public Goal(String title, String description, boolean done, User userOwner) {
        this.title = title;
        this.description = description;
        this.done = done;
        this.userOwner = userOwner;
    }

    public Map<String, Object> toMap() {
        return Map.of(
                "id", id,
                "title", title,
                "description", description,
                "done", done,
                "status", status,
                "userOwner", userOwner.toMap(),
                "updatedAt", updatedAt
        );
    }

    @JsonIncludeProperties(value = {"id", "firstName", "lastName", "email", "phone"})
    @ManyToOne()
    @JoinColumn(name="user_id", referencedColumnName = "id", nullable = false)
    private User userOwner;

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "goal")
    @Fetch(FetchMode.SUBSELECT)
    private Set<UserGoalRelations> usersFollowing = new HashSet<>();

    @JsonIncludeProperties(value = {"id", "description", "postReviews", "updatedAt"})
    @OneToMany(cascade = CascadeType.ALL, mappedBy = "goal")
    @Fetch(FetchMode.SUBSELECT)
    private List<GoalProgressPost> progressPosts = new ArrayList<>();

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "goal")
    @Fetch(FetchMode.SUBSELECT)
    private List<GoalInviteCode> inviteCodes = new ArrayList<>();
}
