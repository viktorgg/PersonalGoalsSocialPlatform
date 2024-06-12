package goals.social.network.course.repositories;

import goals.social.network.course.models.User;
import goals.social.network.course.models.UserGoalRelations;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;

public interface UserGoalRelationsRepository extends JpaRepository<UserGoalRelations, Long> {

    @Query("SELECT ug FROM UserGoalRelations ug WHERE ug.user.id = :userId AND ug.goal.id = :goalId")
    UserGoalRelations findByUserIdAndGoalId(@Param("userId") Long userId, @Param("goalId") Long goalId);
}
