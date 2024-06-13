package goals.social.network.course.repositories;

import goals.social.network.course.models.GoalProgressPost;
import goals.social.network.course.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface GoalProgressPostRepositoy extends JpaRepository<GoalProgressPost, Long> {

    @Query("SELECT p FROM GoalProgressPost p WHERE p.goal.id = :goalId AND p.updatedAt >= :monthAgoDatetime")
    List<GoalProgressPost> getAllPostsOfGoalLastMonth(@Param("goalId") Long goalId, LocalDateTime monthAgoDatetime);
}
