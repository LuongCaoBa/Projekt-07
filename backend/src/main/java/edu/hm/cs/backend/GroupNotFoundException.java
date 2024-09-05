package edu.hm.cs.backend;

public class GroupNotFoundException extends RuntimeException {
    GroupNotFoundException(Long id) {
        super("Could not find group " + id);
    }
}
