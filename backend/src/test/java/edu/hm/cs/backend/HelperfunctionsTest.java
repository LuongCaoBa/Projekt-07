package edu.hm.cs.backend;

import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.Assert;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

@SpringBootTest
public class HelperfunctionsTest {

    @Autowired
    public ClientRepository clientRepository;

    @Autowired
    public GroupRepository groupRepository;

    @Autowired
    public helperfunctions helper;

    @Test
    void DoesEmailExistTest_1(){
        Client client = new Client("test", "test", "test@test.com", true, 0, 1, "Informatik");
        clientRepository.save(client);
        Assert.isTrue(helper.DoesEmailExist("test@test.com", clientRepository), "Email not found");

    }

    @Test
    void DoesEmailExistTest_2(){
        Client client = new Client("test", "test", "test@test.com", true, 0, 1, "Informatik");
        clientRepository.save(client);
        Assert.isTrue(!helper.DoesEmailExist("test2@test.com", clientRepository), "Email found");
    }

    @Test
    void DoesEmailExistTest_3(){
        Assert.isTrue(!helper.DoesEmailExist("test3@test.com", clientRepository), "Email found");
    }

    @Test
    void getUserByEmailTest_1(){
        Client client = new Client("test", "test", "test@test.com", true, 0, 1, "Informatik");
        clientRepository.save(client);
        Assert.isTrue(helper.getUserByEmail("test@test.com", clientRepository).getId().equals(client.getId()), "Wrong User returned");
    }

    @Test
    void getUserByEmailTest_2() {
        Client client = new Client("test", "test", "test@test.com", true, 0, 1, "Informatik");
        clientRepository.save(client);
        Assert.isTrue(helper.getUserByEmail("test2@test.com", clientRepository) == null, "Wrong User returned");
    }

    @Test
    void getUserByEmailTest_3() {
        Assert.isTrue(helper.getUserByEmail("test3@test.com", clientRepository) == null, "Wrong User returned");
    }

    @Test
    void isGroupIDFoundTest_1(){
        Group group = new Group("test");
        groupRepository.save(group);
        Assert.isTrue(helper.isGroupIDFound(group.getId()), "Group not found");
    }

    @Test
    void isGroupIDFoundTest_2(){
        Group group = new Group("test");
        groupRepository.save(group);
        Assert.isTrue(!helper.isGroupIDFound(8L), "Group found");
    }

    @Test
    void isGroupIDFoundTest_3(){
        Assert.isTrue(!helper.isGroupIDFound(8L), "Group found");
    }

    @Test
    public void GetMessageRepoTest_1() {
        MessageRepository messageRepository = helper.getMessageRepo();
        assertNotNull(messageRepository, "MessageRepository should not be null");
        // You can add more assertions based on the expected behavior of your repository.
    }

    @Test
    public void GetUserByIDTest_1() {
        Client client = new Client("test", "test", "test@test.com", true, 0, 1, "Informatik");
        clientRepository.save(client);
        // Replace '1' with a valid existing user ID from your test data
        long userId = 1;
        Client user = helper.getUserByID(userId);
        assertNotNull(user, "User should not be null");
        assertEquals(userId, user.getId(), "User ID should match");
        // You can add more assertions based on the expected behavior of your getUserByID method.
    }

    @Test
    public void GetUserByIdTest_2() {
        Client client = new Client("test", "test", "test@test.com", true, 0, 1, "Informatik");
        clientRepository.save(client);
        long userId = 10;
        Client user = helper.getUserByID(userId);
        assertEquals(null, user, "User should be null");
    }

    @Test
    public void GetUserByIdTest_3() {
        long userId = 10;
        Client user = helper.getUserByID(userId);
        assertEquals(null, user, "User should be null");
    }

    @Test
    public void GetMessageByGroupIDTest_1() {
        // Replace '1' with a valid existing group ID from your test data
        long groupId = 1;
        List<Message> messages = helper.getMessageByGroupID(groupId);
        assertNotNull(messages, "Message list should not be null");
        // You can add more assertions based on the expected behavior of your getMessageByGroupID method.
    }
}
