package goals.social.network.course.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "user_goal_rel")
public class UserGoalRelations {

    @EmbeddedId
    private UserGoalRelationsId id;

    @JsonIgnore
    @MapsId("userId")
    @ManyToOne()
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    protected User user;

    @JsonIgnore
    @MapsId("goalId")
    @ManyToOne()
    @JoinColumn(name = "goal_id", referencedColumnName = "id")
    protected Goal goal;

    public UserGoalRelations(User user, Goal goal) {
        this.user = user;
        this.goal = goal;
        this.id = new UserGoalRelationsId(user.getId(), goal.getId());
    }
}
