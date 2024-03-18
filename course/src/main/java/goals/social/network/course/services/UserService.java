package goals.social.network.course.services;

import goals.social.network.course.models.User;
import goals.social.network.course.models.UserRelations;
import goals.social.network.course.repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Service
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;

    public UserDetailsService userDetailsService() {
        return username -> userRepository.findByEmail(username)
                .orElseThrow(() -> new UsernameNotFoundException("User not found"));
    }

    public void save(User newUser) {
        userRepository.save(newUser);
    }

    public List<User> getUserFollowers(User user) {
        Set<UserRelations> followers = user.getFollowers();
        List<User> followersList = new ArrayList<>();
        for (UserRelations userRel : followers) {
            followersList.add(userRel.getFollower());
        }
        return followersList;
    }

    public List<User> getUserFollowing(User user) {
        Set<UserRelations> following = user.getFollowing();
        List<User> followingList = new ArrayList<>();
        for (UserRelations userRel : following) {
            followingList.add(userRel.getUser());
        }
        return followingList;
    }
}
