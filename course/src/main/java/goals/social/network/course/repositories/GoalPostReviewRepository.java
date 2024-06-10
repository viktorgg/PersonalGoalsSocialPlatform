package goals.social.network.course.repositories;

import goals.social.network.course.models.GoalPostReview;
import goals.social.network.course.models.GoalProgressPost;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.time.LocalDateTime;
import java.util.List;

public interface GoalPostReviewRepository extends JpaRepository<GoalPostReview, Long> {

    @Query("SELECT p FROM GoalPostReview p WHERE p.goalPost.id = :goalPostId AND p.updatedAt >= :monthAgoDatetime")
    List<GoalPostReview> getAllReviewsOfGoalPostLastMonth(@Param("goalPostId") Long goalPostId, LocalDateTime monthAgoDatetime);
}
