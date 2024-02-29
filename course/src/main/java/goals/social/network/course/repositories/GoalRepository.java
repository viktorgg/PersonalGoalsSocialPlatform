package goals.social.network.course.repositories;

import goals.social.network.course.models.Goal;
import org.springframework.data.jpa.repository.JpaRepository;

public interface GoalRepository extends JpaRepository<Goal, Long> {}
