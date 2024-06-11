package goals.social.network.course.repositories;

import goals.social.network.course.models.GoalInviteCode;
import goals.social.network.course.models.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface GoalInviteCodesRepository extends JpaRepository<GoalInviteCode, Long> {

    Optional<GoalInviteCode> findByCode(String code);
}
