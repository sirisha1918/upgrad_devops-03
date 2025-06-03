package com.example.service;

import com.example.model.User;
import org.springframework.stereotype.Service;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class UserService {
    private final Map<Integer, User> userMap = new HashMap<>();
    private int idCounter = 1;

    public List<User> getAllUsers() {
        return new ArrayList<>(userMap.values());
    }

    public User getUserById(int id) {
        return userMap.get(id);
    }

    public User createUser(User user) {
        user.setId(idCounter++);
        userMap.put(user.getId(), user);
        return user;
    }

    public User updateUser(int id, User user) {
        if (userMap.containsKey(id)) {
            user.setId(id);
            userMap.put(id, user);
            return user;
        }
        return null;
    }

    public boolean deleteUser(int id) {
        return userMap.remove(id) != null;
    }
}
