package edu.hm.cs.backend;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.*;
import java.util.stream.Collectors;


@RestController
public class Controller {
    @Autowired
    public GroupRepository repository;

    @Autowired
    public ClientRepository clientRepository;

    @GetMapping("/groups")
    List<Group> allGroups() {
        return repository.findAll();
    }

    @GetMapping("/groups/{id}")
    Group getGroupById(@PathVariable(value = "id") Long groupId) {
        return repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));
    }

    @PostMapping("/groups")
    Group newGroup(@RequestBody Group newGroup) {
        return repository.save(newGroup);
    }

    @DeleteMapping("/groups/{id}")
    public Map<String, Boolean> deleteGroup(@PathVariable(value = "id") Long groupId)
            throws GroupNotFoundException {
        Group group = repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));

        repository.delete(group);
        Map<String, Boolean> response = new HashMap<>();
        response.put("deleted", Boolean.TRUE);
        return response;
    }

    @PutMapping("/groups/{id}")
    public ResponseEntity<Group> editGroup(@PathVariable(value = "id") Long groupId, @RequestBody Group groupDetails) throws GroupNotFoundException {
        Group group = repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));

        group.setName(groupDetails.getName());
        final Group updatedGroup = repository.save(group);
        return ResponseEntity.ok(updatedGroup);
    }

    @PutMapping("/groups/{id}/addUser/{userId}")
    public ResponseEntity<Group> addUserToGroup(@PathVariable(value = "id") Long groupId, @PathVariable(value = "userId") Long userId) throws GroupNotFoundException, ClientNotFoundException {
        // Retrieve the group
        Group group = repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));
        Client client = clientRepository.findById(userId).orElseThrow(() -> new ClientNotFoundException(userId));
        client.addToGroup(group);
        repository.save(group);
        final Group updatedGroup = repository.findById(groupId).orElseThrow(() -> new GroupNotFoundException(groupId));
        final Client updateClient = clientRepository.save(client);
        return ResponseEntity.ok(updatedGroup);
    }

    @PutMapping("/groups/{id}/users/{userId}")
    public ResponseEntity<Group> deleteUserFromGroup(
            @PathVariable(value = "id") Long groupId,
            @PathVariable(value = "userId") Long userId) throws GroupNotFoundException, ClientNotFoundException {

        // Retrieve the group
        Group group = repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));

        // Retrieve the user to be removed
        Client clientToRemove = group.getClients().stream()
                .filter(user -> Objects.equals(user.getId(), userId))
                .findFirst()
                .orElseThrow(() -> new ClientNotFoundException(userId));

        clientToRemove.removeFromGroup(group);
        final Group updatedGroup = repository.save(group);
        final Client updateClient = clientRepository.save(clientToRemove);

        return ResponseEntity.ok(updatedGroup);
    }

    @GetMapping("/users")
    List<Client> allUsers() {
        return clientRepository.findAll();
    }

    @GetMapping("/users/{id}")
    Client getUserById(@PathVariable(value = "id") Long UserId) {
        return clientRepository.findById(UserId)
                .orElseThrow(() -> new GroupNotFoundException(UserId));
    }

    @PostMapping("/users")
    Client newUser(@RequestBody Client newUser) {
        return clientRepository.save(newUser);
    }

    @DeleteMapping("/users/{id}")
    public Map<String, Boolean> deleteUser(@PathVariable(value = "id") Long userId)
            throws ClientNotFoundException {
        Client user = clientRepository.findById(userId)
                .orElseThrow(() -> new ClientNotFoundException(userId));

        clientRepository.delete(user);
        Map<String, Boolean> response = new HashMap<>();
        response.put("deleted", Boolean.TRUE);
        return response;
    }

    @PutMapping("/users/{id}")
    public ResponseEntity<Client> updateUser(@PathVariable(value = "id") Long userId, @RequestBody Client userDetails) throws ClientNotFoundException {
        Client user = clientRepository.findById(userId)
                .orElseThrow(() -> new ClientNotFoundException(userId));

        user.setUsername(userDetails.getUsername());
        final Client updatedUser = clientRepository.save(user);
        return ResponseEntity.ok(updatedUser);
    }

    @GetMapping("/groups/{id}/users/{userId}")
    public Client getUserWithIdFromGroup(
            @PathVariable(value = "id") Long groupId,
            @PathVariable(value = "userId") Long userId) throws GroupNotFoundException, ClientNotFoundException {

        // Retrieve the group
        Group group = repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));

        Client userToGet = group.getClients().stream()
                .filter(user -> Objects.equals(user.getId(), userId))
                .findFirst()
                .orElseThrow(() -> new ClientNotFoundException(userId));

        return userToGet;
    }

    @GetMapping("/groups/{id}/users")
    public Set<Client> getUserListFromGroup(
            @PathVariable(value = "id") Long groupId) throws GroupNotFoundException {

        // Retrieve the group
        Group group = repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));

        return group.getClients();
    }

    @GetMapping("/users/{id}/groups")
    public Set<Group> getGroupListFromUser(
            @PathVariable(value = "id") Long userId) throws ClientNotFoundException {

        // Retrieve the group
        Client user = clientRepository.findById(userId)
                .orElseThrow(() -> new ClientNotFoundException(userId));

        return user.getGroups();
    }

    @GetMapping("/groups/{id}/usersNotInGroup")
    public Set<Client> getUsersNotInGroup(@PathVariable(value = "id") Long groupId) throws GroupNotFoundException {

        // Retrieve the group
        Group group = repository.findById(groupId)
                .orElseThrow(() -> new GroupNotFoundException(groupId));

        // Retrieve all users
        List<Client> allUsers = clientRepository.findAll();

        // Filter out users that are already in the group
        Set<Client> usersNotInGroup = allUsers.stream()
                .filter(user -> !group.getClients().contains(user))
                .collect(Collectors.toSet());

        return usersNotInGroup;

    }

    @GetMapping("/users/{id}/group_list")
    public String getGroupListForUser( @PathVariable(value = "id") Long userId) throws ClientNotFoundException{
        Client user = clientRepository.findById(userId)
                .orElseThrow(() -> new ClientNotFoundException(userId));
        Set<Group> groups = user.getGroups();
        String groupList = "";
        for(Group group : groups){
            groupList += group.getName() + ":" + group.getId() + ",";
        }
        return groupList;

    }
}
