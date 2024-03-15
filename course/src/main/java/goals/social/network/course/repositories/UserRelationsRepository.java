package goals.social.network.course.repositories;

import goals.social.network.course.models.UserRelations;
import org.springframework.data.jpa.repository.JpaRepository;

public interface UserRelationsRepository extends JpaRepository<UserRelations, Long> {
}
