package edu.hm.cs.backend;

public class ClientNotFoundException extends RuntimeException {
    ClientNotFoundException(Long id) {
        super("Could not find user " + id);
    }
}
