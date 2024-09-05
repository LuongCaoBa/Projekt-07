package edu.hm.cs.backend;
import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.Assert;

import java.time.Instant;
import java.util.Date;

@SpringBootTest
public class MessageControllerTest {

    @Autowired
    public MessageController messageController;

    @Autowired
    public LoginController loginController;

    @Autowired
    public MessageRepository messageRepository;

    @Autowired
    public GroupRepository groupRepository;

    @Test
    void allMessagesTest_1() {
        long id = 1;
        loginController.insertUser("test", "test", "test@test.com", true, 0, 1, "Informatik");
        Message message = new Message("Hello World", "test", true ,id, "1", Date.from(Instant.now()).toString(), Date.from(Instant.now()));
        messageRepository.save(message);
        Group group = new Group("test");
        groupRepository.save(group);
        String anser = messageController.allMessages(id, 1, 1);
        JSONObject response = new JSONObject(anser);
        Assert.isTrue(!response.getBoolean("Error-bool"), "Error-bool is true");
        Assert.isTrue(response.getString("Error-Message").equals(""), "Error-Message is not empty");
        Assert.isTrue(response.getJSONArray("Messages").getJSONObject(0).getString("Message-Content").equals("Hello World"), "Message-Content is wrong");
    }

    @Test
    void allMessagesTest_2() {
        long id = 1;
        loginController.insertUser("test", "test", "test@test.com", true, 0, 1, "Informatik");
        Group group = new Group("test");
        groupRepository.save(group);
        Group group2 = new Group("test2");
        groupRepository.save(group2);
        String anser = messageController.allMessages(id, 2, 1);
        JSONObject response = new JSONObject(anser);
        Assert.isTrue(!response.getBoolean("Error-bool"), "Error-bool is true");
        Assert.isTrue(response.getString("Error-Message").equals(""), "Error-Message is not empty");
        Assert.isTrue(response.getJSONArray("Messages").length() == 0, "Message-Content is wrong");
    }

    @Test
    void allMessagesTest_3() {
        long id = 1;
        loginController.insertUser("test", "test", "test@test.com", true, 0, 1, "Informatik");
        String anser = messageController.allMessages(id, 8, 1);
        JSONObject response = new JSONObject(anser);
        Assert.isTrue(response.getBoolean("Error-bool"), "Error-bool is false");
        Assert.isTrue(response.getString("Error-Message").equals("No User or Group with this ID found"), "Error-Message is wrong");
    }

    @Test
    void sendMessageTest_1() {
        long id = 1;
        loginController.insertUser("test", "test", "test@test.com", true, 0, 1, "Informatik");
        Group group = new Group("test");
        groupRepository.save(group);
        String anser = messageController.sendMessage(id, 1, true, "2024-1-15-22-26-1", "Hello World");
        JSONObject response = new JSONObject(anser);
        Assert.isTrue(!response.getBoolean("Error-bool"), "Error-bool is true");
        Assert.isTrue(response.getString("Error-Message").equals(""), "Error-Message is not empty");
    }

    @Test
    void sendMessageTest_2() {
        long id = 1;
        loginController.insertUser("test", "test", "test@test.com", true, 0, 1, "Informatik");
        Group group = new Group("test");
        groupRepository.save(group);
        String anser = messageController.sendMessage(id, 1, true, "2024-1-15-22-1", "Hello World");
        JSONObject response = new JSONObject(anser);
        Assert.isTrue(response.getBoolean("Error-bool"), "Error-bool is false");
        Assert.isTrue(response.getString("Error-Message").equals("Wrong Date Format"), "Error-Message is wrong");
    }

}
