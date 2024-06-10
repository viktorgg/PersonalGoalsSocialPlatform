package goals.social.network.course.services;

import goals.social.network.course.models.Goal;
import goals.social.network.course.models.GoalPostReview;
import goals.social.network.course.models.GoalProgressPost;
import goals.social.network.course.repositories.GoalPostReviewRepository;
import goals.social.network.course.repositories.GoalProgressPostRepositoy;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Service
@RequiredArgsConstructor
public class GoalService {

    private final GoalProgressPostRepositoy goalProgressPostRepository;
    private final GoalPostReviewRepository goalPostReviewRepository;

    public List<Goal> calculateGoalStatuses(List<Goal> goals) {
        List<Goal> modifiedGoals = new ArrayList<>();
        LocalDateTime datetimeMonthAgo = LocalDateTime.now().minusMonths(1);
        for (Goal goal : goals) {
            int goalScore = 0;
            List<GoalProgressPost> goalPostsLastMonth = goalProgressPostRepository.getAllPostsOfGoalLastMonth(goal.getId(), datetimeMonthAgo);
            for (GoalProgressPost post : goalPostsLastMonth) {
                List<GoalPostReview> postReviewsLastMonth = goalPostReviewRepository.getAllReviewsOfGoalPostLastMonth(post.getId(), datetimeMonthAgo);
                for (GoalPostReview review : postReviewsLastMonth) {
                    if (review.isApproved()) {
                        goalScore++;
                    } else {
                        goalScore--;
                    }
                }
            }
            if (goalScore > 0) {
                goal.setStatus(1);
            } else if (goalScore < 0) {
                goal.setStatus(-1);
            }
            modifiedGoals.add(goal);
        }

        return modifiedGoals;
    }
}
