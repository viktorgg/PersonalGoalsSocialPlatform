package goals.social.network.course.repositories;

import goals.social.network.course.models.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface UserRepository extends JpaRepository<User, Long> {
    Optional<User> findByEmail(String email);

    @Query("SELECT u FROM User u WHERE UPPER(CONCAT(u.firstName, ' ', u.lastName)) like %:name%")
    List<User> findByNameContaining(@Param("name") String name);
}
