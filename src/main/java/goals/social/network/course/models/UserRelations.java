package goals.social.network.course.models;

import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.persistence.*;
import lombok.*;

@Getter
@NoArgsConstructor
@Entity
@Table(name = "users_rel")
public class UserRelations {

    @EmbeddedId
    private UserRelationsId id;

    @JsonIgnore
    @MapsId("userId")
    @ManyToOne()
    @JoinColumn(name = "user_id", referencedColumnName = "id")
    protected User user;

    @JsonIgnore
    @MapsId("relationId")
    @ManyToOne()
    @JoinColumn(name = "follower_id", referencedColumnName = "id")
    protected User follower;

    public UserRelations(User user, User follower) {
        this.user = user;
        this.follower = follower;
        this.id = new UserRelationsId(user.getId(), follower.getId());
    }
}
