package goals.social.network.course.models;

import jakarta.persistence.Column;
import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.io.Serializable;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Embeddable
public class UserGoalRelationsId implements Serializable {

    @Column(name = "user_id")
    private Long userId;

    @Column(name = "goal_id")
    private Long goalId;
}
