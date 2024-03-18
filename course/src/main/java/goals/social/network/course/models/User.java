package goals.social.network.course.models;

import jakarta.persistence.*;
import lombok.*;
import org.hibernate.annotations.Fetch;
import org.hibernate.annotations.FetchMode;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@Entity
@ToString
@Table(name = "users")
public class User implements UserDetails {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    Long id;

    @Column(nullable = false)
    String firstName;

    @Column(nullable = false)
    String lastName;

    @Column(unique = true, nullable = false)
    String email;

    @Column(nullable = false)
    String password;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    Role role;

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return List.of(new SimpleGrantedAuthority(role.name()));
    }

    @Override
    public String getPassword() {
        return password;
    }

    @Override
    public String getUsername() {
        return email;
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }

    public Map<String, Object> toMap() {
        return Map.of(
                "id", id,
                "firstName", firstName,
                "lastName", lastName,
                "email", email
        );
    }

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "user")
    @Fetch(FetchMode.SUBSELECT)
    private Set<UserRelations> followers = new HashSet<>();

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "follower")
    @Fetch(FetchMode.SUBSELECT)
    private Set<UserRelations> following = new HashSet<>();

    @OneToMany(cascade = CascadeType.ALL, mappedBy = "user")
    private List<Goal> goals;
}