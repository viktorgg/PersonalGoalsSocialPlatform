package goals.social.network.course.repositories;

import goals.social.network.course.models.UserGoalRelations;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserGoalRelationsRepository extends JpaRepository<UserGoalRelations, Long> {
}
