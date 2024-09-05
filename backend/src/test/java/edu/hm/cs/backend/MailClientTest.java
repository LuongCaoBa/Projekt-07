package edu.hm.cs.backend;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.util.Assert;

@SpringBootTest
public class MailClientTest {

    @Autowired
    MailClient mailClient;

    @Test
    void sendMailTest_1(){
        Assert.isTrue(mailClient.sendMail("fstadler@hm.edu", "Test", "Test"), "Mail not sent");
    }

    @Test
    void sendMailTest_2() {
        Assert.isTrue(!mailClient.sendMail("Test", "Test", "Test"), "Mail sent");
    }
}
