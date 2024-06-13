package goals.social.network.course.models;

import com.fasterxml.jackson.annotation.JsonIncludeProperties;
import jakarta.persistence.*;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;

@Getter
@Setter
@Entity
@RequiredArgsConstructor
@Table(name = "goal_invite_codes")
public class GoalInviteCode {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Long id;

    @Column(nullable = false)
    private String code;

    public GoalInviteCode(String code, Goal goal) {
        this.code = code;
        this.goal = goal;
    }

    @JsonIncludeProperties(value = {"id"})
    @ManyToOne()
    @JoinColumn(name="goal_id", referencedColumnName = "id", nullable = false)
    private Goal goal;
}
